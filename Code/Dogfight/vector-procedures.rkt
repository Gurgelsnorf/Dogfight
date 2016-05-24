#lang racket

(provide (all-defined-out))




;Here, all vector-procedures are defined.


;_________________________________________________
;_________________________________________________
;----------------Vector Procedures----------------
;_________________________________________________
;_________________________________________________

;Creates a vector.
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
;Vector multiplication with a real number.
(define ($Vector_Multiplication real_numb vector)
  (cons (* (car vector) real_numb) (* (cdr vector) real_numb)))

;_________________________________________________
;Vector addition with a another vector.
(define ($Vector_Addition vector_1 vector_2)
  (cons (+ (car vector_1) (car vector_2)) (+ (cdr vector_1) (cdr vector_2))))


;_________________________________________________
;Returns the length of a vector.
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
;Returns the orthogonal complement given a vector and a base vector.
(define ($Vector_Ortagonal vector_1 vector_base)
  ($Vector_Addition vector_1 ($Vector_Multiplication ($Vector_Projection vector_1 vector_base) -1)))


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

;Takes 2 points and returns the point in the middle between them.
(define ($Calculate_Center_Of_Gravity point_1 point_2)
  ($Vector (/ (+ ($Vector_Get_X point_1) ($Vector_Get_X point_2) 2))
           (/ (+ ($Vector_Get_Y point_1)  ($Vector_Get_Y point_2) 2))))

;_________________________________________________
  


