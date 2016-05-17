#lang racket/gui

(require "flying-unit-rectangular.rkt")


(provide (all-defined-out))

;Here, the class airplane is defined.

(define airplane%
  (class flying_unit_rectangular%
    (init-field
     [turn_allowed #t]
     [shoot_allowed #t]
     [shooting_speed 0.5]) ;shots per second

    

;_________________________________________________
;Getting The variables of the airplane
    (define/public ($Turn_Allowed?)
      turn_allowed)

    (define/public ($Shoot_Allowed?)
      shoot_allowed)

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
      

    ;The timer that counts down the shooting cooldown.
    (define *clock_shooting*
      (new timer%
           [notify-callback (set! shoot_allowed #t)]))

    ;The timer that counts down the turning cooldown.
    (define *clock_turning*
      (new timer%
           [notify-callback (set! turn_allowed #t)]))
    
    
    (super-new)))


