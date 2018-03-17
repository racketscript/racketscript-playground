#lang racketscript/base

(require racketscript/interop
         (for-syntax syntax/parse))


;;-----------------------------------------------------------------------------

(define express ($/require "express"))
(define body-parser ($/require "body-parser"))
(define child-process ($/require "child_process"))
(define spawn ($ child-process 'spawn))

(define console #js*.global.console)

;;-----------------------------------------------------------------------------
(define PORT 8080)

;;-----------------------------------------------------------------------------
;; Handlers

(define (handle-compile req res)
  (define racket-code (or ($ req 'body 'code) #f))

  (cond
    [racket-code
     (#js.console.log #js"Compiling request.")

     (define racks (spawn #js"racks"
                            [$/array #js"-n"
                                     #js"--js"
                                     #js"--stdin"
                                     #js"--enable-self-tail"]))

     (define output #js"")
     (define err    #js"")

     ;; Write to process input stream, followed by closing it
     ;; so that we get output
     (#js.racks.stdin.write racket-code)
     (#js.racks.stdin.end)

     (#js.racks.stdout.on #js"data"
       (λ (data)
         ($/:= output ($/binop + output data))))

     (#js.racks.stderr.on #js"data"
       (λ (data)
         ($/:= err ($/binop + err data))))

     (#js.racks.on #js"error"
       (λ (err)
         (#js.res.send #js"Error invoking compiler.")))

     (#js.racks.on #js"close"
       (λ (code)
         (cond
           [(equal? code 0)
            (#js.res.status 200)
            (#js.res.send output)]
           [else
            (#js.res.status 400)
            (#js.res.send err)])))]
    [else
     ($> (#js.res.status 400)
         (send #js"Bad Request"))]))

;;-----------------------------------------------------------------------------

(define (main)
  (define app (express))

  (#js.app.use (#js.express.static #js"static"))
  (#js.app.use #js"/examples" (#js.express.static #js"examples"))

  (#js.app.use (#js.body-parser.urlencoded {$/obj [extended #f]
                                                  [limit #js"8mb"]}))
  (#js.app.use (#js.body-parser.json {$/obj [limit #js"8mb"]}))

  (#js.app.post #js"/compile" handle-compile)

  (#js.app.listen PORT
      (λ ()
        (#js.console.log #js"Starting playground at port" PORT)))

  (void))

(main)
