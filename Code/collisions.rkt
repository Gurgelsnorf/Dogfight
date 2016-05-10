#lang racket
(require "basic-procedures.rkt")

(require "rectangle.rkt")
(require "circle.rkt")
(require "airplane.rkt")
(require "projectile.rkt")
(require "buff.rkt")
(require "flying-entity.rkt")
(require "world-init.rkt")

(require "player-commands.rkt")

(provide (all-defined-out))


#| This file contains all procedures needed to detect collisions.

The file is quite big, and is thus divided into multiple sections.

;_________________________________________________
Section Cheat Sheet:

     1. Help procedures for single unit collisions
     2. Single unit collisions

     3. World Collision

     4. Help procedures for multiple unit collisions

     5. Main Collision Finder
     6. Main Collision Handler

;_________________________________________________
Segment description:

;The 2 first segments are:

     *Help procedures for single unit collisions
     *Single unit collisions

Which contains all procedures needed for detecting
if 2 given objects are currently colliding, and mostly
consists of different geometric calculations.

;-------------------------------------------------
This is followed by the segment:

     *World Collision

That contains all procedures needed to check if
an object has collided with the world.

;-------------------------------------------------
Next, the segment:

     *Help procedures for multiple unit collisions

Is defined, which containts all procedures that help
find and handle all collisions in *world*

;-------------------------------------------------
Lastly, the 2 final segments are defined:

     *Main Collision Finder
     *Main Collision Handler

The first which, when run, returns all collisions in *world*.

The second includes the main procedure ($Collisions), that
finds all collisions, and takes the corresponding actions
for every type of collision. This is the procedure that will
be called by the main loop in physics-engine later.

|#

;_________________________________________________
;_________________________________________________
;---------Defining rectangles for testing---------
;_________________________________________________
;_________________________________________________

(define *re1* (new rectangle%
                   [name 're1]
                   [bl_corner ($Vector 2 2)]
                   [br_corner ($Vector 6 2)]
                   [tl_corner ($Vector 2 6)]
                   [tr_corner ($Vector 6 6)]))

(define *re2* (new rectangle%
                   [name 're2]
                   [bl_corner ($Vector 1 1)]
                   [br_corner ($Vector 3 1)]
                   [tl_corner ($Vector 1 3)]
                   [tr_corner ($Vector 3 3)]))

(define *re3* (new rectangle%
                   [name 're3]
                   [bl_corner ($Vector 1 7)]
                   [br_corner ($Vector 2 7)]
                   [tl_corner ($Vector 1 9)]
                   [tr_corner ($Vector 2 9)]))

(define *re4* (new rectangle%
                   [name 're4]
                   [bl_corner ($Vector 10 2)]
                   [br_corner ($Vector 11 2)]
                   [tl_corner ($Vector 10 3)]
                   [tr_corner ($Vector 11 3)]))

(define *re5* (new rectangle%
                   [name 're5]
                   [bl_corner ($Vector 5 1)]
                   [br_corner ($Vector 8 1)]
                   [tl_corner ($Vector 5 7)]
                   [tr_corner ($Vector 8 7)]))

(define *re6* (new rectangle%
                   [name 're6]
                   [bl_corner ($Vector 6 2)]
                   [br_corner ($Vector 12 2)]
                   [tl_corner ($Vector 6 4)]
                   [tr_corner ($Vector 12 4)]))

(define *re7* (new rectangle%
                   [name 're7]
                   [bl_corner ($Vector 5 5)]
                   [br_corner ($Vector 6 5)]
                   [tl_corner ($Vector 5 6)]
                   [tr_corner ($Vector 6 6)]))

(define *re8* (new rectangle%
                   [name 're8]
                   [bl_corner ($Vector 7 7)]
                   [br_corner ($Vector 12 7)]
                   [tl_corner ($Vector 7 9)]
                   [tr_corner ($Vector 12 9)]))

(define *re9* (new rectangle%
                   [name 're9]
                   [bl_corner ($Vector 3 5)]
                   [br_corner ($Vector 7 7)]
                   [tl_corner ($Vector 2 7)]
                   [tr_corner ($Vector 6 9)]))

(define *re10* (new rectangle%
                    [name 're10]
                    [bl_corner ($Vector 7 7)]
                    [br_corner ($Vector 10 8.5)]
                    [tl_corner ($Vector 6 9)]
                    [tr_corner ($Vector 9 10.5)]))

(define *re11* (new rectangle%
                    [name 're11]
                    [bl_corner ($Vector 5 1)]
                    [br_corner ($Vector 6 2)]
                    [tl_corner ($Vector 4 2)]
                    [tr_corner ($Vector 5 3)]))


;_________________________________________________
;_________________________________________________
;-----------Defining circles for testing----------
;_________________________________________________
;_________________________________________________

;_________________________________________________
;_________________________________________________
;test circles

(define *ci1*
  (new circle%
       [radius 1]
       [center ($Vector 0 0)]))

(define *ci2*
  (new circle%
       [radius 2]
       [center ($Vector 2 3)]))

(define *ci3*
  (new circle%
       [radius 1]
       [center ($Vector 1 1)]))

(define *ci4*
  (new circle%
       [radius 3]
       [center ($Vector 0 -4)]))

(define *ci5*
  (new circle%
       [radius 2]
       [center ($Vector -5 -4)]))

(define *ci6*
  (new circle%
       [radius 1]
       [center ($Vector -5 -4)]))

;_________________________________________________
;_________________________________________________
;----Help procedures for single unit collisions---
;_________________________________________________
;_________________________________________________


;Takes a rectangle and returns 2 axes perpendicular
;to its sides as a pair.
(define ($Find_Perpendicular_Axes rectangle_object)
  
  ;Retrieving the necessary corners to make the axes.
  (let ([tr_corner_x ($Vector_Get_X (send rectangle_object $Get_Tr_Corner))]
        [tr_corner_y ($Vector_Get_Y (send rectangle_object $Get_Tr_Corner))]
        [tl_corner_x ($Vector_Get_X (send rectangle_object $Get_Tl_Corner))]
        [tl_corner_y ($Vector_Get_Y (send rectangle_object $Get_Tl_Corner))]
        [br_corner_x ($Vector_Get_X (send rectangle_object $Get_Br_Corner))]
        [br_corner_y ($Vector_Get_Y (send rectangle_object $Get_Br_Corner))])
    
    (let (
          ;goes from the left side to the right,(parallel to the top and bottom side)
          [axis_lr ($Vector (- tr_corner_x tl_corner_x)
                            (- tr_corner_y tl_corner_y))]
          ;goes from the bottom to the top,(parallel to the left and right side) 
          [axis_bt ($Vector (- tr_corner_x br_corner_x)
                            (- tr_corner_y br_corner_y))])
      
      ;returned as a pair
      (cons  axis_lr  axis_bt))))

;_________________________________________________

;Takes an axis, some projections on that axis, then takes the dot product
;between the projections and the axis. The max and min of these
;values are then returned as a pair. (cons min_scalar max_scalar)
(define ($Find_Max_Min_Projection_Scalar axis . projections)
  (let ([list_of_scalars
         (sort
          (map (lambda (vector)
                 ($Vector_Dot_Product axis vector))
               projections)
          <)])
    
    (let ([min_scalar (car list_of_scalars)]
          [max_scalar ($Last_Element_List list_of_scalars)])
      
      ;Returned as a pair.
      (cons min_scalar max_scalar))))

;_________________________________________________

;Takes an axis and two rectangles and returns #t if their projections
;overlap on that axis, else #f.
(define ($Projection_Overlap?
         axis
         main_rectangle
         second_rectangle)
  
  (let* (
         ;Projections on the given axis.
         
         ;Since the given axis should be perpendicular
         ;to the first(main) rectangle, only 2 projections
         ;are needed since they result in the same axis anyways.
         ;You however need all 4 for the second rectnagle.
         [proj_main_1 ($Vector_Projection
                       (send main_rectangle $Get_Tr_Corner)
                       axis)]
         [proj_main_2 ($Vector_Projection
                       (send main_rectangle $Get_Bl_Corner)
                       axis)]
         [proj_second_1 ($Vector_Projection
                         (send second_rectangle $Get_Tr_Corner)
                         axis)]
         [proj_second_2 ($Vector_Projection
                         (send second_rectangle $Get_Tl_Corner)
                         axis)]
         [proj_second_3 ($Vector_Projection
                         (send second_rectangle $Get_Br_Corner)
                         axis)]
         [proj_second_4 ($Vector_Projection
                         (send second_rectangle $Get_Bl_Corner)
                         axis)]
         
         ;The scalar comparision-values are defined for the
         ;First rectangle
         [min_max_scalar_a ($Find_Max_Min_Projection_Scalar
                            axis
                            proj_main_1
                            proj_main_2)]
         
         ;Same for the second one.
         [min_max_scalar_b ($Find_Max_Min_Projection_Scalar
                            axis
                            proj_second_1
                            proj_second_2
                            proj_second_3
                            proj_second_4)]
         
         
         ;Finally, the min and max values are separated
         [min_scalar_a (car min_max_scalar_a)]
         [max_scalar_a (cdr min_max_scalar_a)]
         [min_scalar_b (car min_max_scalar_b)]
         [max_scalar_b (cdr min_max_scalar_b)])
    
    
    ;If this is true, their projection
    ;overlap on the given axis.
    (and (< min_scalar_b max_scalar_a)
         (< min_scalar_a max_scalar_b))))

;_________________________________________________

;Takes a point and 3 specific corners of a rectangle
;and returns if the point is inside the area limited
;by the rectangles edges.
(define ($Point_In_Rectangle?
         point
         br_corner
         bl_corner
         tr_corner)
  
  ;Necessary vectors are defined.
  (let* ([vector_br_p 
          ($Vector_Create br_corner point)]
         [vector_br_bl 
          ($Vector_Create br_corner bl_corner)]
         [vector_br_tr
          ($Vector_Create br_corner tr_corner)]
         
         ;used to compare the angles in the rectangle.
         [comparison_value_1($Vector_Dot_Product
                             vector_br_p
                             vector_br_bl)]
         [comparison_value_2 ($Vector_Dot_Product
                              vector_br_p
                              vector_br_tr)])
    
    
    ;If this is true, then the point must be inside
    ;the rectangle.
    (and (< 0 comparison_value_1)
         (< comparison_value_1 ($Vector_Dot_Product vector_br_bl vector_br_bl))
         (< 0 comparison_value_2)
         (< comparison_value_2 ($Vector_Dot_Product vector_br_tr vector_br_tr)))))

;_________________________________________________

;Returns the distance between an infinite line and a point
;given the comparision point and 2 different points on the line.
(define  ($Distance_Line_Point
          main_point
          line_point_1
          line_point_2)
  
  ;Extracting the necessary values.
  (let* ([x_1 ($Vector_Get_X line_point_1)]
         [y_1 ($Vector_Get_Y line_point_1)]
         [x_2 ($Vector_Get_X line_point_2)]
         [y_2 ($Vector_Get_Y line_point_2)]
         [x_main ($Vector_Get_X main_point)]
         [y_main ($Vector_Get_Y main_point)]
         [delta_x (- x_2 x_1)]
         [delta_y (- y_2 y_1)])
    
    ;Equation for calculating the distance.
    (/ (abs (+
             (* delta_y x_main)
             (* -1 delta_x y_main)
             (* x_2 y_1)
             (* -1 y_2 x_1)))
       (sqrt (+
              (sqr delta_y)
              (sqr delta_x))))))

;_________________________________________________

;Finds the distance between a NON-infinite line-segment
;and a point, given that point and the 2 end points of
;the line.
(define ($Distance_Line_Segment_Point
         main_point
         start_point_line
         end_point_line)
  
  ;Calculating the necessary vectors/projections.
  (let* ([line
          ($Vector_Create start_point_line end_point_line)]
         
         [vector_start_main
          ($Vector_Create start_point_line main_point)]
         
         [main_point_projection
          ($Vector_Projection vector_start_main
                              line)])
    
    
    (cond
      ;If the angle between the line and the vector
      ;from the start point to the main point is
      ;>90 degrees <=> dot-product < 0, then
      ;the closest point is the start point.
      [(> 0 ($Vector_Dot_Product
             vector_start_main
             line))
       ($Vector_Length vector_start_main)]
      
      ;If the projection is longer than the
      ;line segment, the end point is the
      ;closest point.
      [(> ($Vector_Length main_point_projection)
          ($Vector_Length line))
       ($Vector_Length ($Vector_Create
                        end_point_line
                        main_point))]
      
      ;Otherwise, we can just calculate the
      ;perpendicular distance to the line.
      [else ($Distance_Line_Point
             main_point
             start_point_line
             end_point_line)])))

;_________________________________________________

;_________________________________________________
;_________________________________________________
;-------------Single unit collisions-------------
;_________________________________________________
;_________________________________________________

#|
Here the 4 collision-decector types are defined:

1. circle-circle collision

2. rectangle-rectangle collision

3. rectangle-circle collision

4. The 3 above joined into 1.

--------------------------------------------------
How they work:

1. circle-circle: If the distance between them is smaller than
  their added radii, a collision occured.

--------------------------------------------------
2. rectangle-rectangle: Uses SAT(separating axes theorem) to find
if a collision har occured:

    A. Find the perpendicular axes to 1 of the rectangles.

    B. Project all corners from both rectangles on the axes, one at a time.

    C. Take the dot product between the projections and the projection axis to
      find which projection goes furthest and shortest for both rectangles.

    D. Compare these values, collision has occured if:
      min(rectangle b) < max(rectangle a)
      min(rectangle a) < max(rectangle b)

    E. Repeat for the second axis. Collision has occured if both axis returns true.


    NOTE: If one axes shows no collision, that is enough to fully decide that no
     collision has occured, and the procedure won't check the next one.

--------------------------------------------------
3.
    A. Checks if the center of the circle is inside the rectangle.

    B. Checks if shortest distance to any of the edges is
      smaller than the radius of the circle.

__________________________________________________|#
;1.

;Returns #t if 2 circles overlap. else #f.
(define ($Circle_Collision? circle_1 circle_2)
  (let ([distance ($Vector_Length ($Vector_Create
                                   (send circle_1 $Get_Center)
                                   (send circle_2 $Get_Center)))])
    (< distance (+ (send circle_1 $Get_Radius)
                   (send circle_2 $Get_Radius)))))

;_________________________________________________
;2.

;Returns #t if 2 rectangles overlap, else #f.
(define ($Rectangle_Collision?
         rectangle_a
         rectangle_b)
  
  (let ([perpendicular_axes_obj_a ($Find_Perpendicular_Axes rectangle_a)])
    
    ;Checks if their projections on the perpendicular axes to 1
    ;of the rectangles overlap.
    (and ($Projection_Overlap?
          ($Vector_Get_X perpendicular_axes_obj_a) rectangle_a rectangle_b)
         ($Projection_Overlap?
          ($Vector_Get_Y perpendicular_axes_obj_a) rectangle_a rectangle_b))))

;_________________________________________________
;3.

;Returns #t if 2 a rectangle and circle overlap, else #f.
(define ($Rectangle_Circle_Collision? rectangle circle)
  
  ;Extracting the necessary values.
  (let* ([circle_center (send circle $Get_Center)]
         [circle_radius (send circle $Get_Radius)]
         [rec_br_corner (send rectangle $Get_Br_Corner)]
         [rec_bl_corner (send rectangle $Get_Bl_Corner)]
         [rec_tr_corner (send rectangle $Get_Tr_Corner)]
         [rec_tl_corner (send rectangle $Get_Tl_Corner)])
    
    ;Checks if the circle center is inside
    ;the rectangle.
    (or ($Point_In_Rectangle? circle_center
                              rec_br_corner
                              rec_bl_corner
                              rec_tr_corner)
        
        ;The list of distances is searched. If some distance is
        ;shorter than the circle radius, a collision has occured.
        (not (null? (filter (lambda (distance)
                              (< distance circle_radius))
                            
                            ;Returns a list of shorest distances
                            ;from every edge to the point.
                            (map
                             (lambda (corner_pair)
                               ($Distance_Line_Segment_Point
                                circle_center
                                (car corner_pair)
                                (cdr corner_pair)))
                             
                             ;list of all the edges start/end points.
                             (list (cons rec_bl_corner rec_br_corner)
                                   (cons rec_bl_corner rec_tl_corner)
                                   (cons rec_tl_corner rec_tr_corner)
                                   (cons rec_bl_corner rec_tl_corner)))))))))


;_________________________________________________
;4.

;Takes 2 objects and returns #t if they collide, else #f
(define ($Collision? object_1 object_2)
  (cond
    [(and (is-a? object_1 rectangle%) (is-a? object_2 rectangle%))
     ($Rectangle_Collision? object_1 object_2)]
    
    [(and (is-a? object_1 circle%) (is-a? object_2 circle%))
     ($Circle_Collision? object_1 object_2)]
    
    [else ($Rectangle_Circle_Collision? object_1 object_2)]))


;_________________________________________________
;_________________________________________________
;----------------World Collision------------------
;_________________________________________________
;_________________________________________________

;Here, the procedures needed to
;detect world collision are defined.


;_________________________________________________

;Takes a flying unit and returns if it is colliding with the
;world, and how it collides(sky, ground, left, right) if it does.
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
          
          ;The values are compared and a tag containing the
          ;occured collision is returned(see
          ;$World_Collision_Comparison for the name of the tags). 
          ($World_Collision_Comparison
           lowest_x lowest_y
           highest_x highest_y
           world_height world_width))
        
        ;-----------------------------------------
        
        ;If not rectangular, it is guaranteed to be circular.
        (let* (
               [radius (send flying_unit $Get_Radius)]
               [center (send flying_unit $Get_Center)]
               
               [lowest_x (- ($Vector_Get_X center) radius)]
               [lowest_y (- ($Vector_Get_Y center) radius)]
               [highest_x (+ ($Vector_Get_X center) radius)]
               [highest_y (+ ($Vector_Get_Y center) radius)])
          
          ;The values are compared and a tag containing the
          ;occured collision is returned(see
          ;$World_Collision_Comparison for the name of the tags).
          ($World_Collision_Comparison
           lowest_x lowest_y
           highest_x highest_y
           world_height world_width)))))

;_________________________________________________


;A help procedure to $Find_World_Collision that takes
;the values of a flying unit and info about the
;world and returns what type of collision has occured
;with the world, if any.
(define ($World_Collision_Comparison
         obj_lowest_x obj_lowest_y
         obj_highest_x obj_highest_y
         world_height world_width)
  
  (cond
    ;Returns the collision type as a tag.
    [(< obj_lowest_y 0) 'ground_collision]
    [(< world_height obj_lowest_y ) 'sky_collision]
    [(< obj_highest_x 0) 'left_collision]
    [(< world_width obj_lowest_x) 'right_collision]
    [else 'no_collision]))


;_________________________________________________
;_________________________________________________
;--Help procedures for multiple unit collisions---
;_________________________________________________
;_________________________________________________

;Here, the procedures which help handle multiple collsions
;are defined. This includes taking all units in *world*
;and checking what they have collided with, but also
;prioritizing which collision takes priority.

;_________________________________________________


;Sorts a list of flying units ordered by collision
;priority. Is returned like:
;(append planes entities projectiles buffs)
;,which is the priority order.
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

;_________________________________________________


;Takes a list of flying units and returns 2 lists. The first
;is a list of all objects that have collided with the world,
;and the second one those that haven't.
;Returned as: (cons world_collision_list no_world_collision_list)

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

;Takes a flying unit and a list of flying units sorted by priotity,
;and returns either the tag 'no-collision, or if it has collided,
;returns the flying unit which had the highest collision priority.
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

;Takes a list of units and removes them from world,
;and runs their kill procedure.
(define ($Kill_All kill_list)
  (map (lambda (flying_unit)
         (send *world* $Delete_Flying_unit flying_unit)
         (send flying_unit $Kill))
       kill_list))

;_________________________________________________

;Takes a list of planes and teleports them to
;the right or left side.
(define ($Teleport_All direction teleport_list)
  
  (let ([world_width (send *world* $Get_Width)])
    
    (if (equal? direction 'left)

        ;to the left.
        (map (lambda (plane)
               ($Increase_Pos plane (- (+ world_width (send plane $Get_Width))) 0)
               ($Rotate_All_Corners plane))
             teleport_list)

        ;to the right.
        (map (lambda (plane)
               ($Increase_Pos plane (+ world_width (send plane $Get_Width)) 0)
               ($Rotate_All_Corners plane))
             teleport_list))))


;_________________________________________________
;_________________________________________________
;-------------Main Collision Finder---------------
;_________________________________________________
;_________________________________________________

;Finds all the collisions that has occured in *world*.
;is returned like 2 lists separated world-unit collision and
;unit-unit collision like:
;(cons world_collisions list_of_unit_collisions)
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


;_________________________________________________
;_________________________________________________
;-------------Main Collision Handler--------------
;_________________________________________________
;_________________________________________________

;Finds all occuring collisions in the world,
;and takes the corresponding actions.
(define ($Collisions)
  (let* (
         ;All collisions are found and separated into
         ;world/unit collisions.
         [collisions ($Find_Collisions)]
         [world_collisions (car collisions)]
         [flying_unit_collisions (cdr collisions)]
         
         ;Lists are created which will be filled with
         ;the units that will be teleported/killed.
         [kill_list '()]
         [teleport_too_right_list '()]
         [teleport_too_left_list '()])
    
    ;A loop for the world collisions.
    (define (loop_world)
      
      ;If no world collisions left, continue to
      ;unit collisions.
      (if (null? world_collisions)
          (loop_units)
          
          (let (
                [flying_unit (caar world_collisions)]
                [collision_tag (cdar world_collisions)])
            
            (cond
              ;If a non airplane unit collides with the world,
              ;it will be removed.
              [(not (is-a? flying_unit airplane%))
               (set! kill_list (cons flying_unit kill_list))]
              
              ;Else, take the corresponding action.
              [(equal? collision_tag 'ground_collision)
               (set! kill_list
                     (cons flying_unit kill_list))]
              
              [(equal? collision_tag 'sky_collision)
               (send flying_unit $Stalling)]
              
              [(equal? collision_tag 'left_collision)
               (set! teleport_too_right_list
                     (cons flying_unit teleport_too_right_list))]
              
              [(equal? collision_tag 'right_collision)
               (set! teleport_too_left_list
                     (cons flying_unit teleport_too_left_list))])
            
            ;Loop until no collisions left.
            (set! world_collisions (cdr world_collisions))
            (loop_world))))
    
    
    ;A loop for the unit collisions.
    (define (loop_units)
      
      ;Continue until no collisions left.
      (when (not (null? flying_unit_collisions))
        
        (let (;Separate the units that will be compared first.
              [unit_1 (caar flying_unit_collisions)]
              [unit_2 (cdar flying_unit_collisions)])
          
          ;Detect unit type to take the correct action.
          (cond
            ;-------------------------------------
            ;unit_1 plane
            [(is-a? unit_1 airplane%)
             (cond
               
               ;unit_2 buff
               [(is-a? unit_2 buff%)
                (set! kill_list (cons unit_2 kill_list))
                (send unit_1 $Buff (send unit_2 $Get_Buff_Type))]
               
               ;if not a buff, all other cases means both the plane
               ;and the other unit should be killed.
               [else (set! kill_list
                           (cons unit_1 (cons unit_2 kill_list)))])]
            
            ;-------------------------------------
            ;unit_1 entity
            [(is-a? unit_1 flying_entity%)
             (cond
               
               ;unit_2 plane
               [(is-a? unit_2 airplane%)
                (set! kill_list (cons unit_1 (cons unit_2 kill_list)))]
               
               ;unit_2 entity
               [(is-a? unit_2 flying_entity%)
                (set! kill_list (cons unit_1 (cons unit_2 kill_list)))]
               
               ;unit_2 projectile
               [(is-a? unit_2 projectile%)
                (set! kill_list (cons unit_1 (cons unit_2 kill_list)))
                (printf "To implement: spawn buff here!")]
               
               ;unit_2 buff
               [(is-a? unit_2 buff%)
                (set! kill_list (cons unit_2 kill_list))
                (printf "To implement: buff entity!")])]
            
            ;-------------------------------------
            ;unit_1 projectile
            [(is-a? unit_1 projectile%)
             (cond
               
               ;unit_2 entity
               [(is-a? unit_2 flying_entity%)
                (set! kill_list (cons unit_1 (cons unit_2 kill_list)))
                (printf "To implement: spawn buff here!")]
               
               ;if not an entity, all other cases will be
               ;killing both units
               [else (set! kill_list (cons unit_1 (cons unit_2 kill_list)))])]
            
            ;-------------------------------------
            ;unit_1 buff
            [(is-a? unit_1 buff%)
             (cond
               
               ;unit_2 plane
               [(is-a? unit_2 airplane%)
                (set! kill_list (cons unit_1 kill_list))
                (send unit_2 $Buff (send unit_1 $Get_Buff_Type))]
               
               ;unit_2 entity
               [(is-a? unit_2 flying_entity%)
                (set! kill_list (cons unit_1 kill_list))
                (printf "To implement: buff entity!")]
               
               ;unit_2 projectile
               [(is-a? unit_2 projectile%)
                (set! kill_list (cons unit_1 (cons unit_2 kill_list)))]
               
               ;unit_2 buff       NOTE: (this case doesn't make anyting happen,
               ;since buffs should be able to overlap. Case is added
               ;for easier overview or later changes. (super-buffs maybe?)
               [(is-a? unit_2 buff%)
                (void)])])
          
          ;-------------------------------------
          
          ;Finally, repeat for all units.
          (set! flying_unit_collisions (cdr flying_unit_collisions))
          (loop_units))))
    
    ;-------------------------------------
    
    
    ;Start the loop, which will run loop_world and loop_units for
    ;all units.
    (loop_world)
    
    
    ($Kill_All kill_list)
    ($Teleport_All 'left teleport_too_left_list)
    ($Teleport_All 'right teleport_too_right_list)))