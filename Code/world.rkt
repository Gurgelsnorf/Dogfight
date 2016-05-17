#lang racket
(provide (all-defined-out))


;The world object, which contains all the objects
;currently in play (players, birds etc...)
(define world%
  (class object%
    (init-field

     [list_of_buildings '()] ;List of all the buildings in the world.
     [list_of_flying_units '()] ;List of the flying units in the world.
     [list_of_corpses '()] ;List of all the dead units that should be
     ;printed.
     
     
     
     ;The worlds bottom-left corner coordinates are at (0 0),
     ;so that makes the world have its corners in:
     
     ;bottom left   :(0 0)
     ;bottom right  :(width 0)
     ;top left      :(0 height)
     ;top right     :(width height)
     
     [height 700] ;The height of the world,
     [width 1200] ;The width of the world.
     [sky_height 650] ;The height at which the upper sky limit starts
     [ground_height 50]) ;The height at which the ground stops.
    
    
    ;Returns the variables of the world
    (define/public ($Get_Flying_Units)
      list_of_flying_units)

    (define/public ($Get_Buildings)
      list_of_buildings)

    (define/public ($Get_Height)
      height)
    
    (define/public ($Get_Width)
      width)

    (define/public ($Get_Sky_Height)
      sky_height)

    (define/public ($Get_Ground_Height)
      ground_height)

    (define/public ($Get_Corpses)
      list_of_corpses)
    

    
    ;Adds a flying unit to the world.
    (define/public ($Add_Flying_Unit flying_unit)
      (set! list_of_flying_units
            (cons flying_unit list_of_flying_units)))
    
    ;Deletes a flying unit from the world.
    (define/public ($Delete_Flying_Unit flying_unit)
      (set! list_of_flying_units
            (filter (lambda (list_unit)
                      (not (equal? list_unit flying_unit)))
                    list_of_flying_units)))

    ;Adds a flying unit to the list of corpses
    (define/public ($Add_Corpse corpse)
      (set! list_of_corpses (cons corpse list_of_corpses)))

    ;Removes a flying unit from the list of corpses.
    (define/public ($Delete_Corpse corpse)
      (set! list_of_corpses
            (filter (lambda (list_corpse)
                      (not (equal? corpse list_corpse)))
                    list_of_corpses)))
    
    (super-new)))


