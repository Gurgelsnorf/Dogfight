#lang racket/gui
(require "world-init.rkt")
(require "basic-procedures.rkt")
(require "player-commands.rkt")
(require "physics-engine.rkt")
(require "flying-unit-rectangular.rkt")
(require "input-canvas.rkt")
(require "graphics-engine-Copy.rkt")
(require "collisions.rkt")

;_____________________________________________________________
;Main loop
(define ($Gameplay_Looping)
  (begin
    ($Key_Board_Full_Movement)
    ($Collisions)
    ($Game_Loop_Shooting)
    (send *flying_units* refresh-now)))


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
(send *clock_timer* start 16 #f)



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


;Procedure that takes action depending on the win condition. 
(define ($Victory)
  (let (
        [victory-condition ($Victory_Condition)])
    
    (cond
      ;If you should keep playing, nothing happens.
      [(equal? victory-condition 'keep-playing) (void)]

      ;If it's a tie, the game is stopped and the tie
      ;bitmap is drawn.
      [(equal? victory-condition 'tie)
       (send *start_clock* $Set_Clock_Run #f)
       (send (send *flying_units* get-dc) draw-bitmap
             *tie_bitmap*
             0
             0)]

      ;Otherwise, a player has won, so the game is stopped
      ;and their victory bitmap is drawn.
      [else (send (send *flying_units* get-dc) draw-bitmap
                  (send victory-condition $Get_Victory_Bitmap)
                  0
                  0)])))
  
  
  