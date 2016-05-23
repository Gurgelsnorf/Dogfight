#lang racket/gui

(require "class-flying-entity.rkt")
(require "class-flying-unit-rectangular.rkt")

(require "world-init.rkt")
(require "vector-procedures.rkt")
(require "commands.rkt")

(require "class-input-canvas.rkt")

(provide *main_canvas*)


;Here, all graphics related procedures are defined, as
;well as the frames/canvases used.

;_________________________________________________

;Creates the main window
(define *main_window*

  ;For placing the window in the center of the screen.
  (let-values ([(screen_width screen_height) (get-display-size)])


    (new frame%
         [width 0]
         [height 0]
         [x (- (/ screen_width 2) 600)]
         [y (- (/ screen_height 2) 350)]
       [label "Dogfight!"]
       [style (list 'no-resize-border)])))



;Makes the main window appear
(send *main_window* show #t)


;_________________________________________________
;The paint callback procedure for rendering the world.

(define ($Render canvas dc)

  ;If the game hasn't started yet, the
  ;menu should be drawn.
  (if (not (send *world* $Game_Started?))
      (send dc draw-bitmap *menu_bitmap*
            0
            0)
      

      ;Retrieving the necessary variables.
      (let (
            [list_of_flying_units
             (send *world* $Get_Flying_Units)]
            [world_height (send *main_canvas* get-height)]
            [world_width (send *world* $Get_Width)]
            [active_players (send *world* $Get_Active_Players)])

        
        ;Drawing the background.
        (send dc draw-bitmap *background_bitmap*
              0
              0)
        
        
        ;_________________________________________________
        ;Drawing flags for all active players.
        (map (lambda (player)
               (let (
                     [flag_bl_corner_x($Vector_Get_X (send player $Get_Flag_Bl_Corner))]
                     [flag_bl_corner_y ($Vector_Get_Y (send player $Get_Flag_Bl_Corner))]
                     [flag_bitmap (send player $Get_Flag_Bitmap)])
                 
                 (send dc translate
                       flag_bl_corner_x
                       flag_bl_corner_y)
                 
                 (send dc draw-bitmap
                       flag_bitmap
                       0
                       0)
                 
                 (send dc translate
                       (- flag_bl_corner_x)
                       (- flag_bl_corner_y))))
             
             active_players)

        
        ;Paints all flying units 1 by 1.
        (map (lambda (flying_unit)

               ;Drawing rectangular units.
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

                   ;Drawing circular units.
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
        
        ;Drawing the corpses, if any.
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
                           
                           (set! angle (/ (* pi (send flying_unit $Get_Direction)) 16))))
                     
                     
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
             (send *world* $Get_Corpses)))))



;_______________________________________________________
;Create a keyboard event that will define what happens on a key press.

(define ($Airplane_Key_Controlls_Handler event)
  (let (
        [£Key_Code (send event get-key-code)]
        [£Key_Release_Code (send event get-key-release-code)])

    ;If the game has started, all controls are avaliable.
    (if (send *world* $Game_Started?)

        (begin

          ;When a key is pressed down, a variable is set to #t
          ;that stay like that until the key is released.
          (cond
              [(eq? £Key_Code 'left) (send *player_1* $Set_Activate_Turn_Left #t)]
              [(eq? £Key_Code 'right) (send *player_1* $Set_Activate_Turn_Right #t)]
              [(eq? £Key_Code 'up) (send *player_1* $Set_Activate_Shoot #t)]
              [(eq? £Key_Code 'down) ($Spawn_Player *player_1*)]
              
              [(eq? £Key_Code #\a) (send *player_2* $Set_Activate_Turn_Left #t)]
              [(eq? £Key_Code #\d) (send *player_2* $Set_Activate_Turn_Right #t)]
              [(eq? £Key_Code #\w) (send *player_2* $Set_Activate_Shoot #t)]
              [(eq? £Key_Code #\s) ($Spawn_Player *player_2*)]
              
              [(eq? £Key_Code #\l) (send *player_3* $Set_Activate_Turn_Left #t)]
              [(eq? £Key_Code #\ä) (send *player_3* $Set_Activate_Turn_Right #t)]
              [(eq? £Key_Code #\p) (send *player_3* $Set_Activate_Shoot #t)]
              [(eq? £Key_Code #\ö) ($Spawn_Player *player_3*)]
              
              [(eq? £Key_Code #\g) (send *player_4* $Set_Activate_Turn_Left #t)]
              [(eq? £Key_Code #\j) (send *player_4* $Set_Activate_Turn_Right #t)]
              [(eq? £Key_Code #\y) (send *player_4* $Set_Activate_Shoot #t)]
              [(eq? £Key_Code #\h) ($Spawn_Player *player_4*)]
              
              [(eq? £Key_Code 'escape) (send *world*  $Set_Game_Paused #t)]
              [(eq? £Key_Code #\space) (if (send *world* $Game_Started?)
                                           (when (and (not (send *world* $Game_Over?))
                                                      (send *world* $Game_Paused?))
                                             (send *world* $Set_Game_Paused #f))
                                           
                                           (begin (send *world* $Set_Game_Started #t)
                                                  (send *world* $Set_Game_Paused #f)))])


          ;When released, the variable is set to #f again.
          (cond
            [(eq? £Key_Release_Code 'left) (send *player_1* $Set_Activate_Turn_Left #f)]
            [(eq? £Key_Release_Code 'right) (send *player_1* $Set_Activate_Turn_Right #f)]
            [(eq? £Key_Release_Code 'up) (send *player_1* $Set_Activate_Shoot #f)]
            
            [(eq? £Key_Release_Code #\a) (send *player_2* $Set_Activate_Turn_Left #f)]
            [(eq? £Key_Release_Code #\w) (send *player_2* $Set_Activate_Shoot #f)]
            [(eq? £Key_Release_Code #\d) (send *player_2* $Set_Activate_Turn_Right #f)]
            
            [(eq? £Key_Release_Code #\l) (send *player_3* $Set_Activate_Turn_Left #f)]
            [(eq? £Key_Release_Code #\p) (send *player_3* $Set_Activate_Shoot #f)]
            [(eq? £Key_Release_Code #\ä) (send *player_3* $Set_Activate_Turn_Right #f)]
            
            [(eq? £Key_Release_Code #\g) (send *player_4* $Set_Activate_Turn_Left #f)]
            [(eq? £Key_Release_Code #\y) (send *player_4* $Set_Activate_Shoot #f)]
            [(eq? £Key_Release_Code #\j) (send *player_4* $Set_Activate_Turn_Right #f)]))


        ;If the game hasn't begun(main menu), only
        ;space is avaliable for pressing, to start the game.
        (when (eq? £Key_Code #\space)
          (send *world* $Set_Game_Started #t)
          (send *world* $Set_Game_Paused #f)))))
                                      

;_________________________________________________
    
    ;Defining the canvas in which flying units are drawn.
    (define *main_canvas*
      (new input-canvas-key%
           [parent *main_window*]
           [min-height (send *world* $Get_Height)]
           [min-width (send *world* $Get_Width)]
           [horiz-margin 0]
           [vert-margin 0]
           [key-handler $Airplane_Key_Controlls_Handler]
           [paint-callback $Render]))
    


;The Coordinate-system is set so that x is right and y is up on the screen.
    (send (send *main_canvas* get-dc) set-scale 1 -1)
    (send (send *main_canvas* get-dc) set-origin 0 (send *main_canvas* get-height))