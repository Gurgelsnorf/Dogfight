#lang racket

(provide direction%)

;Here the direction% class is defined.
;A direction% is defined by a direction-vector, a minimum
;allowed speed in this direction, and how much gravity
;takes its effect in this direction.


;NOTE: Gravity and stalling is not implemented yet,
;and thus min_cap and gravity is not currently used.

(define direction%
  (class object%
    (init-field

     ;NOTE: Direction vector is always of length 1.
     vector
     min_cap
     gravity)


    ;Returning the variables for the object
    (define/public ($Get_Vector)
      vector)

    (define/public ($Get_Min_Cap)
      min_cap)

    (define/public ($Get_Gravity)
      gravity)
    
    (super-new)))