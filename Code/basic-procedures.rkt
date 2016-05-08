;Note, should be renamed to "basic_procedures.rkt", but needs to be
;renamed everywhere where it is required!
;This is because i(marcus) placed $Last_eElement_List
;here, thought it was better than having separate files
;for different types of basic procedures used everywhere.

#lang racket
(provide (all-defined-out))




;_________________________________________________
;_________________________________________________
;----------------Vector Procedures----------------
;_________________________________________________
;_________________________________________________

;Creates a vector
(define ($Vector x y)
  (cons x y))

;Returns the X-value of a vector.
(define ($Vector_Get_X vector)
  (car vector))

;Returns the Y-value of a vector.
(define ($Vector_Get_Y vector)
  (cdr vector))




;_________________________________________________
;Returns a vector between a start point and an end point.
(define ($Vector_Create start_point end_point)
  ($Vector_Addition end_point ($Vector_Multiplication -1 start_point)))

;_________________________________________________
;Vector multiplication with a real number and returns the new vector.
(define ($Vector_Multiplication real_numb vector)
  (cons (* (car vector) real_numb) (* (cdr vector) real_numb)))

;_________________________________________________
;Vector addition with a another vector and returns the new vector.
(define ($Vector_Addition vector_1 vector_2)
  (cons (+ (car vector_1) (car vector_2)) (+ (cdr vector_1) (cdr vector_2))))


;_________________________________________________
;Returns the length of a given vector.
(define ($Vector_Length vector)
  (sqrt (+ (sqr (car vector)) (sqr (cdr vector)))))


;_________________________________________________
;Returns the dot product of 2 vectors.
(define ($Vector_Dot_Product vector_1 vector_2)
  (+ (* (car vector_1) (car vector_2)) (* (cdr vector_1) (cdr vector_2))))


;_________________________________________________
;Projects a vector on another one.
(define ($Vector_Projection vector_proj vector_base)
  ($Vector_Multiplication
   (/ ($Vector_Dot_Product vector_proj vector_base)
      (sqr ($Vector_Length vector_base)))
   vector_base))


;_________________________________________________
;Returns the Orthogonal complement given a vector and a base vector.
(define ($Vector_Ortagonal vector_1 vector_base)
  ($Vector_Addition vector_1 ($Vector_Multiplication ($Vector_Projection vector_1 vector_base) -1)))


;_________________________________________________
;Returns the Parallel vector and orthogonal vector as
;a pair in given order based on another vector
(define ($Vector_Base_Split vector_1 vector_base)
  (cons ($Vector_Projection vector_1 vector_base)
        ($Vector_Ortagonal vector_1 vector_base)))

;_________________________________________________
;Takes 2 points and return their absolute distance.
(define ($Point_Distance point_1 point_2)
  ($Vector_Length ($Vector_Create point_1 point_2)))



;_________________________________________________
;Rotates a vector based on an angle
(define ($Single_Vector_Rotation vector angle)
  ($Vector (- (* ($Vector_Get_X vector) (cos angle))
              (* ($Vector_Get_Y vector) (sin angle)))
           (+ (* ($Vector_Get_Y vector) (cos angle))
              (* ($Vector_Get_X vector) (sin angle)))))

;_________________________________________________
;_________________________________________________
;---------Miscellaneous Basic Procedures----------
;_________________________________________________
;_________________________________________________

;Takes 2 opposing corners of a rectangle and returns
;the center of gravity for that rectangle.
(define ($Calculate_Center_Of_Gravity projected_bl_corner projected_tr_corner)
  ($Vector (/ (+ ($Vector_Get_X projected_bl_corner) ($Vector_Get_X projected_tr_corner) 2))
           (/ (+ ($Vector_Get_Y projected_bl_corner)  ($Vector_Get_Y projected_tr_corner) 2))))

;_________________________________________________

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
  


