#lang racket

(provide (all-defined-out))

;A class for defining a rectangle object. Won't
;necessarily be defined like this in the finished
;program, is mostly defined for testing.
(define rectangle%
  (class object%
    (init-field 
     bl_corner  ;bottom-left coordinate
     br_corner  ;bottom-right coordinate
     tl_corner  ;top-left coordinate
     tr_corner  ;top-right coordinate
     [name 'im-a-rectangle]) ;name tag for the rectangle
    
    ;Retreiveing the variables for the object
    (define/public ($Get_Bl_Corner) bl_corner)
    (define/public ($Get_Br_Corner) br_corner)
    (define/public ($Get_Tl_Corner) tl_corner)
    (define/public ($Get_Tr_Corner) tr_corner)
    (define/public ($Get_Name) name)
    (super-new)))