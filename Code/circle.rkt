#lang racket

(provide circle%)



;Defines the class circle.
(define circle%
  (class object%

    (init-field

     center
     radius
     [bitmap 'no-bitmap-choosen!])


;_________________________________________________

    ;Retrieving the variables of the object.
    (define/public ($Get_Center)
      center)
    (define/public ($Get_Radius)
      radius)
    (define/public ($Get_Bitmap)
      bitmap)


;_________________________________________________
    
    ;Setting the variables of the object.
    (define/public ($Set_Center new_center)
      (set! center new_center))
    
    (define/public ($Set_Radius new_radius)
      (set! radius new_radius))



    (super-new)))