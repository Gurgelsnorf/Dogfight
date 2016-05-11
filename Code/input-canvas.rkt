#lang racket/gui
(require "player-commands.rkt")
(require "world-init.rkt")
(require "collisions.rkt")
(require "basic-procedures.rkt")
(require "physics-engine.rkt")
(require "flying-unit-rectangular.rkt")
(provide (all-defined-out))


;______________________________________________________
;A file to define input-canvas% for handling mouse events and also key events
;with one input-canvas-key and one input-canvas-mouse

(define input-canvas-key%
  (class canvas%
    [init-field key-handler]

    (define/override (on-char key-event)
      (key-handler key-event))

    (super-new)))



    
  










  
  