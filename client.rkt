#lang racketscript/base

(require racketscript/browser
         racketscript/interop
         racket/match
         racket/string
         (for-syntax racket/base))
(define jQuery #js*.$)

;;----------------------------------------------------------------------------
;; Globals

(define *split-gutter-size* 3)

(define *racket-editor-id*        #js"racket-edit")
(define *jsout-editor-id*         #js"jsout-edit")
(define *console-log-editor-id*   #js"console-log-edit")

;; Gist
(define *gist-source-file* #js"source.rkt")
(define *gist-javascript-file* #js"compiled.js")

;; CodeMirror

(define *cm-theme*          #js"neat")

(define cm-editor-racket    #f)
(define cm-editor-console   #f)
(define cm-editor-jsout     #f)

;; State

(define compiling?           #f)
(define last-compile-time    (#js*.Date.now))

(define-syntax := (make-rename-transformer #'$/:=))
(define run-frame-init-handler (λ ()
  (#js*.console.error #js"Run frame init handler called too early")))

;;-------------------------------------------------------------------------------
;; UI

(define (init-split-layout!)
  (#js*.Split [$/array #js"#left-container" #js"#right-container"]
              {$/obj [direction    #js"horizontal"]
                     [sizes        [$/array 50 50]]
                     [gutterSize   *split-gutter-size*]})
  (#js*.Split [$/array #js"#play-container" #js"#console-log-container"]
              {$/obj [direction    #js"vertical"]
                     [sizes        [$/array 75 25]]
                     [gutterSize   *split-gutter-size*]})
  (#js*.Split [$/array #js"#racket-container" #js"#jsout-container"]
              {$/obj [direction    #js"vertical"]
                     [sizes        [$/array 75 25]]
                     [gutterSize   *split-gutter-size*]}))

(define (register-button-events!)
  ($/:= ($> (#js.document.getElementById #js"btn-compile") onclick)
        (λ (e)
               (#js.e.preventDefault)
               (compile #f)))
  ($/:= ($> (#js.document.getElementById #js"btn-run") onclick)
        (λ (e)
               (#js.e.preventDefault)
               (run)))
  ($/:= ($> (#js.document.getElementById #js"btn-compile-run") onclick)
        (λ (e)
               (#js.e.preventDefault)
               (compile #t)))
  ($/:= ($> (#js.document.getElementById #js"btn-logout") onclick)
        (λ (e)
               (logout)
               (do-logged-out)))
  ($/:= ($> (#js.document.getElementById #js"btn-save") onclick)
        (λ (e)
               (#js.e.preventDefault)
               (save))))

;;-----------------------------------------------------------------------------
;; Editors

;; DOM-Id (Listof (Pairof CodeMirrorOption CodeMirrorOptionValue)) -> CodeMirror
;; Initialize CodeMirror in HTML TextArea of id `dom-id` and
;; with CodeMirror `options`
(define (create-editor dom-id options)
  (#js*.CodeMirror.fromTextArea
    (#js.document.getElementById dom-id)
    (#js*.Object.assign {$/obj} options
      {$/obj [theme          *cm-theme*]
             [matchBrackets  #t]
             [scrollbarStyle #js"simple"]
             [extraKeys
                 {$/obj ["F11" (λ (cm)
                                 (toggle-editor-fullscreen cm))]
                        ["Esc" (λ (cm)
                                 (when (#js.cm.getOption #js"fullscreen")
                                   (toggle-editor-fullscreen cm)))]}]})))

(define (toggle-editor-fullscreen cm)
  (#js.cm.setOption #js"fullScreen"
                    (not (#js.cm.getOption #js"fullScreen"))))

(define (init-editors!)
  (set! cm-editor-racket
        (create-editor *racket-editor-id*
                       {$/obj [lineNumbers    #t]
                              [mode           #js"scheme"]}))
  (set! cm-editor-console
        (create-editor *console-log-editor-id*
                       {$/obj [lineNumbers    #f]
                              [readOnly       #t]}))
  (set! cm-editor-jsout
        (create-editor *jsout-editor-id*
                       {$/obj [lineNumbers    #t]
                              [readOnly       #f]
                              [mode           #js"javascript"]})))

(define (append-to-editor! editor str)
  (#js.editor.replaceRange (js-string str) {$/obj [line +inf.0]}))

;;-------------------------------------------------------------------------------
;; Console

(define (get-logger level)
  (λ args
    (append-to-editor! cm-editor-console (string-append "[" level "] "))
    (for-each (λ (a)
                (append-to-editor!
                 cm-editor-console (string-append (cond
                                         [(string? a) a]
                                         [(number? a) (number->string a)]
                                         [else (racket-string (#js*.JSON.stringify a))])
                                       " "))
                (append-to-editor! cm-editor-console #js"\n"))
              args)))

(define (override-console frame-win)
  (define new-con {$/obj [log    (get-logger "log")]
                         [debug  (get-logger "debug")]
                         [error  (get-logger "error")]
                         [info   (get-logger "info")]})
  (:= #js.new-con.prototype #js.frame-win.console)
  (:= #js.frame-win.console new-con)
  (:= #js.frame-win.document.console new-con))

(define (set-racket-code code)
  (#js.cm-editor-racket.setValue code))

(define (set-javascript-code code)
  (#js.cm-editor-jsout.setValue (#js*.js_beautify code
                                                  {$/obj [indent_size 2]})))

;;-------------------------------------------------------------------------------
;; Ops

(define (run-racket code)
  (define run-frame (#js.document.getElementById #js"run-area"))
  (define src #js.run-frame.src)
  (:= #js.run-frame.src #js"")
  (:= #js.run-frame.src src)
  (set! run-frame-init-handler
    (λ (event)
      (override-console #js.event.source)
      (define newscript (#js.document.createElement "script"))
      (#js.newscript.setAttribute "type" "module")
      (:= #js.newscript.textContent code)
      (#js.run-frame.contentDocument.head.append newscript))))

(define (run)
  (define code (#js.cm-editor-jsout.getValue))
  (cond
    [($/binop === code #js"") (#js*.console.warn #js"Code not compiled!")]
    [else (#js.cm-editor-console.setValue #js"Console Log: \n")
          (run-racket code)]))

(define (compile execute?)
  (when (or (not compiling?) (> (- (#js*.Date.now) last-compile-time) 5000))
    (:= compiling? #t)
    (#js*.setTimeout (λ ()
                       (:= compiling? #f))
                     5000)
    (#js.cm-editor-console.setValue #js"Console Log:\n")
    (#js.cm-editor-jsout.setValue #js"Compiling ...")
    ($> #;(#js.jQuery.post #js"/compile" {$/obj [code (#js.cm-editor-racket.getValue)]})
        (#js*.fetch
         #js"/compile"
         {$/obj [method #js"POST"]
                [headers {$/obj #;[Content-Type #js"application/x-www-form-urlencoded; charset=UTF-8"]
                                [Content-Type #js"application/json"]}]
                [body (#js*.JSON.stringify
                       {$/obj [code (#js.cm-editor-racket.getValue)]})]})
        (then (λ (response) (:= compiling? #f) (#js.response.text)))
        (then (λ (data)
                (set-javascript-code data)
                (when execute?
                  (run))))
        (catch (λ (err) #;(xhr status err)
                (#js.cm-editor-console.setValue
                 ($/binop + #js"Compilation error:\n" err))
                (#js.cm-editor-jsout.setValue #js"")))
        #;(always (λ ()
                  (:= compiling? #f))))))

;;-----------------------------------------------------------------------------
;; Login, Save, and Load Gist

(define (hide-element e)
  ($/:= #js.e.style.display #js"none")
  ;; TODO: not sure if these are needed, was trying to get modal working
  #;($/:= #js.e.classList.remove #js"show")
  #;($/:= #js.e.classList.add #js"hidden"))
(define (show-element e)
  ($/:= #js.e.style.display #js"block")
  #;($/:= #js.e.classList.add #js"show")
  #;($/:= #js.e.classList.remove #js"hidden"))

(define (check-logged-in)
  ;(#js.jQuery.get #js"/isloggedin"
  ($> (#js*.fetch #js"/isloggedin")
      (then (λ (response) (#js.response.json)))
      (then (λ (isloggedin)
     (if isloggedin
         (do-logged-in)
         (do-logged-out))))))

(define (do-logged-in)
  (show-element (#js.document.getElementById #js"btn-save"))
  (show-element (#js.document.getElementById #js"btn-logout"))
  (hide-element (#js.document.getElementById #js"btn-login")))

(define (do-logged-out)
  (hide-element (#js.document.getElementById #js"btn-save"))
  (hide-element (#js.document.getElementById #js"btn-logout"))
  (show-element (#js.document.getElementById #js"btn-login")))

(define (logout)
  (#js*.fetch #js"/logout")
  #;(#js.jQuery.get #js"/logout"))

(define (load-gist id)
  ($> (#js*.fetch ($/binop + "https://api.github.com/gists/" id))
      #;(#js.jQuery.get ($/binop + "https://api.github.com/gists/" id))
      (then (λ (response) (#js.response.json)))
      (then (λ (data)
              (set-racket-code ($ #js.data.files *gist-source-file* 'content))
              (define jscode ($ #js.data.files *gist-javascript-file* 'content))
              (cond
                [(and jscode ($/binop !== jscode #js""))
                 (set-javascript-code jscode)
                 (run)]
                [else
                 (compile #t)])))
      (catch (λ (xhr) (show-error "Error loading Gist" #js.xhr)))))

(define (save)
  (define data
    {$/obj
     [public      #t]
     [files
      (assoc->object
       `([,*gist-source-file* ,{$/obj
                                [content (#js.cm-editor-racket.getValue)]}]
         [,*gist-javascript-file* ,{$/obj
                                    [content (#js.cm-editor-jsout.getValue)]}]))]})
  ($> #;(#js.jQuery.post #js"/save" data)
      (#js*.fetch
       #js"/save"
       {$/obj [method #js"POST"]
              [headers {$/obj [Content-Type #js"application/json"]}]
              [body (#js*.JSON.stringify data)]})
      (then (λ (response) (#js.response.text)))
      (then (λ (id) (:= #js.window.location.href ($/binop + #js"#gist/" id))))
      (catch (λ (e) (show-error "Error saving as Gist" #js.e)))))

;;-------------------------------------------------------------------------------

(define (show-error title msg)
  ($> (#js.jQuery #js"#error-modal")
                  (modal #js"show"))
  ($> (#js.jQuery #js"#error-modal .modal-title")
      (text (js-string title)))
  ($> (#js.jQuery #js"#error-modal p")
      (text (js-string msg))))
;; modal without jquery
;; TODO: doesnt work
#;(define (show-error title msg)
  (show-element (#js.document.querySelector #js"#error-modal"))
  ($/:= ($> (#js.document.querySelector #js"#error-modal .modal-title") textContent)
        (js-string title))
  ($/:= ($> (#js.document.querySelector #js"#error-modal p") textContent)
        (js-string msg)))

;;-------------------------------------------------------------------------------

(define (load-racket-example example-name)
  (define examples #js"/examples/")
  ($> (#js*.fetch ($> examples (concat example-name #js".rkt")))
      (then (λ (response) (#js.response.text)))
      (then (λ (code) (set-racket-code code))))
  ($> (#js*.fetch ($> examples (concat example-name #js".rkt.js")))
      (then (λ (response) (#js.response.text)))
      (then (λ (code)
        (set-javascript-code code)
        (run)))))

(define (reset-ui!)
  ;; Reset editors
  (#js.cm-editor-racket.setValue #js"Loading ...")
  (#js.cm-editor-jsout.setValue #js"")
  (#js.cm-editor-console.setValue #js"")

  ;; Reset the iframe with a blank page
  (define run-frame (#js.document.getElementById #js"run-area"))
  (:= #js.run-frame.contentWindow.location #js"about:blank"))

(define (load-racket-code)
  ;; TODO: string-split doesn't work
  (define parts ($> (#js.window.location.hash.slice 1)
                    (split #js"/")))
  (reset-ui!)
  ; TODO: #js"str" does not work in a case branch
  (case (racket-string ($ parts 0))
    [("gist") (load-gist ($ parts 1))]
    [("example") (load-racket-example ($ parts 1))]
    [else
      (let ([first-example
             ($ ($> (#js.document.querySelector #js"#example-menu a") hash
                    (split #js"/")) 1)])
        (load-racket-example first-example))]))

(define (main)
  (#js*.document.addEventListener #js"DOMContentLoaded"
    (λ ()
      (init-editors!)
      (init-split-layout!)
      (register-button-events!)
      (load-racket-code)))
  (#js*.window.addEventListener #js"hashchange" load-racket-code))
  (#js*.window.addEventListener #js"message"
    (λ (event)
      (when ($/binop === #js.event.data #js"run-iframe-init")
      (run-frame-init-handler event))))

(main)
