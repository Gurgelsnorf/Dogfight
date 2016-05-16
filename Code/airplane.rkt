#lang racket

(require "flying-unit-rectangular.rkt")

(provide (all-defined-out))

;Here, the class airplane is defined.

(define airplane%
  (class flying_unit_rectangular%

    (super-new)))


;_________________________________________________________
;Variables for turning or shooting

;Player 1

(define £Player_1_Turn_Left #f)
(define £Player_1_Turn_Right #f)
(define £Player_1_Shoot #f)


;Player 2

(define £Player_2_Turn_Left #f)
(define £Player_2_Turn_Right #f)
(define £Player_2_Shoot #f)