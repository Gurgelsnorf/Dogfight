#lang racket
(provide (all-defined-out))


(define clocking%
  (class object%
    (init-field
     Should_Run)

    (define/public ($Get_Clock_Run?)
      Should_Run)

    (define/public ($Set_Clock_Run well)
      (set! Should_Run well))

    (super-new)))