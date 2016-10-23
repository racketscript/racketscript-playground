#lang racketscript/base

(require racketscript/htdp/universe
         racketscript/htdp/image
         racketscript/interop
         racketscript/browser)

;; Rain falls down the screen.
(define GRAVITY-FACTOR 1)
(define DROP-MAX-SIZE 10)

;;-----------------------------------------------------------------------------
;; World Structures

(struct world (drops))
(struct drop (posn velocity color size))

(define (viewport-width)
  (- #js.window.innerWidth 25))

(define (viewport-height)
  (- #js.window.innerHeight 25))

(define (random-velocity)
  (+ 5 (random 10)))

;; random-drop-particle: drop
;; Generates a random particle.
(define (random-drop)
  (drop (posn (random (viewport-width)) 0)
        (random-velocity)
        (random-choice (list "gray"
                             "darkgray"
                             "white"
                             "blue" 
                             "lightblue"
                             "darkblue"))
        (random DROP-MAX-SIZE)))

;; random-choice: (ListOf X) -> X
;; Picks a random element of elts.
(define (random-choice elts)
  (list-ref elts (random (length elts))))

;; tick: world -> world
(define (tick w)
  (world
   (filter not-on-floor?
           (map drop-descend (cons (random-drop)
                                   (cons (random-drop)
                                         (world-drops w)))))))

;; drop-descend: drop -> drop
;; Makes the drops descend.
(define (drop-descend a-drop)
  (cond
    [(> (posn-y (drop-posn a-drop)) (viewport-height))
     a-drop]
    [else
     (drop (posn-descend (drop-posn a-drop) (drop-velocity a-drop))
           (+ GRAVITY-FACTOR (drop-velocity a-drop))
           (drop-color a-drop)
           (drop-size a-drop))]))

;; posn-descend: posn number -> posn
(define (posn-descend a-posn n)
  (make-posn (posn-x a-posn)
             (+ n (posn-y a-posn))))

;; on-floor?: drop -> boolean
;; Produces true if the drop has fallen to the floor.
(define (on-floor? a-drop)
  (> (posn-y (drop-posn a-drop))
     (viewport-height)))

(define (not-on-floor? a-drop)
  (not (on-floor? a-drop)))

;; make-drop-image: color number -> drop
;; Creates an image of the drop particle.
(define (make-drop-image color size)
  (circle size "solid" color))

;; place-drop: drop scene -> scene
(define (place-drop a-drop a-scene)
  (place-image (make-drop-image (drop-color a-drop)
                                (drop-size a-drop))
               (posn-x (drop-posn a-drop))
               (posn-y (drop-posn a-drop))
               a-scene))

;; draw: world -> scene
(define (draw w)
  (foldl place-drop (empty-scene (viewport-width) 
                                 (viewport-height))
         (world-drops w)))

(big-bang (world '())
          (to-draw draw)
          (on-tick tick))
