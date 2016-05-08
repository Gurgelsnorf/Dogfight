#lang racket

(require "world-init.rkt")
(require "airplane.rkt")
(require "direction.rkt")
(require "rectangle.rkt")
(require "basic-procedures.rkt")

(provide (all-defined-out))




;A help procedure to $Find_World_Collision that takes
;the values of a flying unit and info about the
;world and returns what type of collision has occured
;with the world, if any.
(define ($World_Collision_Comparison
         obj_lowest_x obj_lowest_y
         obj_highest_x obj_highest_y
         world_height world_width)
  (cond
    [(< obj_lowest_y 0) 'ground_collision]
    [(< world_height obj_highest_y ) 'sky_collision]
    [(< obj_lowest_x 0) 'left_collision]
    [(< world_width obj_highest_x) 'right_collision]
    [else 'no_collision]))




;Takes a flying unit and returns if it has collided
;with the world.
(define ($Find_World_Collision flying_unit)
  (let (
        [world_width (send *world* $Get_Width)]
        [world_height (send *world* $Get_Height)])
    
    ;If its a rectangular unit
    (if (is-a? flying_unit rectangle%)
        (let* (
               [corner_x_coordinates
                (sort (list
                       ($Vector_Get_X (send flying_unit $Get_Bl_Corner))
                       ($Vector_Get_X (send flying_unit $Get_Br_Corner))
                       ($Vector_Get_X (send flying_unit $Get_Tl_Corner))
                       ($Vector_Get_X (send flying_unit $Get_Tr_Corner)))
                      <)]
               
               [corner_y_coordinates
                (sort (list
                       ($Vector_Get_Y (send flying_unit $Get_Bl_Corner))
                       ($Vector_Get_Y (send flying_unit $Get_Br_Corner))
                       ($Vector_Get_Y (send flying_unit $Get_Tl_Corner))
                       ($Vector_Get_Y (send flying_unit $Get_Tr_Corner)))
                      <)]
               
               [lowest_x (car corner_x_coordinates)]
               [lowest_y (car corner_y_coordinates)]
               [highest_x ($Last_Element_List corner_x_coordinates)]
               [highest_y ($Last_Element_List corner_y_coordinates)])
          
          ($World_Collision_Comparison
           lowest_x lowest_y
           highest_x highest_y
           world_height world_width))
        
        
        ;If not rectangular, it is guaranteed to be circular.
        (let* (
               [radius (send flying_unit $Get_Radius)]
               [center (send flying_unit $Get_Center)]
               
               [lowest_x (- ($Vector_Get_X center) radius)]
               [lowest_y (- ($Vector_Get_Y center) radius)]
               [highest_x (+ ($Vector_Get_X center) radius)]
               [highest_y (+ ($Vector_Get_Y center) radius)])
          
          ($World_Collision_Comparison
           lowest_x lowest_y
           highest_x highest_y
           world_height world_width)))))









#| Not finished, will find all collisions in the game
during every physics loop.


(define ($Find_Collisions)
  (let* (
         [flying_units (send *world* $Get_Flying_units)]
         
         [world_collisions (map (lambda (flying_unit)
                                  (cons flying_unit
                                        ($Find_World_Collision flying_unit))
                                  flying_units))
|#
                           
                           
                           