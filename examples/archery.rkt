#lang racket
(require racketscript/htdp/image
         racketscript/htdp/universe)

;(define WOOT (bitmap/file "WOOT.png"))
;(define WWOOT (bitmap/file "WWOOT.png"))
;(define UWOOT (bitmap/file "UWOOT.png"))
;(define BWOOT (bitmap/file "BWOOT.png"))
;(define SB (bitmap/file "SB.png"))
;(define VSB (bitmap/file "VSB.png"))
;(define ASB (bitmap/file "ASB.png"))
;(define WSB (bitmap/file "WSB.png"))
;(define SSB (bitmap/file "SSB.png"))
;(define ARCHER-S (bitmap/file "ARCHER-S.png"))
;(define ARCHER (bitmap/file "ARCHER.png"))
;(define B-ARCHER-S (bitmap/file "B-ARCHER-S.png"))
;(define B-ARCHER (bitmap/file "B-ARCHER.png"))
;(define BLINKR (bitmap/file "BLINKR.png"))
;(define BLINKL (bitmap/file "BLINKL.png"))
;(define WUP (bitmap/file "WUP.png"))
;(define WDOWN (bitmap/file "WDOWN.png"))
;(define WEVEN (bitmap/file "WEVEN.png"))
;(define HITPOINT (bitmap/file "HITPOINT.png"))
;(define ARROW (bitmap/file "ARROW.png"))
;(define HT1 (bitmap/file "HT1.png"))
;(define HT2 (bitmap/file "HT2.png"))
;(define HT3 (bitmap/file "HT3.png"))
;(define HT4 (bitmap/file "HT4.png"))
;(define HT5 (bitmap/file "HT5.png"))
;(define HT6 (bitmap/file "HT6.png"))
;(define HT7 (bitmap/file "HT7.png"))
;(define SCOREBOARD (bitmap/file "SCOREBOARD.png"))
;(define SB1 (bitmap/file "SB1.png"))
;(define SB2 (bitmap/file "SB2.png"))
;(define CONTINUE (bitmap/file "CONTINUE.png"))
;(define EXIT (bitmap/file "EXIT.png"))
;(define STATS (bitmap/file "STATS.png"))
;(define HOWTO (bitmap/file "HOWTO.png"))
;(define NICE (bitmap/file "NICE.png"))
;(define QUALIFY (bitmap/file "QUALIFY.png"))
;(define NQUALIFYX (bitmap/file "NQUALIFYX.png"))
(define ARCHER (bitmap/url "http://i.imgur.com/PkCMNNn.png"))
(define ARCHER-S (bitmap/url "http://i.imgur.com/ZYwtHWV.png"))
(define ARROW (bitmap/url "http://i.imgur.com/YEOB1RP.png"))
(define ASB (bitmap/url "http://i.imgur.com/2SFORKH.png"))
(define B-ARCHER (bitmap/url "http://i.imgur.com/HV1y9rb.png"))
(define B-ARCHER-S (bitmap/url "http://i.imgur.com/2ME1Jzm.png"))
(define BLINKL (bitmap/url "http://i.imgur.com/Wk6pC5z.png"))
(define BLINKR (bitmap/url "http://i.imgur.com/m39poUR.png"))
(define BWOOT (bitmap/url "http://i.imgur.com/7mtVXF8.png"))
(define CONTINUE (bitmap/url "http://i.imgur.com/KZsZTj7.png"))
(define EXIT (bitmap/url "http://i.imgur.com/suuJYdf.png"))
(define HITPOINT (bitmap/url "http://i.imgur.com/7XrsoH5.png"))
(define HOWTO (bitmap/url "http://i.imgur.com/XLZi9a7.png"))
(define HT1 (bitmap/url "http://i.imgur.com/VEV3RB1.png"))
(define HT2 (bitmap/url "http://i.imgur.com/cqY2u2c.png"))
(define HT3 (bitmap/url "http://i.imgur.com/WlakuBI.png"))
(define HT4 (bitmap/url "http://i.imgur.com/zOYtSOI.png"))
(define HT5 (bitmap/url "http://i.imgur.com/QTOHnw9.png"))
(define HT6 (bitmap/url "http://i.imgur.com/m2LWx57.png"))
(define HT7 (bitmap/url "http://i.imgur.com/frndd5v.png"))
(define NICE (bitmap/url "http://i.imgur.com/chUPaJN.png"))
(define NQUALIFYX (bitmap/url "http://i.imgur.com/9COnA4D.png"))
(define QUALIFY (bitmap/url "http://i.imgur.com/BTHna0n.png"))
(define SB (bitmap/url "http://i.imgur.com/Nkf3QBN.png"))
(define SB1 (bitmap/url "http://i.imgur.com/9qh1LeG.png"))
(define SB2 (bitmap/url "http://i.imgur.com/h9UUJuj.png"))
(define SCOREBOARD (bitmap/url "http://i.imgur.com/Bu5imty.png"))
(define SSB (bitmap/url "http://i.imgur.com/hVv3oqK.png"))
(define STATS (bitmap/url "http://i.imgur.com/yYaNxFo.png"))
(define UWOOT (bitmap/url "http://i.imgur.com/RjvJYu9.png"))
(define VSB (bitmap/url "http://i.imgur.com/JoKhNd9.png"))
(define WDOWN (bitmap/url "http://i.imgur.com/ENK9DfL.png"))
(define WEVEN (bitmap/url "http://i.imgur.com/Zw0U6Pz.png"))
(define WOOT (bitmap/url "http://i.imgur.com/c5YGnGf.png"))
(define WSB (bitmap/url "http://i.imgur.com/N5qjeJF.png"))
(define WUP (bitmap/url "http://i.imgur.com/tKp6Znv.png"))
(define WWOOT (bitmap/url "http://i.imgur.com/3jGLSju.png"))

(define-struct archer (x y timer))

(define ARCHER1(make-archer 105 400 0))

#|Template for archer
;archer-func: archer -> ...
;consumes an archer and produces ...
(define (archer-func a-archer)
  (make-archer
   (archer-x a-archer)
   (archer-y a-archer)
   (archer-timer a-archer)
   ))|#

(define-struct arrow (x y x-v y-v angle timer bounce-timer score increase?)) 

#|Template for arrow
;arrow-func: arrow -> ...
;consumes an arrow and produces ...
(define (arrow-func a-arrow)
  (make-arrow
   (arrow-x a-arrow)
   (arrow-y a-arrow)
   (arrow-x-v a-arrow)
   (arrow-y-v a-arrow)
   (arrow-angle a-arrow)
   (arrrow-timer a-arrow)
   (arrow-bounce-timer a-arrow)
   (arrow-score a-arrow)
   (arrow-increase? a-arrow)
   ))|#

#|Template for list of arrow
;define list-of-arrow-func: list-of-arrow -> ...
;consumes a list-of-arrow and produces ...
(define (list-of-arrow-func a-loa)
  (cond
    [(empty? a-loa)...]
    [(cons? a-loa)
     (arrow-func (first a-loa))(list-of-arrow-func (rest a-loa))]))|#

(define ARROW1 (make-arrow 100 400 20 0 0 75 0 -1 false)) 

(define-struct target (x1 x2 x3 x4 x5 y tx ty dir timer))

#|Template for target
;target-func: target -> ...
;consumes a target and produces ...
(define (target-func a-target)
  (make-target
   (target-x1 a-target)
   (target-x2 a-target)
   (target-x3 a-target)
   (target-x4 a-target)
   (target-x5 a-target)
   (target-y a-target)
   (target-tx a-target)
   (target-ty a-target)
   (target-dir a-target)
   (target-timer a-target)))|#

(define TARGET1 (make-target 818 823 828 833 838 400 675 252 'up 0))

(define-struct blinks (timer on?))

#|Template for blinks
;blinks-func: blinks -> ...
;consumes a blinks and produces ...
(define (blinks-func a-blinks)
  (make-blinks
   (blinks-timer a-blinks)
   (blinks-on? a-blinks)
   ))|#

(define BLINKS1(make-blinks 0 true))

(define-struct tg(x1 y1 x2 y2 x3 y3 x4 y4 x5 y5 x6 y6 x7 y7))

(define TG1 (make-tg 450 100 450 200 450 300 450 400 450 500 450 600 450 700))

#|TEMPLATE FOR TG
;tg-func: tg -> ?
;consumes a tg and produces ...
(define(tg-func a-tg)
  (make-tg 
   (tg-x1 a-tg)
   (tg-y1 a-tg)
   (tg-x2 a-tg)
   (tg-y2 a-tg) 
   (tg-x3 a-tg)
   (tg-y3 a-tg)
   (tg-x4 a-tg)
   (tg-y4 a-tg)
   (tg-x5 a-tg)
   (tg-y5 a-tg)
   (tg-x6 a-tg)
   (tg-y6 a-tg)
   (tg-x7 a-tg)
   (tg-y7 a-tg)
   ))
|#

(define-struct score (t1 t2 t3 2-t1 2-t2 2-t3 try-try try-try-2 record total 2-total hs best-try total-q arrows-shot noc bulls nom p1w p2w))

#|Template for score
;score-func: score -> ...
;consumes a score and produces ... 
(define (score-func a-score)
  (make-score
   (score-t1 a-score)
   (score-t2 a-score)
   (score-t3 a-score)
   (score-2-t1 a-score)
   (score-2-t2 a-score)
   (score-2-t3 a-score)
   (score-try-try a-score)
   (score-try-try-2 a-score)
   (score-record a-score)
   (score-total a-score)
   (score-2-total a-score)
   (score-hs a-score)
   (score-best-try a-score)
   (score-total-q a-score) 
   (score-arrows-shot a-score)
   (score-noc a-score)
   (score-bulls a-score)
   (score-nom a-score)
   (score-p1w a-score)
   (score-p2w a-score) 
))|#
 
(define INITIAL-SCORE (make-score 0 0 0 0 0 0 0 0 3500 0 0 0 0 0 0 0 0 0 0 0))

(define-struct world (archer loa target score count try turn atimer blinks wind stopped? r-t increase? cc how-to tg hub? stats? credits? how-to? how-too? 1p? 2p? start? pause? sure? slider-x gcount)) 

#|Template for World
;world-func: world -> ...
;consumes a world and produces ...
(define (world-func a-world) 
  (make-world 
   (world-archer a-world)
   (world-loa a-world) 
   (world-target a-world) 
   (world-score a-world)
   (world-count a-world)
   (world-try a-world)  
   (world-turn a-world)
   (world-atimer a-world)
   (world-blinks a-world)
   (world-wind a-world)
   (world-stopped? a-world)
   (world-r-t a-world)
   (world-increase? a-world)
   (world-cc a-world)
   (world-how-to a-world)
   (world-tg a-world)
   (world-hub? a-world)
   (world-stats? a-world)
   (world-credits? a-world)
   (world-how-to? a-world)
   (world-how-too? a-world)
   (world-1p? a-world)
   (world-2p? a-world)
   (world-start? a-world) 
   (world-pause? a-world)
   (world-sure? a-world)
   (world-slider-x a-world)
   (world-gcount a-world)
   ))
|#  

(define IW (make-world ARCHER1 empty TARGET1 INITIAL-SCORE 9 1 "p1" 0 BLINKS1 0 false (random 2) false 0 1 TG1 true false false false false false false false false false 420 2))  

;draw-world: world -> scene
;consumes a world and draws it on the scene
(define (draw-world a-world) 
 (cond
   [(game-over? a-world)(draw-game-over a-world (world-score a-world) (empty-scene 900 600))]
   [(world-hub? a-world)(draw-hub a-world (empty-scene 900 600))]
   [(world-how-to? a-world)(draw-how-to a-world (empty-scene 900 600))]
   [(world-how-too? a-world)(draw-how-too a-world (empty-scene 900 600))]
   [(world-stats? a-world)(draw-stats a-world (world-score a-world) (empty-scene 900 600))]
   [(and(world-pause? a-world)(world-sure? a-world))(draw-sure a-world (empty-scene 900 600))]
   [(world-credits? a-world)(draw-credits a-world (empty-scene 900 600))] 
   [(world-pause? a-world)(draw-pause a-world (empty-scene 900 600))]
   [else(draw-score (world-score a-world) a-world(draw-hitpoints-list (world-target a-world)(world-loa a-world)(draw-wind a-world (draw-archer a-world (world-archer a-world)(draw-blinks-try (world-blinks a-world) a-world(draw-arrow-count a-world(draw-blinks (world-blinks a-world)(draw-target (world-target a-world)(draw-loa (world-loa a-world)(world-target a-world)(draw-backround a-world (empty-scene 900 600)))))))))))]))    

;draw-hub: world scene -> scene 
;consumes a world and a scene and draws it on the scene 
(define (draw-hub a-world a-scene) 
  (place-image (text "Tutorial" 30 "white")450 370(place-image (text "Credits" 30 "white")450 540(place-image (text "Stats" 30 "white")450 455(place-image (text "2 Player" 30 "white")450 285(place-image (text "1 Player" 30 "white")450 200(place-image (rectangle 200 60 "solid"(make-color 205 71 72))450 540(place-image (rectangle 210 70 "solid""white")450 540(place-image (rectangle 200 60 "solid"(make-color 205 71 72))450 455(place-image (rectangle 210 70 "solid""white")450 455(place-image (rectangle 200 60 "solid"(make-color 205 71 72))450 370(place-image (rectangle 210 70 "solid""white")450 370(place-image (rectangle 200 60 "solid"(make-color 205 71 72))450 285(place-image (rectangle 210 70 "solid""white")450 285(place-image (rectangle 200 60 "solid"(make-color 205 71 72))450 200(place-image (rectangle 210 70 "solid""white")450 200(place-image WOOT 450 300 a-scene)))))))))))))))))

;draw-how-to: world scene -> scene
;consumes a world and a scene and draws it on the scene
(define (draw-how-to a-world a-scene)  
  (place-image
   (cond
    [(eq?(world-how-to a-world)1)HT1]
    [(eq?(world-how-to a-world)2)HT2]
    [(eq?(world-how-to a-world)3)HT3]
    [(eq?(world-how-to a-world)4)HT4]
    [(eq?(world-how-to a-world)5)HT5]
    [(eq?(world-how-to a-world)6)HT6]
    [(eq?(world-how-to a-world)7)HT7]
    )450 300 (place-image (text "X" 35 "white")20 20(place-image (rectangle 310 410 "solid"(make-color 205 71 72))450 300(place-image (rectangle 320 420 "solid""white")450 300(place-image(rotate 90 (triangle 20 "solid""white"))
                                                                (cond
                                                                   [(not(=(world-how-to a-world)1))250]
                                                                   [else 450])300(place-image(rotate 270 (triangle 20 "solid""white"))
                                                                (cond
                                                                   [(not(=(world-how-to a-world)7))650]
                                                                   [else 450])300(place-image (rectangle 900 600 "solid"(color 0 0 0 107)) 450 300 (draw-score (world-score a-world) a-world(draw-hitpoints-list (world-target a-world)(world-loa a-world)(draw-wind a-world (draw-archer a-world(world-archer a-world)(draw-blinks-try (world-blinks a-world) a-world(draw-arrow-count a-world(draw-blinks (world-blinks a-world)(draw-target (world-target a-world)(draw-loa (world-loa a-world)(world-target a-world)(draw-backround a-world a-scene)))))))))))))))))) 

;draw-how-too: world scene -> scene
;consumes a world and a scene and draws it on the scene
(define (draw-how-too a-world a-scene)
  (place-image
   (cond
    [(eq?(world-how-to a-world)1)HT1]
    [(eq?(world-how-to a-world)2)HT2]
    [(eq?(world-how-to a-world)3)HT3]  
    [(eq?(world-how-to a-world)4)HT4]
    [(eq?(world-how-to a-world)5)HT5]
    [(eq?(world-how-to a-world)6)HT6]
    [(eq?(world-how-to a-world)7)HT7]
    )450 300(place-image (text "Back" 35 "white")69 37.5(place-image (rectangle 120 50 "solid"(make-color 205 71 72))70 35 (place-image (rectangle 130 60 "solid""white")70 35 (place-image (rectangle 310 410 "solid"(make-color 205 71 72))450 300(place-image (rectangle 320 420 "solid""white")450 300(place-image(rotate 90 (triangle 20 "solid""white"))
                                                                (cond
                                                                   [(not(=(world-how-to a-world)1))250]
                                                                   [else 450])300(place-image(rotate 270 (triangle 20 "solid""white"))
                                                                (cond
                                                                   [(not(=(world-how-to a-world)7))650]
                                                                   [else 450])300(cond
                                                                                   [(world-pause? a-world)(place-image (rectangle 900 600 "solid"(color 0 0 0 107)) 450 300 (draw-score (world-score a-world) a-world(draw-hitpoints-list (world-target a-world)(world-loa a-world)(draw-wind a-world (draw-archer a-world(world-archer a-world)(draw-blinks-try (world-blinks a-world) a-world(draw-arrow-count a-world(draw-blinks (world-blinks a-world)(draw-target (world-target a-world)(draw-loa (world-loa a-world)(world-target a-world)(draw-backround a-world a-scene)))))))))))]
                                                                                   [else (place-image WWOOT 450 300 a-scene)]))))))))))    

;draw-stats: world score scene -> scene
;consumes a world, a score, and a scene and draws certain aspects of each on the scene
(define (draw-stats a-world a-score a-scene) 
  (place-image (rectangle 300 30 "solid""black")(+ 148 (world-slider-x a-world))515(place-image(rectangle 2 5 "solid""black")(world-slider-x a-world) 535(place-image (circle 5 "solid""white")(world-slider-x a-world) 535(place-image (rectangle 105 3 "solid""gray")368 535(place-image (text "Back" 35 "white")69 37.5(place-image (rectangle 120 50 "solid"(make-color 203 72 72))70 35 (place-image (rectangle 130 60 "solid""white")70 35(place-image (text (number->string(score-hs a-score))18 "white")250 143.5(place-image (text (number->string(score-best-try a-score))18 "white")230 184(place-image (text (number->string(score-total-q a-score))18 "white")290 225.5(place-image (text (number->string(score-arrows-shot a-score))18 "white")270 267(place-image (text (number->string(score-noc a-score))18 "white")313  308(place-image (text (number->string(score-bulls a-score))18 "white")250 350(place-image (text (number->string(score-nom a-score))18 "white")315 390(place-image (text (number->string(score-p1w a-score))18 "white")275 432(place-image (text (number->string(score-p2w a-score))18 "white")275 473(place-image SCOREBOARD 450 330(cond
                                                           [(world-pause? a-world)(place-image (rectangle 900 600 "solid"(color 0 0 0 107)) 450 300 (draw-score (world-score a-world) a-world(draw-hitpoints-list (world-target a-world)(world-loa a-world)(draw-wind a-world (draw-archer a-world(world-archer a-world)(draw-blinks-try (world-blinks a-world) a-world(draw-arrow-count a-world(draw-blinks (world-blinks a-world)(draw-target (world-target a-world)(draw-loa (world-loa a-world)(world-target a-world)(draw-backround a-world a-scene)))))))))))]
                                                           [else(place-image WWOOT 450 300 a-scene)])
                                                           ))))))))))))))))))           

;draw-credits: world scene -> scene
;consumes a world and a scene and draws it on the scene
(define (draw-credits a-world a-scene) 
  (place-image (text "Back" 35 "white")69 37.5(place-image SB1 450 330(place-image (rectangle 120 50 "solid"(make-color 203 72 72))70 35 (place-image (rectangle 130 60 "solid""white")70 35(place-image UWOOT 450 50(place-image BWOOT 450 581(place-image (text "Intro to Programming" 45 "white")(tg-x4(world-tg a-world))(tg-y4(world-tg a-world))(place-image (text "Medway Public Schools" 45 "white")(tg-x5(world-tg a-world))(tg-y5(world-tg a-world))(place-image (text "http://www.medwayschools.org" 40 "white")(tg-x6(world-tg a-world)) (tg-y6(world-tg a-world))(place-image (text "http://www.racket-lang.org" 40 "white")(tg-x7(world-tg a-world)) (tg-y7(world-tg a-world))(place-image (text "Developed with DrRacket" 45 "white")(tg-x3(world-tg a-world)) (tg-y3(world-tg a-world))(place-image (text "Taught by Mr. Nassiff" 45 "white")(tg-x2(world-tg a-world)) (tg-y2(world-tg a-world))(place-image (text "Made by Jake Lawrence" 45 "white")(tg-x1(world-tg a-world)) (tg-y1(world-tg a-world))(place-image SB2 450 330(place-image WWOOT 450 300 a-scene)))))))))))))))) 

;draw-pause: world scene -> scene
;consumes a world and a scene and draws it on the scene
(define (draw-pause a-world a-scene) 
  (place-image (text "TUTORIAL" 20 "white")450 264 (place-image (text "STATS" 20 "white")450 344(place-image (text "CONTINUE" 20 "white")450 184(place-image (text "EXIT" 20 "white")450 424(place-image HOWTO 380 264(place-image STATS 380 340(place-image EXIT 380 420(place-image CONTINUE 380 180(place-image (rectangle 200 60 "solid"(make-color 205 71 72))450 420(place-image (rectangle 210 70 "solid""white")450 420(place-image (rectangle 200 60 "solid"(make-color 205 71 72))450 180(place-image (rectangle 210 70 "solid""white")450 180(place-image (rectangle 200 60 "solid"(make-color 205 71 72))450 340(place-image (rectangle 210 70 "solid""white")450 340(place-image (rectangle 200 60 "solid"(make-color 205 71 72))450 260(place-image (rectangle 210 70 "solid""white")450 260(place-image (rectangle 900 600 "solid"(color 0 0 0 107)) 450 300 (draw-score (world-score a-world) a-world(draw-hitpoints-list (world-target a-world)(world-loa a-world)(draw-wind a-world (draw-archer a-world(world-archer a-world)(draw-blinks-try (world-blinks a-world) a-world(draw-arrow-count a-world(draw-blinks (world-blinks a-world)(draw-target (world-target a-world)(draw-loa (world-loa a-world)(world-target a-world)(draw-backround a-world a-scene)))))))))))))))))))))))))))) 

;draw-sure: world scene -> scene
;consumes a world and a scene and draws it on the scene
(define (draw-sure a-world a-scene)
  (place-image (text "Any scores in this game will be lost." 50 "white")450 120(place-image (text "Are you sure you want to quit?" 50 "white")450 50(place-image (rectangle 810 150 "solid" (make-color 205 71 72))450 90(place-image (rectangle 820 160 "solid" "white")450 90(place-image (text "NO" 20 "white")450 360(place-image (text "YES" 20 "white")450 240(place-image (rectangle 200 60 "solid"(make-color 205 71 72))450 360(place-image (rectangle 210 70 "solid""white")450 360(place-image (rectangle 200 60 "solid"(make-color 205 71 72))450 240(place-image (rectangle 210 70 "solid""white")450 240(place-image (rectangle 900 600 "solid"(color 0 0 0 107)) 450 300 (draw-score (world-score a-world) a-world(draw-hitpoints-list (world-target a-world)(world-loa a-world)(draw-wind a-world (draw-archer a-world(world-archer a-world)(draw-blinks-try (world-blinks a-world) a-world(draw-arrow-count a-world(draw-blinks (world-blinks a-world)(draw-target (world-target a-world)(draw-loa (world-loa a-world)(world-target a-world)(draw-backround a-world a-scene))))))))))))))))))))))  

;draw-game-over: world score scene -> scene
;consumes a world, a score, and a scene and draws a game over screen on the scene
(define (draw-game-over a-world a-score a-scene)
  (cond
    [(world-2p? a-world)(place-image(cond
           [(<(score-total a-score)(score-2-total a-score))(text "Player 2 Wins!"50"white")]
           [(>(score-total a-score)(score-2-total a-score))(text "Player 1 Wins!" 50 "white")]
           [else(text "'Twas close, but it is a Tie!"50"white")])
            450 75(place-image(cond 
           [(<(score-total a-score)(score-2-total a-score))(text "Good Job Player 2!"50"white")]
           [(>(score-total a-score)(score-2-total a-score))(text "Good Job Player 1!" 50 "white")]
           [else(text "How about a Tiebreaker?" 50 "white")]
            )450 150(place-image (text (number->string(world-gcount a-world)) 50 "blue")100 100(place-image (rectangle 700 150 "solid"(make-color 205 71 72))450 112.5(place-image (rectangle 710 160 "solid""white")450 112.5(place-image (text "REMATCH?" 20 "white")450 275(place-image (text "MENU" 20 "white")450 375(place-image(rectangle 200 60 "solid"(make-color 205 71 72))450 275 (place-image (rectangle 210 70 "solid""white")450 275(place-image (rectangle 200 60 "solid"(make-color 205 71 72))450 375 (place-image (rectangle 210 70 "solid""white")450 375 (place-image (rectangle 900 600 "solid"(color 0 0 0 107)) 450 300 (draw-score (world-score a-world) a-world(draw-hitpoints-list (world-target a-world)(world-loa a-world)(draw-wind a-world (draw-archer a-world(world-archer a-world)(draw-blinks-try (world-blinks a-world) a-world(draw-arrow-count a-world(draw-blinks (world-blinks a-world)(draw-target (world-target a-world)(draw-loa (world-loa a-world)(world-target a-world)(draw-backround a-world a-scene))))))))))))))))))))))]
    [(world-1p? a-world)(place-image(cond
           [(<(score-try-try a-score)2500)(text "Better luck next time!"50"white")]
           [(>=(score-try-try a-score)2500)(text "Congratulations!" 50 "white")])
            450 75(place-image(cond 
           [(<(score-try-try a-score)2500)(text "Practice Makes Perfect!"50"white")]
           [(>=(score-try-try a-score)2500)(text "You Qualified for the Olympics!" 50 "white")])450 150(place-image (rectangle 700 150 "solid"(make-color 205 71 72))450 112.5(place-image (rectangle 710 160 "solid""white")450 112.5(place-image (text "AGAIN?" 20 "white")450 275(place-image (text "MENU" 20 "white")450 375(place-image(rectangle 200 60 "solid"(make-color 205 71 72))450 275 (place-image (rectangle 210 70 "solid""white")450 275(place-image (rectangle 200 60 "solid"(make-color 205 71 72))450 375 (place-image (rectangle 210 70 "solid""white")450 375 (place-image (rectangle 900 600 "solid"(color 0 0 0 107)) 450 300 (draw-score (world-score a-world) a-world(draw-hitpoints-list (world-target a-world)(world-loa a-world)(draw-wind a-world (draw-archer a-world(world-archer a-world)(draw-blinks-try (world-blinks a-world) a-world(draw-arrow-count a-world(draw-blinks (world-blinks a-world)(draw-target (world-target a-world)(draw-loa (world-loa a-world)(world-target a-world)(draw-backround a-world a-scene)))))))))))))))))))))]))  

;draw-backround: world -> scene
;consumes a world and draws the backround on the scene
(define (draw-backround a-world a-scene) 
  (place-image (rectangle 5 15 "solid""white")882 22.5(place-image (rectangle 5 15 "solid""white")873 22.5(place-image (rectangle 30 30 "solid"(make-color 205 71 72))877.5 22.5(place-image (rectangle 40 40 "solid""white")877.5 22.5(place-image (text"0"37 "white")(+ 601(* 1 .5))563 (place-image (text "2500" 18 "white") 698 105(place-image SSB 600 550(place-image WSB 350 550(place-image (text "0.00" 38 "white")411.5 266(place-image ASB 350 265(place-image VSB 150 290(place-image SB 450 100(place-image (rectangle 900 10 "solid""black")450 205(place-image (rectangle 7 400 "solid""white")100 400(place-image (rectangle 30 400 "solid""black")825 400(place-image (rectangle 900 200 "solid""aqua")450 100(place-image (rectangle 900 400 "solid""YellowGreen") 450 400 a-scene)))))))))))))))))) 

;draw-target: target -> scene 
;consumes a target and draws it on the scene  
(define (draw-target a-target a-scene) 
  (place-image (circle 10 "solid""yellow") (target-tx a-target) (target-ty a-target)(place-image (circle 20 "solid""red") (target-tx a-target) (target-ty a-target)(place-image (circle 32.5 "solid""white") (target-tx a-target) (target-ty a-target)(place-image (circle 45 "solid""blue") (target-tx a-target) (target-ty a-target)(place-image (rectangle 105 105 "solid""gray") (target-tx a-target) (target-ty a-target)(place-image (rectangle 5 20 "solid""yellow")(target-x1 a-target) (target-y a-target)(place-image (rectangle 5 40 "solid""red")(target-x2 a-target) (target-y a-target)(place-image (rectangle 5 65 "solid""white")(target-x3 a-target) (target-y a-target)(place-image (rectangle 5 90 "solid""blue")(target-x4 a-target) (target-y a-target)(place-image (rectangle 5 105 "solid""gray")(target-x5 a-target) (target-y a-target) a-scene)))))))))))  

;draw-hitpoints: target arrow -> scene
;consumes a target and a arrow and draws the hitpoints on the scene 
(define (draw-hitpoints a-target a-arrow a-scene)  
  (cond
    [(and (<(target-timer a-target)5)(collision? a-arrow a-target))(place-image HITPOINT (- (target-tx a-target)(-(target-y a-target)(arrow-y a-arrow)))(-(+ (target-ty a-target)52.5) (* 10.5 (arrow-angle a-arrow)))a-scene)]  
    [else a-scene])) 

;draw-hitpoints-list: target loa -> scene
;consumes a target and a loa and draws the hitpoints on the scene
(define (draw-hitpoints-list a-target a-loa a-scene) 
  (cond
    [(empty? a-loa)a-scene]
    [(cons? a-loa)
     (draw-hitpoints a-target (first a-loa)(draw-hitpoints-list a-target (rest a-loa)a-scene))])) 

;draw-arrow-count: world scene -> scene
;consumes a world and a scene and draws the arrow count on the scene
(define (draw-arrow-count a-world a-scene) 
  (cond
    [(or(and(world-2p? a-world)(eq? (world-try a-world)7))(and(world-1p? a-world)(eq? (world-try a-world)4)))a-scene]
    [(eq? (world-count a-world) 9)(place-image ARROW 151 252 (place-image ARROW 151 262 (place-image ARROW 151 272 (place-image ARROW 151 282(place-image ARROW 151 292(place-image ARROW 151 302(place-image ARROW 151 312(place-image ARROW 151 322(place-image ARROW 151 332 a-scene)))))))))] 
    [(eq? (world-count a-world) 8)(place-image ARROW 151 262 (place-image ARROW 151 272 (place-image ARROW 151 282(place-image ARROW 151 292(place-image ARROW 151 302(place-image ARROW 151 312(place-image ARROW 151 322(place-image ARROW 151 332 a-scene))))))))]
    [(eq? (world-count a-world) 7)(place-image ARROW 151 272 (place-image ARROW 151 282(place-image ARROW 151 292(place-image ARROW 151 302(place-image ARROW 151 312(place-image ARROW 151 322(place-image ARROW 151 332 a-scene)))))))]
    [(eq? (world-count a-world) 6)(place-image ARROW 151 282(place-image ARROW 151 292(place-image ARROW 151 302(place-image ARROW 151 312(place-image ARROW 151 322(place-image ARROW 151 332 a-scene))))))]
    [(eq? (world-count a-world) 5)(place-image ARROW 151 292(place-image ARROW 151 302(place-image ARROW 151 312(place-image ARROW 151 322(place-image ARROW 151 332 a-scene)))))]
    [(eq? (world-count a-world) 4)(place-image ARROW 151 302(place-image ARROW 151 312(place-image ARROW 151 322(place-image ARROW 151 332 a-scene))))]
    [(eq? (world-count a-world) 3)(place-image ARROW 151 312(place-image ARROW 151 322(place-image ARROW 151 332 a-scene)))]
    [(eq? (world-count a-world) 2)(place-image ARROW 151 322(place-image ARROW 151 332 a-scene))]
    [(eq? (world-count a-world) 1)(place-image ARROW 151 332 a-scene)] 
    [else a-scene])) 

(define (trim x)
  (/ (round (* 100 x)) 100))

;draw-arrow: arrow target scene -> scene
;consumes a arrow, a target and a scene and draws the arrows on the scene
(define (draw-arrow a-arrow a-target a-scene)   
  (cond
    [(=(arrow-score a-arrow)600)(place-image NICE 640 498(place-image (text (cond
                                                       [(=(arrow-angle a-arrow)0)"0.00"]
                                                       [(=(arrow-angle a-arrow)4.9)"4.90"]
                                                       [(=(arrow-angle a-arrow)5)"5.00"]
                                                       [(=(arrow-angle a-arrow)9.9)"9.90"]
                                                       [(>=(arrow-angle a-arrow)10)"10.00"] 
                                                       [else(number->string(trim(arrow-angle a-arrow)))])38 "white")(+ 410(*(string-length(number->string(exact->inexact(arrow-angle a-arrow)))).5)) 266(place-image (rectangle 97 40 "solid""black")412 265(place-image ARROW (arrow-x a-arrow)(arrow-y a-arrow) (cond
                                                                 [(and (>(arrow-bounce-timer a-arrow)5)(>=(arrow-score a-arrow)0))(place-image (text(number->string(round(arrow-score a-arrow)))37 "white")(+ 601(*(string-length(number->string(arrow-score a-arrow))).5))563 a-scene)]
                                                                 [else a-scene])))))]
    [(or (>(arrow-x a-arrow)920)(collision? a-arrow a-target))(place-image (text (cond
                                                       [(=(arrow-angle a-arrow)0)"0.00"]
                                                       [(=(arrow-angle a-arrow)5)"5.00"]
                                                       [(=(arrow-angle a-arrow)9.9)"9.90"]
                                                       [(>=(arrow-angle a-arrow)10)"10.00"] 
                                                       [else(number->string(trim(arrow-angle a-arrow)))])38 "white")(+ 410(*(string-length(number->string(exact->inexact(arrow-angle a-arrow)))).5)) 266(place-image (rectangle 97 40 "solid""black")412 265(place-image (rectangle 100 10 "solid""black")890 205(place-image (rectangle 100 400 "solid""yellowgreen")890 400(place-image ARROW (arrow-x a-arrow)(arrow-y a-arrow) (cond
                                                                 [(and (>(arrow-bounce-timer a-arrow)5)(>=(arrow-score a-arrow)0))(place-image (text(number->string(round(arrow-score a-arrow)))37 "white")(+ 601(*(string-length(number->string(arrow-score a-arrow))).5))563 a-scene)]
                                                                 [else a-scene]))))))]
    [(=(arrow-score a-arrow)600)(place-image NICE 450 300(place-image (text (cond
                                                       [(=(arrow-angle a-arrow)0)"0.00"]
                                                       [(=(arrow-angle a-arrow)4.9)"4.90"]
                                                       [(=(arrow-angle a-arrow)5)"5.00"]
                                                       [(=(arrow-angle a-arrow)9.9)"9.90"]
                                                       [(>=(arrow-angle a-arrow)10)"10.00"] 
                                                       [else(number->string(trim(arrow-angle a-arrow)))])38 "white")(+ 410(*(string-length(number->string(exact->inexact(arrow-angle a-arrow)))).5)) 266(place-image (rectangle 97 40 "solid""black")412 265(place-image ARROW (arrow-x a-arrow)(arrow-y a-arrow) (cond
                                                                 [(and (>(arrow-bounce-timer a-arrow)5)(>=(arrow-score a-arrow)0))(place-image (text(number->string(round(arrow-score a-arrow)))37 "white")(+ 601(*(string-length(number->string(arrow-score a-arrow))).5))563 a-scene)]
                                                                 [else a-scene])))))]
    [else(place-image (text (cond
                                                       [(=(arrow-angle a-arrow)0)"0.00"]
                                                       [(=(arrow-angle a-arrow)4.9)"4.90"]
                                                       [(=(arrow-angle a-arrow)5)"5.00"]
                                                       [(=(arrow-angle a-arrow)9.9)"9.90"]
                                                       [(>=(arrow-angle a-arrow)10)"10.00"] 
                                                       [else(number->string(trim(arrow-angle a-arrow)))])38 "white")(+ 410(*(string-length(number->string(exact->inexact(arrow-angle a-arrow)))).5)) 266(place-image (rectangle 97 40 "solid""black")412 265(place-image ARROW (arrow-x a-arrow)(arrow-y a-arrow) (cond
                                                                 [(and (>(arrow-bounce-timer a-arrow)5)(>=(arrow-score a-arrow)0))(place-image (text(number->string(round(arrow-score a-arrow)))37 "white")(+ 601(*(string-length(number->string(arrow-score a-arrow))).5))563 a-scene)]
                                                                 [else a-scene]))))]))   
;draw-arrow-block: arrow scene -> scene
;consumes a arrow and a scene and draws the arrow-block on the scene
(define (draw-arrow-block a-arrow a-scene)  
  (cond
    [(>=(arrow-score a-arrow)0)(place-image (rectangle 74 32 "solid""black")600 560 a-scene)] 
    [else a-scene])) 
 
;draw-loa: loa target scene -> scene
;consumes a loa, target, and a scene and drawsw the arrows on the scene
(define (draw-loa a-loa a-target a-scene)   
  (cond
    [(empty? a-loa)a-scene]   
    [(cons? a-loa)
     (draw-arrow (first a-loa)a-target(draw-arrow-block (first a-loa) (draw-loa (rest a-loa) a-target a-scene)))]))

;draw-blinks: blinks scene -> scene
;consumes a blinks and a scene and draws the blinks on the scene
(define (draw-blinks a-blinks a-scene)
  (cond
    [(blinks-on? a-blinks)(place-image BLINKR 150 150 a-scene)] 
    [else a-scene]))

(define (draw-blinks-try a-blinks a-world a-scene) 
  (cond
    [(and(blinks-on? a-blinks)(or(and(world-2p? a-world)(or (eq?(world-try a-world)2)(eq? (world-try a-world) 1)))(and(world-1p? a-world)(eq? (world-try a-world) 1))))(place-image BLINKL 800 127 a-scene)]
    [(and(blinks-on? a-blinks)(or(and(world-2p? a-world)(or (eq?(world-try a-world)3)(eq? (world-try a-world) 4)))(and(world-1p? a-world)(eq? (world-try a-world) 2))))(place-image BLINKL 800 142 a-scene)]
    [(and(blinks-on? a-blinks)(or(and(world-2p? a-world)(or (eq?(world-try a-world)5)(eq? (world-try a-world) 6)))(and(world-1p? a-world)(eq? (world-try a-world) 3))))(place-image BLINKL 800 159 a-scene)]
     
    [else a-scene]))

;draw-archer: world archer scene -> scene
;consumes a world, an archer, and a scene and draws the archer on the scene
(define (draw-archer a-world a-archer a-scene)  
  (cond 
    [(and(or (world-1p? a-world)(and (world-2p? a-world)(or (=(world-try a-world)1)(=(world-try a-world)3)(=(world-try a-world)5))))(not(eq?(world-atimer a-world)0)))(place-image ARCHER-S (-(archer-x a-archer)3)(archer-y a-archer)a-scene)]
    [(or (world-1p? a-world)(and (world-2p? a-world)(or (=(world-try a-world)1)(=(world-try a-world)3)(=(world-try a-world)5)))) (place-image ARCHER (archer-x a-archer)(archer-y a-archer) a-scene)]
    [(and(or (world-1p? a-world)(and (world-2p? a-world)(or (=(world-try a-world)2)(=(world-try a-world)4)(>=(world-try a-world)6))))(not(eq?(world-atimer a-world)0)))(place-image B-ARCHER-S (-(archer-x a-archer)3)(archer-y a-archer)a-scene)]
    [(or (world-1p? a-world)(and (world-2p? a-world)(or (=(world-try a-world)2)(=(world-try a-world)4)(>=(world-try a-world)6)))) (place-image B-ARCHER (archer-x a-archer)(archer-y a-archer) a-scene)]
[else a-scene]))     

;draw-wind: world -> scene
;consumes a world and draws the amount of wind on the scene 
(define (draw-wind a-world a-scene) 
  (cond
    [(<(world-wind a-world)0)(place-image WDOWN 385 552(place-image (text (number->string(abs(world-wind a-world))) 35 "white")410 552 a-scene))]
    [(eq?(world-wind a-world)0)(place-image WEVEN 385 549(place-image (text (number->string(abs(world-wind a-world))) 35 "white")410 552 a-scene))] 
    [else(place-image WUP 385 548(place-image (text (number->string(abs(world-wind a-world))) 35 "white")410 552 a-scene))]))

;draw-score: score world scene -> scene
;consumes a score, a world, and a scene and draws the score on the scene
(define (draw-score a-score a-world a-scene) 
  (cond
    [(world-1p? a-world)(cond
    [(>=(world-try a-world)3)(place-image (text (number->string(score-try-try a-score)) 24 "white")290 153(place-image (cond
                                                                                                                         [(>=(score-try-try a-score)2500)QUALIFY] 
                                                                                                                         [else NQUALIFYX])350 153 (place-image (text (number->string(score-record a-score))24 "white")617 70(place-image (text (number->string (score-hs a-score)) 18 "white")290 59(place-image(text (number->string(score-total a-score))18 "white")290 83(place-image(text (number->string(score-t3 a-score))18 "white")(+ 696(*(string-length(number->string(score-t3 a-score))).5)) 162(place-image(text (number->string(score-t2 a-score))18 "white")(+ 696(*(string-length(number->string(score-t2 a-score))).5)) 144(place-image(text (number->string(score-t1 a-score))18 "white")(+ 696(*(string-length(number->string(score-t1 a-score))).5)) 127 a-scene))))))))]
    [(>=(world-try a-world)2)(place-image (text (number->string(score-try-try a-score)) 24 "white")290 153(place-image (cond
                                                                                                                         [(>=(score-try-try a-score)2500)QUALIFY] 
                                                                                                                         [else NQUALIFYX])350 153 (place-image (text (number->string(score-record a-score))24 "white")617 70(place-image (text (number->string (score-hs a-score)) 18 "white")290 59(place-image(text (number->string(score-total a-score))18 "white")290 83(place-image(text (number->string(score-t2 a-score))18 "white")(+ 696(*(string-length(number->string(score-t2 a-score))).5)) 144(place-image(text (number->string(score-t1 a-score))18 "white")(+ 696(*(string-length(number->string(score-t1 a-score))).5)) 127 a-scene)))))))] 
    [(>=(world-try a-world)1)(place-image (text (number->string(score-try-try a-score)) 24 "white")290 153(place-image (cond
                                                                                                                         [(>=(score-try-try a-score)2500)QUALIFY]  
                                                                                                                         [else NQUALIFYX])350 153 (place-image (text (number->string(score-record a-score))24 "white")617 70(place-image (text (number->string (score-hs a-score)) 18 "white")290 59(place-image(text (number->string(score-total a-score))18 "white")290 83(place-image(text (number->string(score-t1 a-score))18 "white")(+ 696(*(string-length(number->string(score-t1 a-score))).5)) 127  a-scene))))))]    
)]
    [(world-2p? a-world) 
     (cond
       [(=(world-try a-world)1)(place-image(text "1P" 30 "white")73 150(place-image (rectangle 37 30 "solid""black")70 150(place-image (text (number->string(score-try-try a-score)) 24 "white")290 153(place-image (cond
                                                                                                                         [(>=(score-try-try a-score)2500)QUALIFY]   
                                                                                                                         [else NQUALIFYX])350 153 (place-image (text (number->string(score-record a-score))24 "white")617 70(place-image (text (number->string (score-hs a-score)) 18 "white")290 59 (place-image (text "P2" 14 "white")646 106(place-image (text "P1" 14 "white")595 106(place-image (rectangle 95 2 "solid""white")620.5 115(place-image (rectangle 2 65 "solid""white")620.5 137(place-image(text (number->string(score-2-total a-score))18 "white")290 107(place-image(text (number->string(score-total a-score))18 "white")290 83(place-image(text (number->string(score-t1 a-score))18 "white")595 127  a-scene)))))))))))))]
       [(=(world-try a-world)2)(place-image(text "2P" 30 "white")73 150(place-image (rectangle 37 30 "solid""black")70 150(place-image (text (number->string(score-try-try-2 a-score)) 24 "white")290 153(place-image (cond
                                                                                                                         [(>=(score-try-try-2 a-score)2500)QUALIFY]  
                                                                                                                         [else NQUALIFYX])350 153 (place-image (text (number->string(score-record a-score))24 "white")617 70(place-image (text (number->string (score-hs a-score)) 18 "white")290 59 (place-image (text "P2" 14 "white")646 106(place-image (text "P1" 14 "white")595 106(place-image (rectangle 95 2 "solid""white")620.5 115(place-image (text (number->string(score-2-t1 a-score))18 "white")646 127(place-image (rectangle 2 65 "solid""white")620.5 137(place-image(text (number->string(score-2-total a-score))18 "white")290 107(place-image(text (number->string(score-total a-score))18 "white")290 83(place-image(text (number->string(score-t1 a-score))18 "white")595 127  a-scene))))))))))))))]
       [(=(world-try a-world)3)(place-image(text "1P" 30 "white")73 150(place-image (rectangle 37 30 "solid""black")70 150(place-image (text (number->string(score-try-try a-score)) 24 "white")290 153(place-image (cond
                                                                                                                         [(>=(score-try-try a-score)2500)QUALIFY]  
                                                                                                                         [else NQUALIFYX])350 153 (place-image (text (number->string(score-record a-score))24 "white")617 70(place-image (text (number->string (score-hs a-score)) 18 "white")290 59 (place-image (text "P2" 14 "white")646 106(place-image (text "P1" 14 "white")595 106(place-image (rectangle 95 2 "solid""white")620.5 115(place-image (text (number->string(score-2-t1 a-score))18 "white")646 127(place-image (rectangle 2 65 "solid""white")620.5 137(place-image(text (number->string(score-t2 a-score))18 "white")595 144 (place-image(text (number->string(score-2-total a-score))18 "white")290 107(place-image(text (number->string(score-total a-score))18 "white")290 83(place-image(text (number->string(score-t1 a-score))18 "white")595 127  a-scene)))))))))))))))] 
       [(=(world-try a-world)4)(place-image(text "2P" 30 "white")73 150(place-image (rectangle 37 30 "solid""black")70 150(place-image (text (number->string(score-try-try-2 a-score)) 24 "white")290 153(place-image (cond
                                                                                                                         [(>=(score-try-try-2 a-score)2500)QUALIFY]  
                                                                                                                         [else NQUALIFYX])350 153 (place-image (text (number->string(score-record a-score))24 "white")617 70(place-image (text (number->string (score-hs a-score)) 18 "white")290 59 (place-image (text "P2" 14 "white")646 106(place-image (text "P1" 14 "white")595 106(place-image (rectangle 95 2 "solid""white")620.5 115(place-image (text (number->string(score-2-t1 a-score))18 "white")646 127(place-image (rectangle 2 65 "solid""white")620.5 137(place-image(text (number->string(score-2-t2 a-score))18 "white")646 144 (place-image(text (number->string(score-t2 a-score))18 "white")595 144 (place-image(text (number->string(score-2-total a-score))18 "white")290 107(place-image(text (number->string(score-total a-score))18 "white")290 83(place-image(text (number->string(score-t1 a-score))18 "white")595 127  a-scene))))))))))))))))] 
       [(=(world-try a-world)5)(place-image(text "1P" 30 "white")73 150(place-image (rectangle 37 30 "solid""black")70 150(place-image (text (number->string(score-try-try a-score)) 24 "white")290 153(place-image (cond
                                                                                                                         [(>=(score-try-try a-score)2500)QUALIFY]  
                                                                                                                         [else NQUALIFYX])350 153 (place-image (text (number->string(score-record a-score))24 "white")617 70(place-image (text (number->string (score-hs a-score)) 18 "white")290 59 (place-image (text "P2" 14 "white")646 106(place-image (text "P1" 14 "white")595 106(place-image (rectangle 95 2 "solid""white")620.5 115(place-image (text (number->string(score-2-t1 a-score))18 "white")646 127(place-image (rectangle 2 65 "solid""white")620.5 137(place-image(text (number->string(score-2-t2 a-score))18 "white")646 144 (place-image(text (number->string(score-t3 a-score))18 "white")595 162 (place-image(text (number->string(score-t2 a-score))18 "white")595 144 (place-image(text (number->string(score-2-total a-score))18 "white")290 107(place-image(text (number->string(score-total a-score))18 "white")290 83(place-image(text (number->string(score-t1 a-score))18 "white")595 127  a-scene)))))))))))))))))]
       [(>=(world-try a-world)6)(place-image(text "1P" 30 "white")73 150(place-image (rectangle 37 30 "solid""black")70 150(place-image (text (number->string(score-try-try-2 a-score)) 24 "white")290 153(place-image (cond
                                                                                                                         [(>=(score-try-try-2 a-score)2500)QUALIFY]  
                                                                                                                         [else NQUALIFYX])350 153 (place-image (text (number->string(score-record a-score))24 "white")617 70(place-image (text (number->string (score-hs a-score)) 18 "white")290 59(place-image (text "P2" 14 "white")646 106(place-image (text "P1" 14 "white")595 106(place-image (rectangle 95 2 "solid""white")620.5 115(place-image (rectangle 2 65 "solid""white")620.5 137(place-image(text (number->string(score-2-total a-score))18 "white")290 107(place-image (text (number->string (score-2-t3 a-score)) 18 "white")646 162(place-image (text (number->string (score-2-t2 a-score)) 18 "white")646 144 (place-image(text (number->string(score-2-t1 a-score))18 "white")646 127 (place-image(text (number->string(score-total a-score))18 "white")290 83(place-image(text (number->string(score-t3 a-score))18 "white")595 162 (place-image(text (number->string(score-t2 a-score))18 "white")595 144 (place-image(text (number->string(score-t1 a-score))18 "white")595 127  a-scene))))))))))))))))))])]
    [else a-scene]))  

;update-world: world -> world
;consumes a world and updates it accordingly
(define (update-world a-world)
  (cond
    [(game-over? a-world)(make-world 
   (world-archer a-world)
   (world-loa a-world) 
   (world-target a-world) 
   (update-score-game-over(world-score a-world)a-world)
   (world-count a-world)
   (world-try a-world)  
   (world-turn a-world)
   (world-atimer a-world)
   (world-blinks a-world)
   (world-wind a-world)
   (world-stopped? a-world)
   (world-r-t a-world)
   (world-increase? a-world)
   (world-cc a-world)
   (world-how-to a-world)
   (world-tg a-world)
   (world-hub? a-world)
   (world-stats? a-world)
   (world-credits? a-world)
   (world-how-to? a-world)
   (world-how-too? a-world)
   (world-1p? a-world)
   (world-2p? a-world)
   (world-start? a-world)
   (world-pause? a-world)
   (world-sure? a-world)
   (world-slider-x a-world)
   (cond
     [(=(world-gcount a-world)0)0] 
     [else(-(world-gcount a-world)1)])
   )]
   [(world-credits? a-world)(make-world 
   (world-archer a-world)
   (world-loa a-world)
   (world-target a-world) 
   (world-score a-world)
   (world-count a-world)
   (world-try a-world)  
   (world-turn a-world)
   (world-atimer a-world)
   (world-blinks a-world)
   (world-wind a-world)
   (world-stopped? a-world)
   (world-r-t a-world)
   (world-increase? a-world)
   (world-cc a-world)
   (world-how-to a-world)
   (update-tg(world-tg a-world))
   (world-hub? a-world)
   (world-stats? a-world)
   (world-credits? a-world)
   (world-how-to? a-world)
   (world-how-too? a-world)
   (world-1p? a-world)
   (world-2p? a-world)
   (world-start? a-world)
   (world-pause? a-world)
   (world-sure? a-world)
   (world-slider-x a-world)
   (world-gcount a-world)
   )]
   [(world-start? a-world)
   (make-world  
   (update-archer(world-archer a-world))   
   (update-loa(world-loa a-world)(world-target a-world)a-world) 
   (update-target(world-target a-world) a-world)  
   (update-score-list(world-score a-world)(world-loa a-world)a-world)
   (cond
     [(and (world-1p? a-world)(eq?(world-try a-world)4))0]
     [(and (world-2p? a-world)(eq?(world-try a-world)7))0]
     [(and(eq? (world-count a-world)0)(eq?(world-atimer a-world)0))9]
     [else(world-count a-world)])  
   (cond
     [(and(eq? (world-count a-world)0)(eq?(world-atimer a-world)0)(or(and (world-2p? a-world)(not(eq?(world-try a-world)7)))(and (world-1p? a-world)(not(eq?(world-try a-world)4)))))(+(world-try a-world)1)]  
     [else(world-try a-world)])       
   (world-turn a-world)  
   (cond
     [(eq? (world-atimer a-world)0)0]
     [(and (world-1p? a-world)(eq?(world-try a-world)4))0]
     [(and (world-2p? a-world)(eq?(world-try a-world)7))0]
     [else(-(world-atimer a-world)1)]) 
   (update-blinks(world-blinks a-world)) 
   (cond
     [(world-stopped? a-world)(world-wind a-world)] 
     [else(cond
            [(eq? (world-r-t a-world)1)(random 10)]
            [(eq? (world-r-t a-world)0)(* -1(random 10))])])
   (cond
     [(and(=(world-count a-world)0)(eq?(world-atimer a-world)0))false]
     [else(world-stopped? a-world)])
   (random 2)
   (world-increase? a-world)
   (cond
     [(eq?(world-atimer a-world)0)0]
     [else (world-cc a-world)])
   (world-how-to a-world)
   (world-tg a-world)
   (world-hub? a-world)
   (world-stats? a-world)
   (world-credits? a-world)
   (world-how-to? a-world)
   (world-how-too? a-world)
   (world-1p? a-world)
   (world-2p? a-world)
   (world-start? a-world)
   (world-pause? a-world)
   (world-sure? a-world)
   (world-slider-x a-world)
   (world-gcount a-world)
   )]
   [else a-world]))

;update-tg: tg -> tg
;consumes a tg and updates it accordingly
(define(update-tg a-tg) 
  (make-tg
   (tg-x1 a-tg)
   (cond
     [(<(tg-y1 a-tg)-50)650]
     [else(-(tg-y1 a-tg)5)])
   (tg-x2 a-tg)
   (cond
     [(<(tg-y2 a-tg)-50)650]
     [else(-(tg-y2 a-tg)5)]) 
   (tg-x3 a-tg)
   (cond
     [(<(tg-y3 a-tg)-50)650]
     [else(-(tg-y3 a-tg)5)])
   (tg-x4 a-tg)
   (cond
     [(<(tg-y4 a-tg)-50)650]
     [else(-(tg-y4 a-tg)5)])
   (tg-x5 a-tg)
   (cond
     [(<(tg-y5 a-tg)-50)650] 
     [else(-(tg-y5 a-tg)5)])
   (tg-x6 a-tg)
   (cond
     [(<(tg-y6 a-tg)-50)650]
     [else(-(tg-y6 a-tg)5)])
   (tg-x7 a-tg)
   (cond
     [(<(tg-y7 a-tg)-50)650]
     [else(-(tg-y7 a-tg)5)])
   ))

;update-target: target world -> target
;consumes a target and a world and updates the target accoringly
(define (update-target a-target a-world)  
  (make-target
   (target-x1 a-target)  
   (target-x2 a-target)
   (target-x3 a-target) 
   (target-x4 a-target)  
   (target-x5 a-target)
   (cond
     [(eq? (target-dir a-target)'down)(+(target-y a-target)4)]
     [(eq? (target-dir a-target)'up)(-(target-y a-target)4)]
     )
   (target-tx a-target)
   (target-ty a-target)
   (cond 
     [(<= (target-y a-target)265)'down]   
     [(>= (target-y a-target)550)'up]   
     [else(target-dir a-target)])
   (cond
     [(eq? (target-timer a-target)10)1]
     [else(+(target-timer a-target)1)])
   ))

;update-score: score arrow world -> score
;consumes a score, an arrow, and a world an updates the score accordingly
(define (update-score a-score a-arrow a-world)
  (make-score
   (cond
     [(and(eq?(arrow-timer a-arrow)1)(world-1p? a-world)(eq?(world-try a-world)1))(+(score-t1 a-score)(arrow-score a-arrow))]
     [(and(eq?(arrow-timer a-arrow)1)(world-2p? a-world)(eq?(world-try a-world)1))(+(score-t1 a-score)(arrow-score a-arrow))]
     [else (score-t1 a-score)]) 
   (cond
     [(and(eq?(arrow-timer a-arrow)1)(world-1p? a-world)(eq?(world-try a-world)2))(+(score-t2 a-score)(arrow-score a-arrow))]
     [(and(eq?(arrow-timer a-arrow)1)(world-2p? a-world)(eq?(world-try a-world)3))(+(score-t2 a-score)(arrow-score a-arrow))]
     [else (score-t2 a-score)])
   (cond
     [(and(eq?(arrow-timer a-arrow)1)(world-1p? a-world)(eq?(world-try a-world)3))(+(score-t3 a-score)(arrow-score a-arrow))]
     [(and(eq?(arrow-timer a-arrow)1)(world-2p? a-world)(eq?(world-try a-world)5))(+(score-t3 a-score)(arrow-score a-arrow))]
     [else (score-t3 a-score)])
   (cond
     [(and(eq?(arrow-timer a-arrow)1)(world-2p? a-world)(eq?(world-try a-world)2))(+(score-2-t1 a-score)(arrow-score a-arrow))]
     [else (score-2-t1 a-score)]) 
   (cond
     [(and(eq?(arrow-timer a-arrow)1)(world-2p? a-world)(eq?(world-try a-world)4))(+(score-2-t2 a-score)(arrow-score a-arrow))]
     [else (score-2-t2 a-score)])
   (cond
     [(and(eq?(arrow-timer a-arrow)1)(world-2p? a-world)(eq?(world-try a-world)6))(+(score-2-t3 a-score)(arrow-score a-arrow))]
     [else (score-2-t3 a-score)])
   (score-try-try a-score)
   (score-try-try-2 a-score)
   (cond
     [(>(score-t1 a-score)(score-record a-score))(score-t1 a-score)]
     [(>(score-t2 a-score)(score-record a-score))(score-t2 a-score)]
     [(>(score-t3 a-score)(score-record a-score))(score-t3 a-score)]
     [else (score-record a-score)]) 
   (+(score-t1 a-score)(score-t2 a-score)(score-t3 a-score))
   (+(score-2-t1 a-score)(score-2-t2 a-score)(score-2-t3 a-score))
   (cond
     [(>(score-total a-score)(score-hs a-score))(score-total a-score)]
     [(>(score-2-total a-score)(score-hs a-score))(score-2-total a-score)]
     [else(score-hs a-score)]) 
   (score-best-try a-score)
   (score-total-q a-score) 
   (score-arrows-shot a-score)
   (score-noc a-score)
   (score-bulls a-score)
   (score-nom a-score)
   (score-p1w a-score)
   (cond
     [(and (world-2p? a-world)(game-over? a-world)(=(world-gcount a-world)2)(>(score-2-total a-score)(score-total a-score)))40]
     [else(score-p2w a-score)]) 
   ))

;update-score-game-over: score world -> score
;consumes a score and a world and updates the score accordingly
(define (update-score-game-over a-score a-world)
  (make-score
   (score-t1 a-score)
   (score-t2 a-score)
   (score-t3 a-score)
   (score-2-t1 a-score)
   (score-2-t2 a-score)
   (score-2-t3 a-score)
   (score-try-try a-score)
   (score-try-try-2 a-score)
   (score-record a-score)
   (score-total a-score)
   (score-2-total a-score)
   (score-hs a-score)
   (score-best-try a-score) 
   (cond
     [(and (=(world-gcount a-world)1)(or(>=(score-t1 a-score)2500)(>=(score-t2 a-score)2500)(>=(score-t3 a-score)2500)(>=(score-2-t1 a-score)2500)(>=(score-2-t2 a-score)2500)(>=(score-2-t3 a-score)2500)))(+(score-total-q a-score)1)]
     [else(score-total-q a-score)])
   (score-arrows-shot a-score)
   (score-noc a-score)
   (score-bulls a-score)
   (score-nom a-score)
   (cond
     [(and (world-2p? a-world)(=(world-gcount a-world)1)(>(score-total a-score)(score-2-total a-score)))(+(score-p1w a-score)1)]
     [else(score-p1w a-score)]) 
   (cond
     [(and (world-2p? a-world)(=(world-gcount a-world)1)(>(score-2-total a-score)(score-total a-score)))(+(score-p2w a-score)1)]
     [else(score-p2w a-score)])
   ))
  

;update-score-list: score loa world -> score
;consumes a score, a loa, and a world and updates the score accordingly
(define (update-score-list a-score a-loa a-world) 
  (cond
    [(empty? a-loa)a-score]
    [(cons? a-loa)
     (cond
       [(and(=(world-atimer a-world)7)(> (score-t1 a-score)(score-best-try a-score)))(make-score 
   (score-t1 a-score)
                                                                       (score-t2 a-score)
                                                                       (score-t3 a-score)
                                                                       (score-2-t1 a-score)
                                                                       (score-2-t2 a-score)
                                                                       (score-2-t3 a-score)
                                                                       (score-try-try a-score)
                                                                       (score-try-try-2 a-score)
                                                                       (score-record a-score)
                                                                       (+(score-t1 a-score)(score-t2 a-score)(score-t3 a-score))
                                                                       (score-2-total a-score)
                                                                       (+(score-t1 a-score)(score-t2 a-score)(score-t3 a-score))
                                                                       (score-t1 a-score)
                                                                       (score-total-q a-score)
                                                                       (score-arrows-shot a-score)
                                                                       (score-noc a-score)
                                                                       (score-bulls a-score)
                                                                       (score-nom a-score)
                                                                       (score-p1w a-score)
                                                                       (score-p2w a-score)  
)]
       [(and(=(world-atimer a-world)7)(> (score-t2 a-score)(score-best-try a-score)))(make-score 
   (score-t1 a-score)
                                                                       (score-t2 a-score)
                                                                       (score-t3 a-score)
                                                                       (score-2-t1 a-score)
                                                                       (score-2-t2 a-score)
                                                                       (score-2-t3 a-score)
                                                                       (score-try-try a-score)
                                                                       (score-try-try-2 a-score)
                                                                       (score-record a-score)
                                                                       (+(score-t1 a-score)(score-t2 a-score)(score-t3 a-score))
                                                                       (score-2-total a-score)
                                                                       (+(score-t1 a-score)(score-t2 a-score)(score-t3 a-score))
                                                                       (score-t2 a-score)
                                                                       (score-total-q a-score)
                                                                       (score-arrows-shot a-score)
                                                                       (score-noc a-score)
                                                                       (score-bulls a-score)
                                                                       (score-nom a-score)
                                                                       (score-p1w a-score)
                                                                       (score-p2w a-score)
)]
       [(and(=(world-atimer a-world)7)(> (score-t3 a-score)(score-best-try a-score)))(make-score 
   (score-t1 a-score)
                                                                       (score-t2 a-score)
                                                                       (score-t3 a-score)
                                                                       (score-2-t1 a-score)
                                                                       (score-2-t2 a-score)
                                                                       (score-2-t3 a-score)
                                                                       (score-try-try a-score)
                                                                       (score-try-try-2 a-score)
                                                                       (score-record a-score)
                                                                       (+(score-t1 a-score)(score-t2 a-score)(score-t3 a-score))
                                                                       (score-2-total a-score)
                                                                       (+(score-t1 a-score)(score-t2 a-score)(score-t3 a-score))
                                                                       (score-t3 a-score)
                                                                       (score-total-q a-score)
                                                                       (score-arrows-shot a-score)
                                                                       (score-noc a-score)
                                                                       (score-bulls a-score)
                                                                       (score-nom a-score)
                                                                       (score-p1w a-score)
                                                                       (score-p2w a-score)
)]
       
       [(and(=(world-atimer a-world)7)(> (score-2-t1 a-score)(score-best-try a-score)))(make-score 
   (score-t1 a-score) 
                                                                       (score-t2 a-score)
                                                                       (score-t3 a-score)
                                                                       (score-2-t1 a-score)
                                                                       (score-2-t2 a-score)
                                                                       (score-2-t3 a-score)
                                                                       (score-try-try a-score)
                                                                       (score-try-try-2 a-score)
                                                                       (score-record a-score)
                                                                       (+(score-t1 a-score)(score-t2 a-score)(score-t3 a-score))
                                                                       (score-2-total a-score)
                                                                       (+(score-t1 a-score)(score-t2 a-score)(score-t3 a-score))
                                                                       (score-2-t1 a-score)
                                                                       (score-total-q a-score)
                                                                       (score-arrows-shot a-score)
                                                                       (score-noc a-score)
                                                                       (score-bulls a-score)
                                                                       (score-nom a-score)
                                                                       (score-p1w a-score)
                                                                       (score-p2w a-score)  
)]
       
       [(and(=(world-atimer a-world)7)(> (score-2-t2 a-score)(score-best-try a-score)))(make-score 
   (score-t1 a-score)
                                                                       (score-t2 a-score)
                                                                       (score-t3 a-score)
                                                                       (score-2-t1 a-score)
                                                                       (score-2-t2 a-score)
                                                                       (score-2-t3 a-score)
                                                                       (score-try-try a-score)
                                                                       (score-try-try-2 a-score)
                                                                       (score-record a-score)
                                                                       (+(score-t1 a-score)(score-t2 a-score)(score-t3 a-score))
                                                                       (score-2-total a-score)
                                                                       (+(score-t1 a-score)(score-t2 a-score)(score-t3 a-score))
                                                                       (score-2-t2 a-score)
                                                                       (score-total-q a-score)
                                                                       (score-arrows-shot a-score)
                                                                       (score-noc a-score)
                                                                       (score-bulls a-score)
                                                                       (score-nom a-score)
                                                                       (score-p1w a-score)
                                                                       (score-p2w a-score)  
)]
       
       [(and(=(world-atimer a-world)7)(> (score-2-t3 a-score)(score-best-try a-score)))(make-score 
   (score-t1 a-score)
                                                                       (score-t2 a-score)
                                                                       (score-t3 a-score)
                                                                       (score-2-t1 a-score)
                                                                       (score-2-t2 a-score)
                                                                       (score-2-t3 a-score)
                                                                       (score-try-try a-score)
                                                                       (score-try-try-2 a-score)
                                                                       (score-record a-score)
                                                                       (+(score-t1 a-score)(score-t2 a-score)(score-t3 a-score))
                                                                       (score-2-total a-score)
                                                                       (+(score-t1 a-score)(score-t2 a-score)(score-t3 a-score))
                                                                       (score-2-t3 a-score)
                                                                       (score-total-q a-score)
                                                                       (score-arrows-shot a-score)
                                                                       (score-noc a-score)
                                                                       (score-bulls a-score)
                                                                       (score-nom a-score)
                                                                       (score-p1w a-score)
                                                                       (score-p2w a-score)  
)]
       [(and(world-1p? a-world)(>(+(score-t1 a-score)(score-t2 a-score)(score-t3 a-score))(score-hs a-score))(or(=(world-try a-world)1)(=(world-try a-world)2)(=(world-try a-world)3))(=(arrow-timer(first a-loa))1))(make-score
                                                                       (score-t1 a-score)
                                                                       (score-t2 a-score)
                                                                       (score-t3 a-score)
                                                                       (score-2-t1 a-score)
                                                                       (score-2-t2 a-score)
                                                                       (score-2-t3 a-score)
                                                                       (score-try-try a-score)
                                                                       (score-try-try-2 a-score)
                                                                       (score-record a-score)
                                                                       (+(score-t1 a-score)(score-t2 a-score)(score-t3 a-score))
                                                                       (score-2-total a-score)
                                                                       (+(score-t1 a-score)(score-t2 a-score)(score-t3 a-score))
                                                                       (score-best-try a-score)
                                                                       (score-total-q a-score)
                                                                       (score-arrows-shot a-score)
                                                                       (score-noc a-score)
                                                                       (score-bulls a-score)
                                                                       (score-nom a-score)
                                                                       (score-p1w a-score)
                                                                       (score-p2w a-score))]
       [(and(world-1p? a-world)(>(score-t1 a-score)(score-record a-score))(or(=(world-try a-world)1)(=(world-try a-world)2)(=(world-try a-world)3))(=(arrow-timer(first a-loa))3))(make-score  
                                                                       (score-t1 a-score)
                                                                       (score-t2 a-score)
                                                                       (score-t3 a-score)
                                                                       (score-2-t1 a-score)
                                                                       (score-2-t2 a-score)
                                                                       (score-2-t3 a-score)
                                                                       (score-try-try a-score)
                                                                       (score-try-try-2 a-score)
                                                                       (score-t1 a-score)
                                                                       (score-total a-score)
                                                                       (score-2-total a-score)
                                                                       (score-hs a-score)
                                                                       (score-best-try a-score)
                                                                       (score-total-q a-score)
                                                                       (score-arrows-shot a-score)
                                                                       (score-noc a-score)
                                                                       (score-bulls a-score)
                                                                       (score-nom a-score)
                                                                       (score-p1w a-score)
                                                                       (score-p2w a-score))]
       [(and(world-1p? a-world)(>(score-t2 a-score)(score-record a-score))(or(=(world-try a-world)1)(=(world-try a-world)2)(=(world-try a-world)3))(=(arrow-timer(first a-loa))3))(make-score
                                                                       (score-t1 a-score)
                                                                       (score-t2 a-score)
                                                                       (score-t3 a-score)
                                                                       (score-2-t1 a-score)
                                                                       (score-2-t2 a-score)
                                                                       (score-2-t3 a-score)
                                                                       (score-try-try a-score)
                                                                       (score-try-try-2 a-score)
                                                                       (score-t2 a-score)
                                                                       (score-total a-score)
                                                                       (score-2-total a-score)
                                                                       (score-hs a-score)
                                                                       (score-best-try a-score) 
                                                                       (score-total-q a-score)
                                                                       (score-arrows-shot a-score)
                                                                       (score-noc a-score)
                                                                       (score-bulls a-score)
                                                                       (score-nom a-score)
                                                                       (score-p1w a-score)
                                                                       (score-p2w a-score))]
       [(and(world-1p? a-world)(>(score-t3 a-score)(score-record a-score))(or(=(world-try a-world)1)(=(world-try a-world)2)(=(world-try a-world)3))(=(arrow-timer(first a-loa))3))(make-score
                                                                       (score-t1 a-score)
                                                                       (score-t2 a-score)
                                                                       (score-t3 a-score)
                                                                       (score-2-t1 a-score)
                                                                       (score-2-t2 a-score)
                                                                       (score-2-t3 a-score)
                                                                       (score-try-try a-score)
                                                                       (score-try-try-2 a-score)
                                                                       (score-t3 a-score)
                                                                       (score-total a-score)
                                                                       (score-2-total a-score)
                                                                       (score-hs a-score)
                                                                       (score-best-try a-score)
                                                                       (score-total-q a-score)
                                                                       (score-arrows-shot a-score)
                                                                       (score-noc a-score)
                                                                       (score-bulls a-score)
                                                                       (score-nom a-score)
                                                                       (score-p1w a-score)
                                                                       (score-p2w a-score))]
       
       [(and (world-1p? a-world)(>(score-t1 a-score)(score-try-try a-score))(or(=(world-try a-world)1)(=(world-try a-world)2)(=(world-try a-world)3))(=(arrow-timer(first a-loa))2))(make-score
                                                                                                                                                                                          (score-t1 a-score)
                                                                       (score-t2 a-score)
                                                                       (score-t3 a-score)
                                                                       (score-2-t1 a-score)
                                                                       (score-2-t2 a-score)
                                                                       (score-2-t3 a-score)
                                                                       (score-t1 a-score)
                                                                       (score-try-try-2 a-score)
                                                                       (score-record a-score)
                                                                       (score-total a-score)
                                                                       (score-2-total a-score)
                                                                       (score-hs a-score)
                                                                       (score-best-try a-score)
                                                                       (score-total-q a-score)
                                                                       (score-arrows-shot a-score)
                                                                       (score-noc a-score)
                                                                       (score-bulls a-score)
                                                                       (score-nom a-score)
                                                                       (score-p1w a-score)
                                                                       (score-p2w a-score))]
       
       [(and (world-1p? a-world)(>(score-t2 a-score)(score-try-try a-score))(or(=(world-try a-world)1)(=(world-try a-world)2)(=(world-try a-world)3))(=(arrow-timer(first a-loa))2))(make-score
                                                                                                                                                                                          (score-t1 a-score)
                                                                       (score-t2 a-score)
                                                                       (score-t3 a-score)
                                                                       (score-2-t1 a-score)
                                                                       (score-2-t2 a-score)
                                                                       (score-2-t3 a-score)
                                                                       (score-t2 a-score)
                                                                       (score-try-try-2 a-score)
                                                                       (score-record a-score)
                                                                       (score-total a-score)
                                                                       (score-2-total a-score)
                                                                       (score-hs a-score)
                                                                       (score-best-try a-score)
                                                                       (score-total-q a-score)
                                                                       (score-arrows-shot a-score)
                                                                       (score-noc a-score)
                                                                       (score-bulls a-score)
                                                                       (score-nom a-score)
                                                                       (score-p1w a-score)
                                                                       (score-p2w a-score))]
       
       [(and (world-1p? a-world)(>(score-t3 a-score)(score-try-try a-score))(or(=(world-try a-world)1)(=(world-try a-world)2)(=(world-try a-world)3))(=(arrow-timer(first a-loa))2))(make-score
                                                                                                                                                                                          (score-t1 a-score)
                                                                       (score-t2 a-score)
                                                                       (score-t3 a-score)
                                                                       (score-2-t1 a-score)
                                                                       (score-2-t2 a-score)
                                                                       (score-2-t3 a-score)
                                                                       (score-t3 a-score)
                                                                       (score-try-try-2 a-score)
                                                                       (score-record a-score)
                                                                       (score-total a-score)
                                                                       (score-2-total a-score)
                                                                       (score-hs a-score)
                                                                       (score-best-try a-score)
                                                                       (score-total-q a-score)
                                                                       (score-arrows-shot a-score)
                                                                       (score-noc a-score)
                                                                       (score-bulls a-score)
                                                                       (score-nom a-score)
                                                                       (score-p1w a-score)
                                                                       (score-p2w a-score))] 
       
       [(and(world-1p? a-world)(or(=(world-try a-world)1)(=(world-try a-world)2)(=(world-try a-world)3))(=(arrow-timer(first a-loa))1))(make-score 
                                                                       (score-t1 a-score)
                                                                       (score-t2 a-score)
                                                                       (score-t3 a-score)
                                                                       (score-2-t1 a-score)
                                                                       (score-2-t2 a-score)
                                                                       (score-2-t3 a-score)
                                                                       (score-try-try a-score)
                                                                       (score-try-try-2 a-score)
                                                                       (score-record a-score)
                                                                       (+(score-t1 a-score)(score-t2 a-score)(score-t3 a-score))
                                                                       (score-2-total a-score)
                                                                       (score-hs a-score)
                                                                       (score-best-try a-score)
                                                                       (score-total-q a-score)
                                                                       (score-arrows-shot a-score)
                                                                       (score-noc a-score)
                                                                       (score-bulls a-score)
                                                                       (score-nom a-score)
                                                                       (score-p1w a-score)
                                                                       (score-p2w a-score))]
      [(and(world-2p? a-world)(>(score-2-t1 a-score)(score-record a-score))(or(=(world-try a-world)2)(=(world-try a-world)4)(=(world-try a-world)6))(=(arrow-timer(first a-loa))2))(make-score 
                                                                       (score-t1 a-score)
                                                                       (score-t2 a-score)
                                                                       (score-t3 a-score)
                                                                       (score-2-t1 a-score)
                                                                       (score-2-t2 a-score)
                                                                       (score-2-t3 a-score)
                                                                       (score-try-try a-score)
                                                                       (score-try-try-2 a-score)
                                                                       (score-2-t1 a-score)
                                                                       (score-total a-score)
                                                                       (score-2-total a-score)
                                                                       (score-hs a-score)
                                                                       (score-best-try a-score)
                                                                       (score-total-q a-score)
                                                                       (score-arrows-shot a-score)
                                                                       (score-noc a-score)
                                                                       (score-bulls a-score)
                                                                       (score-nom a-score)
                                                                       (score-p1w a-score)
                                                                       (score-p2w a-score))]
       [(and(world-2p? a-world)(>(score-2-t2 a-score)(score-record a-score))(or(=(world-try a-world)2)(=(world-try a-world)4)(=(world-try a-world)6))(=(arrow-timer(first a-loa))2))(make-score 
                                                                       (score-t1 a-score)
                                                                       (score-t2 a-score)
                                                                       (score-t3 a-score)
                                                                       (score-2-t1 a-score)
                                                                       (score-2-t2 a-score)
                                                                       (score-2-t3 a-score)
                                                                       (score-try-try a-score)
                                                                       (score-try-try-2 a-score)
                                                                       (score-2-t2 a-score)
                                                                       (score-total a-score)
                                                                       (score-2-total a-score)
                                                                       (score-hs a-score)
                                                                       (score-best-try a-score)
                                                                       (score-total-q a-score)
                                                                       (score-arrows-shot a-score)
                                                                       (score-noc a-score)
                                                                       (score-bulls a-score)
                                                                       (score-nom a-score)
                                                                       (score-p1w a-score)
                                                                       (score-p2w a-score))]
       [(and(world-2p? a-world)(>(score-2-t3 a-score)(score-record a-score))(or(=(world-try a-world)2)(=(world-try a-world)4)(=(world-try a-world)6))(=(arrow-timer(first a-loa))2))(make-score 
                                                                       (score-t1 a-score)
                                                                       (score-t2 a-score)
                                                                       (score-t3 a-score)
                                                                       (score-2-t1 a-score)
                                                                       (score-2-t2 a-score)
                                                                       (score-2-t3 a-score)
                                                                       (score-try-try a-score)
                                                                       (score-try-try-2 a-score)
                                                                       (score-2-t3 a-score)
                                                                       (score-total a-score)
                                                                       (score-2-total a-score)
                                                                       (score-hs a-score)
                                                                       (score-best-try a-score)
                                                                       (score-total-q a-score)
                                                                       (score-arrows-shot a-score)
                                                                       (score-noc a-score)
                                                                       (score-bulls a-score)
                                                                       (score-nom a-score)
                                                                       (score-p1w a-score)
                                                                       (score-p2w a-score))] 
       
       [(and(world-2p? a-world)(>(+(score-t1 a-score)(score-t2 a-score)(score-t3 a-score))(score-hs a-score))(or(=(world-try a-world)1)(=(world-try a-world)3)(=(world-try a-world)5))(=(arrow-timer(first a-loa))1))(make-score
                                                                       (score-t1 a-score)
                                                                       (score-t2 a-score)
                                                                       (score-t3 a-score)
                                                                       (score-2-t1 a-score)
                                                                       (score-2-t2 a-score)
                                                                       (score-2-t3 a-score)
                                                                       (score-try-try a-score)
                                                                       (score-try-try-2 a-score)
                                                                       (score-record a-score)
                                                                       (+(score-t1 a-score)(score-t2 a-score)(score-t3 a-score))
                                                                       (score-2-total a-score)
                                                                       (+(score-t1 a-score)(score-t2 a-score)(score-t3 a-score))
                                                                       (score-best-try a-score) 
                                                                       (score-total-q a-score)
                                                                       (score-arrows-shot a-score)
                                                                       (score-noc a-score)
                                                                       (score-bulls a-score)
                                                                       (score-nom a-score)
                                                                       (score-p1w a-score)
                                                                       (score-p2w a-score))]
       
              [(and(world-2p? a-world)(or(=(world-try a-world)1)(=(world-try a-world)3)(=(world-try a-world)5))(=(arrow-timer(first a-loa))1))(make-score
                                                                       (score-t1 a-score)
                                                                       (score-t2 a-score)
                                                                       (score-t3 a-score)
                                                                       (score-2-t1 a-score)
                                                                       (score-2-t2 a-score)
                                                                       (score-2-t3 a-score)
                                                                       (score-try-try a-score)
                                                                       (score-try-try-2 a-score)
                                                                       (score-record a-score)
                                                                       (+(score-t1 a-score)(score-t2 a-score)(score-t3 a-score))
                                                                       (score-2-total a-score)
                                                                       (score-hs a-score)
                                                                       (score-best-try a-score)
                                                                       (score-total-q a-score)
                                                                       (score-arrows-shot a-score)
                                                                       (score-noc a-score)
                                                                       (score-bulls a-score)
                                                                       (score-nom a-score)
                                                                       (score-p1w a-score)
                                                                       (score-p2w a-score))]
              [(and(world-2p? a-world)(>(+(score-2-t1 a-score)(score-2-t2 a-score)(score-2-t3 a-score))(score-hs a-score))(or(=(world-try a-world)2)(=(world-try a-world)4)(=(world-try a-world)6))(=(arrow-timer(first a-loa))1))(make-score
                                                                       (score-t1 a-score)
                                                                       (score-t2 a-score)
                                                                       (score-t3 a-score)
                                                                       (score-2-t1 a-score)
                                                                       (score-2-t2 a-score)
                                                                       (score-2-t3 a-score)
                                                                       (score-try-try a-score)
                                                                       (score-try-try-2 a-score)
                                                                       (score-record a-score)
                                                                       (score-total a-score)
                                                                       (+(score-2-t1 a-score)(score-2-t2 a-score)(score-2-t3 a-score))
                                                                       (+(score-2-t1 a-score)(score-2-t2 a-score)(score-2-t3 a-score))
                                                                       (score-best-try a-score)
                                                                       (score-total-q a-score)
                                                                       (score-arrows-shot a-score)
                                                                       (score-noc a-score)
                                                                       (score-bulls a-score)
                                                                       (score-nom a-score)
                                                                       (score-p1w a-score)
                                                                       (score-p2w a-score))]
              [(and(world-2p? a-world)(or(=(world-try a-world)2)(=(world-try a-world)4)(=(world-try a-world)6))(=(arrow-timer(first a-loa))1))(make-score
                                                                       (score-t1 a-score)
                                                                       (score-t2 a-score) 
                                                                       (score-t3 a-score)
                                                                       (score-2-t1 a-score)
                                                                       (score-2-t2 a-score)
                                                                       (score-2-t3 a-score)
                                                                       (score-try-try a-score)
                                                                       (score-try-try-2 a-score)
                                                                       (score-record a-score)
                                                                       (score-total a-score)
                                                                       (+(score-2-t1 a-score)(score-2-t2 a-score)(score-2-t3 a-score))
                                                                       (score-hs a-score)
                                                                       (score-best-try a-score)
                                                                       (score-total-q a-score)
                                                                       (score-arrows-shot a-score)
                                                                       (score-noc a-score)
                                                                       (score-bulls a-score)
                                                                       (score-nom a-score)
                                                                       (score-p1w a-score)
                                                                       (score-p2w a-score))]
              [(and(world-2p? a-world)(>(score-t1 a-score)(score-record a-score))(or(=(world-try a-world)1)(=(world-try a-world)3)(=(world-try a-world)5))(=(arrow-timer(first a-loa))2))(make-score 
                                                                       (score-t1 a-score)
                                                                       (score-t2 a-score)
                                                                       (score-t3 a-score)
                                                                       (score-2-t1 a-score)
                                                                       (score-2-t2 a-score)
                                                                       (score-2-t3 a-score)
                                                                       (score-try-try a-score)
                                                                       (score-try-try-2 a-score)
                                                                       (score-t1 a-score)
                                                                       (score-total a-score)
                                                                       (score-2-total a-score)
                                                                       (score-hs a-score)
                                                                       (score-best-try a-score)
                                                                       (score-total-q a-score)
                                                                       (score-arrows-shot a-score)
                                                                       (score-noc a-score)
                                                                       (score-bulls a-score)
                                                                       (score-nom a-score)
                                                                       (score-p1w a-score)
                                                                       (score-p2w a-score))]
              [(and(world-2p? a-world)(>(score-t2 a-score)(score-record a-score))(or(=(world-try a-world)1)(=(world-try a-world)3)(=(world-try a-world)5))(=(arrow-timer(first a-loa))2))(make-score 
                                                                       (score-t1 a-score)
                                                                       (score-t2 a-score)
                                                                       (score-t3 a-score)
                                                                       (score-2-t1 a-score)
                                                                       (score-2-t2 a-score) 
                                                                       (score-2-t3 a-score)
                                                                       (score-try-try a-score)
                                                                       (score-try-try-2 a-score)
                                                                       (score-t2 a-score)
                                                                       (score-total a-score)
                                                                       (score-2-total a-score)
                                                                       (score-hs a-score)
                                                                       (score-best-try a-score)
                                                                       (score-total-q a-score)
                                                                       (score-arrows-shot a-score)
                                                                       (score-noc a-score)
                                                                       (score-bulls a-score)
                                                                       (score-nom a-score)
                                                                       (score-p1w a-score)
                                                                       (score-p2w a-score))]
              [(and(world-2p? a-world)(>(score-t3 a-score)(score-record a-score))(or(=(world-try a-world)1)(=(world-try a-world)3)(=(world-try a-world)5))(=(arrow-timer(first a-loa))2))(make-score 
                                                                       (score-t1 a-score)
                                                                       (score-t2 a-score)
                                                                       (score-t3 a-score)
                                                                       (score-2-t1 a-score)
                                                                       (score-2-t2 a-score)
                                                                       (score-2-t3 a-score)
                                                                       (score-try-try a-score)
                                                                       (score-try-try-2 a-score)
                                                                       (score-t3 a-score)
                                                                       (score-total a-score)
                                                                       (score-2-total a-score)
                                                                       (score-hs a-score)
                                                                       (score-best-try a-score)
                                                                       (score-total-q a-score)
                                                                       (score-arrows-shot a-score)
                                                                       (score-noc a-score)
                                                                       (score-bulls a-score)
                                                                       (score-nom a-score)
                                                                       (score-p1w a-score)
                                                                       (score-p2w a-score))]
              [(and (world-2p? a-world)(>(score-t1 a-score)(score-try-try a-score))(or(=(world-try a-world)1)(=(world-try a-world)3)(=(world-try a-world)5))(=(arrow-timer(first a-loa))3))(make-score
                                                                                                                                                                                          (score-t1 a-score)
                                                                       (score-t2 a-score)
                                                                       (score-t3 a-score)
                                                                       (score-2-t1 a-score)
                                                                       (score-2-t2 a-score)
                                                                       (score-2-t3 a-score)
                                                                       (score-t1 a-score)
                                                                       (score-try-try-2 a-score)
                                                                       (score-record a-score)
                                                                       (score-total a-score)
                                                                       (score-2-total a-score)
                                                                       (score-hs a-score)
                                                                       (score-best-try a-score)
                                                                       (score-total-q a-score)
                                                                       (score-arrows-shot a-score)
                                                                       (score-noc a-score)
                                                                       (score-bulls a-score)
                                                                       (score-nom a-score)
                                                                       (score-p1w a-score)
                                                                       (score-p2w a-score))]
              
              [(and (world-2p? a-world)(>(score-t2 a-score)(score-try-try a-score))(or(=(world-try a-world)1)(=(world-try a-world)3)(=(world-try a-world)5))(=(arrow-timer(first a-loa))3))(make-score
                                                                                                                                                                                          (score-t1 a-score)
                                                                       (score-t2 a-score)
                                                                       (score-t3 a-score)
                                                                       (score-2-t1 a-score)
                                                                       (score-2-t2 a-score)
                                                                       (score-2-t3 a-score)
                                                                       (score-t2 a-score)
                                                                       (score-try-try-2 a-score)
                                                                       (score-record a-score)
                                                                       (score-total a-score)
                                                                       (score-2-total a-score)
                                                                       (score-hs a-score)
                                                                       (score-best-try a-score)
                                                                       (score-total-q a-score)
                                                                       (score-arrows-shot a-score)
                                                                       (score-noc a-score)
                                                                       (score-bulls a-score)
                                                                       (score-nom a-score)
                                                                       (score-p1w a-score)
                                                                       (score-p2w a-score))]
              
              [(and (world-2p? a-world)(>(score-t3 a-score)(score-try-try a-score))(or(=(world-try a-world)1)(=(world-try a-world)3)(=(world-try a-world)5))(=(arrow-timer(first a-loa))3))(make-score
                                                                                                                                                                                          (score-t1 a-score)
                                                                       (score-t2 a-score)
                                                                       (score-t3 a-score)
                                                                       (score-2-t1 a-score)
                                                                       (score-2-t2 a-score)
                                                                       (score-2-t3 a-score)
                                                                       (score-t3 a-score)
                                                                       (score-try-try-2 a-score)
                                                                       (score-record a-score)
                                                                       (score-total a-score)
                                                                       (score-2-total a-score)
                                                                       (score-hs a-score)
                                                                       (score-best-try a-score)
                                                                       (score-total-q a-score)
                                                                       (score-arrows-shot a-score)
                                                                       (score-noc a-score)
                                                                       (score-bulls a-score)
                                                                       (score-nom a-score)
                                                                       (score-p1w a-score)
                                                                       (score-p2w a-score))]
              
              [(and (world-2p? a-world)(>(score-2-t1 a-score)(score-try-try-2 a-score))(or(=(world-try a-world)2)(=(world-try a-world)4)(=(world-try a-world)6))(=(arrow-timer(first a-loa))3))(make-score
                                                                                                                                                                                          (score-t1 a-score)
                                                                       (score-t2 a-score)
                                                                       (score-t3 a-score)
                                                                       (score-2-t1 a-score)
                                                                       (score-2-t2 a-score)
                                                                       (score-2-t3 a-score)
                                                                       (score-try-try a-score)
                                                                       (score-2-t1 a-score)
                                                                       (score-record a-score)
                                                                       (score-total a-score)
                                                                       (score-2-total a-score)
                                                                       (score-hs a-score)
                                                                       (score-best-try a-score)
                                                                       (score-total-q a-score)
                                                                       (score-arrows-shot a-score)
                                                                       (score-noc a-score)
                                                                       (score-bulls a-score)
                                                                       (score-nom a-score)
                                                                       (score-p1w a-score)
                                                                       (score-p2w a-score))]
              
              [(and (world-2p? a-world)(>(score-2-t2 a-score)(score-try-try-2 a-score))(or(=(world-try a-world)2)(=(world-try a-world)4)(=(world-try a-world)6))(=(arrow-timer(first a-loa))3))(make-score
                                                                                                                                                                                          (score-t1 a-score)
                                                                       (score-t2 a-score)
                                                                       (score-t3 a-score)
                                                                       (score-2-t1 a-score)
                                                                       (score-2-t2 a-score)
                                                                       (score-2-t3 a-score)
                                                                       (score-try-try a-score)
                                                                       (score-2-t2 a-score)
                                                                       (score-record a-score)
                                                                       (score-total a-score)
                                                                       (score-2-total a-score)
                                                                       (score-hs a-score)
                                                                       (score-best-try a-score)
                                                                       (score-total-q a-score)
                                                                       (score-arrows-shot a-score)
                                                                       (score-noc a-score)
                                                                       (score-bulls a-score)
                                                                       (score-nom a-score)
                                                                       (score-p1w a-score)
                                                                       (score-p2w a-score))]
              
              [(and (world-2p? a-world)(>(score-2-t3 a-score)(score-try-try-2 a-score))(or(=(world-try a-world)2)(=(world-try a-world)4)(=(world-try a-world)6))(=(arrow-timer(first a-loa))3))(make-score
                                                                                                                                                                                          (score-t1 a-score)
                                                                       (score-t2 a-score)
                                                                       (score-t3 a-score)
                                                                       (score-2-t1 a-score)
                                                                       (score-2-t2 a-score)
                                                                       (score-2-t3 a-score)
                                                                       (score-try-try a-score)
                                                                       (score-2-t3 a-score)
                                                                       (score-record a-score)
                                                                       (score-total a-score)
                                                                       (score-2-total a-score)
                                                                       (score-hs a-score)
                                                                       (score-best-try a-score)
                                                                       (score-total-q a-score)
                                                                       (score-arrows-shot a-score)
                                                                       (score-noc a-score)
                                                                       (score-bulls a-score)
                                                                       (score-nom a-score)
                                                                       (score-p1w a-score)
                                                                       (score-p2w a-score))]
              
              [(and(=(arrow-score (first a-loa))600)(=(arrow-timer(first a-loa))25))(make-score
                                                                       (score-t1 a-score)
                                                                       (score-t2 a-score)
                                                                       (score-t3 a-score)
                                                                       (score-2-t1 a-score)
                                                                       (score-2-t2 a-score)
                                                                       (score-2-t3 a-score)
                                                                       (score-try-try a-score)
                                                                       (score-try-try-2 a-score)
                                                                       (score-record a-score)
                                                                       (score-total a-score)
                                                                       (score-2-total a-score)
                                                                       (score-hs a-score)
                                                                       (score-best-try a-score)
                                                                       (score-total-q a-score)
                                                                       (score-arrows-shot a-score)
                                                                       (score-noc a-score)
                                                                       (+(score-bulls a-score)1) 
                                                                       (score-nom a-score)
                                                                       (score-p1w a-score)
                                                                       (score-p2w a-score))]
              [(and(=(arrow-score (first a-loa))0)(=(arrow-timer(first a-loa))25))(make-score
                                                                       (score-t1 a-score)
                                                                       (score-t2 a-score)
                                                                       (score-t3 a-score)
                                                                       (score-2-t1 a-score)
                                                                       (score-2-t2 a-score)
                                                                       (score-2-t3 a-score)
                                                                       (score-try-try a-score)
                                                                       (score-try-try-2 a-score)
                                                                       (score-record a-score)
                                                                       (score-total a-score)
                                                                       (score-2-total a-score)
                                                                       (score-hs a-score)
                                                                       (score-best-try a-score)
                                                                       (score-total-q a-score)
                                                                       (score-arrows-shot a-score)
                                                                       (score-noc a-score)
                                                                       (score-bulls a-score) 
                                                                       (+(score-nom a-score)1)
                                                                       (score-p1w a-score)
                                                                       (score-p2w a-score))] 
       [(and(=(world-try a-world)1)(=(arrow-timer(first a-loa))4))(make-score
                                                                       (+(score-t1 a-score)(arrow-score (first a-loa)))
                                                                       (score-t2 a-score)
                                                                       (score-t3 a-score)
                                                                       (score-2-t1 a-score)
                                                                       (score-2-t2 a-score)
                                                                       (score-2-t3 a-score)
                                                                       (score-try-try a-score)
                                                                       (score-try-try-2 a-score)
                                                                       (score-record a-score)
                                                                       (score-total a-score)
                                                                       (score-2-total a-score)
                                                                       (score-hs a-score)
                                                                       (score-best-try a-score)
                                                                       (score-total-q a-score)
                                                                       (score-arrows-shot a-score)
                                                                       (score-noc a-score)
                                                                       (score-bulls a-score)
                                                                       (score-nom a-score)
                                                                       (score-p1w a-score)
                                                                       (score-p2w a-score))]
       [(and(world-1p? a-world)(=(world-try a-world)2)(=(arrow-timer(first a-loa))4))(make-score
                                                                       (score-t1 a-score)
                                                                       (+(score-t2 a-score)(arrow-score (first a-loa)))
                                                                       (score-t3 a-score)
                                                                       (score-2-t1 a-score)
                                                                       (score-2-t2 a-score)
                                                                       (score-2-t3 a-score)
                                                                       (score-try-try a-score)
                                                                       (score-try-try-2 a-score)
                                                                       (score-record a-score)
                                                                       (+(score-t1 a-score)(score-t2 a-score)(score-t3 a-score))
                                                                       (score-2-total a-score)
                                                                       (score-hs a-score)                       
                                                                       (score-best-try a-score)
                                                                       (score-total-q a-score)
                                                                       (score-arrows-shot a-score)
                                                                       (score-noc a-score)
                                                                       (score-bulls a-score)
                                                                       (score-nom a-score)
                                                                       (score-p1w a-score)
                                                                       (score-p2w a-score))]
       [(and(world-1p? a-world)(=(world-try a-world)3)(=(arrow-timer(first a-loa))4))(make-score
                                                                       (score-t1 a-score) 
                                                                       (score-t2 a-score)
                                                                       (+(score-t3 a-score)(arrow-score (first a-loa)))
                                                                       (score-2-t1 a-score)
                                                                       (score-2-t2 a-score)
                                                                       (score-2-t3 a-score)
                                                                       (score-try-try a-score)
                                                                       (score-try-try-2 a-score)
                                                                       (score-record a-score)
                                                                       (+(score-t1 a-score)(score-t2 a-score)(score-t3 a-score))
                                                                       (score-2-total a-score)
                                                                       (score-hs a-score)
                                                                       (score-best-try a-score)
                                                                       (score-total-q a-score)
                                                                       (score-arrows-shot a-score)
                                                                       (score-noc a-score)
                                                                       (score-bulls a-score)
                                                                       (score-nom a-score)
                                                                       (score-p1w a-score)
                                                                       (score-p2w a-score))]
       [(and(world-2p? a-world)(=(world-try a-world)3)(=(arrow-timer(first a-loa))4))(make-score
                                                                       (score-t1 a-score)
                                                                       (+(score-t2 a-score)(arrow-score (first a-loa)))
                                                                       (score-t3 a-score)
                                                                       (score-2-t1 a-score)
                                                                       (score-2-t2 a-score)
                                                                       (score-2-t3 a-score)
                                                                       (score-try-try a-score)
                                                                       (score-try-try-2 a-score)
                                                                       (score-record a-score)
                                                                       (+(score-t1 a-score)(score-t2 a-score)(score-t3 a-score))
                                                                       (score-2-total a-score)
                                                                       (score-hs a-score)
                                                                       (score-best-try a-score)
                                                                       (score-total-q a-score)
                                                                       (score-arrows-shot a-score)
                                                                       (score-noc a-score)
                                                                       (score-bulls a-score)
                                                                       (score-nom a-score)
                                                                       (score-p1w a-score)
                                                                       (score-p2w a-score))]
       [(and(world-2p? a-world)(=(world-try a-world)5)(=(arrow-timer(first a-loa))4))(make-score
                                                                       (score-t1 a-score) 
                                                                       (score-t2 a-score)
                                                                       (+(score-t3 a-score)(arrow-score (first a-loa)))
                                                                       (score-2-t1 a-score)
                                                                       (score-2-t2 a-score)
                                                                       (score-2-t3 a-score)
                                                                       (score-try-try a-score)
                                                                       (score-try-try-2 a-score)
                                                                       (score-record a-score)
                                                                       (+(score-t1 a-score)(score-t2 a-score)(score-t3 a-score))
                                                                       (score-2-total a-score)
                                                                       (score-hs a-score)
                                                                       (score-best-try a-score)
                                                                       (score-total-q a-score)
                                                                       (score-arrows-shot a-score)
                                                                       (score-noc a-score)
                                                                       (score-bulls a-score)
                                                                       (score-nom a-score)
                                                                       (score-p1w a-score)
                                                                       (score-p2w a-score))]
       
       [(and(world-2p? a-world)(=(world-try a-world)2)(=(arrow-timer(first a-loa))4))(make-score
                                                                       (score-t1 a-score)
                                                                       (score-t2 a-score)
                                                                       (score-t3 a-score)
                                                                       (+(score-2-t1 a-score)(arrow-score (first a-loa)))
                                                                       (score-2-t2 a-score)
                                                                       (score-2-t3 a-score)
                                                                       (score-try-try a-score)
                                                                       (score-try-try-2 a-score)
                                                                       (score-record a-score)
                                                                       (score-total a-score)
                                                                       (score-2-total a-score)
                                                                       (score-hs a-score)
                                                                       (score-best-try a-score)
                                                                       (score-total-q a-score)
                                                                       (score-arrows-shot a-score)
                                                                       (score-noc a-score)
                                                                       (score-bulls a-score)
                                                                       (score-nom a-score)
                                                                       (score-p1w a-score)
                                                                       (score-p2w a-score))]
       [(and(world-2p? a-world)(=(world-try a-world)4)(=(arrow-timer(first a-loa))4))(make-score
                                                                       (score-t1 a-score)
                                                                       (score-t2 a-score)
                                                                       (score-t3 a-score)
                                                                       (score-2-t1 a-score)
                                                                       (+(score-2-t2 a-score)(arrow-score (first a-loa)))
                                                                       (score-2-t3 a-score)
                                                                       (score-try-try a-score)
                                                                       (score-try-try-2 a-score)
                                                                       (score-record a-score)
                                                                       (+(score-t1 a-score)(score-t2 a-score)(score-t3 a-score))
                                                                       (score-2-total a-score)
                                                                       (score-hs a-score)
                                                                       (score-best-try a-score)
                                                                       (score-total-q a-score)
                                                                       (score-arrows-shot a-score)
                                                                       (score-noc a-score)
                                                                       (score-bulls a-score)
                                                                       (score-nom a-score)
                                                                       (score-p1w a-score)
                                                                       (score-p2w a-score))]
       [(and(world-2p? a-world)(=(world-try a-world)6)(=(arrow-timer(first a-loa))4))(make-score
                                                                       (score-t1 a-score) 
                                                                       (score-t2 a-score)
                                                                       (score-t3 a-score)
                                                                       (score-2-t1 a-score)
                                                                       (score-2-t2 a-score)
                                                                       (+(score-2-t3 a-score)(arrow-score (first a-loa)))
                                                                       (score-try-try a-score)
                                                                       (score-try-try-2 a-score)
                                                                       (score-record a-score)
                                                                       (+(score-t1 a-score)(score-t2 a-score)(score-t3 a-score))
                                                                       (score-2-total a-score)
                                                                       (score-hs a-score)
                                                                       (score-best-try a-score)
                                                                       (score-total-q a-score)
                                                                       (score-arrows-shot a-score) 
                                                                       (score-noc a-score)
                                                                       (score-bulls a-score)
                                                                       (score-nom a-score)
                                                                       (score-p1w a-score)
                                                                       (score-p2w a-score))] 
       
       [else(update-score-list a-score (rest a-loa) a-world)])]
    [else (cons (update-score a-score (first a-loa) a-world)(update-score-list a-score (rest a-loa) a-world))]
    )) 

;update-arrow: arrow target world -> arrow
;consumes an arrow, a target, and a world and updates the arrow accordingly
(define (update-arrow a-arrow a-target a-world)  
  (make-arrow
   (cond
     [(>(arrow-x a-arrow)920)(arrow-x a-arrow)] 
     [else(+(arrow-x a-arrow)(arrow-x-v a-arrow))])       
   (cond
     [(>(arrow-x a-arrow)300)(+(arrow-y a-arrow)(* -1 (*(world-wind a-world).2)))]
     [else (arrow-y a-arrow)]) 
   (arrow-x-v a-arrow) 
   (arrow-y-v a-arrow)
   (cond
     [(=(arrow-angle a-arrow)4.9)5]
          [(>(arrow-angle a-arrow)10)10.00]  
     [(eq?(world-increase? a-world)false)(arrow-angle a-arrow)] 
     [(and (not(>=(arrow-angle a-arrow)10))(world-increase? a-world))(+(arrow-angle a-arrow).49)] 
     [else(arrow-angle a-arrow)])  
   (cond
     [(eq? (arrow-timer a-arrow)0)0]
     [else(-(arrow-timer a-arrow)1)]) 
   (cond
     [(eq?(arrow-bounce-timer a-arrow)10)0]
     [else (+(arrow-bounce-timer a-arrow)1)])
   (arrow-score a-arrow)
   (arrow-increase? a-arrow)
   ))  

;update-loa: loa target world -> loa
;consumes a loa, a target, and a world and updates the loa accorgingly+
(define (update-loa a-loa a-target a-world) 
  (cond
    [(empty? a-loa)a-loa]
    [(eq?(arrow-timer(first a-loa))1)(rest a-loa)]
    [(>(arrow-x (first a-loa))920)(cons(make-arrow
   (arrow-x (first a-loa))  
   (arrow-y (first a-loa)) 
   (arrow-x-v (first a-loa))
   (arrow-y-v (first a-loa))
   (arrow-angle (first a-loa))
   (cond
     [(eq? (arrow-timer (first a-loa))0)0]
     [else(-(arrow-timer (first a-loa))1)])
   (cond
     [(eq?(arrow-bounce-timer (first a-loa))10)0]
     [else (+(arrow-bounce-timer (first a-loa))1)])
   0
   (arrow-increase? (first a-loa))
   )(rest a-loa))]
    [(and(eq?(target-dir a-target)'down)(collision? (first a-loa) a-target))(cons (make-arrow
   (arrow-x (first a-loa))
   (+(arrow-y (first a-loa))4) 
   (arrow-x-v (first a-loa))
   (arrow-y-v (first a-loa))
   (arrow-angle (first a-loa))
   (cond
     [(eq? (arrow-timer (first a-loa))0)0]
     [else(-(arrow-timer (first a-loa))1)])
   (cond
     [(eq?(arrow-bounce-timer (first a-loa))10)0]
     [else (+(arrow-bounce-timer (first a-loa))1)]) 
   (cond
            [(<(sqrt(+(expt(- (target-tx a-target)(- (target-tx a-target)(-(target-y a-target)(arrow-y (first a-loa)))))2)(expt(- (target-ty a-target) (-(+(target-ty a-target)52.5)(* 10.5 (arrow-angle (first a-loa)))))2)))5)600]
            [(<(sqrt(+(expt(- (target-tx a-target)(- (target-tx a-target)(-(target-y a-target)(arrow-y (first a-loa)))))2)(expt(- (target-ty a-target) (-(+(target-ty a-target)52.5)(* 10.5 (arrow-angle (first a-loa)))))2)))10)400]
            [(<(sqrt(+(expt(- (target-tx a-target)(- (target-tx a-target)(-(target-y a-target)(arrow-y (first a-loa)))))2)(expt(- (target-ty a-target) (-(+(target-ty a-target)52.5)(* 10.5 (arrow-angle (first a-loa)))))2)))20)300]
            [(<(sqrt(+(expt(- (target-tx a-target)(- (target-tx a-target)(-(target-y a-target)(arrow-y (first a-loa)))))2)(expt(- (target-ty a-target) (-(+(target-ty a-target)52.5)(* 10.5 (arrow-angle (first a-loa)))))2)))32.5)200]
            [(<(sqrt(+(expt(- (target-tx a-target)(- (target-tx a-target)(-(target-y a-target)(arrow-y (first a-loa)))))2)(expt(- (target-ty a-target) (-(+(target-ty a-target)52.5)(* 10.5(arrow-angle (first a-loa)))))2)))45)100]
            [(and(> (-(+(target-ty a-target)52.5)(* 10.5 (arrow-angle (first a-loa))))(-(target-ty a-target)52.6))(< (-(+(target-ty a-target)52.5)(* 10.5 (arrow-angle (first a-loa))))(+(target-ty a-target)52.6))(>(sqrt(+(expt(- (target-tx a-target)(- (target-tx a-target)(-(target-y a-target)(arrow-y (first a-loa)))))2)(expt(- (+(target-ty a-target)52.5) (-(target-ty a-target)(* 10.5 (arrow-angle (first a-loa)))))2)))45))50]  
            [else 0]) 
   (arrow-increase? (first a-loa)))(rest a-loa))]
    [(and(eq?(target-dir a-target)'up)(collision? (first a-loa) a-target))(cons (make-arrow
   (arrow-x (first a-loa))
   (-(arrow-y (first a-loa))4) 
   (arrow-x-v (first a-loa))
   (arrow-y-v (first a-loa))
   (arrow-angle (first a-loa))
   (cond
     [(eq? (arrow-timer (first a-loa))0)0]
     [else(-(arrow-timer (first a-loa))1)]) 
   (cond
     [(eq?(arrow-bounce-timer (first a-loa))10)0]
     [else (+(arrow-bounce-timer (first a-loa))1)])
   (cond
            [(<(sqrt(+(expt(- (target-tx a-target)(- (target-tx a-target)(-(target-y a-target)(arrow-y (first a-loa)))))2)(expt(- (target-ty a-target) (-(+(target-ty a-target)52.5)(* 10.5 (arrow-angle (first a-loa)))))2)))5)600]
            [(<(sqrt(+(expt(- (target-tx a-target)(- (target-tx a-target)(-(target-y a-target)(arrow-y (first a-loa)))))2)(expt(- (target-ty a-target) (-(+(target-ty a-target)52.5)(* 10.5 (arrow-angle (first a-loa)))))2)))10)400]
            [(<(sqrt(+(expt(- (target-tx a-target)(- (target-tx a-target)(-(target-y a-target)(arrow-y (first a-loa)))))2)(expt(- (target-ty a-target) (-(+(target-ty a-target)52.5)(* 10.5 (arrow-angle (first a-loa)))))2)))20)300]
            [(<(sqrt(+(expt(- (target-tx a-target)(- (target-tx a-target)(-(target-y a-target)(arrow-y (first a-loa)))))2)(expt(- (target-ty a-target) (-(+(target-ty a-target)52.5)(* 10.5 (arrow-angle (first a-loa)))))2)))32.5)200]
            [(<(sqrt(+(expt(- (target-tx a-target)(- (target-tx a-target)(-(target-y a-target)(arrow-y (first a-loa)))))2)(expt(- (target-ty a-target) (-(+(target-ty a-target)52.5)(* 10.5(arrow-angle (first a-loa)))))2)))45)100]
            [(and(> (-(+(target-ty a-target)52.5)(* 10.5 (arrow-angle (first a-loa))))(-(target-ty a-target)52.6))(< (-(+(target-ty a-target)52.5)(* 10.5 (arrow-angle (first a-loa))))(+(target-ty a-target)52.6))(>(sqrt(+(expt(- (target-tx a-target)(- (target-tx a-target)(-(target-y a-target)(arrow-y (first a-loa)))))2)(expt(- (+(target-ty a-target)52.5) (-(target-ty a-target)(* 10.5 (arrow-angle (first a-loa)))))2)))45))50]  
            [else 0]) 
   (arrow-increase? (first a-loa)))(rest a-loa))]  
    [(cons? a-loa)
     (cons (update-arrow (first a-loa) a-target a-world)(update-loa (rest a-loa) a-target a-world))])) 

;update-blinks: blinks -> blinks
;consumes a blinks and updates it accordingly
(define (update-blinks a-blinks)
  (make-blinks
   (cond
     [(eq? (blinks-timer a-blinks) 16)0]
     [else (+(blinks-timer a-blinks)1)]) 
   (cond
     [(<(blinks-timer a-blinks)8)true]
     [else false])))

;update-archer: archer -> archer
;consumes an archer and updates it accordingly
(define (update-archer a-archer)
  (make-archer
   (archer-x a-archer)
   (archer-y a-archer) 
   (cond
     [(eq? (archer-timer a-archer)0)0]
     [else(-(archer-timer a-archer)1)]))) 

;process-mouse: world number number mouse-event -> world
;consumes a world, a number, a number, and a mouse-event and updates the world accordingly
(define (process-mouse a-world x y mouse-event)
  (cond
    [(game-over? a-world)(make-world 
   (world-archer a-world)
   (world-loa a-world) 
   (world-target a-world) 
   (cond
     [(and (mouse=? mouse-event "button-down")(or (and (< x 555)(> x 345)(< y 310)(> y 240))(and (< x 555)(> x 345)(< y 410)(> y 340))))
      (make-score
                                                                                                           0
   0
   0
   0
   0
   0
   0
   0
   (score-record (world-score a-world))
   0
   0
   (score-hs (world-score a-world))
   (score-best-try (world-score a-world)) 
   (score-total-q (world-score a-world)) 
   (score-arrows-shot (world-score a-world))
   (score-noc (world-score a-world))
   (score-bulls (world-score a-world))
   (score-nom (world-score a-world)) 
   (score-p1w (world-score a-world))
   (score-p2w (world-score a-world)))]
     [else (world-score a-world)])
   (cond
     [(and (mouse=? mouse-event "button-down")(or (and (< x 555)(> x 345)(< y 310)(> y 240))(and (< x 555)(> x 345)(< y 410)(> y 340))))9]
     [else(world-count a-world)])
   (cond
     [(and (mouse=? mouse-event "button-down")(or (and (< x 555)(> x 345)(< y 310)(> y 240))(and (< x 555)(> x 345)(< y 410)(> y 340))))1]
     [else(world-try a-world)]) 
   (world-turn a-world)
   (world-atimer a-world)
   (world-blinks a-world)
   (world-wind a-world)
   (cond
     [(and (mouse=? mouse-event "button-down")(or (and (< x 555)(> x 345)(< y 310)(> y 240))(and (< x 555)(> x 345)(< y 410)(> y 340))))false]
     [else(world-stopped? a-world)])
   (world-r-t a-world)
   (world-increase? a-world)
   (world-cc a-world)
   (world-how-to a-world)
   (world-tg a-world)
   (cond
     [(and (mouse=? mouse-event "button-down")(and (< x 555)(> x 345)(< y 410)(> y 340)))true]
     [else(world-hub? a-world)])
   (world-stats? a-world)
   (world-credits? a-world)
   (world-how-to? a-world)
   (world-how-too? a-world)
   (cond
     [(and (mouse=? mouse-event "button-down")(and (< x 555)(> x 345)(< y 410)(> y 340)))false]
     [else(world-1p? a-world)])
(cond
     [(and (mouse=? mouse-event "button-down")(and (< x 555)(> x 345)(< y 410)(> y 340)))false]
     [else(world-2p? a-world)])
   (cond
     [(and (mouse=? mouse-event "button-down")(and (< x 555)(> x 345)(< y 310)(> y 240)))true]
     [(and (mouse=? mouse-event "button-down")(and (< x 555)(> x 345)(< y 410)(> y 340)))false]
     [else(world-start? a-world)])
   (world-pause? a-world) 
   (world-sure? a-world)
   (world-slider-x a-world)
   (cond
     [(and (mouse=? mouse-event "button-down")(or (and (< x 555)(> x 345)(< y 310)(> y 240))(and (< x 555)(> x 345)(< y 410)(> y 340))))2]
     [else(world-gcount a-world)])
   )]
    [(not(world-pause? a-world))
     (make-world 
   (process-mouse-archer(world-archer a-world) a-world x y mouse-event)
   (cond
     [(and(world-stopped? a-world)(mouse=? mouse-event "button-down")(eq?(world-count a-world)0))(world-loa a-world)]
     [(and(world-stopped? a-world)(mouse=? mouse-event "button-down")(not(eq?(world-atimer a-world)0)))(world-loa a-world)]
     [(and (world-start? a-world)(mouse=? mouse-event "button-down")(and (< x 897.5)(> x 857.5)(> y 2.5)(< y 42.5)))(world-loa a-world)]
     [(and(mouse=? mouse-event "button-down")(world-start? a-world)(world-stopped? a-world))(cons ARROW1  (world-loa a-world))]  
     [else (world-loa a-world)]) 
   (world-target a-world)  
   (process-mouse-score(world-score a-world)a-world x y mouse-event)
   (cond
     [(and(world-stopped? a-world)(mouse=? mouse-event "button-down")(=(world-count a-world)0))(world-count a-world)]
     [(and(world-stopped? a-world)(mouse=? mouse-event "button-down")(not(eq? (world-atimer a-world)0)))(world-count a-world)]
     [(and (world-start? a-world)(mouse=? mouse-event "button-down")(and (< x 897.5)(> x 857.5)(> y 2.5)(< y 42.5)))(world-count a-world)]
     [(and(world-stopped? a-world)(world-start? a-world)(mouse=? mouse-event "button-down"))(-(world-count a-world)1)]  
     [else(world-count a-world)])
   (world-try a-world)  
   (world-turn a-world)
   (cond
     [(and (world-start? a-world)(mouse=? mouse-event "button-down")(and (< x 897.5)(> x 857.5)(> y 2.5)(< y 42.5)))(world-atimer a-world)]
     [(and (world-stopped? a-world)(world-start? a-world)(mouse=? mouse-event "button-down")(eq? (world-atimer a-world)0))75]
     [(and (world-stopped? a-world)(mouse=? mouse-event "button-down")(not(eq? (world-atimer a-world)0)))(world-atimer a-world)]
     [else(world-atimer a-world)])  
   (world-blinks a-world)
   (world-wind a-world)
   (cond
     [(and (world-start? a-world)(mouse=? mouse-event "button-down")(and (< x 897.5)(> x 857.5)(> y 2.5)(< y 42.5)))(world-stopped? a-world)]
     [(and(world-start? a-world)(mouse=? mouse-event "button-down"))true]  
     [else(world-stopped? a-world)])
   (random 2)
   (cond
     [(and (eq? (world-cc a-world)0)(not (world-hub? a-world))(mouse=? mouse-event "button-down"))true]
     [(and(world-start? a-world)(mouse=? mouse-event "button-up"))false]
     [else (world-increase? a-world)]) 
   (cond
     [(and(mouse=? mouse-event "button-down")(world-start? a-world)(eq?(world-atimer a-world)0))1]
     [(and(mouse=? mouse-event "button-down")(not(eq?(world-atimer a-world)0)))(world-cc a-world)] 
     [else(world-cc a-world)])
   (cond
     [(and (mouse=? mouse-event "button-down")(world-how-to? a-world)(and(< x 40)(> x 5)(> y 5)(< y 40)))1]
     [(and (world-how-too? a-world)(mouse=? mouse-event "button-down")(not(world-hub? a-world))(and (< x 135)(> x 5)(< y 65)(> y 5)))1]
     [(and (or (world-how-to? a-world)(world-how-too? a-world))(mouse=? mouse-event "button-down")(not(=(world-how-to a-world)7))(<(sqrt(+(expt(- x 650)2)(expt(- y 300)2)))15))(+(world-how-to a-world)1)]
     [(and (or (world-how-to? a-world)(world-how-too? a-world))(mouse=? mouse-event "button-down")(not(=(world-how-to a-world)1))(<(sqrt(+(expt(- x 250)2)(expt(- y 300)2)))15))(-(world-how-to a-world)1)]
     [else (world-how-to a-world)])
   (world-tg a-world)
   (cond
     [(and (or (and (> x 345)(< x 555)(> y 165)(< y 235))(and (> x 345)(< x 555)(> y 250)(< y 320))(and (> x 345)(< x 555)(> y 335)(< y 405))(and (> x 345)(< x 555)(> y 420)(< y 490))(and (> x 345)(< x 555)(> y 505)(< y 575))) (mouse=? mouse-event "button-down"))false]
     [(and (mouse=? mouse-event "button-down")(not(world-hub? a-world))(or (world-how-too? a-world)(world-stats? a-world)(world-credits? a-world))(and (< x 135)(> x 5)(< y 65)(> y 5)))true]
     [else(world-hub? a-world)])

   (cond
     [(and (world-hub? a-world)(mouse=? mouse-event "button-down")(and (> x 345)(< x 555)(> y 420)(< y 490)))true]
     [(and (world-stats? a-world)(mouse=? mouse-event "button-down")(not(world-hub? a-world))(and (< x 135)(> x 5)(< y 65)(> y 5)))false]
     [else(world-stats? a-world)])
   (cond
     [(and (world-hub? a-world)(mouse=? mouse-event "button-down")(and (> x 345)(< x 555)(> y 505)(< y 575)))true]
     [(and (world-credits? a-world)(mouse=? mouse-event "button-down")(not(world-hub? a-world))(and (< x 135)(> x 5)(< y 65)(> y 5)))false]
     [else(world-credits? a-world)])
   (cond
     [(and (mouse=? mouse-event "button-down")(world-how-to? a-world)(and(< x 40)(> x 5)(> y 5)(< y 40)))false]
     [(and(world-hub? a-world)(mouse=? mouse-event "button-down")(or (and (> x 345)(< x 555)(> y 165)(< y 235))(and (> x 345)(< x 555)(> y 250)(< y 320))))true] 
     [else(world-how-to? a-world)]) 
   (cond
     [(and(world-hub? a-world)(mouse=? mouse-event "button-down")(and (> x 345)(< x 555)(> y 335)(< y 405)))true]
     [(and (world-how-too? a-world)(mouse=? mouse-event "button-down")(not(world-hub? a-world))(and (< x 135)(> x 5)(< y 65)(> y 5)))false]
     [else(world-how-too? a-world)])  
   (cond
     [(and (world-hub? a-world)(mouse=? mouse-event "button-down")(and (> x 345)(< x 555)(> y 165)(< y 235)))true]
     [else(world-1p? a-world)])
   (cond
     [(and (world-hub? a-world)(mouse=? mouse-event "button-down")(and (> x 345)(< x 555)(> y 250)(< y 320)))true]
     [else(world-2p? a-world)])
   (cond
     [(and (world-start? a-world)(mouse=? mouse-event "button-down")(and (< x 897.5)(> x 857.5)(> y 2.5)(< y 42.5)))false]
     [(and (mouse=? mouse-event "button-down")(world-how-to? a-world)(and(< x 40)(> x 5)(> y 5)(< y 40)))true]
     [else(world-start? a-world)])
   (cond
     [(and (world-start? a-world)(mouse=? mouse-event "button-down")(and (< x 897.5)(> x 857.5)(> y 2.5)(< y 42.5)))true]
     [else(world-pause? a-world)])
   (world-sure? a-world)
   (cond
     [(and(or(mouse=? mouse-event "button-down")(mouse=? mouse-event "drag"))(and (< x 420)(> x 316)(< y 545)(> y 525)))x] 
     [else(world-slider-x a-world)])
   (world-gcount a-world)

   )]
    [(world-pause? a-world)(make-world  
   (world-archer a-world)
   (cond
     [(and (mouse=? mouse-event "button-down")(world-sure? a-world)(and (< x 555)(> x 345)(< y 275)(> y 205)))empty] 
     [else(world-loa a-world)]) 
   (cond
     [(and (mouse=? mouse-event "button-down")(world-sure? a-world)(and (< x 555)(> x 345)(< y 275)(> y 205)))TARGET1] 
     [else(world-target a-world)])    
   (cond
     [(and (mouse=? mouse-event "button-down")(world-sure? a-world)(and (< x 555)(> x 345)(< y 275)(> y 205)))(make-score
                                                                                                           0
   0
   0
   0
   0
   0
   0
   0
   (score-record (world-score a-world))
   0
   0
   (score-hs (world-score a-world))
   (score-best-try (world-score a-world)) 
   (score-total-q (world-score a-world)) 
   (score-arrows-shot (world-score a-world))
   (score-noc (world-score a-world))
   (score-bulls (world-score a-world))
   (score-nom (world-score a-world)) 
   (score-p1w (world-score a-world))
   (score-p2w (world-score a-world)))] 
     [else(process-mouse-score(world-score a-world)a-world x y mouse-event)])
   (cond
     [(and (mouse=? mouse-event "button-down")(world-sure? a-world)(and (< x 555)(> x 345)(< y 275)(> y 205)))9] 
     [else(world-count a-world)])
   (cond
     [(and (mouse=? mouse-event "button-down")(world-sure? a-world)(and (< x 555)(> x 345)(< y 275)(> y 205)))1] 
     [else(world-try a-world)])  
   (world-turn a-world)
   (world-atimer a-world)
   (world-blinks a-world)
   (world-wind a-world)
   (cond
     [(and (mouse=? mouse-event "button-down")(world-sure? a-world)(and (< x 555)(> x 345)(< y 275)(> y 205)))false] 
     [else(world-stopped? a-world)])
   (world-r-t a-world)
   (world-increase? a-world) 
   (world-cc a-world) 
   (cond
     [(and (world-how-too? a-world)(mouse=? mouse-event "button-down")(not(world-hub? a-world))(and (< x 135)(> x 5)(< y 65)(> y 5)))1]
     [(and (or (world-how-to? a-world)(world-how-too? a-world))(mouse=? mouse-event "button-down")(not(=(world-how-to a-world)7))(<(sqrt(+(expt(- x 650)2)(expt(- y 300)2)))15))(+(world-how-to a-world)1)]
     [(and (or (world-how-to? a-world)(world-how-too? a-world))(mouse=? mouse-event "button-down")(not(=(world-how-to a-world)1))(<(sqrt(+(expt(- x 250)2)(expt(- y 300)2)))15))(-(world-how-to a-world)1)]
     [else (world-how-to a-world)])
   (world-tg a-world)
   (cond
     [(and (mouse=? mouse-event "button-down")(world-sure? a-world)(and (< x 555)(> x 345)(< y 275)(> y 205)))true]
     [else(world-hub? a-world)])
   (cond
     [(and (not(world-sure? a-world))(mouse=? mouse-event "button-down")(and (< x 555)(> x 345)(< y 375)(> y 305)))true]
     [(and (not(world-sure? a-world))(world-stats? a-world)(mouse=? mouse-event "button-down")(not(world-hub? a-world))(and (< x 135)(> x 5)(< y 65)(> y 5)))false] 
     [else(world-stats? a-world)])
   (world-credits? a-world)
   (world-how-to? a-world)
   (cond
     [(and (not(world-sure? a-world))(mouse=? mouse-event "button-down")(and(< x 555)(> x 345) (< y 295) (> y 225)))true]
     [(and (not(world-sure? a-world))(world-how-too? a-world)(mouse=? mouse-event "button-down")(not(world-hub? a-world))(and (< x 135)(> x 5)(< y 65)(> y 5)))false]  
     [else(world-how-too? a-world)])
   (cond
     [(and (mouse=? mouse-event "button-down")(world-sure? a-world)(and (< x 555)(> x 345)(< y 275)(> y 205)))false] 
     [else(world-1p? a-world)])
   (cond
     [(and (mouse=? mouse-event "button-down")(world-sure? a-world)(and (< x 555)(> x 345)(< y 275)(> y 205)))false] 
     [else(world-2p? a-world)]) 
   (cond
     [(and (mouse=? mouse-event "button-down")(world-sure? a-world)(and (< x 555)(> x 345)(< y 275)(> y 205)))false]
     [(and (mouse=? mouse-event "button-down")(and(< x 555)(> x 345) (< y 215) (> y 145)))true] 
     [else(world-start? a-world)])
   (cond
     [(and (mouse=? mouse-event "button-down")(and(< x 555)(> x 345) (< y 215) (> y 145)))false]
     [(and (mouse=? mouse-event "button-down")(world-sure? a-world)(and (< x 555)(> x 345)(< y 275)(> y 205)))false]
     [else(world-pause? a-world)])
   (cond
     [(and (mouse=? mouse-event "button-down")(world-sure? a-world)(and (< x 555)(> x 345)(< y 395)(> y 325)))false] 
     [(and (mouse=? mouse-event "button-down")(world-sure? a-world)(and (< x 555)(> x 345)(< y 275)(> y 205)))false] 
     [(and (mouse=? mouse-event "button-down")(and (< x 555)(> x 345)(> y 385)(< y 455)))true]
     [else(world-sure? a-world)])
   (cond
     [(and(or(mouse=? mouse-event "button-down")(mouse=? mouse-event "drag"))(and (< x 420)(> x 316)(< y 545)(> y 525)))x] 
     [else(world-slider-x a-world)])
   (world-gcount a-world)
   )]
    [else a-world]))  

;process-mouse-archer: archer world number number mouse-event -> archer
;consumes an archer, a world, a number, a number. and a mouse-event and updates the archer accordingly
(define (process-mouse-archer a-archer a-world x y mouse-event)
  (make-archer
   (archer-x a-archer)
   (archer-y a-archer) 
   (cond
     [(and(world-stopped? a-world)(eq? mouse-event "button-down")(not(eq?(archer-timer a-archer)0)))(archer-timer a-archer)]
     [(and(world-stopped? a-world)(eq? mouse-event "button-down"))75]     
     [else(archer-timer a-archer)])))

;process-mouse-score: score world number number mouse-event -> score
;consumes a score, a world, a number, a number, and a mouse-event and updates the score accordingly
(define  (process-mouse-score a-score a-world x y mouse-event)
  (make-score
   (score-t1 a-score) 
   (score-t2 a-score)
   (score-t3 a-score)
   (score-2-t1 a-score)
   (score-2-t2 a-score)
   (score-2-t3 a-score)
   (score-try-try a-score)
   (score-try-try-2 a-score)
   (score-record a-score)
   (score-total a-score)
   (score-2-total a-score)
   (score-hs a-score)
   (score-best-try a-score) 
   (score-total-q a-score)
   (cond
     [(and (world-start? a-world)(world-stopped? a-world)(eq? mouse-event "button-down")(and (< x 897.5)(> x 857.5)(> y 2.5)(< y 42.5)))(score-arrows-shot a-score)]
     [(and (eq? mouse-event "button-down")(=(world-atimer a-world)0)(world-stopped? a-world)(world-start? a-world)(or(and(world-1p? a-world)(not(=(world-try a-world)4)))(and (world-2p? a-world)(not(=(world-try a-world)7)))))(+(score-arrows-shot a-score)1)]
     [else(score-arrows-shot a-score)])
   (cond
     [(eq? mouse-event "button-down")(+(score-noc a-score)1)]
     [else (score-noc a-score)])
   (score-bulls a-score)
   (score-nom a-score)
   (score-p1w a-score)
   (score-p2w a-score)
)) 

;collision?: arrow target -> boolean
;consumes an arrow and a target and determines if they have collided
(define (collision? a-arrow a-target)  
  (or
   (and(<(abs(-(arrow-x a-arrow)(target-x5 a-target)))(+ (/(image-width ARROW)4)(/(image-width (rectangle 5 105 "solid""yellow"))2)))
      (<(abs(-(arrow-y a-arrow)(target-y a-target)))(+ (/(image-height ARROW)8)(/(image-height(rectangle 5 105 "solid""yellow"))2))))
   (and(<(abs(-(arrow-x a-arrow)(target-x4 a-target)))(+ (/(image-width ARROW)4)(/(image-width (rectangle 5 90 "solid""yellow"))2)))
      (<(abs(-(arrow-y a-arrow)(target-y a-target)))(+ (/(image-height ARROW)8)(/(image-height(rectangle 5 90 "solid""yellow"))2))))
   (and(<(abs(-(arrow-x a-arrow)(target-x3 a-target)))(+ (/(image-width ARROW)4)(/(image-width (rectangle 5 65 "solid""yellow"))2)))
      (<(abs(-(arrow-y a-arrow)(target-y a-target)))(+ (/(image-height ARROW)8)(/(image-height(rectangle 5 65 "solid""yellow"))2))))
   (and(<(abs(-(arrow-x a-arrow)(target-x2 a-target)))(+ (/(image-width ARROW)4)(/(image-width (rectangle 5 40 "solid""yellow"))2)))
      (<(abs(-(arrow-y a-arrow)(target-y a-target)))(+ (/(image-height ARROW)8)(/(image-height(rectangle 5 40 "solid""yellow"))2))))
   (and(<(abs(-(arrow-x a-arrow)(target-x1 a-target)))(+ (/(image-width ARROW)4)(/(image-width (rectangle 5 20 "solid""yellow"))2))) 
      (<(abs(-(arrow-y a-arrow)(target-y a-target)))(+ (/(image-height ARROW)8)(/(image-height(rectangle 5 20 "solid""yellow"))2))))
   )) 

;game-over?: world -> boolean
;consumes a world and determines if a game over has occured
(define (game-over? a-world)
  (or(and (world-1p? a-world)(=(world-try a-world)4))(and(world-2p? a-world)(=(world-try a-world)7))))
     
  (big-bang IW
          (to-draw draw-world)
          (on-tick update-world (/ 1.0 28))  
          (on-mouse process-mouse))
