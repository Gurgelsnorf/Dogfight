#lang racket

(provide (all-defined-out))
 
(require "direction.rkt")
(require "airplane.rkt")
(require "world-init.rkt")
(require "basic-procedures.rkt")
(require "flying-unit-rectangular.rkt")


;Here, the commands for interacting with the objects are defined.

;NOTE: Some of these procedure will be moved at a later stage,
;when keyboard presses are implemented!


;_________________________________________________
;Sets an angle for the object and then rotates the projected corners based on that angle
(define ($Set_Angle_Rotate object new_angle)
  (begin
    ($Set_Angle object new_angle)
    ($Rotate_All_Corners object)))
    
;_________________________________________________
;Moves all units in *world*
(define ($Move_All)
  (let ([flying_units (send *world* $Get_Flying_Units)])

    (map (lambda (flying_unit) (if (is-a? flying_unit flying_unit_rectangular%)
                                   ($Airplane_Full_Movement flying_unit)
                                   (printf "To implement: Flying_unit_circular")))
         flying_units)))


;_________________________________________________
; Moves an object based on it's speed and then rotates the projected angles
(define ($Airplane_Full_Movement object)
  (begin
    ($Move_Airplane object)
    ($Rotate_All_Corners object)))

;_________________________________________________
; Moves an object based on it's speed and direction      
(define ($Move_Airplane object)
  (let ([£temp_angle (hash-ref £Directions (send object $Get_Direction))]
        [£temp_speed (send object $Get_Speed)])
    (cond
      [(<= £temp_speed (send £temp_angle $Get_Min_Cap))
       (printf "Too low speed, stalling ~n")]
      [else
       ($Increase_Pos object (* £temp_speed ($Vector_Get_X (send £temp_angle $Get_Vector))) (* £temp_speed (cdr (send £temp_angle $Get_Vector))))])))


;_________________________________________________
; Changes the speed of an object based on given value.
(define ($Increase_Speed object new_speed)
  (send object $Set_Speed (+ new_speed (send object $Get_Speed))))

;_________________________________________________
;Rotates all coners on the projected angle
(define ($Rotate_All_Corners object)

  (send object $Set_Projected_Bl_Corner
        ($Vector_Addition
         ($Single_Vector_Rotation ($Vector_Create (send object $Get_Center_Of_Gravity) (send object $Get_Bl_Corner)) (/ (* pi (send object $Get_Direction)) 16))
         (send object $Get_Center_Of_Gravity)))

  (send object $Set_Projected_Br_Corner
        ($Vector_Addition
         ($Single_Vector_Rotation ($Vector_Create (send object $Get_Center_Of_Gravity) (send object $Get_Br_Corner)) (/ (* pi (send object $Get_Direction)) 16))
         (send object $Get_Center_Of_Gravity)))

  (send object $Set_Projected_Tl_Corner
        ($Vector_Addition
         ($Single_Vector_Rotation ($Vector_Create (send object $Get_Center_Of_Gravity) (send object $Get_Tl_Corner)) (/ (* pi (send object $Get_Direction)) 16))
         (send object $Get_Center_Of_Gravity)))

  (send object $Set_Projected_Tr_Corner
        ($Vector_Addition
         ($Single_Vector_Rotation ($Vector_Create (send object $Get_Center_Of_Gravity) (send object $Get_Tr_Corner)) (/ (* pi (send object $Get_Direction)) 16))
         (send object $Get_Center_Of_Gravity))))

  
;_________________________________________________
; Set the speed for an object.
(define ($Set_Speed object new_speed)
  (send object $Set_Speed new_speed)) 


;_________________________________________________
; Change direction of an object based on given value.
(define ($Increase_Angle object new_angle)
  (send object $Set_Direction (+ (send object $Get_Direction) new_angle)))


;_________________________________________________
; Set direction of an object.
(define ($Set_Angle object new_angle)
  (send object $Set_Direction new_angle))


;_________________________________________________
; Change position of an object.
(define ($Increase_Pos object movement_x movement_y)

  (send object $Set_Bl_Corner
        ($Vector (+ ($Vector_Get_X (send object $Get_Bl_Corner))
                 movement_x)
              (+ ($Vector_Get_Y (send object $Get_Bl_Corner))
                 movement_y)))

  (send object $Set_Br_Corner
        ($Vector (+ ($Vector_Get_X (send object $Get_Br_Corner))
                 movement_x)
              (+ ($Vector_Get_Y (send object $Get_Br_Corner))
                 movement_y)))
  
  (send object $Set_Tl_Corner
        ($Vector (+ ($Vector_Get_X (send object $Get_Tl_Corner))
                 movement_x)
              (+ ($Vector_Get_Y (send object $Get_Tl_Corner))
                 movement_y)))

  (send object $Set_Tr_Corner
        ($Vector (+($Vector_Get_X (send object $Get_Tr_Corner))
                movement_x)
              (+ ($Vector_Get_Y (send object $Get_Tr_Corner))
                 movement_y)))

(send object $Set_Center_Of_Gravity
        ($Vector (+($Vector_Get_X (send object $Get_Center_Of_Gravity))
                movement_x)
              (+ ($Vector_Get_Y (send object $Get_Center_Of_Gravity))
                 movement_y))))


;_________________________________________________
; Set position of an object.                                                 
(define ($Set_Pos object pos_x_bl pos_y_bl pos_x_tr pos_y_tr)
  (send object $Set_Bl_Corner ($Vector pos_x_bl pos_y_bl))
  (send object $Set_Br_Corner ($Vector pos_x_tr pos_y_bl))
  (send object $Set_Tl_Corner ($Vector pos_x_bl pos_y_tr))
  (send object $Set_Tr_Corner ($Vector pos_x_tr pos_y_tr))
  (send object $Set_Center_Of_Gravity
        ($Vector (/ (+ pos_x_bl pos_x_tr) 2)
                 (/ (+ pos_y_bl pos_y_tr) 2))))


