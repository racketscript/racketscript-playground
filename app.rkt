#lang racket/base

(require rapture/ffi
         (for-syntax syntax/parse))


;;-----------------------------------------------------------------------------

(define express ($/require "express"))
(define body-parser ($/require "body-parser"))
(define child-process ($/require "child_process"))
(define spawn ($ child-process 'spawn))

(define console ($ 'global 'console))
(define $/undefined ($ 'undefined))

;;-----------------------------------------------------------------------------
(define PORT 8080)

;;-----------------------------------------------------------------------------
;; Handlers

(define (handle-index req res)
  ($$ res.send "Hello World!"))


(define (handle-compile req res)
  (define racket-code (or ($ req 'body 'code) #f))

  (cond
    [racket-code
     ($$ console.log "Compiling request.")

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
     ($$ rapture.stdin.write racket-code)
     ($$ rapture.stdin.end)

     ($$ rapture.stdout.on "data"
         (λ (data)
           (set-box! output (string-append (unbox output) data))))

     ($$ rapture.stderr.on "data"
         (λ (data)
           (set-box! err (string-append (unbox err) data))))

     ($$ rapture.on "error"
         (λ (err)
           ($$ res.send "Error invoking compiler.")))

     ($$ rapture.on "close"
         (λ (code)
           (cond
             [(zero? code)
              ($$ res.status 200)
              ($$ res.send (unbox output))]
             [else
              ($$ res.status 500)
              ($$ res.send (unbox err))])))]
    [else
     ($> ($$ res.status 400)
         (send "Bad Request"))]))

;;-----------------------------------------------------------------------------

(define (main)
  (define app (express))

  ($$ app.use ($$ express.static "static"))

  ($$ app.use ($$ body-parser.urlencoded {$/obj [extended #f]}))
  ($$ app.use ($$ body-parser.json))

  ($$ app.get "/" handle-index)
  ($$ app.post "/compile" handle-compile)

  ($$ app.listen PORT
      (λ ()
        ($$ console.log "Starting playground at port " PORT)))

  (void))

(main)
