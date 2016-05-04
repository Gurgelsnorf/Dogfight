#lang racket
(require "world-init.rkt")

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
         [collision_types (map (lambda (flying_unit)
                                 (cons
                                  flying_unit
                                  ($World_Collision flying_unit)))
                               flying_units)])
    
    
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
             
             [(is-a? flying-entity% flying_unit)
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


(define ($Collision_Detection flying_unit
                              sorted_flying_units)
  
    (define (loop)
      (cond
        [(null? priority_list) 'no-collision]
        [($collision? flying_unit (car sorted_flying_units))
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
         [world_collision_lists ($Separate_World_Collisions units)]
         
         [world_collisions (car world_collision_lists)]
         [no_world_collisions (cdr world_collision_lists)]
         
         
         ;The flying units that didn't collide with the world
         ;are separated into categories.
         [sorted_flying_units ($Sort_Unit_Types no_world_collisions)])
  