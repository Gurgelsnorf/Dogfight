#lang racket/gui



;_____________________________________________________________
;Main loop
(define ($Gameplay_Looping)
  (printf "lel ~n"))


;_____________________________________________________________
;Possible first render?





;_____________________________________________________________
;Clock timer

(define *clock_timer*
  (new timer%
       [notify-callback $Gameplay_Looping]))
;_____________________________________________________________
;Jäveln som startar tidsuppateringar
(send *clock_timer* start 1000 #f)



;________Structure____________________________________________
;Run physics movement
;-
;Check collitions
;-
;if
;Collition - draw crash
;else - uppdate graphics
;-
;timer for next uppdate
;_____________________________________________________________

(define (play)
  ;open menu
  ;etc...

  ;When you press start in menu:
  (let (
        [timer clock-timer])
    (define (main-loop)
      ;collisions
      ;movement...

      ;if keypress pause
      ;send timer stop

      (wait))

    (main-loop)))
    