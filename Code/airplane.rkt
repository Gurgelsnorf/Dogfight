#lang racket

(require "flying-unit-rectangular.rkt")


(provide (all-defined-out))

;Here, the class airplane is defined.

(define airplane%
  (class flying_unit_rectangular%
    (init-field
     [turn_left_allowed #f]
     [turn_right_allowed #f]
     [shoot_allowed #f])

    

;_________________________________________________
;Getting The variables of the airplane
    (define/public ($Turn_Left_Allowed?)
      turn_left_allowed)

    (define/public ($Turn_Right_Allowed?)
      turn_right_allowed)

    (define/public ($Shoot_Allowed?)
      shoot_allowed)

;_________________________________________________
;Setting the varables for the airplane
    (define/public ($Set_Turn_Left_Allowed setter)
      (set! turn_left_allowed setter))

    (define/public ($Set_Turn_Right_Allowed setter)
      (set! turn_right_allowed setter))

    (define/public ($Set_Shoot_Allowed setter)
      (set! shoot_allowed setter))

    (super-new)))


