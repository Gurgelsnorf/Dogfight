#lang racket
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
(define £c6_tl (cons 4 6))
(define £c6_tr (cons 4 12))

(define £c7_bl (cons 5 5))
(define £c7_br (cons 6 5))
(define £c7_tl (cons 5 6))
(define £c7_tr (cons 6 6))

(define £c8_bl (cons 9 7))
(define £c8_br (cons 12 7))
(define £c8_tl (cons 9 9))
(define £c8_tr (cons 12 9))
;_________________________________________________
;_________________________________________________
;A class for defining a rectangle box
(define rectangle-object%
  (class object%
    (init-field
     name       ;name tag for the rectangle 
     bl_corner  ;bottom-left coordinates
     br_corner  ;bottom-right coordinates
     tl_corner  ;top-left coordinates
     tr_corner) ;top-right coordinates
    
    (define/public ($Get_Bl_Corner) bl_corner)
    (define/public ($Get_Br_Corner) br_corner)
    (define/public ($Get_Tl_Corner) tl_corner)
    (define/public ($Get_Tr_Corner) tr_corner)
    (define/public ($Get_Name) name)
    (super-new)))
;_________________________________________________
;_________________________________________________
;Defining rectangle-objects for testing

(define *sq1* (new rectangle-object%
                   [name 'sq1]
                   [bl_corner £c1_bl]
                   [br_corner £c1_br]
                   [tl_corner £c1_tl]
                   [tr_corner £c1_tr]))

(define *sq2* (new rectangle-object%
                   [name 'sq2]
                   [bl_corner £c2_bl]
                   [br_corner £c2_br]
                   [tl_corner £c2_tl]
                   [tr_corner £c2_tr]))

(define *sq3* (new rectangle-object%
                   [name 'sq3]
                   [bl_corner £c3_bl]
                   [br_corner £c3_br]
                   [tl_corner £c3_tl]
                   [tr_corner £c3_tr]))

(define *sq4* (new rectangle-object%
                   [name 'sq4]
                   [bl_corner £c4_bl]
                   [br_corner £c4_br]
                   [tl_corner £c4_tl]
                   [tr_corner £c4_tr]))

(define *sq5* (new rectangle-object%
                   [name 'sq5]
                   [bl_corner £c5_bl]
                   [br_corner £c5_br]
                   [tl_corner £c5_tl]
                   [tr_corner £c5_tr]))

(define *sq6* (new rectangle-object%
                   [name 'sq6]
                   [bl_corner £c6_bl]
                   [br_corner £c6_br]
                   [tl_corner £c6_tl]
                   [tr_corner £c6_tr]))

(define *sq7* (new rectangle-object%
                   [name 'sq7]
                   [bl_corner £c7_bl]
                   [br_corner £c7_br]
                   [tl_corner £c7_tl]
                   [tr_corner £c7_tr]))

(define *sq8* (new rectangle-object%
                   [name 'sq8]
                   [bl_corner £c8_bl]
                   [br_corner £c8_br]
                   [tl_corner £c8_tl]
                   [tr_corner £c8_tr]))

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
(define ans ($Find_X_Collision *sq1* *sq2* *sq3* *sq4* *sq5* *sq6* *sq7* *sq8*))
;____________________________________________________________________________________



;Prints the list of collisions on the x-axis in a readable format.
(define ($Print_X_Collisions collisions)
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
