(in-package :cl-user)
(defpackage cl-pov-test
  (:use :cl
        :cl-pov
        :prove))
(in-package :cl-pov-test)

;; NOTE: To run this test file, execute `(asdf:test-system :cl-pov)' in your Lisp.

(plan 45)
(defmacro test (&key case result)
  `(is (pov:ray nil ,case)
       ,result #'string=))

(test
 :case
 (:global_settings
  (:adc_bailout 1/255)
  (:ambient_light <1 1 1>)
  (:hf_gray_16 :off)
  (:irid_wavelength <0.25 0.18 0.14>)
  (:charset :ascii)
  (:max_intersections 64)
  (:max_trace_level 5)
  (:number_of_waves 10)
  (:noise_generator 2))
 :result
 "global_settings {
adc_bailout 1/255
ambient_light <1,1,1>
hf_gray_16 off
irid_wavelength <0.25,0.18,0.14>
charset ascii
max_intersections 64
max_trace_level 5
number_of_waves 10
noise_generator 2
}")

(test 
 :case
 (:camera
  (:perspective)
  (:location <0 0 0>)
  (:direction <0 0 1>)
  (:right <1.33 0 0>)
  (:sky <0 1 0>)
  (:up <0 1 0>)
  (:look_at <0 0 1>))
 :result
 "camera {
perspective
location <0,0,0>
direction <0,0,1>
right <1.33,0,0>
sky <0,1,0>
up <0,1,0>
look_at <0,0,1>
}")

(test
 :case
 (:light_group
  (:light_source
   <5 -3 5>
   (:color 0.7)
   (:parallel)
   (:point_at <5 -1 0>))
  (:sphere
   <-1.5 0 1> 1
   (:pigment
    (:color (:rgb <0.7 0.5 0.5>)))))
 :result
 "light_group {
light_source {
<5,-3,5>
color 0.7
parallel
point_at <5,-1,0>
}
sphere {
<-1.5,0,1>, 1
pigment {
color rgb <0.7,0.5,0.5>
}
}
}")

(test
 :case
 (:pigment
  (:gradient :y)
  (:color_map
   (0.8 (:color (:rgb <0.3 0.4 1.2>)))
   (0.999 (:color (:rgb <1 1 0.9>)) (:filter 0.1))
   (0.9995 (* "White" 1.2)))
  (:rotate (* :x 30)))
 :result
 "pigment {
gradient y
color_map {
[0.8 color rgb <0.3,0.4,1.2>]
[0.999 color rgb <1,1,0.9> filter 0.1]
[0.9995 White*1.2]
}
rotate x*30
}")

(test
 :case
 (:fog
  (:color "White")
  (:fog_type 2)
  (:fog_alt 0.05)
  (:fog_offset 0.1)
  (:distance 0.2)
  (:rotate (* :x 90))
  (:turbulence (* :z 0.2))
  (:turb_depth 0.2))
 :result
 "fog {
color White
fog_type 2
fog_alt 0.05
fog_offset 0.1
distance 0.2
rotate x*90
turbulence z*0.2
turb_depth 0.2
}")

(test
 :case
 (:media
  (:intervals  10)
  (:samples  1 1)
  (:confidence  0.9)
  (:variance   1/128)
  (:ratio  0.9)
  (:method  3)
  (:aa_level  4)
  (:aa_threshold  0.1))
 :result
 "media {
intervals 10
samples 1, 1
confidence 0.9
variance 1/128
ratio 0.9
method 3
aa_level 4
aa_threshold 0.1
}")

(test
 :case
 (:media
  (:intervals 50)
  (:samples 5 10)
  (:scattering 4 (:rgb 0.05))
  (:density
   (:agate)
   (:color_map
    (0.2 (:color (* "White" 0.6)))
    (0.4 (:color "White"))
    (0.8 (:color (* "White" 0.1))))))
 :result
 "media {
intervals 50
samples 5, 10
scattering {
4, rgb 0.05
}
density {
agate
color_map {
[0.2 color White*0.6]
[0.4 color White]
[0.8 color White*0.1]
}
}
}")
(test
 :case
 (:sphere
  <0 0 3.2> 3
  (:material "M_Glass3")
  (:photons
   (:target)
   (:collect :off)
   (:reflection :on)
   (:refraction :off)))
 :result
 "sphere {
<0,0,3.2>, 3
material {
M_Glass3
}
photons {
target
collect off
reflection on
refraction off
}
}")

(test
 :case
 (:global_settings
  (:radiosity
   (:pretrace_start 0.08)
   (:pretrace_end 0.04)
   (:count 35)
   (:nearest_count 5)
   (:error_bound 1.8)
   (:recursion_limit 3)
   (:low_error_factor 0.5)
   (:gray_threshold 0.0)
   (:minimum_reuse 0.015)
   (:brightness 1)
   (:adc_bailout (/ 0.01 2))))
 :result
 "global_settings {
radiosity {
pretrace_start 0.08
pretrace_end 0.04
count 35
nearest_count 5
error_bound 1.8
recursion_limit 3
low_error_factor 0.5
gray_threshold 0.0
minimum_reuse 0.015
brightness 1
adc_bailout 0.01/2
}
}")

(test
 :case
 (:box
  <0 0 0> <1 1 1>
  (:pigment
   (:checker (* "White" 1.5)
	     (:color (:rgb <0.5 0.8 0.4>)))
   (:scale 0.25))
  (:finish
   (:phong 1)
   (:reflection 0.1))
  (:translate <-0.5 -0.5 0>))
 :result
 "box {
<0,0,0>, <1,1,1>
pigment {
checker White*1.5, color rgb <0.5,0.8,0.4>
scale 0.25
}
finish {
phong 1
reflection {
0.1
}
}
translate <-0.5,-0.5,0>
}")

(test
 :case
 (:sphere
  0 1
  (:scale <0.5 2 0.5>)
  (:rotate (* :x 15))
  (:translate <-2 0 1>))
 :result
 "sphere {
0, 1
scale <0.5,2,0.5>
rotate x*15
translate <-2,0,1>
}")

(test
 :case 
 (:cylinder
  0 (* :z 1) 0.5
  (:open)
  (:pigment
   (:checker (* "White" 1.2) "Red")
   (:scale 0.25))
  (:finish
   (:phong 1)
   (:reflection 0.1))
  (:translate <0.7 0 0>))
  :result
  "cylinder {
0, z*1, 0.5
open
pigment {
checker White*1.2, Red
scale 0.25
}
finish {
phong 1
reflection {
0.1
}
}
translate <0.7,0,0>
}")
(test
 :case
 (:cone
  0 1 (* :z 1) 0.5
  (:open)
  (:pigment
   (:checker (* "White" 1.2) (* "White" 0.0))
   (:scale 0.5))
  (:finish
   (:phong 1)
   (:reflection 0.1))
  (:rotate (* :x 60))
  (:translate <-2 1 1>))
 :result
 "cone {
0, 1, z*1, 0.5
open
pigment {
checker White*1.2, White*0.0
scale 0.5
}
finish {
phong 1
reflection {
0.1
}
}
rotate x*60
translate <-2,1,1>
}")

(test
 :case
 (:torus
  1 0.3
  (:pigment
   (:checker
    (:color (:rgb (* <1 0.8 0.4> 1.5)))
    (:color (:rgb <1 1 0.8>)))
   (:scale 1))
  (:finish
   (:phong 1)
   (:reflection 0.2))
  (:rotate (* :x -60))
  (:translate (* :z 1)))
 :result
 "torus {
1, 0.3
pigment {
checker color rgb <1,0.8,0.4>*1.5, color rgb <1,1,0.8>
scale 1
}
finish {
phong 1
reflection {
0.2
}
}
rotate x*-60
translate z*1
}")

(test
 :case
 (:disc
  0 :z 1 0
  (:pigment
   (:checker (* "White" 1.2)
	     (:color (:rgb <0.3 1 1>)))
   (:scale 0.25))
  (:finish
   (:phong 1)
   (:reflection 0.1))
  (:rotate (* :x 15))
  (:translate <0 0.5 1.5>))
 :result
 "disc {
0, z, 1, 0
pigment {
checker White*1.2, color rgb <0.3,1,1>
scale 0.25
}
finish {
phong 1
reflection {
0.1
}
}
rotate x*15
translate <0,0.5,1.5>
}")

(test
 :case
 (:superellipsoid
  <0.25 3.0>
  (:pigment
   (:checker (* "White" 1.2)
	     (:color (:rgb <0.9 0.6 0.2>)))
   (:scale 2.5))
  (:finish
   (:phong 1)
   (:reflection 0.2))
  (:scale 0.5)
  (:translate <-1.2 0 0.5>))
 :result
 "superellipsoid {
<0.25,3.0>
pigment {
checker White*1.2, color rgb <0.9,0.6,0.2>
scale 2.5
}
finish {
phong 1
reflection {
0.2
}
}
scale 0.5
translate <-1.2,0,0.5>
}")

(test
 :case
 (:triangle
  <-1 -1 0>  <1 -1 0>  <0 1.23 0>
  (:pigment
   (:checker (* "White" 1.2)
	     (:color (:rgb (* <1 0.2 0.2> 1.2))))
   (:scale 0.5))
  (:finish
   (:phong 1)
   (:reflection 0.2))
  (:rotate <30 30 0>)
  (:translate (* :z 1)))
 :result
 "triangle {
<-1,-1,0>, <1,-1,0>, <0,1.23,0>
pigment {
checker White*1.2, color rgb <1,0.2,0.2>*1.2
scale 0.5
}
finish {
phong 1
reflection {
0.2
}
}
rotate <30,30,0>
translate z*1
}")
(test
 :case
 (:polygon
  4
  <-0.5 -0.5>  <0.5 -0.5>  <0 1.23>  <-0.5 -0.5>
  (:pigment
   (:color (:rgb (* <0.8 0.8 0.4> 2))))
  (:rotate (* :x 30))
  (:translate <-2 0 1>))
 :result
 "polygon {
4,
<-0.5,-0.5>, <0.5,-0.5>, <0,1.23>, <-0.5,-0.5>
pigment {
color rgb <0.8,0.8,0.4>*2
}
rotate x*30
translate <-2,0,1>
}")
(test
 :case
 (:mesh
  (:triangle
   :x :y :z
   (:texture "T_2"))
  (:translate (* :z 0.5)))
 :result
 "mesh {
triangle {
x, y, z
texture {
T_2
}
}
translate z*0.5
}")

(test
 :case
 (:mesh2
  (:vertex_vectors
   9  
   <0 0 0>  <0.5 -0.2 0>  <0.5 0.5 0.3> 
   <1 0 0>  <1.2 0.5 0>  <1 1 0> 
   <0.5 1.2 0>  <0 1 0>  <-0.2 0.5 0>)
  (:face_indices
   8  
   <0 1 2>  <1 3 2> 
   <3 4 2>  <4 5 2> 
   <5 6 2>  <6 7 2> 
   <7 8 2>  <8 0 2>)
  (:texture "T_Grnt23"))
 :result
 "mesh2 {
vertex_vectors {
9,
<0,0,0>, <0.5,-0.2,0>, <0.5,0.5,0.3>, <1,0,0>, <1.2,0.5,0>, <1,1,0>, <0.5,1.2,0>, <0,1,0>, <-0.2,0.5,0>
}
face_indices {
8,
<0,1,2>, <1,3,2>, <3,4,2>, <4,5,2>, <5,6,2>, <6,7,2>, <7,8,2>, <8,0,2>
}
texture {
T_Grnt23
}
}")
(test
 :case
 (:sor
  13
  <0 0> <0.5 0.01> <0.5 0.1> <0.4 0.11> <0.4 0.2> 
  <0.3 0.21> <0.3 1.89> <0.4 1.9> <0.4 1.99> 
  <0 2> <0.3 2.2> <0 2.4> <0 2.5>
  (:sturm)
  (:pigment
   (:color (:rgb <1.0 0.8 0.3>)))
  (:finish
   (:phong 1)
   (:reflection 0.2))
  (:rotate (* :x 90)))
  :result
  "sor {
13,
<0,0>, <0.5,0.01>, <0.5,0.1>, <0.4,0.11>, <0.4,0.2>, <0.3,0.21>, <0.3,1.89>, <0.4,1.9>, <0.4,1.99>, <0,2>, <0.3,2.2>, <0,2.4>, <0,2.5>
sturm
pigment {
color rgb <1.0,0.8,0.3>
}
finish {
phong 1
reflection {
0.2
}
}
rotate x*90
}")

(test
 :case 
 (:lathe
  (:linear_spline)
  10 
  <1 0> <1 0.1> <0.5 0.4> <1 1.5> <0.5 2>
  <0.4 2> <0.9 1.5> <0.4 0.4> <0.8 0> <1 0>
  (:pigment
   (:color (:rgb <1 0.8 0.3>)))
  (:finish
   (:phong 1)
   (:reflection 0.1))
  (:rotate (* :x 90))
  (:scale <0.5 0.5 1>)
  (:translate (* :x -1.5)))
 :result
 "lathe {
linear_spline
10,
<1,0>, <1,0.1>, <0.5,0.4>, <1,1.5>, <0.5,2>, <0.4,2>, <0.9,1.5>, <0.4,0.4>, <0.8,0>, <1,0>
pigment {
color rgb <1,0.8,0.3>
}
finish {
phong 1
reflection {
0.1
}
}
rotate x*90
scale <0.5,0.5,1>
translate x*-1.5
}")

(test
 :case
 (:prism
  (:linear_sweep)
  (:linear_spline)
  0 2 14
  <-1 -1> <-0.5 -0.5> <0.5 -0.5>
  <1 -1> <1 1> <0.5 0.5> <-0.5 0.5>
  <-1 1> <-1 -1> <-0.75 -0.3>
  <0.75 -0.3> <0.75 0.3>
  <-0.75 0.3> <-0.75 -0.3>
  (:translate <-2.5 -1 2>))
 :result
 "prism {
linear_sweep
linear_spline
0, 2, 14,
<-1,-1>, <-0.5,-0.5>, <0.5,-0.5>, <1,-1>, <1,1>, <0.5,0.5>, <-0.5,0.5>, <-1,1>, <-1,-1>, <-0.75,-0.3>, <0.75,-0.3>, <0.75,0.3>, <-0.75,0.3>, <-0.75,-0.3>
translate <-2.5,-1,2>
}")

(test
 :case
 (:sphere_sweep
  (:linear_spline)
  4
  <-0.5 0 0>  0.1
  <-0.5 0 1>  0.1
  < 0.5 0 0>  0.1
  < 0.5 0 1>  0.1)
 :result
"sphere_sweep {
linear_spline
4,
<-0.5,0,0>, 0.1
<-0.5,0,1>, 0.1
<0.5,0,0>, 0.1
<0.5,0,1>, 0.1
}")

(test
 :case
 (:height_field
  (:tga #?"hf_image_0.tga"
	(:smooth)
	(:rotate (* :x 90)))
  (:pigment
   (:color (:rgb <0.4 0.8 0.2>)))
  (:finish
   (:phong 1)
   (:reflection 0.1))
  (:translate <-0.5 0.5 0>)
  (:scale <2 2 0.5>))
 :result
"height_field {
tga \"hf_image_0.tga\" smooth rotate x*90
pigment {
color rgb <0.4,0.8,0.2>
}
finish {
phong 1
reflection {
0.1
}
}
translate <-0.5,0.5,0>
scale <2,2,0.5>
}")

(test
 :case
 (:blob
  (:threshold 0.27)
  (:sphere <-1 0 3> 1.5 0.5)
  (:sphere <1 0 3> 1.5 0.5)
  (:cylinder (- (* :x 2)) (* :x 2) 1.5 0.5
	     (:translate (* :z 1)))
  (:pigment
   (:color (:rgb (* <1 0.8 0.3> 1.5))))
  (:finish
   (:phong 1)
   (:reflection 0.1))
  (:scale 0.5))
 :result
 "blob {
threshold 0.27
sphere {
<-1,0,3>, 1.5, 0.5
}
sphere {
<1,0,3>, 1.5, 0.5
}
cylinder {
-x*2, x*2, 1.5, 0.5
translate z*1
}
pigment {
color rgb <1,0.8,0.3>*1.5
}
finish {
phong 1
reflection {
0.1
}
}
scale 0.5
}")

(test
 :case
 (:julia_fractal
  <0.3 0.5 0.0 0.3>
  (:quaternion)
  (:pigment
   (:color (:rgb (* <1 0.6 0> 1.5))))
  (:finish
   (:phong 1))
  (:rotate <0 -90 180>)
  (:translate (* :z 1)))
 :result
 "julia_fractal {
<0.3,0.5,0.0,0.3>
quaternion
pigment {
color rgb <1,0.6,0>*1.5
}
finish {
phong 1
}
rotate <0,-90,180>
translate z*1
}")
(test
 :case
 (:text
  (:ttf #?"c:\WINDOWS\FONTS\Arial.ttf"
	#?"POV-Ray"
	1 (* :x (- 0.03)))
  (:pigment
   (:color (:rgb (* <1 0.6 0.6> 2))))
  (:finish
   (:phong 1)
   (:reflection 0.2))
  (:rotate (* :x 90))
  (:translate <-2 1 2>))
 :result
 "text {
ttf \"c:\WINDOWS\FONTS\Arial.ttf\", \"POV-Ray\", 1, x*-0.03
pigment {
color rgb <1,0.6,0.6>*2
}
finish {
phong 1
reflection {
0.2
}
}
rotate x*90
translate <-2,1,2>
}")

(test
 :case
 (:plane
  :z 0
  (:pigment
   (:checker (* "White" 1.2) (:color (:rgb (* <0.5 0.9 0.9> 0.5))))
   (:scale 0.2))
  (:finish
   (:phong 1)
   (:reflection 0.3)))
 :result
 "plane {
z, 0
pigment {
checker White*1.2, color rgb <0.5,0.9,0.9>*0.5
scale 0.2
}
finish {
phong 1
reflection {
0.3
}
}
}")

(test
 :case
 (:quadric
  <1 1 -1> <0 0 0> <0 0 0> -1
  (:clipped_by "Box")
  (:transform "U_2"))
 :result
 "quadric {
<1,1,-1>, <0,0,0>, <0,0,0>, -1
clipped_by {
Box
}
transform U_2
}")

(test
 :case
 (:quartic
  <1 0 0 0 0 0 0 
  0 1 0 0 0 0 0 
  0 0 1 0 0 0 0 
  0 0 0 1 0 0 0 
  0 0 0 0 1 0 1>
  (:texture "Check"))
 :result
  "quartic {
<1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,1>
texture {
Check
}
}")
(test
 :case
 (:poly
  5 
  <1 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 1 
  0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 1 1>
  (:pigment
   (:checker (* "White" 1.8) (:color (:rgb (* <1 1 0.3> 1.5)))))
  (:finish
   (:phong 1)
   (:reflection 0.1))
  (:rotate (* :y -90)))
 :result
 "poly {
5, <1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,1>
pigment {
checker White*1.8, color rgb <1,1,0.3>*1.5
}
finish {
phong 1
reflection {
0.1
}
}
rotate y*-90
}")
(test
 :case
 (:bicubic_patch
  (:type 1)
  (:flatness 0)
  (:u_steps 4)
  (:v_steps 4)
  <0 0 0> <1 0 1> <2 0 1> <3 0 0>
  <0 1 1> <1 1 1> <2 1 1> <3 1 1>
  <0 2 1> <1 2 1> <2 2 1> <3 2 1>
  <0 3 0> <1 3 1> <2 3 1> <3 3 2>
  (:pigment
   (:checker (* "White" 1.2) (:color (:rgb <0.2 1 1>)))
   (:scale 0.5))
  (:finish
   (:phong 1)
   (:reflection 0.2))
  (:translate <-1.5 -1.5 0>))
 :result
 "bicubic_patch {
type 1
flatness 0
u_steps 4
v_steps 4
<0,0,0>, <1,0,1>, <2,0,1>, <3,0,0>, <0,1,1>, <1,1,1>, <2,1,1>, <3,1,1>, <0,2,1>, <1,2,1>, <2,2,1>, <3,2,1>, <0,3,0>, <1,3,1>, <2,3,1>, <3,3,2>
pigment {
checker White*1.2, color rgb <0.2,1,1>
scale 0.5
}
finish {
phong 1
reflection {
0.2
}
}
translate <-1.5,-1.5,0>
}")

(test
 :case
 (:union
  (:cone
   (* :x -1.8) 1.5 (* :x 1.5) 0.5
   (:texture "Bump_Check"))
  (:sphere
   :x 1.8
   (:texture "Bump_Leopard"))
  (:clipped_by
   (:plane :z 0)))
 :result
 "union {
cone {
x*-1.8, 1.5, x*1.5, 0.5
texture {
Bump_Check
}
}
sphere {
x, 1.8
texture {
Bump_Leopard
}
}
clipped_by {
plane {
z, 0
}
}
}")

(test
 :case
 (:intersection
  (:cone
   (* :x -1.8) 1.5 (* :x 1.5) 0.5
   (:texture "Bump_Check"))
  (:sphere
   :x 1.8
   (:texture "Bump_Leopard"))
  (:clipped_by
   (:plane :z 0)))
 :result
 "intersection {
cone {
x*-1.8, 1.5, x*1.5, 0.5
texture {
Bump_Check
}
}
sphere {
x, 1.8
texture {
Bump_Leopard
}
}
clipped_by {
plane {
z, 0
}
}
}")

(test
 :case
 (:difference
  (:cone
   (* :x -1.8) 1.5 (* :x 1.5) 0.5
   (:texture "Bump_Check"))
  (:sphere
   :x 1.8
   (:texture "Bump_Leopard"))
  (:clipped_by
   (:plane :z 0)))
 :result
 "difference {
cone {
x*-1.8, 1.5, x*1.5, 0.5
texture {
Bump_Check
}
}
sphere {
x, 1.8
texture {
Bump_Leopard
}
}
clipped_by {
plane {
z, 0
}
}
}")

(test
 :case
 (:merge
  (:cone
   (* :x -1.8) 1.5 (* :x 1.5) 0.5
   (:texture "Bump_Check"))
  (:sphere
   :x 1.8
   (:texture "Bump_Leopard"))
  (:clipped_by
   (:plane :z 0)))
 :result
 "merge {
cone {
x*-1.8, 1.5, x*1.5, 0.5
texture {
Bump_Check
}
}
sphere {
x, 1.8
texture {
Bump_Leopard
}
}
clipped_by {
plane {
z, 0
}
}
}")

(test
 :case
 (:object
  (:cylinder
   <-5 0.5 0.5> <5 0.5 0.5> 0.3
   (:pigment
    (:color (:rgb 0.8))))
  (:bounded_by
   (:box
    <0 0 0>  <1 1 1>
    (:pigment
     (:color (:rgb 0.5)))))
  (:clipped_by
   (:bounded_by)))
 :result
 "object {
cylinder {
<-5,0.5,0.5>, <5,0.5,0.5>, 0.3
pigment {
color rgb 0.8
}
}
bounded_by {
box {
<0,0,0>, <1,1,1>
pigment {
color rgb 0.5
}
}
}
clipped_by {
bounded_by
}
}")

(test
 :case
 (:object
  (:cylinder
   <-5 0.5 0.5> <5 0.5 0.5> 0.3
   (:pigment
    (:color (:rgb 0.8))))
  (:clipped_by
   (:box
    <0 0 0>  <1 1 1>
    (:pigment
     (:color (:rgb 0.5)))))
  (:bounded_by
   (:clipped_by)))
 :result
 "object {
cylinder {
<-5,0.5,0.5>, <5,0.5,0.5>, 0.3
pigment {
color rgb 0.8
}
}
clipped_by {
box {
<0,0,0>, <1,1,1>
pigment {
color rgb 0.5
}
}
}
bounded_by {
clipped_by
}
}")

(test
 :case
 (:union
  (:sphere
   (* -0.5 :x) 1
   (:hollow :off))
  (:sphere
   (* 0.5 :x) 1)
  (:hollow))
 :result
 "union {
sphere {
-0.5*x, 1
hollow off
}
sphere {
0.5*x, 1
}
hollow
}")

(test
 :case
 (:sphere
  <-0.5 0 0.1> 0.4  
  (:no_shadow)
  (:texture
   (:finish
    "Shiny")
   (:pigment
    (:color (:rgb <1 0.6 1>)))))
 :result
 "sphere {
<-0.5,0,0.1>, 0.4
no_shadow
texture {
finish {
Shiny
}
pigment {
color rgb <1,0.6,1>
}
}
}")

(test
 :case
 (:sphere
  <-0.5 0 0.1> 0.4  
  (:no_reflection)
  (:texture
   (:finish
    "Shiny")
   (:pigment
    (:color (:rgb <1 0.6 1>)))))
 :result
 "sphere {
<-0.5,0,0.1>, 0.4
no_reflection
texture {
finish {
Shiny
}
pigment {
color rgb <1,0.6,1>
}
}
}")

(test
 :case
 (:union
  (:light_source <0 0 0> "White")
  (:object
   (:sphere <0 0 0> 1)
   (:double_illuminate)))
 :result
 "union {
light_source {
<0,0,0>
White
}
object {
sphere {
<0,0,0>, 1
}
double_illuminate
}
}")

(test
 :case
 (:sphere
  (* :z 3) 1
  (:material "MyGlass"))
 :result
 "sphere {
z*3, 1
material {
MyGlass
}
}")
(test
 :case
 (:intersection
  (:sphere
   <0 0 0>  1  
   (:texture
    (:finish "Shiny")
    (:pigment
     (:color (:rgb <0.6 1 0.6>)))))
  (:box
   <0 0 0>  <1.5 1.5 1.5>
   (:inverse)
   (:pigment
    (:color (:rgb <1 0.7 0.2>))))
  (:translate (* :x -3)))
 :result
 "intersection {
sphere {
<0,0,0>, 1
texture {
finish {
Shiny
}
pigment {
color rgb <0.6,1,0.6>
}
}
}
box {
<0,0,0>, <1.5,1.5,1.5>
inverse
pigment {
color rgb <1,0.7,0.2>
}
}
translate x*-3
}")

(finalize)
