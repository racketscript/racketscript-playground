#lang racket
(require racketscript/htdp/universe
         racketscript/htdp/image
         "wordle-words.rkt")

;; game constants
(define ALL-WORDS WORDLE-WORDS) ; see wordle-words.rkt

(define NUM-WORDS (length ALL-WORDS))
(define MAX-GUESSES 6)
(define WORD-LENGTH 5)

;; game state -----------------------------------------------------------------

;; Game State:
;; - guess: Listof lowercase strings
;; - current-guess: lowercase string
(struct game (guesses current-guess) #:transparent)

; use some global vars to keep code cleaner
(define ACTIVE-GAME #f)
(define ANSWER "")

(define (mk-start-state)
  (set! ACTIVE-GAME #t)
  (set! ANSWER (random-word))
  (game '() ""))

(define (random-word)
  (list-ref ALL-WORDS (random NUM-WORDS)))

(define (game-over? guesses)
  (or (and (not (empty? guesses))
           (string=? (car guesses) ANSWER))
      (= (length guesses) MAX-GUESSES)))

(define (game-update-current g guess)
  (game
   (game-guesses g)
   guess))

(define (game-submit-guess g)
  (define guesses (game-guesses g))
  (define current (game-current-guess g))
  (define current-length (string-length current))
  ;; only accept if guess is correct length and in word list
  (cond
    [(and (= current-length 5) (member current ALL-WORDS))
     (when (game-over? (cons current guesses))
       (printf "ANSWER: ~a\n" (string-upcase ANSWER))
       (set! ACTIVE-GAME #f))
     (game (cons current guesses) "")]
    [else g]))

(define (game-del-char g)
  (define current (game-current-guess g))
  (define current-length (string-length current))
  (game-update-current g
   (if (zero? current-length)
       ""
       (substring current 0 (sub1 current-length)))))
  
(define (game-add-char g k)
  (define current (game-current-guess g))
  (define current-length (string-length current))
  (game-update-current g
   (if (= current-length 5)
       current
       (string-append current (string-downcase k)))))

;; game rendering constants ---------------------------------------------------

(define EMPTY-CANVAS (empty-scene 320 452))

(define WRONG-COLOR "black")
(define CORRECT-COLOR "dark green")
(define MAYBE-COLOR "medium yellow")

(define GUESS-TILE-HEIGHT 50)

(define GAP 8)
(define CHARGAP (rectangle GAP 0 'outline 'white))
(define LINEGAP (rectangle 0 GAP 'outline 'white))

(define BLANK (square GUESS-TILE-HEIGHT 'outline 'gray))

(define GUESS-CHAR-FONT-SIZE 32)

(define CURRENT-CHAR-VALID-COLOR "blue")
(define CURRENT-CHAR-INVALID-COLOR "black")
(define GUESS-CHAR-COLOR "white")

;; helper functions -----------------------------------------------------------

;; repeat : Duplicates the given `x` `n` times, in a list
(define (repeat x n) (for/list ([m n]) x))

;; img-join : combines given `imgs` lst, separated by `sep`, using `combiner` fn
;; - result begins and ends with sep
(define (img-join imgs sep combiner)
  (for/fold ([img sep])
            ([i imgs])
    (combiner img i sep)))

;; render fns -----------------------------------------------------------------

(define (render g)
  (if ACTIVE-GAME
      (render-active g)
      (render-inactive g)))

(define (render-active g)
  (define guesses (game-guesses g))
  (define current (game-current-guess g))
  (above
   (render-guesses guesses)
   (render-current current)
   (render-blanks (- MAX-GUESSES (length guesses)))
   (render-keyboard guesses)))

(define (render-inactive g)
  (overlay/align "middle" "top"
   (above/align "left"
    (render-guesses (game-guesses g))
    (text "ANSWER:" 10 'black)
    (beside
     (rectangle 20 0 'outline 'white)
     (text (string-upcase ANSWER) GUESS-CHAR-FONT-SIZE CORRECT-COLOR)
     (rectangle 40 0 'outline 'white)
     (overlay
      (text "PLAY AGAIN" KEYBOARD-FONT-SIZE 'black)
      (rectangle 100 40 'outline 'black)))
    LINEGAP
    (text "        Click or press ENTER to play again" KEYBOARD-FONT-SIZE 'black))
   EMPTY-CANVAS))

;; render guesses --------------------
(define (render-guesses guesses)
  (for/fold ([img LINEGAP])
            ([guess guesses])
    ;; last guess is first, so render bottom to top
    (above LINEGAP
           (render-guess guess)
           img)))

;; word is string of WORD-LENGTH
(define (render-guess word)
  (img-join
   (for/list ([c word]
              [col (compute-guess-colors word)])
    (guesschar->tile c col))
   CHARGAP
   beside))

;; compute-guess-colors : string -> list of color
;; - input is a string of 5 chars
;; - output possible colors are CORRECT-COLOR, MAYBE-COLOR, OR WRONG-COLOR
(define (compute-guess-colors word)
  ;; remaining-letters is bookkeeping vector to track which letters in ANSWER
  ;; have been used (marked by USED-LETTER char) to color a guess letter
  ;; - gets reset before coloring each guess
  ;; TODO: better data structure for this?
  ;; - need both letters and position info
  (define remaining-letters (list->vector (string->list ANSWER)))

  ;; compute guess colors in 2 passes
  ; 1) compute CORRECT letters first bc MAYBE colors depend on this

  ; partial-colors is vector where elements are either:
  ; - CORRECT-COLOR: for chars in correct position
  ; - WRONG-COLOR (temporarily)
  ; It's a temporary data structure that is result of first pass
  (define partial-colors
    (for/vector ([(c i) (in-indexed word)]
                 [expected ANSWER])
      (cond [(char=? c expected)
             (mark-used! remaining-letters i)
             CORRECT-COLOR]
            [else WRONG-COLOR])))

  ; 2) compute MAYBE or WRONG colors
  ; tile gets MAYBE-COLOR if in answer but not already in a correct position
  (for/list ([col partial-colors]
             [(c i) (in-indexed word)]
             [expected ANSWER])
    (cond [(equal? col CORRECT-COLOR) CORRECT-COLOR] ; dont touch already correct
          [(vector-member c remaining-letters)
           (mark-used! remaining-letters c)
           MAYBE-COLOR]
          [else WRONG-COLOR])))

; mark a letter in the answer as "used" when it's already handled
; to avoid double-counting
(define USED-LETTER "-")

;; mark-used: updates bookkeeping vector
;; vec: vector of chars, or USED-LETTER to indicate
;; c/i: char or index pos to update
(define (mark-used! vec c/i)
  (if (number? c/i) ; update at exact index, if given
      (vector-set! vec c/i USED-LETTER)
      (for/first ([j (vector-length vec)] ; else must find the char
                  #:when (equal? (vector-ref vec j) c/i))
        (vector-set! vec j USED-LETTER))))

;; input is (lowercase) char
(define (guesschar->tile c tile-color)
  (overlay
   (char->img c GUESS-CHAR-COLOR)
   (mk-guess-tile tile-color)))

(define (char->img c color)
  (text (char->string c) GUESS-CHAR-FONT-SIZE color))

(define (char->string c) (string-upcase (string c)))

(define (mk-guess-tile color)
  (square GUESS-TILE-HEIGHT "solid" color))

;; render current --------------------
(define (render-current word)
  (img-join
   (append
    (map
     (if (member word ALL-WORDS)
         valid-char->tile
         char->tile)
     (string->list word))
    (repeat BLANK (- WORD-LENGTH (string-length word))))
   CHARGAP
   beside))

(define (char->tile c)
  (overlay
   (char->img c CURRENT-CHAR-INVALID-COLOR)
   BLANK))
(define (valid-char->tile c)
  (overlay
   (char->img c CURRENT-CHAR-VALID-COLOR)
   BLANK))

(define BLANK-WORD (render-current ""))

(define (render-blanks guesses-remaining)
  (for/fold ([img LINEGAP])
            ([n (sub1 guesses-remaining)]) ; sub1 to account for current
     (above img BLANK-WORD LINEGAP)))

;; render keyboard --------------------

(define KEYBOARD-1ST-ROW '(q w e r t y u i o p))
(define KEYBOARD-2ND-ROW '(a s d f g h j k l))
(define KEYBOARD-3RD-ROW '(z x c v b n m))
(define KEYBOARD
  (list KEYBOARD-1ST-ROW
        KEYBOARD-2ND-ROW
        KEYBOARD-3RD-ROW))

(define KEY-HEIGHT 32)
(define KEYBOARD-FONT-SIZE 14)

(define ENTER-KEY
  (overlay
   (rectangle (* 1.5 KEY-HEIGHT) KEY-HEIGHT 'outline 'gray)
   (text "ENTER" 10 'black)))
(define BACKSPACE-KEY
  (overlay
   (rectangle (* 1.5 KEY-HEIGHT) KEY-HEIGHT 'outline 'gray)
   (text "Backspace" 8 'black)))

(define (render-keyboard guesses)
  (above
   (keys->img KEYBOARD-1ST-ROW guesses)
   (keys->img KEYBOARD-2ND-ROW guesses)
   (beside
    ENTER-KEY
    (keys->img KEYBOARD-3RD-ROW guesses)
    BACKSPACE-KEY)))

(define (keys->img ks guesses)
  (apply
   beside
   (for/list ([k ks])
     (key->img k guesses))))

(define (key->img sym guesses)
  (define tile-col (key-color (symbol->string sym) guesses))
  (overlay
   (text
    (string-upcase (symbol->string sym))
    KEYBOARD-FONT-SIZE
    (if (equal? tile-col "white") "black" "white"))
   (mk-key-tile tile-col)))

(define (mk-key-tile color)
  (if (equal? color "white")
      (square KEY-HEIGHT 'outline 'gray)
      (square KEY-HEIGHT 'solid color)))

(define (key-color k guesses)
  (cond
    [(correct-char? k guesses) CORRECT-COLOR]
    [(maybe-char? k guesses) MAYBE-COLOR]
    [(wrong-char? k guesses) WRONG-COLOR]
    [else "white"]))

;; k : 1 char string
;; guesses: list of string
;; returns true if letter k is in answer and some guess, in correct position
(define (correct-char? k guesses)
  (for/or ([g guesses])
    (for/or ([x g] [y ANSWER])
      (and (equal? x y)
           (equal? (string x) k)))))

;; k : 1 char string
;; guesses: list of string
;; returns true if letter k is in answer and some guess
(define (maybe-char? k guesses)
  (and (string-contains? ANSWER k)
       (for/or ([g guesses])
         (string-contains? g k))))

;; k : 1 char string
;; guesses: list of string
;; returns true if letter k is in some guess but not in answer
(define (wrong-char? k guesses)
  (and (for/or ([g guesses])
         (string-contains? g k))
       (not (string-contains? ANSWER k))))

;; process-char --------------------------------------------------------------------

(define (process-key g k)
  (cond
    [(key=? k "\r") ; return
     (if ACTIVE-GAME
         (game-submit-guess g)
         (mk-start-state))]
    [(key=? k "\b") ; backspace
     (game-del-char g)]
    [(valid-char? k) ; A-Z,a-z
     (game-add-char g k)]
    [else g]))

(define (valid-char? k)
  (and (= 1 (string-length k))
       (regexp-match? #px"[A-Za-z]" k)))

;; process mouse --------------------------------------------------------------

(define (handle-mouse g x y evt)
  (cond
    [(mouse=? evt "button-down")
     (cond [(and (not ACTIVE-GAME) (mouse-play-again? (game-guesses g) y))
            (mk-start-state)]
           [(mouse-in-1st-row? x y) (game-add-char g (row1->char x))]
           [(mouse-in-2nd-row? x y) (game-add-char g (row2->char x))]
           [(mouse-in-3rd-row? x y) (game-add-char g (row3->char x))]
           [(mouse-enter? x y) (game-submit-guess g)]
           [(mouse-backspace? x y) (game-del-char g)]
           [else g])]
    [else g]))

(define KEYBOARD-Y-START 356)
(define KEYBOARD-Y1-START KEYBOARD-Y-START)
(define KEYBOARD-Y1-END (+ KEYBOARD-Y1-START KEY-HEIGHT))
(define KEYBOARD-Y2-START KEYBOARD-Y1-END)
(define KEYBOARD-Y2-END (+ KEYBOARD-Y2-START KEY-HEIGHT))
(define KEYBOARD-Y3-START KEYBOARD-Y2-END)
(define KEYBOARD-Y3-END (+ KEYBOARD-Y3-START KEY-HEIGHT))
(define KEYBOARD-Y-END KEYBOARD-Y3-END) ; should be 3 rows = 452

(define KEYBOARD-X1-START 0)
(define KEYBOARD-X1-END
  (+ KEYBOARD-X1-START (* (length (first KEYBOARD)) KEY-HEIGHT)))
(define KEYBOARD-X2-START
  (+ KEYBOARD-X1-START (/ KEY-HEIGHT 2)))
(define KEYBOARD-X2-END
  (+ KEYBOARD-X2-START (* (length (second KEYBOARD)) KEY-HEIGHT)))
(define KEYBOARD-X3-START
  (+ KEYBOARD-X2-START KEY-HEIGHT))
(define KEYBOARD-X3-END
  (+ KEYBOARD-X3-START (* (length (third KEYBOARD)) KEY-HEIGHT)))

;; check roughly whether mouse clicking "play again" button
(define (mouse-play-again? guesses y)
  ;; adjust y upwards, depending on how many guesses were made
  (define y-adjustment
    (* (- MAX-GUESSES (length guesses))
       (+ GUESS-TILE-HEIGHT GAP)))
  (<= (- KEYBOARD-Y-START y-adjustment) y KEYBOARD-Y-END))

(define (mouse-in-1st-row? x y)
  (and (< KEYBOARD-Y1-START y KEYBOARD-Y1-END)
       (< KEYBOARD-X1-START x KEYBOARD-X1-END)))
(define (mouse-in-2nd-row? x y)
  (and (< KEYBOARD-Y2-START y KEYBOARD-Y2-END)
       (< KEYBOARD-X2-START x KEYBOARD-X2-END)))
(define (mouse-in-3rd-row? x y)
  (and (< KEYBOARD-Y3-START y KEYBOARD-Y3-END)
       (< KEYBOARD-X3-START x KEYBOARD-X3-END)))

(define (mouse-enter? x y) ; in 3rd row
  (and (< KEYBOARD-Y3-START y KEYBOARD-Y3-END)
       (< 0 x (* 1.5 KEY-HEIGHT))))
(define (mouse-backspace? x y) ; in 3rd row
  (and (< KEYBOARD-Y3-START y KEYBOARD-Y3-END)
       (< KEYBOARD-X3-END x (+ KEYBOARD-X3-END (* 1.5 KEY-HEIGHT)))))

(define (row1->char x)
  (symbol->string
   (list-ref (first KEYBOARD) (quotient x KEY-HEIGHT))))
(define (row2->char x)
  (symbol->string
   (list-ref (second KEYBOARD) (quotient (- x KEYBOARD-X2-START) KEY-HEIGHT))))
(define (row3->char x)
  (symbol->string
   (list-ref (third KEYBOARD) (quotient (- x KEYBOARD-X3-START) KEY-HEIGHT))))

;; start the game ----------------------------------------------------------
(big-bang (mk-start-state)
  (to-draw render)
  (on-key process-key)
  (on-mouse handle-mouse))