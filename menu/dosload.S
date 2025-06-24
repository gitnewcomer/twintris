;SS!

top=$7f000
maincl=103660
mainl=276184
menul=202370
works=35004

move.l	4,a6
move.l	#maincl+menul,d0
lea	top-maincl-menul,a1
jsr	-204(a6)
tst.l	d0
bne	rts1

lea	dosname,a1
move.l	4,a6
jsr	-408(a6)
move.l	d0,db

move.l	d0,a6
lea	mname(pc),a0
move.l	a0,d1
move.l	#1005,d2
move.l	db,a6
jsr	-30(a6)

move.l	d0,fhd
move.l	d0,d1
move.l	#top-menul,d2
move.l	#menul,d3
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
move.l	#top-maincl-menul,d2
move.l	#maincl,d3
move.l	db,a6
jsr	-42(a6)

move.l	fhd,d1
move.l	db,a6
jsr	-36(a6)

dong:
move	#$7fff,$dff09a
move	#$7fff,$dff096

lea	top-mainl-menul-works,a7
lea	gul(pc),a0
move.l	a0,$c
move.l	#fhd,$d
rts
illegal
dc.b	"!Bæå­ ']",0
even

gul:
lea	top-mainl-menul-works-2048,a7

lea	cp(pc),a0
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

move	#$4e75,$11a+top-mainl-works
jsr	top-mainl-works

move.l	4,a6
lea	clear(pc),a3
move.l	46(a6),oldpos+2
move.l	a3,46(a6)
clr.l	42(a6)
clr.l	d1
lea	36(a6),a0
move	#16,d0
gfgg:
add	(a0)+,d1
dbra	d0,gfgg
not	d1
move	d1,$82(a6)

lamba:
jsr	top-mainl-menul-works
jsr	top-mainl
bra	lamba

clear:
lea	top-mainl-menul-works,a0
move.l	[mainl+menul+works]/4,d0
ggr:
clr.l	(a0)+
subq.l	#1,d0
bne	ggr

oldpos:
jmp	0

cpe:



rts1:
rts

fhd:
dc.l	0

db:
dc.l	0

mname:
dc.b	"code",0

mgname:
dc.b	"music",0

dosname:
dc.b	"dos.library",0
even


