#lang racket/gui

(provide (all-defined-out))


;A class for a special type of canvas that handles key and
;moues events.

(define input-canvas-key%
  (class canvas%
    [init-field key-handler]

    (define/override (on-char key-event)
      (key-handler key-event))

    (super-new)))



    
  










  
  