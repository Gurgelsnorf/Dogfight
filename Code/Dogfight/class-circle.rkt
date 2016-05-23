#lang racket

(provide circle%)



;Defines the class circle.

(define circle%
  (class object%

    (init-field

     ;The circle has a center, a radius and a bitmap.
     center_of_gravity
     radius
     bitmap)


;_________________________________________________

    ;Retrieving the variables of the object.
    (define/public ($Get_Center_Of_Gravity)
      center_of_gravity)
    (define/public ($Get_Radius)
      radius)
    (define/public ($Get_Bitmap)
      bitmap)


;_________________________________________________
    
    ;Setting the variables of the object.
    (define/public ($Set_Center_Of_Gravity new_center)
      (set! center_of_gravity new_center))
    
    (define/public ($Set_Radius new_radius)
      (set! radius new_radius))

    (super-new)))