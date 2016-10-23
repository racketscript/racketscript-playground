#lang racket

(require racketscript/interop racketscript/browser)

(define (sexp->html sexp)
  (define (compile-attrs attr-names attr-vals)
    (foldl (λ (name val acc)
             (format "~a ~a='~a\'" acc name val))
           ""
           attr-names
           attr-vals))
  (match sexp
    [(list tag-name (list [list attr-name attr-val] ...) body ...)
     (format "<~a~a>~a</~a>"
             tag-name
             (compile-attrs attr-name attr-val)
             (foldl (λ (b acc)
                      (string-append acc (sexp->html b)))
                    ""
                    body)
             tag-name)]
    [(list tag-name body ...)
     (sexp->html `(,tag-name () ,@body))]
    [(? string? val) val]
    [(? number? val) (number->string val)]))

(define html
  (sexp->html `(html
                (head
                 (body
                  (div ([width "100%"]
                        [align "left"])
                       (h1 "Hello world")
                       ,@(map (λ (n)
                               `(p ,(sqr n)))
                             (range 10))))))))

(displayln html)
($$ document.write html)
