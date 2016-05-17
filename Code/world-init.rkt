#lang racket/gui

(require "world.rkt")

(require "direction.rkt")

(require "airplane.rkt")
(require "projectile.rkt")
(require "building.rkt")
  
(require "basic-procedures.rkt")

(require "clock-class.rkt")

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
;----------------Defining bitmaps-----------------
;_________________________________________________
;_________________________________________________
(define *player_1_bitmap* 
  (make-object bitmap%
    "grafik/yellow-red-60-30.png"
    'png/alpha))

(define *player_2_bitmap*
  (make-object bitmap%
    "grafik/green-cyan-60-30.png"
    'png/alpha))

(define *player_3_bitmap*
  (make-object bitmap%
    "grafik/green-brown-60-30.png"
    'png/alpha))

(define *player_4_bitmap*
  (make-object bitmap%
    "grafik/blue-pink-60-30.png"
    'png/alpha))

(define *projectile_bitmap*
  (make-object bitmap%
    "grafik/bullet-11.png"
    'png/alpha))

(define *airplane_death_bitmap*
  (make-object bitmap%
    "grafik/explosion-60.png"
    'png/alpha))

(define *projectile_death_bitmap*
  (make-object bitmap%
    "grafik/explosion-13.png"
    'png/alpha))

;_________________________________________________
;_________________________________________________
;---------------Defining Building-----------------
;_________________________________________________
;_________________________________________________
(define *player_1_building*
  (new building%
       [bl_corner ($Vector 0 50)]
       [br_corner($Vector 150 50)]
       [tl_corner ($Vector 0 150)]
       [tr_corner ($Vector 150 150)]
       [center_of_gravity ($Vector 75 100)]))

(define *player_2_building*
  (new building%
       [bl_corner ($Vector 450 50)]
       [br_corner($Vector 600 50)]
       [tl_corner ($Vector 450 150)]
       [tr_corner ($Vector 600 150)]
       [center_of_gravity ($Vector 525 100)]))

(define *player_3_building*
  (new building%
       [bl_corner ($Vector 600 50)]
       [br_corner($Vector 750 50)]
       [tl_corner ($Vector 600 150)]
       [tr_corner ($Vector 750 150)]
       [center_of_gravity ($Vector 675 100)]))

(define *player_4_building*
  (new building%
       [bl_corner ($Vector 1050 50)]
       [br_corner($Vector 1200 50)]
       [tl_corner ($Vector 1050 150)]
       [tr_corner ($Vector 1200 150)]
       [center_of_gravity ($Vector 1125 100)]))
  




;_________________________________________________
;_________________________________________________
;----------------Defining players-----------------
;_________________________________________________
;_________________________________________________

(define *player_1*
  (new airplane%
       [speed 5]
       [direction 0]
       [bl_corner ($Vector 20 20)]
       [br_corner ($Vector 80 20)]
       [tl_corner ($Vector 20 50)]
       [tr_corner ($Vector 80 50)]
       [center_of_gravity ($Vector 50 35)]
       [projected_bl_corner ($Vector 20 20)]
       [projected_br_corner ($Vector 80 20)]
       [projected_tl_corner ($Vector 20 50)]
       [projected_tr_corner ($Vector 80 50)]
       [bitmap *player_1_bitmap*]
       [death_bitmap *airplane_death_bitmap*]))

(define *player_2*
  (new airplane%
       [speed 5]
       [direction 0]
       [bl_corner ($Vector 120 90)]
       [br_corner ($Vector 180 90)]
       [tl_corner ($Vector 120 120)]
       [tr_corner ($Vector 180 120)]
       [center_of_gravity ($Vector 150 115)]
       [projected_bl_corner ($Vector 120 90)]
       [projected_br_corner ($Vector 180 90)]
       [projected_tl_corner ($Vector 120 120)]
       [projected_tr_corner ($Vector 180 120)]
       [bitmap *player_2_bitmap*]
       [death_bitmap *airplane_death_bitmap*]))

;_________________________________________________
;_________________________________________________
;--------------Defining projectiles---------------
;_________________________________________________
;_________________________________________________
;A help procedure for creating a projectile. 
(define ($Make_Projectile center_ direction_ speed_)
  (new projectile%
       [radius 5.5]
       [center_of_gravity center_]
       [direction direction_]
       [speed speed_]
       [bitmap *projectile_bitmap*]
       [death_bitmap *projectile_death_bitmap*]))



;_________________________________________________
;_________________________________________________
;------------Defining the main world--------------
;_________________________________________________
;_________________________________________________

(define *world*
  (new world%
  [list_of_buildings (list *player_1_building*
                           *player_2_building*
                           *player_3_building*
                           *player_4_building*)]))

;_________________________________________________
;Adding units to the world
(send *world* $Add_Flying_Unit *player_1*)
(send *world* $Add_Flying_Unit *player_2*)
(send *world* $Add_Flying_Unit ($Make_Projectile ($Vector 400 400) 3 10))

(define *start_clock*
  (new clocking%
    [Should_Run #f]))

