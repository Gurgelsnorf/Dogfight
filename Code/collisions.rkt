#lang racket
(require "basic-vector-functions.rkt")

(require "rectangle.rkt") ;won't be required later,
;only for testing!

  
;Contains the procedures that find if the different
;object-types have collided or not. Look furthest down
;to find the main procedures, and directly above
;for a description and sub-procedures.


;_________________________________________________
;_________________________________________________
;---------Defining rectangles for testing---------
;_________________________________________________
;_________________________________________________

(define *re1* (new rectangle%
                   [name 're1]
                   [bl_corner (cons 2 2)]
                   [br_corner (cons 6 2)]
                   [tl_corner (cons 2 6)]
                   [tr_corner (cons 6 6)]))

(define *re2* (new rectangle%
                   [name 're2]
                   [bl_corner (cons 1 1)]
                   [br_corner (cons 3 1)]
                   [tl_corner (cons 1 3)]
                   [tr_corner (cons 3 3)]))

(define *re3* (new rectangle%
                   [name 're3]
                   [bl_corner (cons 1 7)]
                   [br_corner (cons 2 7)]
                   [tl_corner (cons 1 9)]
                   [tr_corner (cons 2 9)]))

(define *re4* (new rectangle%
                   [name 're4]
                   [bl_corner (cons 10 2)]
                   [br_corner (cons 11 2)]
                   [tl_corner (cons 10 3)]
                   [tr_corner (cons 11 3)]))

(define *re5* (new rectangle%
                   [name 're5]
                   [bl_corner (cons 5 1)]
                   [br_corner (cons 8 1)]
                   [tl_corner (cons 5 7)]
                   [tr_corner (cons 8 7)]))

(define *re6* (new rectangle%
                   [name 're6]
                   [bl_corner (cons 6 2)]
                   [br_corner (cons 12 2)]
                   [tl_corner (cons 6 4)]
                   [tr_corner (cons 12 4)]))

(define *re7* (new rectangle%
                   [name 're7]
                   [bl_corner (cons 5 5)]
                   [br_corner (cons 6 5)]
                   [tl_corner (cons 5 6)]
                   [tr_corner (cons 6 6)]))

(define *re8* (new rectangle%
                   [name 're8]
                   [bl_corner (cons 7 7)]
                   [br_corner (cons 12 7)]
                   [tl_corner (cons 7 9)]
                   [tr_corner (cons 12 9)]))

(define *re9* (new rectangle%
                   [name 're9]
                   [bl_corner (cons 3 5)]
                   [br_corner (cons 7 7)]
                   [tl_corner (cons 2 7)]
                   [tr_corner (cons 6 9)]))

(define *re10* (new rectangle%
                    [name 're10]
                    [bl_corner (cons 7 7)]
                    [br_corner (cons 10 8.5)]
                    [tl_corner (cons 6 9)]
                    [tr_corner (cons 9 10.5)]))

(define *re11* (new rectangle%
                    [name 're11]
                    [bl_corner (cons 5 1)]
                    [br_corner (cons 6 2)]
                    [tl_corner (cons 4 2)]
                    [tr_corner (cons 5 3)]))


;_________________________________________________
;_________________________________________________
;-----------Defining circles for testing----------
;_________________________________________________
;_________________________________________________

(define circle%
  (class object%
    (init-field
     [radius 1]
     [center (cons 0 0)])
    
    (define/public ($Get_Center)
      center)
    (define/public ($Get_Radius)
      radius)
    
    (super-new)))

;_________________________________________________
;_________________________________________________
;test circles

(define *ci1*
  (new circle%))

(define *ci2*
  (new circle%
       [radius 2]
       [center (cons 2 3)]))

(define *ci3*
  (new circle%
       [radius 1]
       [center (cons 1 1)]))

(define *ci4*
  (new circle%
       [radius 3]
       [center (cons 0 -4)]))

(define *ci5*
  (new circle%
       [radius 2]
       [center (cons -5 -4)]))

(define *ci6*
  (new circle%
       [radius 1]
       [center (cons -5 -4)]))

;_________________________________________________
;_________________________________________________
;----Defining procedures used in the main ones----
;_________________________________________________
;_________________________________________________


;Takes a rectangle and returns 2 axes perpendicular
;to its sides as a pair.
(define ($Find_Perpendicular_Axes rectangle_object)
  
  ;retrieving the necessary corners to make the axes.
  (let ([tr_corner_x (car (send rectangle_object $Get_Tr_Corner))]
        [tr_corner_y (cdr (send rectangle_object $Get_Tr_Corner))]
        [tl_corner_x (car (send rectangle_object $Get_Tl_Corner))]
        [tl_corner_y (cdr (send rectangle_object $Get_Tl_Corner))]
        [br_corner_x (car (send rectangle_object $Get_Br_Corner))]
        [br_corner_y (cdr (send rectangle_object $Get_Br_Corner))])
    
    (let (
          ;goes from the left side to the right,(parallel to the top and bottom side)
          [axis_lr (cons (- tr_corner_x tl_corner_x)
                         (- tr_corner_y tl_corner_y))]
          ;goes from the bottom to the top,(parallel to the left and right side) 
          [axis_bt (cons (- tr_corner_x br_corner_x)
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
  (let* ([x_1 (car line_point_1)]
         [y_1 (cdr line_point_1)]
         [x_2 (car line_point_2)]
         [y_2 (cdr line_point_2)]
         [x_main (car main_point)]
         [y_main (cdr main_point)]
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
;-------------Main collision procedures-----------
;_________________________________________________
;_________________________________________________



#|
Here the 3 collision-decector types are defined:

1. circle-circle collision

2. rectangle-rectangle collision

3. rectangle-circle collision

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

;Returns #t if 2 circles overlap. else #f.
(define ($Circle_Collision? circle_1 circle_2)
  (let ([distance ($Vector_Length ($Vector_Create
                                   (send circle_1 $Get_Center)
                                   (send circle_2 $Get_Center)))])
    (< distance (+ (send circle_1 $Get_Radius)
                   (send circle_2 $Get_Radius)))))

;_________________________________________________

;Returns #t if 2 rectangles overlap, else #f.
(define ($Rectangle_Collision?
         rectangle_a
         rectangle_b)

  (let ([perpendicular_axes_obj_a ($Find_Perpendicular_Axes rectangle_a)])

    ;Checks if their projections on the perpendicular axes to 1
    ;of the rectangles overlap.
    (and ($Projection_Overlap?
          (car perpendicular_axes_obj_a) rectangle_a rectangle_b)
         ($Projection_Overlap?
          (cdr perpendicular_axes_obj_a) rectangle_a rectangle_b))))

;_________________________________________________

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

