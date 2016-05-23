#lang racket/gui
(provide (all-defined-out))


;The world object, which contains all the objects
;currently in play (players, birds etc...)
(define world%
  (class object%
    (init-field

     [list_of_buildings '()] ;List of all the buildings in the world.
     [list_of_flying_units '()] ;List of the flying units in the world.
     [list_of_corpses '()] ;List of all the dead units that should be
     [list_of_active_players '()]
     ;printed.

     [spawn_entity_allowed #t]

     [someone_just_died #f]
     
     
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

;_________________________________________________    
    
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

    (define/public ($Get_Active_Players)
      list_of_active_players)

    (define/public ($Spawn_Entity_Allowed?)
      spawn_entity_allowed)

    (define/public ($Someone_Just_Died?)
      someone_just_died)
    
;_________________________________________________

    (define/public ($Set_Someone_Just_Died boolean)
      (set! someone_just_died boolean))

    
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
    

;_________________________________________________
    
    ;Adds a flying unit to the list of corpses
    (define/public ($Add_Corpse corpse)
      (set! list_of_corpses (cons corpse list_of_corpses)))

    ;Removes a flying unit from the list of corpses.
    (define/public ($Delete_Corpse corpse)
      (set! list_of_corpses
            (filter (lambda (list_corpse)
                      (not (equal? corpse list_corpse)))
                    list_of_corpses)))

;_________________________________________________
    ;Adds a player to the list of active players, if
    ;they aren't there already.
    (define/public ($Add_Active_Player player)
      (when (null? (filter (lambda (active_player)
                             (equal? player active_player))
                           list_of_active_players))
        (set! list_of_active_players (cons player list_of_active_players))))
    
;_________________________________________________
    ;Starts the cooldown for spawning another entity
    (define/public ($Cooldown_Entity_Spawner)
      (set! spawn_entity_allowed #f)
      (send *clock_spawn_entity* start (+ 9000 (random 6001)) #t))

    ;The timer that counts down the spawn entity cooldown.
    (define *clock_spawn_entity*
      (new timer%
           [notify-callback (lambda ()
                              (set! spawn_entity_allowed #t))]))
    
    (super-new)))


