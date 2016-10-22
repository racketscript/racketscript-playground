#lang racketscript/base

(require racketscript/browser racketscript/interop
         (for-syntax racket/base))
(define jQuery #js*.$)

;;----------------------------------------------------------------------------
;; Globals

(define *split-gutter-size* 4)
  
(define *racket-editor-id*        "racket-edit")
(define *jsout-editor-id*         "jsout-edit")
(define *console-log-editor-id*   "console-log-edit")

(define *cm-theme*          "neat")

(define cm-editor-racket    #f)
(define cm-editor-console   #f)
(define cm-editor-jsout     #f)

(define compiling?           #f)
(define last-compile-time    (#js*.Date.now))

(define ++ string-append)

(define-syntax := (make-rename-transformer #'$/:=))

;;-------------------------------------------------------------------------------
;; UI

(define (init-split-layout!)
  (#js*.Split [$/array "#left-container" "#right-container"]
              ($/obj [direction    "horizontal"]
                     [sizes        [$/array 50 50]]
                     [gutterSize   *split-gutter-size*]))
  (#js*.Split [$/array "#console-log-container" "#play-container"]
              ($/obj [direction    "vertical"]
                     [sizes        [$/array 25 75]]
                     [gutterSize   *split-gutter-size*]))
  (#js*.Split [$/array "#racket-container" "#jsout-container"]
              ($/obj [direction    "vertical"]
                     [sizes        [$/array 70 30]]
                     [gutterSize   *split-gutter-size*])))

(define (register-button-events!)
  ($> (jQuery "#compile-btn")
      (click compile))
  ($> (jQuery "#run-btn")
      (click run))
  ($> (jQuery "#compile-run-btn")
      (click (λ () (compile #t)))))

;;-----------------------------------------------------------------------------
;; Editors

;; DOM-Id (Listof (Pairof CodeMirrorOption CodeMirrorOptionValue)) -> CodeMirror
;; Initialize CodeMirror in HTML TextArea of id `dom-id` and
;; with CodeMirror `options`
(define (create-editor dom-id options)
  (define options* (assoc->object
                    (append options
                            '([theme          *cm-theme*]
                              [matchBrackets  true]))))
  (#js*.CodeMirror.fromTextArea (#js.document.getElementById dom-id)
                                options*))

(define (init-editors!)
  (set! cm-editor-racket
        (create-editor *racket-editor-id*
                       '([lineNumbers    #t]
                         [mode           "scheme"])))
  (set! cm-editor-console
        (create-editor *console-log-editor-id*
                       '([lineNumbers    #f]
                         [readOnly       true]
                         [mode           "scheme"])))
  (set! cm-editor-jsout
        (create-editor *jsout-editor-id*
                       '([lineNumers     #t]
                         [readOnly       #f]
                         [mode           "javascript"]))))

(define (append-to-editor! editor str)
  (#js.editor.replaceRange str ($/obj [line +inf.0])))

;; Console

(define (get-logger level)
  (λ args
    (append-to-editor! cm-editor-console (++ "[" level "]"))
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
        (define head ($ #js.doc.getElementsByTagName("head") 0))
        (define script (#js.doc.createElement "script"))
        (override-console run-frame)
        (:= #js.script.type "module")
        (:= #js.script.text "code")
        (#js.head.appendChild script)
        (#js.run-frame.contentWindow.System.loadScriptTypeModule))))

(define (run)
  (define code (#js.cm-editor-jsout.getValue))
  (cond
    [(equal? code "") (#js*.alert "Code not compiled!")]
    [else (#js.cm-editor-console.setValue "Console Log: \n")
          (run-racket code)]))

(define (compile execute?)
  (unless (or compiling? (> (- (#js*.Date.now) last-compile-time) 5000))
    (:= compiling? #t)
    (#js*.setTimeout (λ ()
                       (:= compiling? #f))
                     5000)
    (#js.cm-editor-console.setValue "Console Log:\n")
    (#js.cm-editor-jsout.setValue "Compiling ...")
    ($> (#js.jQuery.post "/compile" {$/obj [code (#js.cm-editor-racket.getValue)]})
        (done (λ (data)
                (#js.cm-editor-jsout.setValue (#js*.js_beautify data))
                (when execute?
                  (run))))
        (fail (λ (xhr status err)
                (#js.cm-editor-console.setValue
                 (++ "Compilation error:\n" #js.xhr.responseText))
                (#js.cm-editor-jsout.setValue "")))
        (always (λ ()
                  (:= compiling? #f))))))
  
;;-------------------------------------------------------------------------------

(define (main)
  ($> (jQuery document)
      (ready (λ ()
               (init-editors!)
               (init-split-layout!)
               (register-button-events!)))))

(main)
