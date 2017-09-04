#lang racket

;; Hack to compile all runtime files

(require racketscript/interop
         racketscript/browser
         racketscript/htdp/image
         racketscript/htdp/universe)

;; interop
assoc->object
#%js-ffi

;; browser
window

;; image
square

;; universe
big-bang

;; list
foldr
make-list

;; boolean
true
false

;; math
pi

;; match
(match '(1 2)
  [`(,a ,b) (+ a b)])

;; for
(for ([i '(1 2 3)])
  (displayln i))
