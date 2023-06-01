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

(define (get-element-by-id id)
  (#js*.document.getElementById (js-string id)))

(define (query-selector query)
  (#js*.document.querySelector (js-string query)))

(define (register-button-events!)
  (define (add-button-onclick button-id func)
    (define compile-btn (get-element-by-id button-id))
    (#js.compile-btn.addEventListener #js"click" func))
  (add-button-onclick "btn-compile" (λ (e)
               (#js.e.preventDefault)
               (compile #f)))
  (add-button-onclick "btn-run" (λ (e)
               (#js.e.preventDefault)
               (run)))
  (add-button-onclick "btn-compile-run" (λ (e)
               (#js.e.preventDefault)
               (compile #t)))
  (add-button-onclick "btn-logout" (λ (e)
               (logout)
               (do-logged-out)))
  (add-button-onclick "btn-save" (λ (e)
               (#js.e.preventDefault)
               (save)))
  )

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
                                         [else (js-string->string (#js*.JSON.stringify a))])
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

    ($> (#js*.fetch #js"/compile" {$/obj 
                [method "POST"]
                [headers {$/obj
                  [Content-type (js-string "application/json; charset=utf-8")]}]
                [body 
                  (#js*.JSON.stringify {$/obj [code (#js.cm-editor-racket.getValue)]})]
        })
        (then (λ (response) (if #js.response.ok
                                (#js.response.text)
                                ($/throw ($/new (#js*.Error (js-string "Compile error"))))
                            )
        ))
        (then (λ (data) (set-javascript-code data)
                        (when execute? (run))
        ))
        (catch (λ ()
                    ((#js.cm-editor-console.setValue
                    ($/binop + #js"Compilation error:\n" #js"failed to compile"))
                    (#js.cm-editor-jsout.setValue #js""))
        ))
        (then (λ ()
                  (:= compiling? #f)))
    )
))

;;-----------------------------------------------------------------------------
;; Login, Save, and Load Gist

(define (check-logged-in)
  ($> (#js*.fetch #js"/isloggedin")
      (then (λ (response) (#js.response.json)))
      (then (λ (isloggedin)
            (if isloggedin
                (do-logged-in)
                (do-logged-out))))))

(define (hide-button btn)
  (if (#js.btn.classList.contains #js"d-none")
    0
    (#js.btn.classList.add #js"d-none")
    ; (#js*.console.log (js-string (string-append "hiding button: " (js-string->string #js.btn.id))))
    )
  )

(define (show-button btn)
  (if (#js.btn.classList.contains #js"d-none")
    (#js.btn.classList.remove #js"d-none")
    0
    )
  )

(define (do-logged-in)
  (show-button (get-element-by-id "btn-save"))
  (show-button (get-element-by-id "btn-logout"))
  (hide-button (get-element-by-id "btn-login")))

(define (do-logged-out)
  (hide-button (get-element-by-id "btn-save"))
  (hide-button (get-element-by-id "btn-logout"))
  (show-button (get-element-by-id "btn-login")))

(define (logout)
  (#js*.fetch #js"/logout"))

(define (load-gist id)
  ($> (#js*.fetch ($/binop + "https://api.github.com/gists/" id))
      (then (λ (response)
                (if (equal? #js.response.status 200)
                  (#js.response.json)
                  ($/throw ($/new (#js*.Error "Gist not found."))))))
      (then (λ (data)
                (#js*.console.log #js.data.files)
                (set-racket-code ($ #js.data.files *gist-source-file* 'content))
              (define jscode ($ #js.data.files *gist-javascript-file* 'content))
              (cond
                [(and jscode ($/binop !== jscode #js""))
                 (set-javascript-code jscode)
                 (run)]
                [else
                 (compile #t)]))
                )
      (catch (λ (error) (show-error "Error load Gist"
                           #js.error.message)))
                
    )
)

(define (save)
  ;; this data will get forwarded to github
  ;; see: https://docs.github.com/en/rest/reference/gists#create-a-gist--parameters
  (define data
    {$/obj
     [public      #f]
     [description #js"RacketScript Playground Program"]
     [files
      (assoc->object
       `([,*gist-source-file* ,{$/obj
                                [content (#js.cm-editor-racket.getValue)]}]
         [,*gist-javascript-file* ,{$/obj
                                    [content (#js.cm-editor-jsout.getValue)]}]))]})
  ($> (#js*.fetch #js"/save" {$/obj 
                [method "POST"]
                [headers {$/obj
                  [Content-type (js-string "application/json; charset=utf-8")]}]
                [body 
                  (#js*.JSON.stringify data)]
        })
      (then (λ (response) (#js*.console.log response))))
  ; ($> (#js.jQuery.post #js"/save" data)
  ;     (done (λ (data)
  ;             (define id #js.data)
  ;             (:= #js.window.location.href ($/binop + #js"#gist/" id))))
  ;     (fail (λ (e)
  ;             (show-error "Error saving as Gist"
  ;                         #js.e.responseJSON.message))))
  )

;;-------------------------------------------------------------------------------

(define (get-modal id)
  ($/new (#js*.bootstrap.Modal (js-string id)))
  )

(define (show-error title msg)
  (define error-modal (get-modal "#error-modal"))
  (define modal-title (get-element-by-id "error-modal-title"))
  (define modal-body (query-selector "#error-modal p"))
  (#js*.console.log (js-string title))
  (#js*.console.log (js-string msg))
  (#js.error-modal.show)
  ($/:= #js.modal-title.innerHTML (js-string title))
  ($/:= #js.modal-body.innerHTML (js-string msg))
)

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
  (case (js-string->string ($ parts 0))
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
      (load-racket-code)
      (check-logged-in)))
  (#js*.window.addEventListener #js"hashchange" load-racket-code))
  (#js*.window.addEventListener #js"message"
    (λ (event)
      (when ($/binop === #js.event.data #js"run-iframe-init")
      (run-frame-init-handler event))))
  (#js*.window.addEventListener #js"message"
    (λ (event)
      (when ($/binop === #js.event.data #js"logged-in")
      (do-logged-in))))

(main)
