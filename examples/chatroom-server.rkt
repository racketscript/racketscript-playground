#lang racketscript/base

(require racketscript-universe
         racketscript/htdp/image)

;; Example based on https://course.khoury.northeastern.edu/cs5010sp15/set08.html

;; WorldState:
;; (list ListOf<iWorld> ListOf<EventMessage>)

;; TODO:
;; Create methods to:
;; - generate mails for all clients
;; - add event to the event list

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
            [server-id     "my-server"]
            [on-new        handle-new]
            [on-msg        handle-msg]
            [on-disconnect handle-disconnect]))

(start-universe)