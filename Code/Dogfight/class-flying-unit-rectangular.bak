#lang racket
(require "rectangle.rkt")

(provide flying_unit_rectangular%)

(define flying_unit_rectangular%
  (class rectangle%

    (init-field

     speed ;Speed of the unit

     direction ;The direction of the unit. (goes from 0-31, 0 is straight to the
     ;right, 4 is up and left, etc. (32 parts counter-clockwise in the unit circle)). 

     [death_bitmap 'no-bitmap-choosen!] ;bitmap shown when dead

     [corpse_cooldown 0] ;that bitmap is only shown for a short while

     [dead #f]) ;Is the unit out of play?

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

