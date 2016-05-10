#lang racket

(require "flying-unit-rectangular.rkt")

(provide flying_entity%)


;Defines the class flying entity.
(define flying_entity%
  (class flying_unit_rectangular%
    (init-field

     [buff_on_death #f]
     [buff_type '()])


    ;Retrieves the variables of the object.
    (define/public ($Drops_Buff?)
      buff_on_death)

    (define/public ($Get_Buff_Type)
      buff_type)

    (super-new)))