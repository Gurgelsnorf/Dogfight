#lang racket/gui
(require "world-init.rkt")
(require "vector-procedures.rkt")
(require "commands.rkt")
(require "graphics-engine.rkt")
(require "collisions.rkt")

;NOTE: This is the file you should run if you want to play the game!



;In this file, the looping of the game is done.

;There are three main things in the file:

;Main menu loop
;Main game loop
;Victory control




;_________________________________________________

;A loop procedure for the main menu
(define ($Main_Menu_Looping)

  ;Keyboard input is checked.
  ($KeyBoard_Full_Movement)

  ;If the game is started, the menu loop stops
  ;and the game loop starts.
  (when (send *world* $Game_Started?)
    (send *game_updater* start 16 #f)
    (send *main_menu_updater* stop)))


;The timer that loops the main menu.
(define *main_menu_updater*
  (new timer%
       [notify-callback $Main_Menu_Looping]))

;The main menu is opened when the file is run.
(send *main_menu_updater* start 16 #f)    

;_____________________________________________________________
;The loop for the main game.
(define ($Gameplay_Looping)
  (begin
    ;Keypresses are checked first,
    ;and the correspoding movements
    ;are executed for all units.
    ($KeyBoard_Full_Movement)

    ;After this, collisions are calculated.
    ($Collisions)

    ;Then, projectiles are spawned.
    ($Game_Loop_Shooting)

    ;Next, players that are forced to respawn
    ;are so.
    ($Force_Respawn)

    ;After this, random entities are
    ;spawned if they should.
    ($Entity_Spawner)

    ;Next, graphics are updated.
    (send *main_canvas* refresh-now)


    ;Lastly, if somone just died, victory
    ;conditions are checked.
    (when (send *world* $Someone_Just_Died?)
             ($Victory_Handler)
             (send *world* $Set_Someone_Just_Died #f))))


;_____________________________________________________________

;Checks so that the game isn't updated if paused.
(define ($Gameplay_Looping_Check)
  (when (not (send *world* $Game_Paused?)) ($Gameplay_Looping)))

;The timer that updates the main game.
(define *game_updater*
  (new timer%
       [notify-callback $Gameplay_Looping_Check]))

;_________________________________________________
;Procedure that takes action depending on the win condition. 
(define ($Victory_Handler)
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
       (send (send *main_canvas* get-dc) draw-bitmap
             *tie_bitmap*
             0
             0)]

      ;Otherwise, a player has won, so the game is stopped
      ;and their victory bitmap is drawn.
      [else
       (send *game_updater* stop)
       (send *world* $Set_Game_Over #t)
       (send (send *main_canvas* get-dc) draw-bitmap
             (send victory-condition $Get_Victory_Bitmap)
             0
             0)])))


;Finds the current winning condition. Can be a tie,
;keep playing or a winning player.
(define ($Victory_Condition)

  ;If less than 2 players are playing, no one can win.
  (if (< (length (send *world* $Get_Active_Players)) 2)
      'keep-playing

      (let ([remaining_players '()])

        ;Remaining_players is set to all players that are active and
        ;haven't lost(lives = 0) yet.
        (for-each (lambda (player)
                  (when (not (send player $Lost?))
                    (set! remaining_players (cons player remaining_players))))
                (send *world* $Get_Active_Players))

      (let ([number_of_remaining_players (length remaining_players)])

        (cond
          ;If 2 or more players are still playing, nothing happens.
          [(>= number_of_remaining_players 2) 'keep-playing]

          ;If only 1 player left, that player has won! 
          [(= number_of_remaining_players 1) (car remaining_players)]

          ;If 0 players left, that means they died at the same time,
          ;and it's is thereby a tie.
          [(= number_of_remaining_players 0) 'tie])))))