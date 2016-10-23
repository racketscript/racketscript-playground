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

(define *racket-editor-id*        "racket-edit")
(define *jsout-editor-id*         "jsout-edit")
(define *console-log-editor-id*   "console-log-edit")

;; Gist
(define *gist-source-file* "source.rkt")
(define *gist-javascript-file* "compiled.js")

;; CodeMirror

(define *cm-theme*          "neat")

(define cm-editor-racket    #f)
(define cm-editor-console   #f)
(define cm-editor-jsout     #f)

;; State

(define compiling?           #f)
(define last-compile-time    (#js*.Date.now))

(define ++ string-append)
(define-syntax := (make-rename-transformer #'$/:=))

;;-------------------------------------------------------------------------------
;; UI

(define (init-split-layout!)
  (#js*.Split [$/array "#left-container" "#right-container"]
              {$/obj [direction    "horizontal"]
                     [sizes        [$/array 50 50]]
                     [gutterSize   *split-gutter-size*]})
  (#js*.Split [$/array "#play-container" "#console-log-container"]
              {$/obj [direction    "vertical"]
                     [sizes        [$/array 75 25]]
                     [gutterSize   *split-gutter-size*]})
  (#js*.Split [$/array "#racket-container" "#jsout-container"]
              {$/obj [direction    "vertical"]
                     [sizes        [$/array 75 25]]
                     [gutterSize   *split-gutter-size*]}))

(define (register-button-events!)
  ($> (jQuery "#btn-compile")
      (click (λ (e)
               (#js.e.preventDefault)
               (compile #f))))
  ($> (jQuery "#btn-run")
      (click (λ (e)
               (#js.e.preventDefault)
               (run))))
  ($> (jQuery "#btn-compile-run")
      (click (λ (e)
               (#js.e.preventDefault)
               (compile #t))))
  ($> (jQuery "#btn-save")
      (click (λ (e)
               (#js.e.preventDefault)
               (save)))))

;;-----------------------------------------------------------------------------
;; Editors

;; DOM-Id (Listof (Pairof CodeMirrorOption CodeMirrorOptionValue)) -> CodeMirror
;; Initialize CodeMirror in HTML TextArea of id `dom-id` and
;; with CodeMirror `options`
(define (create-editor dom-id options)
  (define options*
    (assoc->object
     (append options
             `([theme          ,*cm-theme*]
               [matchBrackets  ,#t]
               [scrollbarStyle "simple"]
               [extraKeys
                ,{$/obj ["F11" (λ (cm)
                                 (toggle-editor-fullscreen cm))]
                        ["Esc" (λ (cm)
                                 (when (#js.cm.getOption "fullscreen")
                                   (toggle-editor-fullscreen cm)))]}]))))
  (#js*.CodeMirror.fromTextArea (#js.document.getElementById dom-id)
                                options*))

(define (toggle-editor-fullscreen cm)
  (#js.cm.setOption "fullScreen"
                    (not (#js.cm.getOption "fullScreen"))))

(define (init-editors!)
  (set! cm-editor-racket
        (create-editor *racket-editor-id*
                       '([lineNumbers    #t]
                         [mode           "scheme"])))
  (set! cm-editor-console
        (create-editor *console-log-editor-id*
                       '([lineNumbers    #f]
                         [readOnly       true])))
  (set! cm-editor-jsout
        (create-editor *jsout-editor-id*
                       '([lineNumbers    #t]
                         [readOnly       #f]
                         [mode           "javascript"]))))

(define (append-to-editor! editor str)
  (#js.editor.replaceRange str {$/obj [line +inf.0]}))

;;-------------------------------------------------------------------------------
;; Console

(define (get-logger level)
  (λ args
    (append-to-editor! cm-editor-console (++ "[" level "] "))
    (for-each (λ (a)
                (append-to-editor!
                 cm-editor-console (++ (cond
                                         [(string? a) a]
                                         [(number? a) (number->string a)]
                                         [else (#js*.JSON.stringify a)])
                                       " "))
                (append-to-editor! cm-editor-console "\n"))
              args)))

(define (override-console frame)
  (define frame-win #js.frame.contentWindow)
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
  (#js.cm-editor-jsout.setValue (#js*.js_beautify code)))

;;-------------------------------------------------------------------------------
;; Ops

(define (run-racket code)
  (define run-frame (#js.document.getElementById "run-area"))
  (define src #js.run-frame.src)
  (:= #js.run-frame.src "")
  (:= #js.run-frame.src src)
  (:= #js.run-frame.onload
      (λ ()
        (define doc #js.run-frame.contentWindow.document)
        (define head ($ (#js.doc.getElementsByTagName "head") 0))
        (define script (#js.doc.createElement "script"))
        (override-console run-frame)
        (:= #js.script.type "module")
        (:= #js.script.text code)
        (#js.head.appendChild script)
        (#js.run-frame.contentWindow.System.loadScriptTypeModule))))

(define (run)
  (define code (#js.cm-editor-jsout.getValue))
  (cond
    [(equal? code "") (#js*.console.warn "Code not compiled!")]
    [else (#js.cm-editor-console.setValue "Console Log: \n")
          (run-racket code)]))

(define (compile execute?)
  (when (or (not compiling?) (> (- (#js*.Date.now) last-compile-time) 5000))
    (:= compiling? #t)
    (#js*.setTimeout (λ ()
                       (:= compiling? #f))
                     5000)
    (#js.cm-editor-console.setValue "Console Log:\n")
    (#js.cm-editor-jsout.setValue "Compiling ...")
    ($> (#js.jQuery.post "/compile" {$/obj [code (#js.cm-editor-racket.getValue)]})
        (done (λ (data)
                (set-javascript-code data)
                (when execute?
                  (run))))
        (fail (λ (xhr status err)
                (#js.cm-editor-console.setValue
                 (++ "Compilation error:\n" #js.xhr.responseText))
                (#js.cm-editor-jsout.setValue "")))
        (always (λ ()
                  (:= compiling? #f))))))

;;-----------------------------------------------------------------------------
;; Save and Load Gist

(define (load-gist id)
  ($> (#js.jQuery.get (++ "https://api.github.com/gists/" id))
      (done (λ (data)
              (set-racket-code ($ #js.data.files *gist-source-file* 'content))
              (define jscode ($ #js.data.files *gist-javascript-file* 'content))
              (cond
                [(and jscode (not (equal? jscode "")))
                 (set-javascript-code jscode)
                 (run)]
                [else
                 (compile #t)])))
      (fail (λ (xhr)
              (show-error "Error load Gist"
                          (++ #js.xhr.responseJSON.message))))))

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
  ($> (#js.jQuery.post "https://api.github.com/gists" (#js*.JSON.stringify data))
      (done (λ (data)
              (define id #js.data.id)
              (:= #js.window.location.href (++ "#gist/" id))))
      (fail (λ (e)
              (show-error "Error saving as Gist"
                          #js.e.responseJSON.message)))))

;;-------------------------------------------------------------------------------

(define (show-error title msg)
  ($> (#js.jQuery "#error-modal")
                  (modal "show"))
  ($> (#js.jQuery "#error-modal .modal-title")
      (text title))
  ($> (#js.jQuery "#error-modal p")
      (text msg)))

;;-------------------------------------------------------------------------------

(define (load-racket-example example-name)
  ($> (#js.jQuery.get (format "/examples/~a.rkt" example-name))
      (done (λ (data)
              (set-racket-code data))))
  ($> (#js.jQuery.get (format "/examples/~a.rkt.js" example-name))
      (done (λ (data)
              (set-javascript-code data)
              (run)))))

(define (reset-ui!)
  ;; Reset editors
  (#js.cm-editor-racket.setValue "Loading ...")
  (#js.cm-editor-jsout.setValue "")
  (#js.cm-editor-console.setValue "")

  ;; Reset the iframe with a blank page
  (define run-frame (#js.document.getElementById "run-area"))
  (:= #js.run-frame.contentWindow.location "about:blank"))

(define (load-racket-code)
  ;; TODO: string-split doesn't work
  (define parts ($> (substring #js.window.location.hash 1)
                    (split "/")))
  (reset-ui!)
  (case ($ parts 0)
    [("gist") (load-gist ($ parts 1))]
    [("example") (load-racket-example ($ parts 1))]
    [else (load-racket-example "default")]))

(define (main)
  ($> (jQuery document)
      (ready (λ ()
               (init-editors!)
               (init-split-layout!)
               (register-button-events!)
               (load-racket-code))))
  ($> (jQuery window)
      (on "hashchange" load-racket-code)))

(main)
