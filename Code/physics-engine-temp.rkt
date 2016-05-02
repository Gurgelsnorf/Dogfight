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
         [collision_types (map (lambda (flying_unit)
                                 (cons
                                  flying_unit
                                  ($World_Collision flying_unit)))
                               flying_units)])
    
    (map (lambda (world_flying_collision)
           (if (equal? (cdr world_flying_collision) 
                       'no-collision)
               (set! no_world_collisions
                     (cons (car world_flying_collision)
                           no_world_collisions))
               
               (set! world_collisions (cons world_flying_collision
                                            world_collisions))))
         
         world_collision_types)
    
    (cons world_collisions
          no_world_collisions)))







(define ($Separate_Unit_Types list_of_flying_units)
  (let* (
         [planes '()]
         [entities '()]
         [projectiles '()]
         [buffs '()])
    
    (map (lambda (flying_unit)
           (cond
             [(is-a? airplane% flying_unit)
              (set! planes (cons flying_unit planes))]
             
             [(is-a? flying-entity% flying_unit)
              (set! entities (cons flying_unit entities))]
             
             [(is-a? projectile% flying_unit)
              (set! projectiles (cons flying_unit projectiles))]
             
             [else (set! buffs (cons flying_unit buffs))]))
         
         list_of_flying_units)
    
    (list planes
          entities
          projectiles
          buffs)))








(define ($Find_Collisions)
  (let* (
         [flying_units (send *world* $Get_Flying_Units)]
         

         [world_collision_lists ($Separate_World_Collisions units)]
         [world_collisions (car world_collision_lists)]
         [no_world_collisions (cdr world_collision_lists)]
         

         [unit_type_lists ($Separate_Unit_Types no_world_collisions)]
         [planes (car unit_type_lists)]
         [entities (cadr unit_type_lists)]
         [projectiles (caddr unit_type_lists)]
         [buffs (cadddr unit_type_lists)]

         