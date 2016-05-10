#lang racket
(require "rectangle.rkt")

(provide flying_unit_rectangular%)

(define flying_unit_rectangular%
  (class rectangle%

    (init-field
     speed
     direction
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

    (define/public ($Kill)
      (set! dead #t)
      (printf "To implement: death-procedure"))
            
    (super-new)))