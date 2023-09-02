#lang racket

;; Hack to compile all runtime files

(require racketscript/interop
         racketscript/browser
         racketscript/htdp/image
         racketscript/htdp/universe
         rackt)

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

sort

displayln

print

write

;; racket/private/list-predicate.rkt
empty?

;; vector
vector-member

;; string
string-contains?

;; rackt
<el
render