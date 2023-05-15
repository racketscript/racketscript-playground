#lang racket

(require racketscript/interop racketscript/browser)

(define (sexp->html sexp)
  (match sexp
    [(list tag-name (list [list attr-name attr-val] ...) children ...)
     (define node
       ($$ document.createElement (symbol->string tag-name)))
     (for-each (lambda (name val)
                 ($$ node.setAttribute name val))
               attr-name
               attr-val)
     (for-each (lambda (child)
                 ($$ node.append child))
               (map sexp->html children))
     node]
    [(list tag-name children ...)
     (sexp->html `(,tag-name () ,@children))]
    [(? string? val) val]
    [(? number? val) (number->string val)]))

(define html
  (sexp->html `(div ([width "100%"]
                     [align "left"])
                    (h1 "Hello world")
                    ,@(map (λ (n)
                             `(p ,(sqr n)))
                           (range 10)))))

(define body ($$ document.querySelector "body"))
($$ body.append html)
