#lang racket

(require "flying-unit-rectangular.rkt")

(provide (all-defined-out))

;Here, the class airplane is defined.

(define airplane%
  (class flying_unit_rectangular%
    (init-field
     [turn_left #f]
     [turn_right #f]
     [shoot #f])
    

;_________________________________________
;Commands for get and set for the variables


    (define/public ($Get_Turn_Left)
      turn_left)

    (define/public ($Get_Turn_Right)
      turn_right)

    (define/public ($Get_Shoot)
      shoot)

    (define/public ($Set_Turn_Left setter)
      (set! turn_left setter))

    (define/public ($Set_Turn_Right setter)
      (set! turn_right setter))

    (define/public ($Set_Shoot setter)
      (set! shoot setter))


    (super-new)))


