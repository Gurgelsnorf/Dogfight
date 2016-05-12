#lang racket/gui



;_____________________________________________________________
;Main loop



;_____________________________________________________________
;Possible first render?





;_____________________________________________________________
;Clock timer

(define *clock_timer*
  (new timer%
       [notify-callback $Gameplay_Looping]))

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

(define ($Gameplay_Looping)
  (begin
    (:::::::)))