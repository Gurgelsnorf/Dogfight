#lang racket

(require "basic-procedures.rkt")

(provide rectangle%)

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
     center_of_gravity ;The center of the rectangle 
     [projected_bl_corner bl_corner]
     [projected_br_corner br_corner]
     [projected_tl_corner tl_corner]
     [projected_tr_corner tr_corner]
     [bitmap 'no-bitmap-choosen!]
     [name 'im-a-rectangle] ;name tag for the rectangle
     [width 0] ;width of the rectangle
     [height 0] ;Height of the rectangle
     [angle 0]) ;The rotation angle of the rectangle

;_________________________________________________

    ;Retreiveing the variables for the object:
    (define/public ($Get_Bl_Corner) bl_corner)
    (define/public ($Get_Br_Corner) br_corner)
    (define/public ($Get_Tl_Corner) tl_corner)
    (define/public ($Get_Tr_Corner) tr_corner)
    (define/public ($Get_Name) name)
    (define/public ($Get_Width) width)
    (define/public ($Get_Height) height)
    (define/public ($Get_Angle) angle)
    [define/public ($Get_Bitmap) bitmap]
    (define/public ($Get_Center_Of_Gravity) center_of_gravity)
    (define/public ($Get_Projected_Bl_Corner) projected_bl_corner)
    (define/public ($Get_Projected_Br_Corner) projected_br_corner)
    (define/public ($Get_Projected_Tl_Corner) projected_tl_corner)
    (define/public ($Get_Projected_Tr_Corner) projected_tr_corner)

;_________________________________________________

    ;Changing the variables of the object:
    (define/public ($Set_Width new_width)
      (set! width new_width))

    (define/public ($Set_Height new_height)
      (set! height new_height))

    (define/public ($Set_Angle new_angle)
      (set! angle new_angle))

    (define/public ($Set_Bitmap new_bitmap)
      (set! bitmap new_bitmap))

    (define/public ($Set_Center_Of_Gravity new_pos)
      (set! center_of_gravity new_pos))

    (define/public ($Set_Bl_Corner new_pos)
      (set! bl_corner new_pos))
    
    (define/public ($Set_Br_Corner new_pos)
      (set! br_corner new_pos))
    
    (define/public ($Set_Tl_Corner new_pos)
      (set! tl_corner new_pos))
    
    (define/public ($Set_Tr_Corner new_pos)
      (set! tr_corner new_pos))
    
    (define/public ($Set_Projected_Bl_Corner new_pos)
          (set! projected_bl_corner new_pos))

    (define/public ($Set_Projected_Br_Corner new_pos)
      (set! projected_br_corner new_pos))

    (define/public ($Set_Projected_Tl_Corner new_pos)
      (set! projected_tl_corner new_pos))

    (define/public ($Set_Projected_Tr_Corner new_pos)
      (set! projected_tr_corner new_pos))


;_________________________________________________

    ;Initial calculating of width and height:
    (set! width ($Vector_Length ($Vector_Create bl_corner br_corner)))
    (set! height ($Vector_Length ($Vector_Create bl_corner tl_corner)))


    
    (super-new)))