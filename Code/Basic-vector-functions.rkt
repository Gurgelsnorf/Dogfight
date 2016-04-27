#lang racket
(provide (all-defined-out))

(define ($Vector_Create start_point end_point)
  ($Vector_Addition end_point ($Vector_Multiplication -1 start_point)))

;Vector multiplication with a real number and returns the new vector
(define ($Vector_Multiplication real_numb vector)
  (cons (* (car vector) real_numb) (* (cdr vector) real_numb)))

;Vector addition with a another vector and returns the new vector
(define ($Vector_Addition vector_1 vector_2)
  (cons (+ (car vector_1) (car vector_2)) (+ (cdr vector_1) (cdr vector_2))))

;Returns the length of a given vector
(define ($Vector_Length vector)
  (sqrt (+ (sqr (car vector)) (sqr (cdr vector)))))

;Scalar of two vectors and return the value
(define ($Vector_Dot_Product vector_1 vector_2)
  (+ (* (car vector_1) (car vector_2)) (* (cdr vector_1) (cdr vector_2))))

;Projection on a another vector does not give an ortagonal vector!
(define ($Vector_Projection vector_proj vector_base)
  ($Vector_Multiplication (/ ($Vector_Dot_Product vector_proj vector_base) (sqr ($Vector_Length vector_base))) vector_base)) 

;Ortagonal element of the vector based on a another vector does not return the parallell element!
(define ($Vector_Ortagonal vector_1 vector_base)
  ($Vector_Addition vector_1 ($Vector_Multiplication ($Vector_Projection vector_1 vector_base) -1)))

;Returns the Parallel vector and ortagonal vector as a pair in given order based on another vector
(define ($Vector_Base_Split vector_1 vector_base)
  (cons ($Vector_Projection vector_1 vector_base) ($Vector_Ortagonal vector_1 vector_base)))