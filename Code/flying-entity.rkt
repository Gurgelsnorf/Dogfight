#lang racket

(require "flying-unit-rectangular.rkt")

(provide flying_entity%)


;Defines the class flying entity.
(define flying_entity%
  (class flying_unit_rectangular%

    (inherit-field
     speed)

;_________________________________________________

    ;when an entity picks up a buff, it gains super speed
    (define/public ($Buff_Entity)
      (set! speed (* speed 4)))

    (super-new)))