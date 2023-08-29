#lang racketscript/base

(require rackt)

;; 
;; Uses a slightly modified version of the rackt module, a lightweight react wrapper
;; for racketscript. 
;; Check it out @ https://github.com/rackt-org/rackt
;; 

(define root (#js*.document.createElement #js"div"))
($/:= #js.root.id #js"root")
(#js*.document.body.appendChild root)
 
(define (header props ..)
    (<el "div"
        (<el "h1" "React Counter Example")
        (<el "p" "A simple counter demo using "
             (<el "a" "rackt"
                  #:props ($/obj [href "https://github.com/rackt-org/rackt"]))
             ", a react wrapper for racketscript.")))

(define (counter props ..)
    (define-values (counter set-counter) (use-state 0))

    (<el "div"
        (<el header)
        (<el "button"
            #:props ($/obj [ className "button" ]
                   [ type "button" ]
                   [onClick (lambda (_) (set-counter (- counter 1)))])
            "- 1")

        (<el "span" #:props ($/obj [ className "counter" ]) counter)

        (<el "button"
            #:props ($/obj [ className "button" ]
                   [ type "button" ]
                   [onClick (lambda (_) (set-counter (+ counter 1)))])
            "+ 1")))

(render (<el counter) "root")
