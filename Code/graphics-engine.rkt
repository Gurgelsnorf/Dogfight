#lang racket/gui
(require "world-init.rkt")
(require "basic-procedures.rkt")
(require "player-commands.rkt")
(require "physics-engine.rkt")
(require "flying-unit-rectangular.rkt")

(provide *flying_units*)

(define x 0)
;Creates the main window
(define *main_window*
  (new frame%
       [width 0]
       [height 0]
       [label "Dogfight!"]))

;Makes the main window appear
(send *main_window* show #t)


;(send *main_window* maximize #t)
;(send *main_window* get-menu-bar)

;_________________________________________________
;The paint callback procedure for rendering flying
;units.

(define ($Render_Flying canvas dc)
  (let (
        [list_of_flying_units
         (send *world* $Get_Flying_Units)]
        [world_height (send *flying_units* get-height)]
        [world_width (send *world* $Get_Width)]
        [brush_color "red"])
    
    (send dc draw-bitmap (make-object bitmap%
                           "grafik/background.png"
                           'png/alpha)
          0
          0)
    
    ;Paints all flying units 1 by 1.
    (map (lambda (flying_unit)
           (if (is-a? flying_unit flying_unit_rectangular%)
               (begin
                 (let* (
                        [projected_bl_corner (send flying_unit $Get_Projected_Bl_Corner)]
                        [projected_bl_corner_x ($Vector_Get_X projected_bl_corner)]
                        [projected_bl_corner_y ($Vector_Get_Y projected_bl_corner)]
                        [angle (send flying_unit $Get_Angle)])
                   
                   (send dc translate
                         projected_bl_corner_x
                         projected_bl_corner_y)
                   (send dc rotate (- angle))
                   
                   (send dc draw-bitmap (send flying_unit $Get_Bitmap)
                         0
                         0)
                   
                   (send dc rotate angle)
                   (send dc translate
                         (- projected_bl_corner_x)
                         (- projected_bl_corner_y))))
               (begin (let* (
                             [center (send flying_unit $Get_Center_Of_Gravity)]
                             [center_x ($Vector_Get_X center)]
                             [center_y ($Vector_Get_Y center)])
                        
                        (send dc translate
                              center_x
                              center_y)
                        
                        (send dc draw-bitmap (send flying_unit $Get_Bitmap)
                              0
                              0)
                        
                        (send dc translate
                              (- center_x)
                              (- center_y))))))
         
         
         list_of_flying_units)
    
;_________________________________________________
    
    ;drawing the corpses, if any.
    (map (lambda (flying_unit)

           ;If the cooldown has run out, the corpse is removed
           ;from the world and isn't shown anymore
           (if (< (send flying_unit $Get_Corpse_Cooldown) 0)
               (send *world* $Delete_Corpse flying_unit)

               ;Otherwise, it will be printed.
              (let (
                    [bl_corner_x 0]
                    [bl_corner_y 0]
                    [angle 0])

                
                (if (is-a? flying_unit flying_unit_rectangular%)

                    ;Printing coordinates for rectangular units. 
                    (begin
                      (set! bl_corner_x
                            ($Vector_Get_X
                             (send flying_unit $Get_Projected_Bl_Corner)))

                      (set! bl_corner_y
                            ($Vector_Get_Y
                             (send flying_unit $Get_Projected_Bl_Corner)))

                      (set! angle (send flying_unit $Get_Angle)))

                    ;Printing coordinates for circular units.
                    (begin
                      (set! bl_corner_x
                            (- ($Vector_Get_X (send flying_unit $Get_Center_Of_Gravity))
                               (send flying_unit $Get_Radius)))
                      
                      (set! bl_corner_y
                            (- ($Vector_Get_Y (send flying_unit $Get_Center_Of_Gravity))
                               (send flying_unit $Get_Radius)))
                      
                      (set! angle (/ (* pi (send flying_unit $Get_Direction) 16)))))


                ;The cooldown for printing the corpse is counted down.
                ;If 0, the corpse won't be printed any more.
                (send flying_unit $Corpse_Cooldown)

                (send dc translate
                      bl_corner_x
                      bl_corner_y)
                
                (send dc rotate (- angle))

                (send dc draw-bitmap
                      (send flying_unit $Get_Kill_Bitmap)
                      0
                      0)

                (send dc rotate angle)
                (send dc translate
                      (- bl_corner_x)
                      (- bl_corner_y)))))
           
         ;Do this for all corpses.
         (send *world* $Get_Corpses))))


#|   
    ;Draws a box to indicate the worldsize to show when collision has occured. 
    (send dc set-pen "DeepPink" 2 'long-dash)
    (send dc draw-line 0 0 world_width 0)
    (send dc draw-line 0 0 0 world_height)
    (send dc draw-line 0 world_height world_width world_height)
    (send dc draw-line world_width 0 world_width world_height)))
|#

;_________________________________________________
;Can be used to test if the dc coordinates are changed
;correctly.

;        (define-values (x y) (send dc get-origin))
;             (printf "origin x:~n")
;            (display x)
;           (printf "~n~norigin y:~n")
;        (printf "~n~n scale x:~n")
;     (display z)
;       (printf "~n~n scale y:~n")
;      (display a)
;    (printf "~n~n rotation:~n")
; (display (send dc get-rotation))
;   (printf "~n~n transformation:~n")
;  (display (send dc get-transformation))
;(newline)
;_________________________________________________

;Defining the canvas in which flying units are drawn.
(define *flying_units*
  (new canvas%
       [parent *main_window*]
       [min-height (send *world* $Get_Height)]
       [min-width (send *world* $Get_Width)]
       [horiz-margin 0]
       [vert-margin 0]
       [style '(border)]
       [paint-callback $Render_Flying]))


(send (send *flying_units* get-dc) set-scale 1 -1)
(send (send *flying_units* get-dc) set-origin 0 (send *flying_units* get-height))