#lang racket

(require "flying-unit-circular.rkt")

(provide buff%)

(define buff%
  (class flying_unit_circular%

    (init-field

     [buff_type ((lambda ()
                  (let ([seed (random 1)])
                    (cond
                      [(= seed 0) 'flying_speed]
                      [(= seed 1) 'shooting_speed]
                      ;Implement more later
                      ))))])

    (define/public ($Get_Buff_Type)
      buff_type)

  (super-new)))