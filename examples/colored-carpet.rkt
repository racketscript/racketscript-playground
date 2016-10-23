#lang racketscript/base

(require racketscript/htdp/image
         racketscript/htdp/universe
         racketscript/browser
         racketscript/interop
         racket/match
         racket/list
         threading)

(define (colored-carpet colors)
  (match colors
    [(cons hd '()) (square 1 "solid" hd)]
    [(cons hd tl)
     (define c (colored-carpet tl))
     (define i (square (image-width c) "solid" hd))
     (freeze (above (beside c c c)
                    (beside c i c)
                    (beside c c c)))]))

(define (carpet colors)
  (define c        (colored-carpet colors))
  (define n-horiz  (ceiling (/ (viewport-width) (image-width c))))
  (define n-vert   (ceiling (/ (viewport-height) (image-height c))))

  (~> (make-list n-horiz c)
      (apply beside _)
      (make-list n-vert _)
      (apply above _)
      (place-image/align _ 0 0 "left" "top"
                         (empty-scene (viewport-width) (viewport-height)))))

(define (viewport-width)
  (- ($> (#js*.jQuery window) (width)) 5))

(define (viewport-height)
  (- ($> (#js*.jQuery window) (height)) 5))

($> (#js*.jQuery document)
    (ready
     (λ ()
       ($> (#js*.jQuery "body,html,canvas")
           (css "margin" 0)
           (css "padding" 0))

       (print-image
        (carpet
         (list (color 51 0 255)
               (color 102 0 255)
               (color 153 0 255)
               (color 204 0 255)
               (color 255 0 255)
               (color 255 204 0)))))))
