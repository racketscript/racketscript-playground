#lang racketscript/base

(require racketscript/htdp/peer-universe
         racketscript/htdp/image
         racket/list)


;; 
;; Funny words courtesy of ChatGPT
;; 

(define funny-adjectives (list "bumbling"
                               "quizzical"
                               "wacky"
                               "zany"
                               "fluffy"
                               "bizarre"
                               "hilarious"
                               "whimsical"
                               "absurd"
                               "goofy"
                               "ridiculous"
                               "loopy"
                               "nutty"
                               "eccentric"
                               "silly"
                               "quirky"
                               "jovial"
                               "giggly"
                               "mirthful"
                               "haphazard"
                               "chucklesome"
                               "fanciful"
                               "droll"
                               "boisterous"
                               "offbeat"
                               "hysterical"
                               "peculiar"
                               "lighthearted"
                               "playful"
                               "amusing"))

(define funny-nouns (list "goober"
                          "banana"
                          "sock-puppet"
                          "llama"
                          "rubber-chicken"
                          "pajamas"
                          "gobbledygook"
                          "poodle"
                          "bubble-wrap"
                          "tater-tot"
                          "cheeseburger"
                          "wiggle"
                          "snorkel"
                          "ticklemonster"
                          "jello"
                          "balloon-animal"
                          "slinky"
                          "spaghetti"
                          "bumblebee"
                          "dingleberry"
                          "flapdoodle"
                          "doohickey"
                          "noodle"
                          "gobbledygook"
                          "whatchamacallit"
                          "snickerdoodle"
                          "popsicle"
                          "gigglesnort"
                          "wobble"
                          "hootenanny"
                          "noodle"))

(define (generate-id)
  (define adjective (list-ref funny-adjectives 
                              (random (length funny-adjectives))))
  (define noun (list-ref funny-nouns
                         (random (length funny-nouns))))
  (format "~a-~a" adjective noun))


;; 
;; Helper functions
;; 

(define (make-curr-mail ws)
  (define curr-iw (first ws))
  (list (make-mail curr-iw #js"it-is-your-turn")))


;; 
;; Event handlers
;; 

(define (handle-new ws iw)
  (define ws* (append ws (list iw)))
  (define mails (make-curr-mail ws*))
  (define to-remove '())
  (make-bundle ws* mails to-remove))

(define (handle-msg ws iw msg)
  (define ws* (append (rest ws) (list (first ws))))
  (define mails (make-curr-mail ws*))
  (define to-remove '())
  (make-bundle ws* mails to-remove))

(define (handle-disconnect ws iw)
  (define ws* (remove iw ws))
  (define mails (make-curr-mail ws*))
  (define to-remove '())
  (make-bundle ws* mails to-remove))

(define (handle-tick ws)
  (make-bundle ws '() '()))


;; 
;; Starting server on window load
;; 

(define (start-universe)
  (universe '()
    [server-id     (generate-id)]
    [on-new        handle-new]
    [on-msg        handle-msg]
    [on-tick       handle-tick]
    [on-disconnect handle-disconnect]))

($/:= #js*.window.onload start-universe)