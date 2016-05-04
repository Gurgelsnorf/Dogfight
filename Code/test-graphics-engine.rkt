#lang racket/gui
(require "collisions.rkt")
(require "world-init.rkt")
(require "basic-procedures.rkt")
(require "player-commands.rkt")
(require "physics-engine.rkt")

;Creates the main window
(define *main_window*
  (new frame%
       [width 1220]
       [height 820]
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
        [brush_color "red"])
    
    
    ;Paints all flying units
    (map (lambda (flying_unit)
           (send dc set-origin 0 (send *flying_units* get-height))
           (send dc set-scale 1 -1)
           (let* (
                  [tl_corner (send flying_unit $Get_Tl_Corner)]
                  [tr_corner (send flying_unit $Get_Tr_Corner)]
                  [bl_corner (send flying_unit $Get_Bl_Corner)]
                  [width (send flying_unit $Get_Width)]
                  [height (send flying_unit $Get_Height)]

                  (send dc draw-bitmap (send flying_unit $Get_Bitmap

                  
             
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
    (let ([world_width (send *world* $Get_Width)]
          [world_height (send *world* $Get_Height)])
      
      (send dc set-pen "DeepPink" 2 'long-dash)
      (send dc draw-line 0 0 world_width 0)
      (send dc draw-line 0 0 0 world_height)
      (send dc draw-line 0 world_height world_width world_height)
      (send dc draw-line world_width 0 world_width world_height))))









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
       [horiz-margin 20]
       [vert-margin 20]
       [style '(border)]
       [paint-callback $Render_Flying]))





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


(define *player_1_bitmap* 
  (make-object bitmap%
    ;(send *player_1* $Get_Width)
    ;(send *player_1* $Get_Height)
    "grafik/test-flyg-80-39.png"
    'png/alpha))
