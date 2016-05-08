#lang racket

(require "basic-procedures.rkt")

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
     [projected_bl_corner bl_corner]
     [projected_br_corner br_corner]
     [projected_tl_corner tl_corner]
     [projected_tr_corner tr_corner]
     [bitmap 'no-bitmap-choosen!]
     [name 'im-a-rectangle] ;name tag for the rectangle
     [width 0] ;width of the rectangle
     [height 0] ;Height of the rectangle
     [angle 0]) ;The rotation angle of the rectangle
    
    ;Retreiveing the variables for the object
    (define/public ($Get_Bl_Corner) bl_corner)
    (define/public ($Get_Br_Corner) br_corner)
    (define/public ($Get_Tl_Corner) tl_corner)
    (define/public ($Get_Tr_Corner) tr_corner)
    (define/public ($Get_Name) name)
    (define/public ($Get_Width) width)
    (define/public ($Get_Height) height)
    (define/public ($Get_Angle) angle)
    [define/public ($Get_Bitmap) bitmap]


    ;Changing the variables of the object
    (define/public ($Set_Width new_width)
      (set! width new_width))
    (define/public ($Set_Height new_height)
      (set! height new_height))
    (define/public ($Set_Angle new_angle)
      (set! angle new_angle))
    (define/public ($Set_Bitmap new_bitmap)
      (set! bitmap new_bitmap))


    ;Initial calculating of width and height:
    (set! width ($Vector_Length ($Vector_Create bl_corner br_corner)))
    (set! height ($Vector_Length ($Vector_Create bl_corner tl_corner)))
      

    
    (super-new)))