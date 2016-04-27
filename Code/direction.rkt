#lang racket
(provide direction%)


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