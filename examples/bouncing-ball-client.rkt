#lang racketscript/base
(require racketscript/htdp/peer-universe
         racketscript/htdp/image)

;; Implementation of bouncing ball example from
;; 2htdp/universe docs
;; ( https://docs.racket-lang.org/teachpack/2htdpuniverse.html )
;; (ctrl + F search for "Designing the Ball World")

(define SPEED 5)
(define RADIUS 10)
(define WORLD0 'RESTING)

(define WIDTH 600)
(define HEIGHT 400)
(define MT (empty-scene WIDTH HEIGHT))
(define BALL (circle RADIUS 'solid 'blue))

(define (move ws)
  (define is-active (number? ws))
  (if is-active
    (if (<= ws 0)
        (make-package 'RESTING #js"done")
        (- ws SPEED))
    ws))

(define (draw ws)
  (cond
    [(number? ws) (underlay/xy MT 50 ws BALL)]
    [else (underlay/xy MT 50 50 (text "Resting" 24 'blue))]))

;; The only message that the server send is the your-turn one,
;; so this will always return HEIGHT as the next world state
(define (receive ws msg)
  (if (number? ws)
      ws
      HEIGHT))

;; Stops world when ws == "stop"
(define (stop? ws) (equal? ws "stop"))

(define (handle-key ws key)
  (if (equal? key " ")
      "stop" ws))

(define (start-world client-name server-id)
    (big-bang WORLD0 
              [on-tick move]
              [to-draw draw]
              [on-receive receive]
              [register server-id]
              [name client-name]
              [on-key handle-key]
              [stop-when stop?]))

;; 
;; User login UI
;; 

(define join-form         (#js*.document.createElement #js"form"))
(define server-id-label   (#js*.document.createElement #js"label"))
(define br-1              (#js*.document.createElement #js"br"))
(define server-id-input   (#js*.document.createElement #js"input"))
(define br-2              (#js*.document.createElement #js"br"))
(define form-submit       (#js*.document.createElement #js"input"))

($/:= #js.server-id-label.innerHTML   #js"Server's Peer ID")
($/:= #js.server-id-input.placeholder #js"42adwadwa#$021")
($/:= #js.form-submit.type            #js"submit")
($/:= #js.form-submit.value           #js"Join!")

(for-each (λ (el)
            (#js.join-form.appendChild el)
            0)
          (list server-id-label br-1 server-id-input
                br-2
                form-submit))

($/:= #js.join-form.onsubmit
      (λ ()
        (start-world "user"
                     (js-string->string #js.server-id-input.value))
        (#js.join-form.remove)))

(#js*.document.body.appendChild join-form)