#lang racket
(provide airplane%)

;Here, the class airplane is defined.

(define airplane%
  (class object%
    (init-field
     speed
     direction
     bl_corner
     br_corner
     tl_corner
     tr_corner)

    (define/public ($Get_Speed)
      speed)

    (define/public ($Get_Direction)
      direction)

    (define/public ($Get_Bl_Corner)
      bl_corner)

    (define/public ($Get_Br_Corner)
      br_corner)

    (define/public ($Get_Tl_Corner)
      tl_corner)

    (define/public ($Get_Tr_Corner)
      tr_corner)

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
    (super-new)))
     