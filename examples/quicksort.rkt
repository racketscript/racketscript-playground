#lang racket

(define (partition cmp pivot lst)
  (let loop ([lst lst]
             [part-a '()]
             [part-b '()])
    (match lst
      ['() (cons part-a part-b)]
      [(cons hd tl) #:when (cmp hd pivot)
       (loop tl (cons hd part-a) part-b)]
      [(cons hd tl) (loop tl part-a (cons hd part-b))])))
    
(define (quicksort cmp lst)
  (match lst
    ['() '()]
    [(cons hd tl)
     (match-define (cons part-a part-b) (partition cmp hd tl))
     (append (quicksort cmp part-a)
             (cons hd (quicksort cmp part-b)))]))

(displayln (quicksort < '(1 5 3 9 3 8 12 5 32 21 16 4 5 1)))
(displayln (quicksort > '(1 5 3 9 3 8 12 5 32 21 16 4 5 1)))
