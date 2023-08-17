#lang racketscript/base

(require racketscript/htdp/peer-universe
         racketscript/htdp/image)

;; Example based on https://course.khoury.northeastern.edu/cs5010sp15/set08.html

;; WorldState:
;; (list ListOf<iWorld> ListOf<EventMessage>)


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

(define (make-client-list ws)
  (foldl (lambda (iw result) (append result (list (iworld-name iw)))) '() ws))

(define (make-broadcast sender msg)
  (format "[]"))

(define (mail-to-all ws content)
  (foldl (lambda (iw result)
           (append result (list (make-mail iw content))))
         '()
         ws))

(define (client-list-mails ws)
  (define client-list (make-client-list ws))
  (mail-to-all ws (list 'userlist client-list)))


;; 
;; Event handlers
;; 

(define (handle-new ws iw)
  (define ws* (append ws (list iw)))
  (define mails (client-list-mails ws*))
  (define to-remove '())
  (make-bundle ws* mails to-remove))

(define (handle-msg ws iw msg)
  (define msg-mail (list 'broadcast (iworld-name iw) msg))
  (define ws* ws)
  (define mails (mail-to-all ws* msg-mail))
  (define to-remove '())
  (make-bundle ws* mails to-remove))

(define (handle-disconnect ws iw)
  (define ws* (remove iw ws))
  (define mails (client-list-mails ws*))
  (define to-remove '())
  (make-bundle ws* mails to-remove))

(define (start-universe root)
  (universe #:dom-root root
            '()
            [server-id     (generate-id)]
            [on-new        handle-new]
            [on-msg        handle-msg]
            [on-disconnect handle-disconnect]))

(start-universe)