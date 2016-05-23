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

  (for-each (lambda (player)
              (when (send player $Turn_Allowed?)
                ($Increase_Angle_Rotate player
                                        (+ (if (send player $Get_Activate_Turn_Left)
                                               1
                                               0)
                                           (if (send player $Get_Activate_Turn_Right)
                                               -1
                                               0)))
                (send player $Cooldown_Turn)))
            
            (send *world* $Get_Active_Players))

  ($Move_All))

#|  (begin
    (let
       ([£Player_1_Angle
         (+ (if (send *player_1* $Get_Activate_Turn_Left) 1 0) (if (send *player_1* $Get_Activate_Turn_Right) -1 0))]
        [£Player_2_Angle
         (+ (if (send *player_2* $Get_Activate_Turn_Left) 1 0) (if (send *player_2* $Get_Activate_Turn_Right) -1 0))]
        [£Player_3_Angle
         (+ (if (send *player_3* $Get_Activate_Turn_Left) 1 0) (if (send *player_3* $Get_Activate_Turn_Right) -1 0))]
        [£Player_4_Angle
         (+ (if (send *player_4* $Get_Activate_Turn_Left) 1 0) (if (send *player_4* $Get_Activate_Turn_Right) -1 0))])
      
      ($Increase_Angle_Rotate *player_1* £Player_1_Angle)
      ($Increase_Angle_Rotate *player_2* £Player_2_Angle)
      ($Increase_Angle_Rotate *player_3* £Player_3_Angle)
      ($Increase_Angle_Rotate *player_4* £Player_4_Angle))
    ($Move_All)))
  |#  





;_________________________________________________
;Increase the angle and then rotate based on the increse

(define ($Increase_Angle_Rotate object angle_increase)
  (let ([angle_value (* pi (/ (+ (send object $Get_Direction) angle_increase) 16))])
    (cond
      [(<= 32 (+ angle_increase (send object $Get_Direction)))
       ($Increase_Angle object (- angle_increase 32))
       ($Rotate_All_Corners object)
       (send object $Set_Angle angle_value)]
      [(>= -1 (+ angle_increase (send object $Get_Direction)))
       ($Increase_Angle object (+ angle_increase 32))
       ($Rotate_All_Corners object)
       (send object $Set_Angle angle_value)]
      [else
       ($Increase_Angle object angle_increase)
       ($Rotate_All_Corners object)
       (send object $Set_Angle angle_value)])))
       

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
        ($Increase_Pos object (* £temp_speed ($Vector_Get_X (send £temp_angle $Get_Vector)))
                       (* £temp_speed (cdr (send £temp_angle $Get_Vector))))))


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
  (let ( [new_direction (+ (send object $Get_Direction) new_angle)])

    (if (equal? new_direction 32)
        (send object $Set_Direction 0)
        (send object $Set_Direction new_direction))))


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
          [speed 2]
          [direction 24]
          [buff_type randomed_buff_type]
          [bitmap bitmap_]
          [death_bitmap *buff_death_bitmap*]))))

;_________________________________________________
;Spawns a bird at a location.
(define ($Spawn_Bird bl_corner_x bl_corner_y direction speed orientation)
  (let (
        [bird ($Make_Bird bl_corner_x bl_corner_y speed orientation)])

    ($Increase_Angle_Rotate bird direction)

    (send *world* $Add_Flying_Unit bird)))

;_________________________________________________
;Spawns an entity at a "random" place if allowed. 
(define ($Entity_Spawner)
  (when (send *world* $Spawn_Entity_Allowed?)

    (send *world* $Cooldown_Entity_Spawner)

    (let (
          [height_seed (+ 350 (random 251))]
          
          [side_seed (if (equal? (random 2) 0)
                         'left
                         'right)]
          
          [direction_seed (+ (- 3) (random 7))]
          
          [speed_seed (+ 3 (random 4))])

    ($Spawn_Bird
     
     (if (equal? side_seed 'left)
         (- 30)
         1199)

     height_seed
     
     (if (equal? side_seed 'left)
         direction_seed
         (+ direction_seed 16))

     speed_seed

     side_seed))))
     
        
;_________________________________________________
;Spawns a player at their respawn position if allowed
(define ($Spawn_Player player)
  (when (send player $Respawn_Allowed?)
    (send player $Respawn)
    (send *world* $Add_Flying_Unit player)
    (send *world* $Add_Active_Player player)))



;Checks if a player should be forcefully respawned
;And respawns them if they should.
(define ($Force_Respawn)
  (for-each (lambda (player)
           (when (send player $Force_Respawn?)
             ($Spawn_Player player)))
            (send *world* $Get_Active_Players)))

;_________________________________________________

;Checks for victory and returns if it's a tie, who who
;won or if the game should keep playing.
(define ($Victory_Condition)
  

  (if (< (length (send *world* $Get_Active_Players)) 2)
  ;If less than 2 players are playing, no one can win.
      'keep-playing

      (let ([remaining_players '()])

        ;Remaining_players is set to all players that are active and
        ;haven't lost(lives = 0) yet.
        (for-each (lambda (player)
                  (when (not (send player $Lost?))
                    (set! remaining_players (cons player remaining_players))))
                (send *world* $Get_Active_Players))

      (let ([number_of_remaining_players (length remaining_players)])

        (cond
          ;If 2 or more players are still playing, nothing happens.
          [(>= number_of_remaining_players 2) 'keep-playing]

          ;If only 1 player left, that player has won! 
          [(= number_of_remaining_players 1) (car remaining_players)]

          ;If 0 players left, that means they died at the same time,
          ;and it's is thereby a tie.
          [(= number_of_remaining_players 0) 'tie])))))