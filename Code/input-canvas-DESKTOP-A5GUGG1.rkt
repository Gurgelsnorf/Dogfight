#lang racket/gui
(require "player-commands.rkt")
(require "world-init.rkt")
(require "collisions.rkt")
(require "basic-procedures.rkt")
(require "physics-engine.rkt")
(require "flying-unit-rectangular.rkt")
(require "graphics-engine-key-press.rkt")
(provide (all-defined-out))


;______________________________________________________
;A file to define input-canvas% for handling mouse events and also key events
;with one input-canvas-key and one input-canvas-mouse

(define input-canvas-key%
  (class canvas%
    [init-field key-handler]

    (define/override (on-char key-event)
      (key-handler key-event))

    (super-new)))


;_______________________________________________________
;Create a keyboard event that will define what happens on a key press

(define ($Airplane_Key_Controlls_Handler event)
  (let
      ((£Key_Code (send event get-key-code)))
    (cond
      ((eq? £Key_Code 'left) (begin
                               ($Increase_Angle_Rotate *player_1* 1)
                               (send *flying_units* refresh-now)))
      ((eq? £Key_Code 'right) (begin
                                ($Increase_Angle_Rotate *player_1* -1)
                                (send *flying_units* refresh-now)))
      ((eq? £Key_Code 'up) (begin
                             ($Airplane_Full_Movement *player_1*)
                             (send *flying_units* refresh-now)))
      ((eq? £Key_Code 'down) (begin
                               ($Move_All)
                               (send *flying_units* refresh-now))))))
    
  










  
  