#lang racket/gui
(require "collisions.rkt")
(require "world-init.rkt")
(require "basic-procedures.rkt")
(require "player-commands.rkt")
(require "physics-engine.rkt")

;Creates the main window
(define *main_window*
  (new frame%
       [width 0]
       [height 0]
       [label "Detta är ett fönster"]))

;Makes the main window appear
(send *main_window* show #t)


;(send *main_window* maximize #t)
;(send *main_window* get-menu-bar)


;_________________________________________________
;Defines the class input-canvas%, which accepts inputs
;for making stuff happen in the canvas.

(define input-canvas%
  (class canvas%
    ; Vi lägger till ytterligare inargument
    ; (procedurer som vi själva måste skriva!)
    (init-field keyboard-handler) ; ska hantera tangentbord
    ; mouse-handler) ; ska hantera mus
    ; Vid ett knapptryck, anropa vår keyboard-handler
    (define/override (on-char key-event)
      (keyboard-handler key-event))
    (super-new)))



;_________________________________________________
;The paint callback procedure for rendering flying
;units. 
;This is just a test, and will be changed later!                NOTE

(define ($Render_Flying canvas dc)
  (let (
        [list_of_flying_units
         (send *world* $Get_Flying_Units)]
        [world_height (send *flying_units* get-height)]
        [world_width (send *world* $Get_Width)]
        [brush_color "red"])

    
    ;(send dc set-scale 1 -1)
    ;Paints all flying units
    (map (lambda (flying_unit)
           (let (
                 [bl_corner (send flying_unit $Get_Bl_Corner)]
                 [angle (send flying_unit $Get_Angle)])
             
             
             (let* ([bl_corner (send flying_unit $Get_Bl_Corner)]
                    [angle (send flying_unit $Get_Angle)])
               
               (send dc translate (car bl_corner) (cdr bl_corner))
               (send dc rotate angle)

               (send dc draw-bitmap (send flying_unit $Get_Bitmap)
                     0
                     0)

               (send dc rotate (- angle))
               (send dc translate (- (car bl_corner)) (- (cdr bl_corner)))
               (define-values (x y) (send dc get-origin))
               (printf "origin x:~n")
               (display x)
               (printf "~n~norigin y:~n")
               (display y)
               (define-values (z a) (send dc get-scale))
               (printf "~n~n scale x:~n")
               (display z)
               (printf "~n~n scale y:~n")
               (display a)
               (printf "~n~n rotation:~n")
               (display (send dc get-rotation))
               (printf "~n~n transformation:~n")
               (display (send dc get-transformation))
               (newline)
               )))
         
         
         
         #|(cond
               ;If collision with world has occured, it is painted black.
               [(not (equal? ($Find_World_Collision flying_unit)
                             'no_collision)) (set! brush_color "black")]
               
               ;Different colors for different objects (will be bitmaps later).
               [(equal? brush_color "red") (set! brush_color "blue")]
               [(equal? brush_color "blue") (set! brush_color "green")]
               [else (set! brush_color "red")])
             
             (send dc set-brush brush_color 'solid)
             (send dc set-pen "DeepPink" 0 'transparent)
             (send dc draw-rectangle bl_x bl_y width height)
             (send dc draw-bitmap
                   *player_1_bitmap*
                   20
                   20)))
         |#
         list_of_flying_units)
    
    
    ;Draws a box to indicate the worldsize to show when collision has occured.
      
    (send dc set-pen "DeepPink" 2 'long-dash)
    (send dc draw-line 0 0 world_width 0)
    (send dc draw-line 0 0 0 world_height)
    (send dc draw-line 0 world_height world_width world_height)
    (send dc draw-line world_width 0 world_width world_height)
    ))









;Testing key-mappings, not working right now

#|
(define test-keymap
  (new keymap%))

(send test-keymap add-function "up" (lambda ()
                                      ($Increase_Pos *player_1* 0 10)
                                      (send *flying_units* refresh-now))
      
      (send test-keymap map-function "up" "up")
      
      (define test-key-event
        (new key-event%
             [key-code test-keymap]))
      |#



;Defining the canvas in which flying units are drawn.
(define *flying_units*
  (new canvas%
       [parent *main_window*]
       [min-height 820]
       [min-width 1200]
       [horiz-margin 20]
       [vert-margin 20]
       [style '(border)]
       [paint-callback $Render_Flying]))


(send (send *flying_units* get-dc) set-scale 1 -1)
(send (send *flying_units* get-dc) set-origin 0 (send *flying_units* get-height))




;For testing the graphics, will be removed later.         NOTE
;Moves player 1 up, down, left and right.
(define (up)
  ($Increase_Pos *player_1* 0 50)
  (send *flying_units* refresh-now))

(define (down)
  ($Increase_Pos *player_1* 0 -50)
  (send *flying_units* refresh-now))
(define (left)
  ($Increase_Pos *player_1* -50 0)
  (send *flying_units* refresh-now))

(define (right)
  ($Increase_Pos *player_1* 50 0)
  (send *flying_units* refresh-now))



