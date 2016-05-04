#lang racket

(require "world.rkt")
(require "airplane.rkt")
(require "direction.rkt")
(require "rectangle.rkt")
(provide (all-defined-out))

#|
Here, all the objects and similar used in the
program are defined.


It includes:

1. Directions

2. Players

etc... To implement!

|#

;_________________________________________________
;_________________________________________________
;-------Defining all directions for moving--------
;_________________________________________________
;_________________________________________________

;The directions are defined so that they are evenly
;spaced out in a full circle, where:
;angle_0 is straight to the right
;angle_4/16 is sideways up and right
;angle_16/16 is straight left
;etc...


;NOTE: Gravity/min-cap is not implemnted yet and because
;of this only has standard values.

(define *angle_0*
  (new direction%
       [vector (cons 1 0)]
       [min_cap 0]
       [gravity 1]))

(define *angle_1/16*
  (new direction%
       [vector (cons .980785 .195090)]
       [min_cap 0]
       [gravity 1]))

(define *angle_2/16*
  (new direction%
       [vector (cons .923880 .382683)]
       [min_cap 0]
       [gravity 1]))

(define *angle_3/16*
  (new direction%
       [vector (cons .831470 .555570)]
       [min_cap 0]
       [gravity 1]))

(define *angle_4/16*
  (new direction%
       [vector (cons .707107 .707107)]
       [min_cap 0]
       [gravity 1]))

(define *angle_5/16*
  (new direction%
       [vector (cons .555570 .831470)]
       [min_cap 0]
       [gravity 1]))

(define *angle_6/16*
  (new direction%
       [vector (cons .382683 .923880)]
       [min_cap 0]
       [gravity 1]))

(define *angle_7/16*
  (new direction%
       [vector (cons .195090 .980785)]
       [min_cap 0]
       [gravity 1]))

(define *angle_8/16*
  (new direction%
       [vector (cons 0 1)]
       [min_cap 0]
       [gravity 1]))

(define *angle_9/16*
  (new direction%
       [vector (cons -.195090 .980785)]
       [min_cap 0]
       [gravity 1]))

(define *angle_10/16*
  (new direction%
       [vector (cons -.382683 .923880)]
       [min_cap 0]
       [gravity 1]))

(define *angle_11/16*
  (new direction%
       [vector (cons -.555570 .831470)]
       [min_cap 0]
       [gravity 1]))

(define *angle_12/16*
  (new direction%
       [vector (cons -.707107 .707107)]
       [min_cap 0]
       [gravity 1]))

(define *angle_13/16*
  (new direction%
       [vector (cons -.831470 .555570)]
       [min_cap 0]
       [gravity 1]))

(define *angle_14/16*
  (new direction%
       [vector (cons -.923880 .382683)]
       [min_cap 0]
       [gravity 1]))

(define *angle_15/16*
  (new direction%
       [vector (cons -.831470 .555570)]
       [min_cap 0]
       [gravity 1]))

(define *angle_16/16*
  (new direction%
       [vector (cons -1 0)]
       [min_cap 0]
       [gravity 1]))

(define *angle_17/16*
  (new direction%
       [vector (cons -.980785 -.195090)]
       [min_cap 0]
       [gravity 1]))

(define *angle_18/16*
  (new direction%
       [vector (cons -.923880 -.382683)]
       [min_cap 0]
       [gravity 1]))

(define *angle_19/16*
  (new direction%
       [vector (cons -.831470 -.555570)]
       [min_cap 0]
       [gravity 1]))

(define *angle_20/16*
  (new direction%
       [vector (cons -.707107 -.707107)]
       [min_cap 0]
       [gravity 1]))

(define *angle_21/16*
  (new direction%
       [vector (cons -.555570 -.831470)]
       [min_cap 0]
       [gravity 1]))

(define *angle_22/16*
  (new direction%
       [vector (cons -.382683 -.923880)]
       [min_cap 0]
       [gravity 1]))

(define *angle_23/16*
  (new direction%
       [vector (cons -.195090 -.980785)]
       [min_cap 0]
       [gravity 1]))

(define *angle_24/16*
  (new direction%
       [vector (cons 0 -1)]
       [min_cap 0]
       [gravity 1]))

(define *angle_25/16*
  (new direction%
       [vector (cons .195090 -.980785)]
       [min_cap 0]
       [gravity 1]))

(define *angle_26/16*
  (new direction%
       [vector (cons .382683 -.923880)]
       [min_cap 0]
       [gravity 1]))

(define *angle_27/16*
  (new direction%
       [vector (cons .555570 -.831470)]
       [min_cap 0]
       [gravity 1]))

(define *angle_28/16*
  (new direction%
       [vector (cons .707107 -.707107)]
       [min_cap 0]
       [gravity 1]))

(define *angle_29/16*
  (new direction%
       [vector (cons .831470 -.555570)]
       [min_cap 0]
       [gravity 1]))

(define *angle_30/16*
  (new direction%
       [vector (cons .923880 -.382683)]
       [min_cap 0]
       [gravity 1]))

(define *angle_31/16*
  (new direction%
       [vector (cons .980785 -.195090)]
       [min_cap 0]
       [gravity 1]))


;Placing all directions in a hash table
;for easy access.
(define £Directions (hash 0 *angle_0*
                          1 *angle_1/16*
                          2 *angle_2/16*
                          3 *angle_3/16*
                          4 *angle_4/16*
                          5 *angle_5/16*
                          6 *angle_6/16*
                          7 *angle_7/16*
                          8 *angle_8/16*
                          9 *angle_9/16*
                          10 *angle_10/16*
                          11 *angle_11/16*
                          12 *angle_12/16*
                          13 *angle_13/16*
                          14 *angle_14/16*
                          15 *angle_15/16*
                          16 *angle_16/16*
                          17 *angle_17/16*
                          18 *angle_18/16*
                          19 *angle_19/16*
                          20 *angle_20/16*
                          21 *angle_21/16*
                          22 *angle_22/16*
                          23 *angle_23/16*
                          24 *angle_24/16*
                          25 *angle_25/16*
                          26 *angle_26/16*
                          27 *angle_27/16*
                          28 *angle_28/16*
                          29 *angle_29/16*
                          30 *angle_30/16*
                          31 *angle_31/16*))

;_________________________________________________
;_________________________________________________
;----------------Defining players-----------------
;_________________________________________________
;_________________________________________________

(define *player_1*
  (new airplane%
       [speed 5]
       [direction 0]
       [bl_corner (cons 0 0)]
       [br_corner (cons 100 0)]
       [tl_corner (cons 0 100)]
       [tr_corner (cons 100 100)]
       [projected_bl_corner (cons 0 0)]
       [projected_br_corner (cons 100 0)]
       [projected_tl_corner (cons 0 100)]
       [projected_tr_corner (cons 100 100)]
       [center_of_gravity (cons 50 50)]))

(define *player_2*
  (new airplane%
       [speed 5]
       [direction 0]
       [bl_corner (cons 155 155)]
       [br_corner (cons 180 155)]
       [tl_corner (cons 155 195)]
       [tr_corner (cons 180 195)]
       [projected_bl_corner (cons 155 155)]
       [projected_br_corner (cons 180 155)]
       [projected_tl_corner (cons 155 195)]
       [projected_tr_corner (cons 180 195)]
       [center_of_gravity (cons 167.5 175)]))


;_________________________________________________
;_________________________________________________
;------------Defining the main world--------------
;_________________________________________________
;_________________________________________________

(define *world*
  (new world%))

(send *world* $Add_Flying_Unit *player_1*)
(send *world* $Add_Flying_Unit *player_2*)