#lang racket
(require "direction.rkt")
(require "physics-engine.rkt")
(require "airplane.rkt")

;;;;;;;;;;;;;;;;;Player Commands;;;;;;;;;;;;;;;;;;;;;;;

; Moves an object based on it's speed and direction      
(define ($Move_Airplane object)
  (let ([£temp_angle (hash-ref £Directions (send object $Get_Direction))]
        [£temp_speed (send object $Get_Speed)])
        (cond
          [(<= £temp_speed (send £temp_angle $Get_Min_Cap))
           (printf "Too low speed, stalling ~n")]
          [else
           ($Increase_Pos object (* £temp_speed (car (send £temp_angle $Get_Vector))) (* £temp_speed (cdr (send £temp_angle $Get_Vector))))])))


; Changes the speed of an object based on given value
(define ($Increase_Speed object new_speed)
  (send object $Set_Speed (+ new_speed (send object $Get_Speed))))


; Set the speed for an object
(define ($Set_Speed object new_speed)
  (send object £$Set_Speed new_speed)) 


; Change direction of an object based on given value
(define ($Increase_Angle object new_angle)
  (send object $Set_Direction (+ (send object $Get_Direction) new_angle)))


; Set direction of an object
(define ($Set_Angle object new_angle)
  (send object $Set_Direction new_angle))

; Change position of an object
(define ($Increase_Pos object movementX movementY)
    (send object $Set_Bl_Corner (cons (+ (car (send object $Get_Bl_Corner)) movementX) (+ (cdr (send object $Get_Bl_Corner)) movementY)))
    (send object $Set_Br_Corner (cons (+ (car (send object $Get_Br_Corner)) movementX) (+ (cdr (send object $Get_Br_Corner)) movementY)))
    (send object $Set_Tl_Corner (cons (+ (car (send object $Get_Tl_Corner)) movementX) (+ (cdr (send object $Get_Tl_Corner)) movementY)))
    (send object $Set_Tr_Corner (cons (+ (car (send object $Get_Tr_Corner)) movementX) (+ (cdr (send object $Get_Tr_Corner)) movementY))))


; Set position of an object
(define ($Set_Pos object posX posY)
  (send object $Set_Bl_Corner (cons posX posY))
  (send object $Set_Br_Corner (cons posX posY))
  (send object $Set_Tl_Corner (cons posX posY))
  (send object $Set_Tr_Corner (cons posX posY)))


