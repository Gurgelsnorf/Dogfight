#lang racket
(provide direction%)

;Here the direction% class is defined.
;A direction% is defined by a direction-vector, a minimum
;allowed speed in this direction, and how much gravity
;takes its effect in this direction.
(define direction%
  (class object%
    (init-field
     vector
     min_cap
     gravity)

    (define/public ($Get_Vector)
      vector)

    (define/public ($Get_Min_Cap)
      min_cap)

    (define/public ($Get_Gravity)
      gravity)
    (super-new)))