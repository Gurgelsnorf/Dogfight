#lang racket

(require "class-circle.rkt")

(provide flying_unit_circular%)


;Defines the class flying unit circular
(define flying_unit_circular%
  (class circle%

    (init-field

     ;Speed of the unit
     speed 

     ;The direction of the unit. (goes from 0-31, 0 is straight to the
     ;right, 4 is up and right, etc. (32 parts counter-clockwise on the unit circle)).
     direction  

      ;bitmap shown when dead
     death_bitmap

      ;Tracks how long the corpse should be shown
     [corpse_cooldown 5]

     ;Is the unit out of play?
     [dead #f])

;_________________________________________________
    
    ;Returns the variables for the object:
    (define/public ($Get_Speed)
      speed)

    (define/public ($Get_Direction)
      direction)

    (define/public ($Dead?)
      dead)

    (define/public ($Get_Corpse_Cooldown)
      corpse_cooldown)

    (define/public ($Get_Kill_Bitmap)
      death_bitmap)

;_________________________________________________
    
    ;Sets the variables for the object:
    (define/public ($Set_Speed new_speed)
      (set! speed new_speed))
    
    (define/public ($Set_Direction new_direction)
      (set! direction new_direction))

;_________________________________________________

    ;Removes the unit from play.
    (define/public ($Kill)
      (set! dead #t)
      (set! corpse_cooldown 5))

    ;Counts corpse_cooldown down once. When it
    ;reaches 0, the corpse won't be drawn
    ;on the map.
    (define/public ($Corpse_Cooldown)
      (set! corpse_cooldown (- corpse_cooldown 1)))

    
    (super-new)))