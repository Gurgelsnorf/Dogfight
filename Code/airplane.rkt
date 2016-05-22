#lang racket/gui

(require "flying-unit-rectangular.rkt")
(require "basic-procedures.rkt")


(provide (all-defined-out))

;Here, the class airplane is defined.

(define airplane%
  (class flying_unit_rectangular%
    (init-field
     
     respawn_bl_corner
     respawn_br_corner
     respawn_tl_corner
     respawn_tr_corner
     respawn_center_of_gravity
     respawn_direction
     respawn_angle
     flag_bl_corner
     flag_bitmap

     [in_play #f]
     
     [turn_allowed #f]
     [shoot_allowed #f]
     [respawn_allowed #t]

     [immune_to_damage #t]
     

     [activate_turn_right #f]
     [activate_turn_left #f]
     [activate_shoot #f]

     [shooting_speed 0.5] ;shots per second
     
     [active_speed_buffs 0]
     [active_shooting_buffs 0]
     
     [lives 4]
     
     [base_speed 5]
     [base_shooting_speed 0.5])
    
    (inherit-field
     dead
     speed
     bl_corner
     br_corner
     tl_corner
     tr_corner
     projected_bl_corner
     projected_br_corner
     projected_tl_corner
     projected_tr_corner
     center_of_gravity
     direction
     angle)
    
;_________________________________________________
;Getting The variables of the airplane

    (define/public (In_Play?)
      in_play)
    
    (define/public ($Turn_Allowed?)
      turn_allowed)
    
    (define/public ($Shoot_Allowed?)
      shoot_allowed)
    
    (define/public ($Respawn_Allowed?)
      respawn_allowed)
    
    (define/public ($Get_Lives)
      lives)

    (define/public ($Immune_To_Damage?)
      immune_to_damage)
    
    (define/public ($Get_Activate_Turn_Left)
      activate_turn_left)

    (define/public ($Get_Activate_Turn_Right)
      activate_turn_right)

    (define/public ($Get_Activate_Shoot)
      activate_shoot)

    (define/public ($Get_Flag_Bl_Corner)
      flag_bl_corner)

    (define/public ($Get_Flag_Bitmap)
      flag_bitmap)
;_________________________________________________
;Setting the varables for the airplane

    (define/public ($Set_Turn_Allowed setter)
      (set! turn_allowed setter))
    
    (define/public ($Set_Shoot_Allowed setter)
      (set! shoot_allowed setter))

    (define/public ($Set_Immune_To_Damage setter)
      (set! immune_to_damage setter))
    
    (define/public ($Set_Turn_Left_Allowed setter)
      (set! turn_allowed setter))

    (define/public ($Set_Turn_Right_Allowed setter)
      (set! turn_allowed setter))

    (define/public ($Set_Activate_Turn_Right setter)
      (set! activate_turn_right setter))

    (define/public ($Set_Activate_Turn_Left setter)
      (set! activate_turn_left setter))

    (define/public ($Set_Activate_Shoot setter)
      (set! activate_shoot setter))

    (define ($Set_Flag_Height height)
      (set! flag_bl_corner ($Vector ($Vector_Get_X flag_bl_corner) height)))


;_________________________________________________

     ;Starts the cooldown for shooting again.
    (define/public ($Cooldown_Shoot)
      (set! shoot_allowed #f)
      (send *clock_shooting* start (inexact->exact (/ 1000 shooting_speed)) #t))   ;Time should be tested!
    
    ;The timer that counts down the shooting cooldown.
    (define *clock_shooting*
      (new timer%
           [notify-callback (lambda ()
                              (set! shoot_allowed #t))]))
    
    ;_________________________________________________
    
    ;Starts the cooldown for turning again.
    (define/public ($Cooldown_Turn)
      (set! turn_allowed #f)
      (send *clock_turning* start 100 #t))                       ;Time should be tested! 
    
    
    ;The timer that counts down the turning cooldown.
    (define *clock_turning*
      (new timer%
           [notify-callback (lambda ()
                              (set! turn_allowed #t))]))
    
    ;_________________________________________________
    ;When a player dies, they should also be able to respawn
    ;after a certain time.
    (define/override ($Kill)
      (set! lives (- lives 1))

      ;If 0 lives, repsawn allowed is permanently #f.
      (if (= lives 0)
          (set! respawn_allowed #f)
          (send *clock_respawning* start 3000 #t))

        (set! shoot_allowed #f)
      (set! turn_allowed #f)
      (super $Kill)

      ;Update the flag height
      ($Set_Flag_Height (cond
                     [(>= lives 4) 170]
                     [(= lives 3) 165]
                     [(= lives 2) 160]
                     [(= lives 1) 155]
                     [else 150])))
    
    ;The timer that counts the respawning cooldown.
    (define *clock_respawning*
      (new timer%
           [notify-callback (lambda ()
                              (set! respawn_allowed #t))]))
    
    
    ;_________________________________________________
    ;Respawns the player
    (define/public ($Respawn)

      ;All buffs are reset.
      (set! in_play #t)
      (set! active_speed_buffs 0)
      (set! active_shooting_buffs 0)

      ;The speeds are set to the base values.
      (set! speed base_speed)
      (set! shooting_speed base_shooting_speed)


      ;The player is moved back to its respawn position.
      (set! bl_corner respawn_bl_corner)
      (set! projected_bl_corner respawn_bl_corner)
      
      (set! br_corner respawn_br_corner)
      (set! projected_br_corner respawn_br_corner)
      
      (set! tl_corner respawn_tl_corner)
      (set! projected_tl_corner respawn_tl_corner)
      
      (set! tr_corner respawn_tr_corner)
      (set! projected_tr_corner respawn_tr_corner)
      
      (set! center_of_gravity respawn_center_of_gravity)

      (set! direction respawn_direction)
      (set! angle respawn_angle)
      

      ;Your allowances are updated. 
      (set! respawn_allowed #f)
      (set! shoot_allowed #t)
      (set! turn_allowed #t)

      ;You are immune to damage for a short while
      ;when respawning.
      (set! immune_to_damage #t)
      (send *clock_immunity* start 4000 #t))


    
    ;The timer that counts the damage immunity.
    (define *clock_immunity*
      (new timer%
           [notify-callback (lambda ()
                              (set! immune_to_damage #f))]))
    
    ;_________________________________________________
    ;Buffs the plane given a buff type.
    (define/public ($Buff buff_type)
      (cond
        ;Speed buff.
        [(equal? buff_type 'speed-buff)
         
         ;Update buff counter.
         (set! active_speed_buffs (+ active_speed_buffs 1))
         
         ;Set the new speed.
         (set! speed (* base_speed
                        (cond
                          ;The speed is improved by 30% for the first 2 buffs,
                          ;and then 20% for each buff after that, like:
                          ;30%, 60%, 80%, 100%, 120%...
                          [(>= 2 active_speed_buffs) (* active_speed_buffs 1.3)]
                          [else (+ 1.6 (* (- active_speed_buffs 2) 1.2))])))]
        
        
        ;Shooting buff
        [(equal? buff_type 'shooting_buff)
         
         ;Update buff counter
         (set! active_shooting_buffs (+ active_shooting_buffs 1))
         
         ;The new shooting speed is improved by 50% for each buff like:
         ;50%, 100%, 150% ...
         (set! shooting_speed (* base_shooting_speed
                                 (+ (* active_shooting_buffs 0.5) 1)))]
        
        
        [(equal? buff_type 'health-buff)
         (set! lives (+ lives 1))]))
    
    (super-new)))