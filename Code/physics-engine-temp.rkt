#lang racket
(require "world-init.rkt")
(require "physics-engine.rkt")
(require "airplane.rkt")
(require "flying-entity.rkt")
(require "projectile.rkt")
(require "circle.rkt")
(require "rectangle.rkt")
(require "collisions.rkt")


;Takes a list of flying units and returns 2 lists. The first
;is a list of all objects that have collided with the world,
;and the second one those that haven't.
;Returned as: (cons collision_list no_collision_list)
(define ($Separate_World_Collisions list_of_flying_units)
  (let* (
         [world_collisions '()]
         [no_world_collisions '()]
         
         ;Tags every flying unit with a world collision
         ;type, see $World_Collision for list.
         [world_collision_types (map (lambda (flying_unit)
                                 (cons
                                  flying_unit
                                  ($Find_World_Collision flying_unit)))
                               list_of_flying_units)])
    
    
    ;Spliting collision and no collision into 2
    ;separate lists.
    (map (lambda (world_flying_collision)
           (if (equal? (cdr world_flying_collision) 
                       'no-collision)
               (set! no_world_collisions
                     (cons (car world_flying_collision)
                           no_world_collisions))
               
               (set! world_collisions (cons world_flying_collision
                                            world_collisions))))
         
         world_collision_types)
    
    ;Returns the 2 lists as a pair.
    (cons world_collisions
          no_world_collisions)))

;_________________________________________________




;Separates a list of flying units into 4 lists
;sorted by type. Answer is returned like:
;(append planes entities projectiles buffs).
(define ($Sort_Unit_Types list_of_flying_units)
  (let* (
         [planes '()]
         [entities '()]
         [projectiles '()]
         [buffs '()])
    
    (map (lambda (flying_unit)
           ;Identifies the object type
           (cond
             [(is-a? airplane% flying_unit)
              (set! planes (cons flying_unit planes))]
             
             [(is-a? flying_entity% flying_unit)
              (set! entities (cons flying_unit entities))]
             
             [(is-a? projectile% flying_unit)
              (set! projectiles (cons flying_unit projectiles))]
             
             ;If none of the above, only buff% remains
             [else (set! buffs (cons flying_unit buffs))]))
         
         list_of_flying_units)
    
    ;returned list with the objects in the
    ;correct order.
    (append planes
            entities
            projectiles
            buffs)))


;Takes a flying unit and returns if it has collided with another flying unit,
;and if it has which flying unit has the highest collision priority.
(define ($Collision_Detection flying_unit
                              sorted_flying_units)
  
    (define (loop)
      (cond
        [(null? sorted_flying_units) 'no-collision]
        [($Collision? flying_unit (car sorted_flying_units))
         (cons flying_unit (car sorted_flying_units))]
        [else (set! sorted_flying_units (cdr sorted_flying_units))
              (loop)]))
    (loop))
;_________________________________________________


;Finds all the collisions that has occured in *world*.
(define ($Find_Collisions)
  (let* (
         [flying_units (send *world* $Get_Flying_Units)]
         
         ;First, world collisions are taken care of, which takes
         ;priority over the other types of collisions.
         [world_collision_lists ($Separate_World_Collisions flying_units)]
         
         [world_collisions (car world_collision_lists)]
         [no_world_collisions (cdr world_collision_lists)]
         
         
         ;The flying units that didn't collide with the world
         ;are sorted in the order of priority(if multiple collisions
         ;occur, 1 is prioritized).
         [sorted_flying_units ($Sort_Unit_Types no_world_collisions)]

         ;A list which containts pairs of all units that have
         ;a detected collison together.
         [list_of_unit_collisions


          ;After all the flying remaining flying units have been tagged,
          ;Those that have the tag 'no-collision are removed.
          (filter (lambda (flying_unit_collision)
                    (not (equal? (cdr flying_unit_collision 'no-collision))))

                  ;All flying units that didn't collide with the world are run
                  ;through 1 by 1 in the order of priority.
                  (map (lambda (flying_unit)
                         
                         ;The flying unit is tagged with either 'no-collision or
                         ;The unit with the highest priority that it collided with.
                         (cons flying_unit
                               ($Collision_Detection flying_unit
                                                     (cdr sorted_flying_units))))
                       sorted_flying_units))])


    ;Finally, the 2 lists containing the collisions with the world
    ;and the units which collided are returned.
    (cons world_collisions list_of_unit_collisions)))




;Takes 2 objects, and returns if they are colliding or not.
(define ($Collision? object_1 object_2)
  (cond
    [(and (is-a? object_1 rectangle%) (is-a? object_2 rectangle%))
     ($Rectangle_Collision? object_1 object_2)]

    [(and (is-a? object_1 circle%) (is-a? object_2 circle%))
     ($Circle_Collision? object_1 object_2)]

    [else ($Rectangle_Circle_Collision? object_1 object_2)]))