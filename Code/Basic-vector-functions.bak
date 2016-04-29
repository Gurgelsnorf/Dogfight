#lang racket
(provide (all-defined-out))

;Here, some basic vector operations are defined. 
;Vectors are defined like: (cons X-value Y-value)




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


