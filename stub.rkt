#lang racketscript/base

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
