#lang racketscript/base

;; RacketScript is an experimental Racket to JavaScript compiler,
;; which hopes to be practically useful someday. Source code is
;; available at https://github.com/racketscript/racketscript

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
(define (add-elem-to-body elem)
  (#js*.document.body.appendChild elem)
  elem)

;; Here's a toy function to convert xexpr to a DOM element.
(define (sexp->html sexp)
  (define (add-attr attr-name attr-val elem)
    (#js.elem.setAttribute ($/str attr-name) ($/str attr-val))
    elem)
  (define (add-child child elem)
    (#js.elem.append child)
    elem)
  (define (add-attrs elem attr-names attr-vals)
    (foldl add-attr
           elem
           attr-names
           attr-vals))
  (define (add-childs elem childs)
    (foldl add-child
           elem
           childs))
  (match sexp
    [(list (app symbol->string tag-name)
           (list [list (app symbol->string attr-names) (app sexp->html attr-vals)] ...)
           (app sexp->html childs) ...)
     (~> ($/str tag-name)
         (#js*.document.createElement _)
         (add-attrs _ attr-names attr-vals)
         (add-childs _ childs))]
    [(list tag-name childs ...)
     (sexp->html `(,tag-name () ,@childs))]
    [(? string? v) ($/str v)]
    [(? number? v) ($/str (number->string v))]))


(define (on-dom-loaded callback)
  (if (or ($/binop === #js.document.readyState #js"interactive") ($/binop === #js.document.readyState #js"complete"))
    (callback)
    (#js.document.addEventListener #js"DOMContentLoaded" callback)))


(define load-page-contents 
  (λ _
       (displayln "DOM loaded!")
        
        ;; $> is exported by racketscript/interop to make chaining more
        ;; convenient.
       ($> (#js*.document.querySelector #js"body")
           (append (sexp->html
                    `(div
                      (h1 ([align "center"]) "Hello World!")
                      (div
                       (ul
                        (li (a ([href "https://github.com/racketscript/racketscript"]
                                [target "_blank"])
                               "RacketScript on Github"))
                        (li (a ([href "https://github.com/racketscript/racketscript-playground"]
                                [target "_blank"])
                               "Playground on Github"))
                        (li (a ([href "http://www.racket-lang.org/"]
                                [target "_blank"])
                               "Racket Programming Language"))))))))))


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

(on-dom-loaded load-page-contents)