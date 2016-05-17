#lang racket/gui
(require "world-init.rkt")
(require "basic-procedures.rkt")
(require "player-commands.rkt")
(require "physics-engine.rkt")
(require "flying-unit-rectangular.rkt")
(require "input-canvas.rkt")



(provide *flying_units*)
(provide (all-defined-out))

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
                           "grafik/test-background.png"
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
    
    
    ;Draws a box to indicate the worldsize to show when collision has occured. 
    (send dc set-pen "DeepPink" 2 'long-dash)
    (send dc draw-line 0 0 world_width 0)
    (send dc draw-line 0 0 0 world_height)
    (send dc draw-line 0 world_height world_width world_height)
    (send dc draw-line world_width 0 world_width world_height)))



;_______________________________________________________
;Create a keyboard event that will define what happens on a key press

(define ($Airplane_Key_Controlls_Handler event)
  (let
      ((£Key_Code (send event get-key-code))
       (£Key_Release_Code (send event get-key-release-code)))
    (cond
      ((eq? £Key_Code 'left) (printf "left ~n"))
      ((eq? £Key_Code 'right) (send *player_1* $Set_Turn_Right_Allowed #t))
      ((eq? £Key_Code 'up) (send *player_1* $Set_Shoot_Allowed #t))
      ((eq? £Key_Code 'a) (send *player_2* $Set_Turn_Left_Allowed #t))
      ((eq? £Key_Code 'd) (send *player_2* $Set_Turn_Right_Allowed #t))
      ((eq? £Key_Code 's) (send *player_2* $Set_Shoot_Allowed #t))
      ((eq? £Key_Code 'r) (send *start_clock* $Set_Clock_Run #t))
      ((eq? £Key_Code 'escape) (send *start_clock* $Set_Clock_Run #f)))    
    (cond
      ((eq? £Key_Release_Code 'left) (send *player_1* $Set_Turn_Left_Allowed #f))
      ((eq? £Key_Release_Code 'right) (send *player_1* $Set_Turn_Right_Allowed #f))
      ((eq? £Key_Release_Code 'up) (send *player_1* $Set_Shoot_Allowed #f))
      ((eq? £Key_Release_Code 'a) (send *player_2* $Set_Turn_Left_Allowed #f))
      ((eq? £Key_Release_Code 's) (send *player_2* $Set_Turn_Right_Allowed #f))
      ((eq? £Key_Release_Code 'd) (send *player_2* $Set_Shoot_Allowed #f)))))


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
  (new input-canvas-key%
       [parent *main_window*]
       [min-height (send *world* $Get_Height)]
       [min-width (send *world* $Get_Width)]
       [horiz-margin 0]
       [vert-margin 0]
       [style '(border)]
       [key-handler $Airplane_Key_Controlls_Handler]
       [paint-callback $Render_Flying]))


(send (send *flying_units* get-dc) set-scale 1 -1)
(send (send *flying_units* get-dc) set-origin 0 (send *flying_units* get-height))