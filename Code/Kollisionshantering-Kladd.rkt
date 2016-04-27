#lang racket
(require "Basic-vector-functions.rkt")
(require racket/trace)
;_________________________________________________
;Corners for testing collision
;c1_bl = corner 1, bottom left
;c3_tr = corner 3, top right
;etc...
;Structured like: (X-coordinate . Y-coordinate)
(define £c1_bl (cons 2 2))
(define £c1_br (cons 6 2))
(define £c1_tl (cons 2 6))
(define £c1_tr (cons 6 6))

(define £c2_bl (cons 1 1))
(define £c2_br (cons 3 1))
(define £c2_tl (cons 1 3))
(define £c2_tr (cons 3 3))

(define £c3_bl (cons 1 7))
(define £c3_br (cons 2 7))
(define £c3_tl (cons 1 9))
(define £c3_tr (cons 2 9))

(define £c4_bl (cons 10 2))
(define £c4_br (cons 11 2))
(define £c4_tl (cons 10 3))
(define £c4_tr (cons 11 3))

(define £c5_bl (cons 5 1))
(define £c5_br (cons 8 1))
(define £c5_tl (cons 5 7))
(define £c5_tr (cons 8 7))

(define £c6_bl (cons 6 2))
(define £c6_br (cons 12 2))
(define £c6_tl (cons 6 4))
(define £c6_tr (cons 12 4))

(define £c7_bl (cons 5 5))
(define £c7_br (cons 6 5))
(define £c7_tl (cons 5 6))
(define £c7_tr (cons 6 6))

(define £c8_bl (cons 7 7))
(define £c8_br (cons 12 7))
(define £c8_tl (cons 7 9))
(define £c8_tr (cons 12 9))

(define £c9_bl (cons 3 5))
(define £c9_br (cons 7 7))
(define £c9_tl (cons 2 7))
(define £c9_tr (cons 6 9))

(define £c10_bl (cons 7 7))
(define £c10_br (cons 10 8.5))
(define £c10_tl (cons 6 9))
(define £c10_tr (cons 9 10.5))

(define £c11_bl (cons 5 1))
(define £c11_br (cons 6 2))
(define £c11_tl (cons 4 2))
(define £c11_tr (cons 5 3))
;_________________________________________________
;_________________________________________________
;A class for defining a rectangle object
(define rectangle-object%
  (class object%
    (init-field
     name       ;name tag for the rectangle 
     bl_corner  ;bottom-left coordinate
     br_corner  ;bottom-right coordinate
     tl_corner  ;top-left coordinate
     tr_corner) ;top-right coordinate
    
    ;Retreiveing the variables for hte object
    (define/public ($Get_Bl_Corner) bl_corner)
    (define/public ($Get_Br_Corner) br_corner)
    (define/public ($Get_Tl_Corner) tl_corner)
    (define/public ($Get_Tr_Corner) tr_corner)
    (define/public ($Get_Name) name)
    (super-new)))
;_________________________________________________
;_________________________________________________
;Defining rectangle-objects for testing

(define *re1* (new rectangle-object%
                   [name 're1]
                   [bl_corner £c1_bl]
                   [br_corner £c1_br]
                   [tl_corner £c1_tl]
                   [tr_corner £c1_tr]))

(define *re2* (new rectangle-object%
                   [name 're2]
                   [bl_corner £c2_bl]
                   [br_corner £c2_br]
                   [tl_corner £c2_tl]
                   [tr_corner £c2_tr]))

(define *re3* (new rectangle-object%
                   [name 're3]
                   [bl_corner £c3_bl]
                   [br_corner £c3_br]
                   [tl_corner £c3_tl]
                   [tr_corner £c3_tr]))

(define *re4* (new rectangle-object%
                   [name 're4]
                   [bl_corner £c4_bl]
                   [br_corner £c4_br]
                   [tl_corner £c4_tl]
                   [tr_corner £c4_tr]))

(define *re5* (new rectangle-object%
                   [name 're5]
                   [bl_corner £c5_bl]
                   [br_corner £c5_br]
                   [tl_corner £c5_tl]
                   [tr_corner £c5_tr]))

(define *re6* (new rectangle-object%
                   [name 're6]
                   [bl_corner £c6_bl]
                   [br_corner £c6_br]
                   [tl_corner £c6_tl]
                   [tr_corner £c6_tr]))

(define *re7* (new rectangle-object%
                   [name 're7]
                   [bl_corner £c7_bl]
                   [br_corner £c7_br]
                   [tl_corner £c7_tl]
                   [tr_corner £c7_tr]))

(define *re8* (new rectangle-object%
                   [name 're8]
                   [bl_corner £c8_bl]
                   [br_corner £c8_br]
                   [tl_corner £c8_tl]
                   [tr_corner £c8_tr]))

(define *re9* (new rectangle-object%
                   [name 're9]
                   [bl_corner £c9_bl]
                   [br_corner £c9_br]
                   [tl_corner £c9_tl]
                   [tr_corner £c9_tr]))

(define *re10* (new rectangle-object%
                    [name 're10]
                    [bl_corner £c10_bl]
                    [br_corner £c10_br]
                    [tl_corner £c10_tl]
                    [tr_corner £c10_tr]))

(define *re11* (new rectangle-object%
                    [name 're11]
                    [bl_corner £c11_bl]
                    [br_corner £c11_br]
                    [tl_corner £c11_tl]
                    [tr_corner £c11_tr]))
;_________________________________________________
;_________________________________________________
;A procedure that finds if the given rectangle objects collide when projected on
;the x-axis. After this procedure is used, another one is needed to check if
;they collide on the y-axis, and if they do the objects have collided in the 2d plane.

;The output looks as follows:
;(list (cons object1 object2) <-- object 1 and 2 have collided on the x-axis.
;      (cons object3 object4) <-- 3 and 4 aswell.
;      (cons object4 object6) <-- object 4 has also collided with object 6.
;      ...)                   <-- etc...

;The procedure uses the so called "Sort and Sweep Algorithm". Firstly, it defines
;the leftmost x-value of an object with a 'b for beggining, and with an 's for stop
;for the rightmost x-value. These are then sorted ascending and placed in a list,
;and then the procedure goes through the whole list in order. If a new object starts
;before another ends, a collision has occured.
(define ($Find_X_Collision . objects)
  (let ([colliding_objects '()] ;Saves the list of collisions.
        [active_intervals '()]  ;Saves all currently open intervals('b but not 's).
        
        ;a sorted list of all staring points('s). the point is also tagged and saved as:
        ;(list object tag['s/'b] x-coordinate) 
        [start_points (sort
                       (map (lambda (element) (list element 's (car (send element $Get_Bl_Corner))))
                            objects)
                       (lambda (element_1 element_2) (< (caddr element_1) (caddr element_2))))]
        
        ;same as start_points but for end points.
        [end_points (sort
                     (map (lambda (element) (list element 'e (car (send element $Get_Br_Corner))))
                          objects)
                     (lambda (element_1 element_2) (< (caddr element_1) (caddr element_2))))])
    
    ;all the points are collected into 1 list.
    (let ([intervals (sort (append start_points end_points)
                           (lambda (element_1 element_2) (< (caddr element_1) (caddr element_2))))])
      
      
      
      ;Loop that goes through all points.
      (define (loop)
        (if (null? intervals) colliding_objects  ;end if all points are tested
            
            ;info is separated about the object. 
            (let ([current_object (caar intervals)]
                  [object_tag (cadar intervals)]
                  [object_coordinate (caddr (car intervals))])
              
              ;__________________________________________
              ;For easier testing, will be removed later!
              (printf "~%~%Current object: ")
              (display (send current_object $Get_Name));
              (printf "~%Object tag: ")
              (display object_tag)
              (printf "~%Object coordinate: ")
              (display object_coordinate)
              (printf "~%---------~%")
              ;__________________________________________
              
              
              (cond
                ;If its a start point, add it to active intervals and move on.
                [(equal? object_tag 's) 
                 (set! active_intervals
                       (cons (car intervals) active_intervals))
                 (set! intervals
                       (cdr intervals))
                 (loop)]
                
                ;If it's an end point
                [else
                 (set! colliding_objects ;Adds new collisions if there are any.
                       (append
                        (map
                         (lambda (element) (cons current_object (car element))) 
                         (filter ;removes the active intervals that shouldn't collide
                          (lambda (element) (and
                                             (not (eq? ;cant collide with itself
                                                   current_object
                                                   (car element)))
                                             (not (eq? ;same x-values means no collision.
                                                   object_coordinate
                                                   (caddr element)))))
                          active_intervals))
                        colliding_objects))
                 
                 ;Update active intervals and list of intervals and run again.
                 (set! active_intervals (filter
                                         (lambda (element) (not (eq?
                                                                 current_object
                                                                 (car element))))
                                         active_intervals))
                 (set! intervals (cdr intervals))
                 (loop)]))))
      (loop))))


;_____________________________________________________________________________________
;Used for testing, will be removed later!
(define ans ($Find_X_Collision *re1* *re2* *re3* *re4* *re5* *re6* *re7* *re8*))
;____________________________________________________________________________________





;Takes the result of ($Find_X_Collision) as an argument and returns a list
;with all full collisions(x and y-axis, so identified as a true collision).
(define ($Find_Full_Collision x_collisions)
  (filter (lambda (element)
            (let ([ymin_obj1 (cdr (send (car element) $Get_Bl_Corner))]
                  [ymax_obj1 (cdr (send (car element) $Get_Tl_Corner))]
                  [ymin_obj2 (cdr (send (cdr element) $Get_Bl_Corner))]
                  [ymax_obj2 (cdr (send (cdr element) $Get_Tl_Corner))])
              (not (or (>= ymin_obj2 ymax_obj1) (<= ymax_obj2 ymin_obj1)))))
          x_collisions))



;Prints the list of collisions in a readable format, works for both
;full collisions and only on the x-axis.
(define ($Print_Collisions collisions)
  (let ([counter 1])
    (printf "Collision #   obj1    obj2~%~%")
    (map (lambda (element)
           (printf "    ")
           (display counter)
           (printf "         ")
           (display (send (car element) $Get_Name))
           (printf "     ")
           (display (send (cdr element) $Get_Name))
           (printf "~%~%")
           (set! counter (+ counter 1)))
         collisions))
  (void))


;Returns the last element of a list
(define ($Last_Element_List arg_list)
  (let ([rest_of_list arg_list]
        [list_length (length arg_list)])
    (cond [(null? list_length)
           (raise-arguments-error 'last-element
                                  "You cant enter a list with no elements!")]
          [else (define (loop)
                  (if (= list_length 1)
                      (car rest_of_list)
                      (begin (set! rest_of_list (cdr rest_of_list))
                             (set! list_length (- list_length 1))
                             (loop))))
                (loop)])))



;Takes a rectangle object and returns 2 axes perpendicular to its sides. 
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





#|
Takes 2 rectangle objects and returns #t if they have collided,
else #f.

//It uses SAT(separating axes theorem) to find if a collision har occured:

1. Find the perpendicular axes to 1 of the rectangles.

2. Project all corners from both rectangles on the axes, one at a time.

3. Take the dot product between the projections and the projection axis to
   find which projection goes furthest and shortest. for both rectangles.

4. Compare these values, collision has occured if:
   min(rectangle b) < max(rectangle a)
   min(rectangle a) < max(rectangle b)

5. Repeat for the second axis. Collision has occured if both axis returns true.

NOTE: If one axis shows no collision, that is enough to fully decide that no
   collision has occured, and the procedure won't check the next one.//
|#
(define ($Rectangle_Collision? rectangle_a rectangle_b)
  (let ([perpendicular_axes_obj_a ($Find_Perpendicular_Axes rectangle_a)])
    (and ($Projection_Overlap?
          (car perpendicular_axes_obj_a) rectangle_a rectangle_b)
         ($Projection_Overlap?
          (cdr perpendicular_axes_obj_a) rectangle_a rectangle_b))))



;Takes an axis, some projections on that axis, then takes the dot product between
;the projections and the axis. The max and min of these values are then returned as
;a pair.
(define ($Find_Max_Min_Projection_Scalar axis . projections)
  (let ([list_of_scalars
         (sort (map (lambda (vector) ($Vector_Dot_Product axis vector)) projections)
               <)])
    (let ([min_scalar (car list_of_scalars)]
          [max_scalar ($Last_Element_List list_of_scalars)])
      (cons min_scalar max_scalar))))



;Takes an axis and two rectangles and returns #t if their projections
;overlap on that axis, else #f.
(define ($Projection_Overlap? axis main_rectangle second_rectangle)
  
  ;Projections on the given axis.
  (let (
        ;Since the axis is perpendicular to the first(main) rectangle,
        ;only 2 projections are needed since they 
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
                        axis)])
    
    (let ([min_max_scalar_a ($Find_Max_Min_Projection_Scalar
                             axis
                             proj_main_1
                             proj_main_2)]
          
          [min_max_scalar_b ($Find_Max_Min_Projection_Scalar
                             axis
                             proj_second_1
                             proj_second_2
                             proj_second_3
                             proj_second_4)])
      
      (let ([min_scalar_a (car min_max_scalar_a)]
            [max_scalar_a (cdr min_max_scalar_a)]
            [min_scalar_b (car min_max_scalar_b)]
            [max_scalar_b (cdr min_max_scalar_b)])
        
        (and (< min_scalar_b max_scalar_a)
             (< min_scalar_a max_scalar_b))))))


(define ($Point_In_Rectangle? point br_corner bl_corner tr_corner)
  (let* ([vector_br_p ($Vector_Create br_corner point)]
         [vector_br_bl ($Vector_Create br_corner bl_corner)]
         [vector_br_tr ($Vector_Create br_corner tr_corner)]
         
         [comparison_value_1 ($Vector_Dot_Product vector_br_p vector_br_bl)]
         [comparison_value_2 ($Vector_Dot_Product vector_br_p vector_br_tr)])
    
    (and (< 0 comparison_value_1)
         (< comparison_value_1 ($Vector_Dot_Product vector_br_bl vector_br_bl))
         (< 0 comparison_value_2)
         (< comparison_value_2 ($Vector_Dot_Product vector_br_tr vector_br_tr)))))

(define ($Circle_Collision? circle_1 circle_2)
  (let ([distance ($Vector_Length ($Vector_Create
                                   (send circle_1 $Get_Center)
                                   (send circle_2 $Get_Center)))])
    (< distance (+ (send circle_1 $Get_Radius)
                   (send circle_2 $Get_Radius)))))

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

(define ($Rectangle_Circle_Collision? rectangle circle)
  (let* ([circle_center (send circle $Get_Center)]
         [circle_radius (send circle $Get_Radius)]
         [rec_br_corner (send rectangle $Get_Br_Corner)]
         [rec_bl_corner (send rectangle $Get_Bl_Corner)]
         [rec_tr_corner (send rectangle $Get_Tr_Corner)]
         [rec_tl_corner (send rectangle $Get_Tl_Corner)])
    
    (or ($Point_In_Rectangle? circle_center
                              rec_br_corner
                              rec_bl_corner
                              rec_tr_corner)
        (let ([ x (filter
                   (lambda (corner) (< ($Vector_Length
                                        ($Vector_Create corner circle_center))
                                       circle_radius))
                   (list rec_br_corner
                         rec_bl_corner
                         rec_tr_corner
                         rec_tl_corner))])
          (display x)
          (not (null? x)))
        
        
        (let ([y (filter
                  (lambda (line_center_distance)
                    (> circle_radius line_center_distance))
                  
                  (map
                   (lambda (corner_pair)
                     ($Distance_Line_Point
                      (car corner_pair)
                      (cdr corner_pair)
                      circle_center))
                   (list (cons rec_br_corner rec_bl_corner)
                         (cons rec_br_corner rec_tr_corner)
                         (cons rec_tr_corner rec_tl_corner)
                         (cons rec_bl_corner rec_tl_corner))))])
          (display y)
          (not (null? y))))))



(define  ($Distance_Line_Point line_point_1 line_point_2 main_point)
  (let* ([x_1 (car line_point_1)]
         [y_1 (cdr line_point_1)]
         [x_2 (car line_point_2)]
         [y_2 (cdr line_point_2)]
         [x_main (car main_point)]
         [y_main (cdr main_point)]
         [delta_x (- x_2 x_1)]
         [delta_y (- y_2 y_1)])
    
    (/ (abs (+
             (* delta_y x_main)
             (* -1 delta_x y_main)
             (* x_2 y_1)
             (* -1 y_2 x_1)))
       (sqrt (+
              (sqr delta_y)
              (sqr delta_x))))))

(trace $Rectangle_Circle_Collision?)
(trace $Point_In_Rectangle?)
(trace $Distance_Line_Point)