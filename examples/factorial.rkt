#lang racket/base

(define (factorial n)
  (let loop ([n n]
             [a 1])
    (if (zero? n)
        a
        (loop (sub1 n) (* n a)))))

(displayln (factorial 6))
