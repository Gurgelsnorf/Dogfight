#lang racket

(require "flying-unit.rkt")

(provide (all-defined-out))

;Here, the class airplane is defined.

(define airplane%
  (class flying_unit%
    (init-field
     speed
     direction)

    (inherit-field
     bl_corner
     br_corner
     tl_corner
     tr_corner)

    (define/public ($Get_Speed)
      speed)

    (define/public ($Get_Direction)
      direction)

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
     