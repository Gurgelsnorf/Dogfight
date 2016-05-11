#lang racket

(require "circle.rkt")

(provide flying_unit_circular%)


;Defines the class flying unit circular
(define flying_unit_circular%
  (class circle%

    (init-field
     speed
     direction
     death_bitmap
     [dead #f])

;_________________________________________________
    
    ;Returns the variables for the object:
    (define/public ($Get_Speed)
      speed)
    (define/public ($Get_Direction)
      direction)
    (define/public ($Dead?)
      dead)

;_________________________________________________
    
    ;Sets the variables for the object:
    (define/public ($Set_Speed new_speed)
      (set! speed new_speed))
    (define/public ($Set_Direction new_direction)
      (set! direction new_direction))

;_________________________________________________

    ;Removes the unit from play.
    (define/public ($Kill)
      (set! dead #t))
    
    (super-new)))