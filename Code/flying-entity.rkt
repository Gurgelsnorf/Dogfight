#lang racket

(require "flying-unit-rectangular.rkt")

(provide flying_entity%)


;Defines the class flying entity.
(define flying_entity%
  (class flying_unit_rectangular%
    (init-field

     [buff_on_death #f]
     [buff_type '()])

    (inherit-field
     speed)


    ;Retrieves the variables of the object.
    (define/public ($Drops_Buff?)
      buff_on_death)

    (define/public ($Get_Buff_Type)
      buff_type)

;_________________________________________________
    ;when an entity picks up a buff, it gains super speed
    (define/public ($Buff_Entity)
      (set! speed (* speed 4)))

    (super-new)))