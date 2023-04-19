#lang racketscript/base

;; RacketScript is an experimental Racket to JavaScript compiler,
;; which hopes to be practically useful someday. Source code is
;; available at https://github.com/vishesh/racketscript

;; We support modules, but we don't yet compile Racket's stdlib.
(require racketscript/htdp/universe  racketscript/htdp/image  ;; replaces 2htdp/*
         racketscript/interop
         racketscript/browser
         racket/match
         threading)

;; #lang racketscript/base comes with reader extension to interact
;; with JS objects. #js*.<id> picks identifier `id` bound in JS
;; environment, while #js.<id> is used to pick identifier bound in
;; Racket environment. A dot `.` in identifier would split id and do a
;; JS object ref. Eg. `#js*.window.document` would translate to
;; `window.document`"

;; Here's a toy function to convert xexpr to DOM element using document.querySelector.
(define (sexp->jq sexp)
  (define (add-attrs jq attr-names attr-vals)
    (foldl (λ (name val jq)
             (#js.jq.attr ($/str name) ($/str val)))
           jq
           attr-names
           attr-vals))
  (define (add-childs jq childs)
    (foldl (λ (child jq)
             (#js.jq.append child))
           jq
           childs))
  (match sexp
    [(list (app symbol->string tag-name)
           (list [list (app symbol->string attr-names) (app sexp->jq attr-vals)] ...)
           (app sexp->jq childs) ...)
     (~> (format "<~a></~a>" tag-name tag-name)
         ($/str _)
         (#js*.document.querySelector _)
         (add-attrs _ attr-names attr-vals)
         (add-childs _ childs))]
    [(list tag-name childs ...)
     (sexp->jq `(,tag-name () ,@childs))]
    [(? string? v) ($/str v)]
    [(? number? v) ($/str (number->string v))]))


;; $> is exported by racketscript/interop to make chaining more
;; convenient.
($> (#js.document.addEventListener #js"DOMContentLoaded" 
    (λ _
       (displayln "DOM loaded!")
       ($> (#js*.document.querySelector #js"body")
           (append (sexp->jq
                    `(div
                      (h1 ([align "center"]) "Hello World!")
                      (div
                       (ul
                        (li (a ([href "https://github.com/vishesh/racketscript"]
                                [target "_blank"])
                               "RacketScript on Github"))
                        (li (a ([href "https://github.com/vishesh/racketscript-playground"]
                                [target "_blank"])
                               "Playground on Github"))
                        (li (a ([href "http://www.racket-lang.org/"]
                                [target "_blank"])
                               "Racket Programming Language")))))))))))

($> (#js.document.addEventListener #js"click" 
    (λ (e)
          (displayln (list "clicked at: " #js.e.pageX #js.e.pageY)))))


;; Tail calls are converted to loops when possible. Match is
;; experimentally supported.

(define (forever)
  (forever))

(define (sum lst)
  (define (sum/acc lst acc)
    (match lst
      ['() acc]
      [(cons hd tl) (sum/acc tl (+ acc hd))]))
  (sum/acc lst 0))
