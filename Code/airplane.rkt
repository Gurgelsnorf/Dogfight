#lang racket/gui

(require "flying-unit-rectangular.rkt")


(provide (all-defined-out))

;Here, the class airplane is defined.

(define airplane%
  (class flying_unit_rectangular%
    (init-field

     [turn_allowed #t]
     [shoot_allowed #t]
     [respawn_allowed #t]

     [shooting_speed 0.5] ;shots per second

     [active_speed_buffs 0]
     [active_shooting_buffs 0]

     [lives 4]

     [base_speed 5]
     [base_shooting_speed 0.5])

    (inherit-field
     dead
     speed)

    

;_________________________________________________
;Getting The variables of the airplane
    (define/public ($Turn_Allowed?)
      turn_allowed)

    (define/public ($Shoot_Allowed?)
      shoot_allowed)

    (define/public ($Get_Lives)
      lives)

;_________________________________________________
;Setting the varables for the airplane

    (define/public ($Set_Turn_Allowed setter)
      (set! turn_allowed setter))

    (define/public ($Set_Shoot_Allowed setter)
      (set! shoot_allowed setter))


;_________________________________________________

     ;Starts the cooldown for shooting again.
    (define/public ($Cooldown_Shoot)
      (set! shoot_allowed #f)
      (send *clock_shooting* start (/ 1000 shooting_speed) #t))   ;Time should be tested!

    ;Starts the cooldown for turning again
    (define/public ($Cooldown_Turn_Left)
      (set! turn_allowed #f)
      (send *clock_turning* start 100 #t))                       ;Time should be tested! 

;_________________________________________________    
    ;The timer that counts down the shooting cooldown.
    (define *clock_shooting*
      (new timer%
           [notify-callback (set! shoot_allowed #t)]))

    ;The timer that counts down the turning cooldown.
    (define *clock_turning*
      (new timer%
           [notify-callback (set! turn_allowed #t)]))

;_________________________________________________
    ;When a player dies, they should also be able to respawn
    ;after a certain time.
    (define/override ($Kill)
      (send *clock_respawning* start 3000 #t)
      (set! lives (- lives 1))
      (super $Kill))

    ;The timer that counts the respawning cooldown
    (define *clock_respawning*
      (new timer%
           [notify-callback (set! respawn_allowed #t)]))

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
                          ;The speed is improved by 30% for the first 2 buffs, and
                          ;then 20% for each buff after that, like:
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


