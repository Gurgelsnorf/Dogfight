#lang racket

(require "flying-unit-circular.rkt")

(provide buff%)

(define buff%
  (class flying_unit_circular%

    (init-field

     buff_type)

    (define/public ($Get_Buff_Type)
      buff_type)

  (super-new)))