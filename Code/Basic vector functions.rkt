#lang racket

;Vector multiplication with a real number and returns the new vector
(define ($Vector_multiplication Vector Real_numb)
  (cons (* (car (Vector)) Real_numb) (* (cdr (Vector)) Real_numb)))

;Vector addition with a another vector and returns the new vector
(define ($Vector_addition Vector_u Vector_v)
  (cons (+ (car (Vector_u)) (car (Vector_u))) (+ (cdr (Vector_u)) (cdr (Vector_v)))))

;Scalar of two vectors and return the value
(define ($Vector_scalar Vector_u Vector_v)
  (cons (* (car (Vector_u)) (car (Vector_v))) (* (cdr (Vector_u)) (cdr (Vector_v)))))

;Projection on a another vector does not give an ortagonal vector!
(define ($Vector_projection Vector_u Vector_base)
  ($Vector_multiplication (Vector_base (/ ($Vector_scalar Vector_u Vector_base) (sqrt (+ (sqr (car (Vector_base))) (sqr (cdr (Vector_base))))))))) 

;Ortagonal element of the vector based on a another vector does not return the parallell element!
(define ($Vector_ortagonal Vector_u Vector_base)
  ($Vector_addition Vector_u ($Vector_multiplication ($Vector_projection Vector_u Vector_base) -1)))

;Returns the Parallell vector and ortagonal vector as a pair in given order based on another vector
(define ($Vector_base_split Vector_u Vector_base)
  (cons ($Vector_projection Vector_u Vector_base) ($Vector_ortagonal Vector_u Vector_base)))
        
        
        
        