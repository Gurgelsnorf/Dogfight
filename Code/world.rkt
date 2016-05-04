#lang racket
(provide (all-defined-out))


;The world object, which contains all the objects
;currently in play (players, birds etc...)
(define world%
  (class object%
    (init-field
     
     [list_of_flying_units '()] ;List of the flying units in the world.
     
     
     ;The worlds bottom-left corner coordinates are at (0 0),
     ;so that makes the world have its corners in:
     
     ;bottom left   :(0 0)
     ;bottom right  :(width 0)
     ;top left      :(0 height)
     ;top right     :(width height)
     
     [height 800] ;The height of the sky,
     [width 1200]) ;The width of the world.
    
    
    ;Returns the variables of the world
    (define/public ($Get_Flying_Units)
      list_of_flying_units)

    (define/public ($Get_Height)
      height)
    
    (define/public ($Get_Width)
      width)
    

    
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


