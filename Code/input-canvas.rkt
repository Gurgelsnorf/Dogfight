#lang racket/gui
(require "player-commands.rkt")
(require "world-init.rkt")
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
      ((eq? £Key_Code 'left) ($Increase_Angle *player_1* 1))
      ((eq? £Key_Code 'right) ($Increase_Angle *player_1* -1)))))
    
  










  
  