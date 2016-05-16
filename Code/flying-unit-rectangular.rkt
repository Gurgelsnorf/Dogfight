#lang racket
(require "rectangle.rkt")

(provide flying_unit_rectangular%)

(define flying_unit_rectangular%
  (class rectangle%

    (init-field
     speed
     direction
     death_bitmap
     [death_bitmap_cooldown 0]
     [dead #f])

;_________________________________________________
    
    ;Returns the variables for the object:
    (define/public ($Get_Speed)
      speed)
    (define/public ($Get_Direction)
      direction)
    (define/public ($Dead?)
      dead)


    ;Returns the kill bitmap and counts death_bitmap_cooldown
    ;down. If the cooldown is 0, #f is returned.
    (define/public ($Get_Kill_Bitmap_Cooldown)
      (if (= death_bitmap_cooldown 0)
          #f
          death_bitmap))
    
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
      (set! death_bitmap_cooldown 5))
            
    (super-new)))