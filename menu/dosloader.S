;SS!

top=$7f000
maincl=102892
mainl=274960
menul=204254
works=35004

;>extern "df0:main",top-menul-maincl
;>extern "df0:menu",top-maincl-menul

lea	dosname,a1
move.l	4,a6
jsr	-408(a6)
move.l	d0,db

move.l	d0,a6
lea	mname(pc),a0
move.l	a0,d1
move.l	#1005,d2
jsr	-30(a6)
move.l	d0,fhd
bmi	rts

move.l	d0,d1
move.l	#top-maincl-menul,d2
move.l	#-1,d3
move.l	db,a6
jsr	-42(a6)

move.l	fhd,d1
move.l	db,a6
jsr	-36(a6)

lea	mgname(pc),a0
move.l	a0,d1
move.l	#1005,d2
move.l	db,a6
jsr	-30(a6)

move.l	d0,fhd
move.l	d0,d1
move.l	#top-maincl,d2
move.l	#-1,d3
move.l	db,a6
jsr	-42(a6)

move.l	fhd,d1
move.l	db,a6
jsr	-36(a6)

dong:
move	#$7fff,$dff09a

lea	top-mainl-menul-works,a7
move.l	#gul,$c
move.l	#fhd,$d
rts
illegal
dc.b	"!Bæå­ ']",0
even

gul:
lea	top-mainl-menul-works-2048,a7

lea	cp,a0
lea	top-mainl-menul-works-2048,a1
move	#cpe-cp-1,d0
g:
move.b	(a0)+,(a1)+
dbra	d0,g
jmp	top-mainl-menul-works-2048

cp:

lea	top-menul,a0
lea	top-mainl-menul-works,a1
move	#menul/4,d0
g2:
move.l	(a0)+,(a1)+
dbra	d0,g2

lea	top-menul-maincl,a0
lea	top-mainl-works,a1
move	#maincl/4,d0
g3:
move.l	(a0)+,(a1)+
dbra	d0,g3

move	rts1,$11a+top-mainl-works
jsr	top-mainl-works

lamba:
jsr	top-mainl-menul-works
jsr	top-mainl
bra	lamba

cpe:


rts:
rts1:
rts

fhd:
dc.l	0

mname:
dc.b	"menu",0

mgname:
dc.b	"main",0

dosname:
dc.b	"dos.library",0
even

db:
dc.l	0
