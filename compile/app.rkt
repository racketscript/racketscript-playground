#lang racketscript/base

(require racketscript/interop
         (for-syntax syntax/parse))


;;-----------------------------------------------------------------------------

(define express ($/require "express"))
(define body-parser ($/require "body-parser"))
(define child-process ($/require "child_process"))
(define spawn ($ child-process 'spawn))

(define console #js.global.console)

;;-----------------------------------------------------------------------------
(define PORT 8080)

;;-----------------------------------------------------------------------------
;; Handlers

(define (handle-compile req res)
  (define racket-code (or ($ req 'body 'code) #f))

  (cond
    [racket-code
     (#js.console.log "Compiling request.")

     (define rapture (spawn "rapture"
                            [$/array "-n"
                                     "--js"
                                     "--js-beautify"
                                     "--stdin"
                                     "--enable-self-tail"]))

     (define output (box ""))
     (define err    (box ""))

     ;; Write to process input stream, followed by closing it
     ;; so that we get output
     (#js.rapture.stdin.write racket-code)
     (#js.rapture.stdin.end)

     (#js.rapture.stdout.on "data"
         (λ (data)
           (set-box! output (string-append (unbox output) data))))

     (#js.rapture.stderr.on "data"
         (λ (data)
           (set-box! err (string-append (unbox err) data))))

     (#js.rapture.on "error"
         (λ (err)
           (#js.res.send "Error invoking compiler.")))

     (#js.rapture.on "close"
         (λ (code)
           (cond
             [(zero? code)
              (#js.res.status 200)
              (#js.res.send (unbox output))]
             [else
              (#js.res.status 500)
              (#js.res.send (unbox err))])))]
    [else
     ($> (#js.res.status 400)
         (send "Bad Request"))]))

;;-----------------------------------------------------------------------------

(define (main)
  (define app (express))

  (#js.app.use (#js.express.static "static"))

  (#js.app.use (#js.body-parser.urlencoded {$/obj [extended #f]}))
  (#js.app.use (#js.body-parser.json))

  (#js.app.post "/compile" handle-compile)

  (#js.app.listen PORT
      (λ ()
        (#js.console.log "Starting playground at port " PORT)))

  (void))

(main)
