#lang racket/gui
(require "world-init.rkt")
(require "basic-procedures.rkt")
(require "player-commands.rkt")
(require "physics-engine.rkt")
(require "flying-unit-rectangular.rkt")
(require "input-canvas.rkt")
(require "graphics-engine-Copy.rkt")
(require "collisions.rkt")




(define ($Main_Menu_Looping)
  ($Key_Board_Full_Movement)
  (when (send *world* $Game_Started?)
    (send *game_updater* start 16 #f)
    (send *main_menu_updater* stop)))

    

;_____________________________________________________________
;Main loop
(define ($Gameplay_Looping)
  (begin
    ($Key_Board_Full_Movement)
    ($Collisions)
    ($Game_Loop_Shooting)
    ($Force_Respawn)
    ($Entity_Spawner)
    (send *flying_units* refresh-now)
    (when (send *world* $Someone_Just_Died?)
             ($Victory_Finder)
             (send *world* $Set_Someone_Just_Died #f))))


;_____________________________________________________________


;_____________________________________________________________
;Makes sure the loop can be altered by other

(define ($Gameplay_Looping_Check)
  (when (not (send *world* $Game_Paused?)) ($Gameplay_Looping)))


;_____________________________________________________________

;_____________________________________________________________
;Jäveln som startar tidsuppateringar
;(send *game_updater* start 16 #f)
(define *game_updater*
  (new timer%
       [notify-callback $Gameplay_Looping_Check]))
    

(define *main_menu_updater*
  (new timer%
       [notify-callback $Main_Menu_Looping]))


(send *main_menu_updater* start 16 #f)


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
(define ($Victory_Finder)
  (let (
        [victory-condition ($Victory_Condition)])
    
    (cond
      ;If you should keep playing, nothing happens.
      [(equal? victory-condition 'keep-playing) (void)]

      ;If it's a tie, the game is stopped and the tie
      ;bitmap is drawn.
      [(equal? victory-condition 'tie)
       (send *game_updater* stop)
       (send *world* $Set_Game_Over #t)
       (send (send *flying_units* get-dc) draw-bitmap
             *tie_bitmap*
             0
             0)]

      ;Otherwise, a player has won, so the game is stopped
      ;and their victory bitmap is drawn.
      [else
       (send *game_updater* stop)
       (send *world* $Set_Game_Over #t)
       (send (send *flying_units* get-dc) draw-bitmap
             (send victory-condition $Get_Victory_Bitmap)
             0
             0)])))