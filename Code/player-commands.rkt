#lang racket

(provide (all-defined-out))
 
(require "direction.rkt")
(require "airplane.rkt")
(require "world-init.rkt")
(require "basic-procedures.rkt")


;Here, the commands for interacting with the objects are defined.

;NOTE: Some of these procedure will be moved at a later stage,
;when keyboard presses are implemented!

;_________________________________________________
; Moves an object based on it's speed and direction      
(define ($Move_Airplane object)
  (let ([£temp_angle (hash-ref £Directions (send object $Get_Direction))]
        [£temp_speed (send object $Get_Speed)])
    (cond
      [(<= £temp_speed (send £temp_angle $Get_Min_Cap))
       (printf "Too low speed, stalling ~n")]
      [else
       ($Increase_Pos object (* £temp_speed (car (send £temp_angle $Get_Vector))) (* £temp_speed (cdr (send £temp_angle $Get_Vector))))])))


;_________________________________________________
; Changes the speed of an object based on given value.
(define ($Increase_Speed object new_speed)
  (send object $Set_Speed (+ new_speed (send object $Get_Speed))))

;_________________________________________________
;Rotates all coners on the projected angle
(define ($Rotate_All_Corners object)

  (send object $Set_Projected_Bl_Corner
        ($Point_Move_Vector
         ($Single_Vector_Rotation ($Two_Point_Verctor_Create (send object $Get_Center_Of_Gravity) (send object $Get_Bl_Corner)) (/ (* pi (send object $Get_Direction)) 16))
         (send object $Get_Center_Of_Gravity)))

  (send object $Set_Projected_Br_Corner
        ($Point_Move_Vector
         ($Single_Vector_Rotation ($Two_Point_Verctor_Create (send object $Get_Center_Of_Gravity) (send object $Get_Br_Corner)) (/ (* pi (send object $Get_Direction)) 16))
         (send object $Get_Center_Of_Gravity)))

  (send object $Set_Projected_Tl_Corner
        ($Point_Move_Vector
         ($Single_Vector_Rotation ($Two_Point_Verctor_Create (send object $Get_Center_Of_Gravity) (send object $Get_Tl_Corner)) (/ (* pi (send object $Get_Direction)) 16))
         (send object $Get_Center_Of_Gravity)))

  (send object $Set_Projected_Tr_Corner
        ($Point_Move_Vector
         ($Single_Vector_Rotation ($Two_Point_Verctor_Create (send object $Get_Center_Of_Gravity) (send object $Get_Tr_Corner)) (/ (* pi (send object $Get_Direction)) 16))
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
        (cons (+ (car (send object $Get_Bl_Corner))
                 movement_x)
              (+ (cdr (send object $Get_Bl_Corner))
                 movement_y)))

  (send object $Set_Br_Corner
        (cons (+ (car (send object $Get_Br_Corner))
                 movement_x)
              (+ (cdr (send object $Get_Br_Corner))
                 movement_y)))
  
  (send object $Set_Tl_Corner
        (cons (+ (car (send object $Get_Tl_Corner))
                 movement_x)
              (+ (cdr (send object $Get_Tl_Corner))
                 movement_y)))

  (send object $Set_Tr_Corner
        (cons (+(car (send object $Get_Tr_Corner))
                movement_x)
              (+ (cdr (send object $Get_Tr_Corner))
                 movement_y))))


;_________________________________________________
; Set position of an object.                         NOTE: Should this be                                                  
(define ($Set_Pos object posX posY)                  ;changed so that not
  (send object $Set_Bl_Corner (cons posX posY))      ;all corners become the same?
  (send object $Set_Br_Corner (cons posX posY))
  (send object $Set_Tl_Corner (cons posX posY))
  (send object $Set_Tr_Corner (cons posX posY)))


