#lang racket/gui

(provide (all-defined-out))


;The world object, which contains info about
;all the objects currently in play (players, birds etc...)

(define world%
  (class object%
    (init-field

     [list_of_buildings '()]      ;List of all the buildings in the world.
     [list_of_flying_units '()]   ;List of the flying units in the world.
     [list_of_corpses '()]        ;List of all the dead units that should be printed.
     [list_of_active_players '()] ;List of all players that are active(spawned once).

     ;A variable for tracking if a random entity should be spawned
     [spawn_entity_allowed #t]

     ;Tracks if some unit died in the previous game update.
     [someone_just_died #f]

     ;Tracks if the game has started(post menu).
     [game_started #f]

     ;Tracks if the game is over.
     [game_over #f]

     ;Tracks if the game is paused.
     [game_paused #t]
     
     
     [height 700] ;The height of the world,
     [width 1200] ;The width of the world.
     [sky_height 650]    ;The height at which the upper sky limit starts.
     [ground_height 50]) ;The height at which the ground starts.

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

    (define/public ($Game_Started?)
      game_started)
    
    (define/public ($Game_Over?)
      game_over)

    (define/public ($Game_Paused?)
      game_paused)
    
;_________________________________________________
    ;Sets the variables for the world.
    
    (define/public ($Set_Someone_Just_Died boolean)
      (set! someone_just_died boolean))

    (define/public ($Set_Game_Started boolean)
      (set! game_started boolean))

    (define/public ($Set_Game_Over boolean)
      (set! game_over boolean))

    (define/public ($Set_Game_Paused boolean)
      (set! game_paused boolean))

    
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

      ;Based on a random time.
      (send *clock_spawn_entity* start (+ 5000 (random 5001)) #t))

    ;The timer that counts down the spawn entity cooldown.
    (define *clock_spawn_entity*
      (new timer%
           [notify-callback (lambda ()
                              (set! spawn_entity_allowed #t))]))
    
    (super-new)))