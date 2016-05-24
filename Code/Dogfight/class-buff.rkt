#lang racket

(require "class-flying-unit-circular.rkt")

(provide buff%)

;Here, the class buff is defined.

(define buff%
  (class flying_unit_circular%

    (init-field

     ;What kind of buff to be given when picked up.
     buff_type)

    (define/public ($Get_Buff_Type)
      buff_type)

  (super-new)))