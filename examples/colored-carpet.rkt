#lang racketscript/base

(require racketscript/htdp/image
         racketscript/htdp/universe
         racketscript/browser
         racketscript/interop
         racket/match
         racket/list
         threading)

;; #js* references global JS objects.
;; #js"<string>" is a quick syntax for writing native JS strings.
;; "strings" are Racket strings (sequences of Unicode codepoints).
(define body (#js*.document.querySelector #js"body"))

;; #js.<var> references a RacketScript variable
;; ($/:= var val) assigns val to var
($/:= #js.body.style.margin 0)
($/:= #js.body.style.padding 0)

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

;; -> Non-Negative-Integer
(define (viewport-width)
  (- #js*.window.innerWidth 5))


;; -> Non-Negative-Integer
(define (viewport-height)
  (- #js*.window.innerHeight 5))

(print-image (welcome-image))
