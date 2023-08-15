#lang racketscript/base

(require racket/list
         racketscript-universe
         racketscript/htdp/image)

;; Example based on https://course.khoury.northeastern.edu/cs5010sp15/set08.html

;; TODO: Implement encoding/decoding of racket elements so that complex
;; datatypes like MsgFromServer can be more easily sent

;; UserName
;; String of only letters and numbers between 1 and 12 chars long

;; MsgFromServer
;; (list 'userlist ListOf<UserName>) ;; don't include in event-messages
;; (list 'join UserName)
;; (list 'leave UserName)
;; (list 'error Message)
;; (list 'private UserName Message) ;; a private msg from a user
;; (list 'broadcast UserName Message) ;; a public msg from a user

;; Current solution: JSON version of MsgFromServer
;; {"type": "userlist", "content": Array<UserName : js-string>}
;; {"type": "broadcast", "sender": <UserName : js-string>, "content": js-string}

;; WorldState
;; (list client-name<UserName> connected-users<ListOf<UserName>> event-messages<ListOf<MsgFromServer>> curr-input<String>)

;; 
;; Helper functions
;; 

(define (slice-list l start stop)
  (take (drop l start) (- stop start)))

;;
;; Constants
;;

(define FONT-SIZE 12)
(define MARGIN 3)
(define MT (empty-scene 400 400))
(define CHARS-PER-LINE 44) ;; max chars that can fit in the input box
(define MAX-MESSAGES 25)


;;
;; WorldState parsers
;;

(define (get-client-name ws)
  (list-ref ws 0))

(define (get-connected-users ws)
  (list-ref ws 1))

(define (get-event-messages ws)
  (list-ref ws 2))

(define (get-curr-input ws)
  (list-ref ws 3))


;;
;; Message Parsing
;;

(define (parse-user-list u-list)
  (#js.u-list.reduce (lambda (result curr)
                        (append result (list (js-string->string curr))))
                     '()))


;;
;; Drawing Functions
;;

(define (participant-names-column names)
  (define container (rectangle 100 400 'outline 'black))
  (define i 0)
  (foldl (lambda (name res)
           (define name-text (text name FONT-SIZE 'black))
           (define col (underlay/xy res 
                                    MARGIN (+ MARGIN (* i 20))
                                    name-text))
           (set! i (+ i 1))
           col)
         container
         names))

(define (message-textbox curr-text cursor-pos)
  (define container  (rectangle 300 20 'outline 'black))
  (define text-len (string-length curr-text))
  (define input-text (text (if (> text-len CHARS-PER-LINE)
                               (substring curr-text (- text-len CHARS-PER-LINE) text-len)
                               curr-text)
                           FONT-SIZE
                           'black))

  (underlay/xy container MARGIN MARGIN input-text))

(define (message-log-display event-list username)
  (define background (rectangle 300 380 'outline 'black))
  (define count 0)
  (foldl (lambda (evt res)
           (define evt-type (list-ref evt 0))
           (define (add-text img)
             (define new-res (underlay/xy res MARGIN (+ (* count FONT-SIZE) (* (+ count 1) MARGIN)) img))
             (set! count (+ count 1))
             new-res)
           (define (message-text user msg color)
              (text (format "<~a> ~a" user msg) FONT-SIZE color))
           (case evt-type
                 [(broadcast) (add-text (message-text (list-ref evt 1)
                                                        (list-ref evt 2)
                                                        'black))]
                 [(private)   (add-text (message-text (format "~a->~a" (list-ref evt 1) username)
                                                        (list-ref evt 2)
                                                        'blue))]
                 [(join)      (add-text (text (format "~a joined."        (list-ref evt 1))
                                                FONT-SIZE
                                                'gray))]
                 [(leave)     (add-text (text (format "~a left the chat." (list-ref evt 1))
                                                FONT-SIZE
                                                'gray))]
                 [(error)     (add-text (text (list-ref evt 1) FONT-SIZE 'red))]
                 [else res]))
         background
         (if (> (length event-list) MAX-MESSAGES)
             (slice-list event-list 
                         (- (length event-list) MAX-MESSAGES)
                         (length event-list))
             event-list)))

(define (draw ws)
  (define textbox (message-textbox          (get-curr-input ws)))
  (define users   (participant-names-column (get-connected-users ws)))
  (define log     (message-log-display      (get-event-messages ws) (get-client-name ws)))

  (underlay/xy (underlay/xy (underlay/xy MT 0 0 users)
                            100 380
                            textbox)
               100 0
               log))


;;
;; Event Handlers
;;

(define (handle-key ws k)
  (define curr-text (get-curr-input ws))
  (define new-text (cond
                    [(> (string-length k) 1) curr-text]
                    [(key=? k "\b") (if (<= (string-length curr-text) 0)
                                          curr-text
                                          (substring curr-text
                                                     0
                                                     (- (string-length curr-text) 1)))]
                    [else (string-append curr-text k)]))
  (if (key=? k "\r")
      (make-package (list (get-client-name ws)
                          (get-connected-users ws)
                          (get-event-messages ws)
                          "")
                    curr-text)
      (list (get-client-name ws)
            (get-connected-users ws)
            (get-event-messages ws)
            new-text)))

(define (handle-receive ws msg)
  (define username (get-client-name ws))
  (define users (get-connected-users ws))
  (define messages (get-event-messages ws))
  (define input (get-curr-input ws))

  (define msg-type (list-ref msg 0))
  (case msg-type
        [(userlist)   (set! users (list-ref msg 1))]
        [(broadcast)  (set! messages (append messages (list msg)))])
        
  (list username users messages input))

;;
;; Start func
;;

(define (start-world username root)
  (big-bang #:dom-root root
            (list username '() '() "")
            [to-draw draw]
            [on-key handle-key]
            [on-receive handle-receive]
            [name username]
            [register "my-server"]))

(start-world "test user")