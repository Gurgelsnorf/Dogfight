#lang racket
(provide (all-defined-out))


;The world object, which contains all the objects
;currently in play (players, birds etc...)
(define world%
  (class object%
    (init-field
     
     [list_of_flying_units '()])

    ;Returns the flying units in the world.
    (define/public ($Get_Flying_Units)
      list_of_flying_units)


    ;Adds a flying unit to the world.
    (define/public ($Add_Flying_Unit flying_unit)
      (set! list_of_flying_units
            (cons flying_unit list_of_flying_units)))

    ;Deletes a flying unit from the world.
    (define/public ($Delete_Flying_Unit flying_unit)
      (set! list_of_flying_units
            (filter (lambda (list_unit)
                      (not (equal? list_unit flying_unit)))
                    (list_of_flying_units))))

    (super-new)))


