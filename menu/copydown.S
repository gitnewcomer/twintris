org	$7f000
load	$7f000

a:

lea	6946,a7
move.l	#b,$c
move.l	#a,$d

b:
lea	6000,a7

move	#$7fff,$dff09a
lea	$44d06,a0
lea	6946,a1
move	#203456/4,d0
g:
move.l	(a0)+,(a1)+
dbra	d0,g
jsr	6946

