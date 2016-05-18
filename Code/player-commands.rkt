#lang racket

(provide (all-defined-out))
 
(require "direction.rkt")
(require "airplane.rkt")
(require "world-init.rkt")
(require "basic-procedures.rkt")
(require "flying-unit-rectangular.rkt")
(require "buff.rkt")


;Here, the commands for interacting with the objects are defined.

;NOTE: Some of these procedure will be moved at a later stage,
;when keyboard presses are implemented!



;_________________________________________________________________________
;Activate shoot button

(define ($Game_Loop_Shooting)
  (if (send *player_1* $Get_Activate_Shoot) ($Shoot *player_1*) 0)
  (if (send *player_2* $Get_Activate_Shoot) ($Shoot *player_2*) 0))

;_________________________________________________________________________
;Keyboard affected movement requires a timed loop
(define ($Key_Board_Full_Movement)
  (begin
    (let
       ([£Player_1_Angle
         (+ (if (send *player_1* $Get_Activate_Turn_Left) 1 0) (if (send *player_1* $Get_Activate_Turn_Right) -1 0))]
        [£Player_2_Angle
         (+ (if (send *player_2* $Get_Activate_Turn_Left) 1 0) (if (send *player_1* $Get_Activate_Turn_Right) -1 0))])
      ($Increase_Angle_Rotate *player_1* £Player_1_Angle)
      ($Increase_Angle_Rotate *player_2* £Player_1_Angle))
    ($Move_All)))
    





;_________________________________________________
;Increase the angle and then rotate based on the increse

(define ($Increase_Angle_Rotate object angle_increase)
  (begin
    (let ([angle_value (* pi (/ (+ (send object $Get_Direction) angle_increase) 16))])
    (cond
      [(<= 32 (+ angle_increase (send object $Get_Direction)))
       ($Increase_Angle object (- angle_increase 32))
       ($Rotate_All_Corners object)
       (send object $Set_Angle angle_value)]
      [(>= 0 (+ angle_increase (send object $Get_Direction)))
       ($Increase_Angle object (+ angle_increase 32))
       ($Rotate_All_Corners object)
       (send object $Set_Angle angle_value)]
      [else
       ($Increase_Angle object angle_increase)
       ($Rotate_All_Corners object)
       (send object $Set_Angle angle_value)]))))
       

;_________________________________________________
;Sets an angle for the object and then rotates the projected corners based on that angle
(define ($Set_Angle_Rotate object new_angle)
  (begin
    ($Set_Angle object new_angle)
    ($Rotate_All_Corners object)
    (send object $Set_Angle (* pi (/ new_angle 16)))))
    
;_________________________________________________
;Moves all units in *world*
(define ($Move_All)
  (let ([flying_units (send *world* $Get_Flying_Units)])

    (map (lambda (flying_unit) (if (is-a? flying_unit flying_unit_rectangular%)
                                   ($Airplane_Full_Movement flying_unit)
                                   ($Move_Circle flying_unit)))
         flying_units)))



;_________________________________________________
;Moves a circular object based on its speed and direction.
(define ($Move_Circle object)
  (let* (
        [direction (send (hash-ref £Directions (send object $Get_Direction)) $Get_Vector)]
        [speed (send object $Get_Speed)]
        [center (send object $Get_Center_Of_Gravity)]
        [movement_vector ($Vector_Multiplication speed direction)])
       (send object $Set_Center_Of_Gravity ($Vector_Addition center movement_vector)))) 

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


;_________________________________________________
;If shooting is allowed, shooting_allowed is set to #f and
;a projectile is created in the world.
(define ($Shoot airplane)
  (when (send airplane $Shoot_Allowed?)
    (send airplane $Cooldown_Shoot)

    (let* (
           [plane_speed (send airplane $Get_Speed)]
           
           [plane_direction (send airplane $Get_Direction)]
           
           [plane_direction_vector
            (send (hash-ref £Directions plane_direction) $Get_Vector)]
           
           [plane_center (send airplane $Get_Center_Of_Gravity)]
           
           [plane_width (send airplane $Get_Width)])
      
      (send *world* $Add_Flying_Unit
            ($Make_Projectile
             ;The center of the projectile is 0.1 widths
             ;outside the plane straight in front of it.
             ($Vector_Addition plane_center
                               ($Vector_Multiplication (* plane_width 0.55)  
                                                       plane_direction_vector))
             ;The projectile flies in the same direction as the airplane
             plane_direction

             ;The projectile is double the speed of the plane.
             (* plane_speed 2))))))

;_________________________________________________
;Spawns a random buff at this location.
(define ($Spawn_Buff location)
  (let (
        [buff_seed (random 16)]
        [randomed_buff_type 0]
        [bitmap_ 0])

    (cond
      ;1/2 chance
      [(<= buff_seed 7) (set! randomed_buff_type 'speed-buff)
                        (set! bitmap_ *speed_buff_bitmap*)]

      ;5/16 chance
      [(<= buff_seed 12) (set! randomed_buff_type 'shooting-buff)
                         (set! bitmap_ *shooting_buff_bitmap*)]

      ;3/16 chance
      [else (set! randomed_buff_type 'health-buff)
            (set! bitmap_ *health_buff_bitmap*)])

    ;spawning the buff 
    (send *world* $Add_Flying_Unit
          (new buff%
          [center_of_gravity location]
          [radius 12.5]
          [speed 5]
          [direction 24]
          [buff_type randomed_buff_type]
          [bitmap bitmap_]
          [death_bitmap *buff_death_bitmap*]))))

;_________________________________________________
;Spawns a bird at a location.

(define ($Spawn_Bird bl_corner_x bl_corner_y buff_type direction)
  (let (
        [bird ($Make_Bird bl_corner_x bl_corner_y buff_type)])

    ($Increase_Angle_Rotate bird direction)

    (send *world* $Add_Flying_Unit bird)))

(define ($Spawn_Player player)
  (when (send player $Respawn_Allowed?)
    (send player $Respawn)
    (send *world* $Add_Flying_Unit player)))