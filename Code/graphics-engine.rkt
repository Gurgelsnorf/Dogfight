#lang racket/gui
(require "collisions.rkt")
(require "world-init.rkt")
(require "basic-vector-functions.rkt")

; Skapar fönster
(define *main_window*
  (new frame%
       [width 600]
       [height 400]
       [label "Detta är ett fönster"]))

; Gör fönstret synligt
(send *main_window* show #t)


#|
(define x 0)
(define (toggle-x)
  (if (= x 0)
      (set! x 1)
      (set! x 0)))

(define ($Render_Square canvas dc)
  (if (= x 0)
      (send dc set-brush "red" 'solid)
      (send dc set-brush "blue" 'solid))
  (send dc draw-rectangle  100 100 200 200))


|#


#||#
(define ($Render_Flying canvas dc)
  (let (
        [list_of_flying_units
         (send *world* $Get_Flying_Units)]
        [brush_color "red"])
          
    ;(send dc scale 1 -1)
    ;(send dc translate 0 -400)
    
    (map (lambda (flying_unit)
           (send dc set-origin 0 (send *edge* get-height))
           (send dc set-scale 1 -1)
           (let* (
                  [tl_corner (send flying_unit $Get_Tl_Corner)]
                  [tr_corner (send flying_unit $Get_Tr_Corner)]
                  [bl_corner (send flying_unit $Get_Bl_Corner)]
                  [tl_x (car tl_corner)]
                  [tl_y (cdr tl_corner)]
                  [height ($Point_Distance tl_corner bl_corner)]
                  [width ($Point_Distance tl_corner tr_corner)])

             (cond
               [(equal? brush_color "red") (set! brush_color "blue")]
               [(equal? brush_color "blue") (set! brush_color "green")]
               [else (set! brush_color "red")])

             (send dc set-brush brush_color 'solid)    
             (send dc draw-rectangle tl_x tl_y width height)))
         
         list_of_flying_units)

    (send dc set-origin 0 (* -1 (send *edge* get-height)))
    (send dc set-scale 1 -1)))






(define *edge*
  (new canvas%
       [parent *main_window*]
       [horiz-margin 20]
       [vert-margin 20]
       [style '(border)]
       [paint-callback $Render_Flying]))