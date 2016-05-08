#lang racket

(require "flying-unit-rectangular.rkt")

(provide (all-defined-out))

;Here, the class airplane is defined.

(define airplane%
  (class flying_unit_rectangular%
    (init-field
     speed
     direction
     center_of_gravity)

    (inherit-field
     bl_corner
     br_corner
     tl_corner
     tr_corner
     projected_bl_corner
     projected_br_corner
     projected_tl_corner
     projected_tr_corner)

    (define/public ($Get_Speed)
      speed)

    (define/public ($Get_Direction)
      direction)

    (define/public ($Get_Center_Of_Gravity)
      center_of_gravity)

    (define/public ($Set_Center_Of_Gravity new_pos)
      (set! center_of_gravity new_pos))

    (define/public ($Set_Speed new_speed)
      (set! speed new_speed))

    (define/public ($Set_Direction new_direction)
      (set! direction new_direction))

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

    (define/public ($Get_Projected_Bl_Corner)
      projected_bl_corner)
    
    (define/public ($Get_Projected_Br_Corner)
      projected_br_corner)
    
    (define/public ($Get_Projected_Tl_Corner)
      projected_tl_corner)
    
    (define/public ($Get_Projected_Tr_Corner)
      projected_tr_corner)

    (super-new)))
     