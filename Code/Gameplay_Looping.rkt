#lang racket/gui
(require "world-init.rkt")
(require "basic-procedures.rkt")
(require "player-commands.rkt")
(require "physics-engine.rkt")
(require "flying-unit-rectangular.rkt")
(require "input-canvas.rkt")
(require "graphics-engine-key-test.rkt")
(provide *flying_units*)


;_____________________________________________________________
;Main loop
(define ($Gameplay_Looping)
  (printf "lel ~n"))


;_____________________________________________________________
;Possible first render?


;_____________________________________________________________
;Makes sure the loop can be altered by other

(define ($Gameplay_Looping_Check)
  (if (send *start_clock* $Get_Clock_Run?) ($Gameplay_Looping) (send *start_clock* $Set_Clock_Run #f)))


;_____________________________________________________________
;Clock timer

(define *clock_timer*
  (new timer%
       [notify-callback $Gameplay_Looping_Check]))
;_____________________________________________________________
;Jäveln som startar tidsuppateringar
(send *clock_timer* start 1000 #f)



;________Structure____________________________________________
;Run physics movement
;-
;Check collitions
;-
;if
;Collition - draw crash
;else - uppdate graphics
;-
;timer for next uppdate
;_____________________________________________________________


    