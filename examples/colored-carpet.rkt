#lang racketscript/base

(require racketscript/htdp/image
         racketscript/htdp/universe
         racketscript/browser
         racketscript/interop
         racket/match
         racket/list
         threading)

(let ([jquery #js*.jQuery])
  ($> (jquery document)
      (ready
       (λ ()
         ($> (jquery #js"body")
             (css #js"margin" 0)
             (css #js"padding" 0))
         (print-image (welcome-image))))))

;; (Listof Color) -> Image
;; Returns a single tile of carpet
(define (colored-carpet colors)
  (match colors
    [(cons hd '()) (square 1 'solid hd)]
    [(cons hd tl)
     (define c (colored-carpet tl))
     (define i (square (image-width c) 'solid hd))
     (freeze (above (beside c c c)
                    (beside c i c)
                    (beside c c c)))]))

;; (Listof Color) -> Image
;; Creates a tile using colors and combines them to fill current
;; viewport
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

;; String FontSize -> Image
(define (banner txt size)
  (let ([b-text (text txt size 'black)])
    (overlay b-text
             (rectangle (* 1.2 (image-width b-text))
                        (* 1.4 (image-height b-text))
                        'solid 'white))))

;; -> Image
(define (welcome-image)
  (overlay (banner "RacketScript" 48)
           (carpet
             (list (color 51 0 255)
                   (color 102 0 255)
                   (color 153 0 255)
                   (color 204 0 255)
                   (color 255 0 255)
                   (color 255 204 0)))))

;; -> Non-Negative-Integet
(define (viewport-width)
  (- ($> (#js*.jQuery window) (width)) 5))

;; -> Non-Negative-Integet
(define (viewport-height)
  (- ($> (#js*.jQuery window) (height)) 5))
