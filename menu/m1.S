;SS!

;top=$7f000
maincl=103652
mainl=276184
menul=202370
works=35004

>extern	"objects2",obj+mainl+works	;ASS
>extern "inactive2",inactive+mainl+works	;ASS
>extern "active2",active+mainl+works	;ASS
>extern "font",font+mainl+works	;ASS
>extern "we're the devils",mt_data+mainl+works	;ASS

top=$7f000
screen=top-[44*256*3]-mainl	;ASS
keys=screen-128
track=keys-1082
tsync=track-2
font=tsync-8640
obj=font-[44*256*3]-16;	;TEST
inactive=obj-[40*156*3]
active=inactive-[40*156*3]
famedata=active-432
mt_data=famedata-110240

org	mt_data-11810
load	mt_data-11810+mainl+works	;ASS

a:
;-----

move	#150,volume
bsr	setvolume

lea	keys,a0
move	#31,d0
mbvt:
clr.l	(a0)+
dbra	d0,mbvt

move	#0,d0
bsr	changedrive

tst	setprefs
bne	noworry
lea	top+200,a0
lea	defpref,a1
move	#10,d0
vnv:
move	(a1)+,(a0)+
dbra	d0,vnv
not	setprefs
noworry:
move	oldgs,gamestate
bsr	mt_init
move	$dff01c,oldinten
bset	#7,oldinten
move	$dff002,olddmaen
bset	#7,olddmaen
move	#$7fff,$dff09a
vvq:
tst.b	$dff006
bne.S	vvq
btst	#0,$dff005
bne.S	vvq
move	#$7fff,$dff096

move.l	#copperlist,$dff080	;ASS
move	#0,$dff088	;ASS

move	#%1000011111100000,$dff096
move.l	$6c,oldvb
move.l	#vbi,$6c
move.l	$68,oldkeyb+2
move.l	#keyboard,$68
move	#$c028,$dff09a

tst	read
bne	rr
bsr	readfame
not	read
rr:

lea	pointers+2,a0
move	#2,d0
move.l	#screen,d1

vty:
move	d1,4(a0)
swap	d1
move	d1,(a0)
swap	d1
add.l	#[44*256],d1
addq.l	#8,a0
dbra	d0,vty

lea	p2,a0
move	#15,d0
move	#$1a0,d1
ft:
move	d1,(a0)+
add	#2,d1
clr	(a0)+
dbra	d0,ft

lea	palette,a0
move	#$180,d0
move	#7,d1
move.l	#obj+[44*256*3],a1
pon:
move	d0,(a0)+
addq	#2,d0
move	(a1)+,(a0)+
dbra	d1,pon

lea	wide,a0
lea	coords,a1

vui:
tst.b	(a0)
bmi	nyuo
clr	d0
move.b	(a0),d0
lsl	#1,d0
clr	d1
move.b	1(a0),d1
sub.b	(a0),d1
subq	#1,d1

move.b	(a1,d0.w),d2

vnu:
addq	#2,d0
add	#15,d2
move.b	d2,(a1,d0.w)
dbra	d1,vnu

addq.l	#2,a0
bra	vui

nyuo:

tst	nrs
beq	nhr

clr	d0
cmp	#20,level
blt	ffl
move	#1,d0
cmp	#21,level
blt	ffl
bgt	g23
move	#2,d0
bra	ffl

g23:
move	#3,d0

ffl:
mulu	#108,d0
lea	famedata,a0
add.l	d0,a0

move	nrs,d1
sub	#1,d1
lea	recscores,a1

nyscore:
move	2(a1),d3
cmp	106(a0),d3
blt	fds

cmp	#10,(a1)
blt	spn

movem.l	d0-d7/a0-a6,-(a7)
bsr	border

lea	lhs,a0
cmp	#11,(a1)
beq	phew
lea	rhs,a0
phew:
move.l	#screen+[44*100]+4,d6
move	#3,d7
move	#-1,d4
bsr	type

move.l	#screen+[44*76]+4,d6
move	#3,d7
move.l	#whot,a0
move	#-1,d4
bsr	type

move.l	#screen+[44*124]+4,d6
move	#3,d7
move.l	#obt,a0
move	#-1,d4
bsr	type

clr.l	d3
move	2(a1),d3

lea	asciiscore+5,a0
move	#4,d1
sivu3:
divu	#10,d3
swap	d3
add.b	#'0',d3
move.b	d3,-(a0)
clr	d3
swap	d3
dbra	d1,sivu3

move.l	#screen+[44*124]+28,d6
move	#3,d7
move.l	#asciiscore,a0
move	#-1,d4
bsr	type

move.l	#screen+[44*148]+4,d6
move	#3,d7
move.l	#pts,a0
move	#-1,d4
bsr	type



bsr	findname
movem.l	(a7)+,d0-d7/a0-a6
clr	(a1)

spn:
move	#10,d2

spnz:
cmp	(a0,d2.w),d3
bge	fp
add	#12,d2
bra	spnz

fp:
add	#2,d2
cmp	#108,d2
beq	puttinn

move.l	a0,a3
add	#108,a3
move.l	a0,a2
add	d2,a2

fn:
move	-14(a3),-(a3)
cmp.l	a2,a3
bgt	fn

puttinn:
move.l	a0,a2
sub	#12,a2
add	d2,a2

move	(a1),d4
mulu	#20,d4
lea	names,a3
add	d4,a3
move.l	(a3),(a2)
move.l	4(a3),4(a2)
move	8(a3),8(a2)
move	2(a1),10(a2)


fds:
addq.l	#4,a1
dbra	d1,nyscore


bsr	border

move.l	#screen+[44*6]+14,d6
move	#3,d7
move.l	#famet,a0
move	#-1,d4
bsr	type

move.l	#screen+[44*32]+2,d6

move	#"1.",rank
move.l	#famedata,a1

clr	d2
cmp	#20,level
blt	ffl3
move	#1,d2
cmp	#21,level
blt	ffl3
bgt	g233
move	#2,d2
bra	ffl3

g233:
move	#3,d2

ffl3:
mulu	#108,d2
add.l	d2,a1

move	#8,d0

rankl2:
move	#40,d3
veeee2:
cmp.b	#50,$dff006
bne	veeee2
v3:
cmp.b	#50,$dff006
beq	v3
dbra	d3,veeee2

lea	rank,a0
clr	d4
move	#32,d7
bsr	type

add.l	#6,d6
move.l	a1,a0
move	12(a0),d3
clr	12(a0)
bsr	type
move	d3,12(a0)


clr.l	d3
move	10(a1),d3

lea	asciiscore+5,a0
move	#4,d1

sivu2:
divu	#10,d3
swap	d3
add.b	#'0',d3
move.b	d3,-(a0)
clr	d3
swap	d3
dbra	d1,sivu2

lea	asciiscore,a0
move	#32,d7
add.l	#24,d6
clr	d4
bsr	type


add.l	#12,a1
add.l	#14+[23*44],d6

add.b	#1,rank
dbra	d0,rankl2

bsr	writefame

mmi:
add	#1,rn
move.l	a_stickpo,stickpo
bsr	makestick
tst	feuer
bne	haumbug
move.l	b_stickpo,stickpo
bsr	makestick
tst	feuer
bne	haumbug
tst.b	keys+$45
beq	mmi

haumbug:
add	#1,rn
move.l	a_stickpo,stickpo
bsr	makestick
tst	feuer
bne	haumbug
move.l	b_stickpo,stickpo
bsr	makestick
tst	feuer
bne	haumbug

nhr:

move.l	a7,ressetpointer

resset:
bsr	border
move	#-1,onmain
bsr	mainmenu
clr	onmain

cmp	#9168,d1
beq	exit
blt	fame
bra	controlmnu

nextf:
cmp.b	#50,$dff006
beq.S	nextf
nf2:
cmp.b	#50,$dff006
bne.s	nf2
;btst	#0,$dff005
;bne.S	nextf
tst.b	keys+$45
beq	rts
tst	onmain
bne	rts
reset1:
tst	defingkeys
beq	reset
move.l	baa,lk1
move.l	bab,lk2
move	upb,upp
move	upb,up
cmp	#$df,a_stickpo
beq	reset
move	baa,a_stickpo
cmp.b	#$df,b_stickpo
beq	reset
move	bab,b_stickpo
reset:
clr	defingkeys
move.l	ressetpointer,a7
bra	resset
rts:
rts

whot:
dc.b	"WHO PLAYED ON THE",0
rhs:
dc.b	" RIGHT HAND SIDE ",0
lhs:
dc.b	" LEFT HAND  SIDE",0
obt:
dc.b	"AND SCORED ",0
pts:
dc.b	"    POINTS ?",0
even

fame:
clr	actives
bsr	border

clr	x
clr	y
move	#1,mx
move	#4,my

clr	d2
move	#30,d0
move	#1764,d1
bsr	icon
move	#1580,d0
move	#4228,d1
bsr	icon
move	#1590,d0
move	#6692,d1
bsr	icon
move	#3120,d0
move	#9156,d1
bsr	icon

move.l	#screen+[44*6]+14,d6
move	#3,d7
move.l	#famet,a0
move	#-1,d4
bsr	type

move.l	#screen+[44*100]+20,d6
move	#3,d7
move.l	#selectt,a0
move	#-1,d4
bsr	type

move.l	#screen+[44*124]+20,d6
move	#3,d7
move.l	#category,a0
move	#-1,d4
bsr	type

move	#1764,d2
bsr	ramme

bsr	ctrl_move

move	d2,d1
move	#3120,d0
move	#3,d5

cmp	#6692,d1
bgt	fri
beq	ee

move	#30,d0
clr	d5
cmp	#1764,d1
beq	fri
move	#1580,d0
move	#1,d5
bra	fri

ee:
move	#3120,d0
move	#2,d5
fri:

move	#-1,d2
bsr	icon

humbugg:
add	#1,rn
move.l	a_stickpo,stickpo

bsr	makestick
tst	feuer
bne	humbugg
move.l	b_stickpo,stickpo
bsr	makestick
tst	feuer
bne	humbugg
clr	d2
bsr	icon
move	d1,d2
bsr	ramme

;;bsr	readfame
bsr	border

move.l	#screen+[44*6]+14,d6
move	#3,d7
move.l	#famet,a0
move	#-1,d4
bsr	type

move.l	#screen+[44*32]+2,d6

move	#"1.",rank
move	#8,d0
move.l	#famedata,a1
move	d5,d2
mulu	#108,d2
add.l	d2,a1

rankl:

move	#20,d3
veeee:
bsr	nextf
dbra	d3,veeee

lea	rank,a0
clr	d4
move	#32,d7
bsr	type

add.l	#6,d6
move.l	a1,a0
move	12(a0),d3
clr	12(a0)
bsr	type
move	d3,12(a0)

clr.l	d3
move	10(a1),d3

lea	asciiscore+5,a0
move	#4,d1

sivu4:
divu	#10,d3
swap	d3
add.b	#'0',d3
move.b	d3,-(a0)
clr	d3
swap	d3
dbra	d1,sivu4

lea	asciiscore,a0
move	#32,d7
add.l	#24,d6
clr	d4
bsr	type


add.l	#12,a1
add.l	#14+[23*44],d6

add.b	#1,rank
dbra	d0,rankl


we:
bsr	nextf
bra	we

asciiscore:
dc.b	"00000",0
rank:
dc.b	"1. ",0


mainmenu:
move	#9168,d2
move	#1,x
move	#3,y
move	#3,mx
move	#4,my

lea	sprites+2,a0
move	#15,d0
muy:
clr	(a0)
addq.l	#4,a0
dbra	d0,muy

mainmnu:

move	d2,-(a7)

clr	actives
move	#1452,d0
move	#44,d1
move	#8,d2
move	#[44*80],d3
bsr	bo
move	#44*6,d0
move	#2,d1
move	#2,d2
move	#[44*86],d3
bsr	bo
move	#[44*6]+42,d0
move	#2,d1
move	#2,d2
move	#[44*86]+42,d3
bsr	bo

move	#1452,d0
move	#44,d1
move	#8,d2
move	#[44*192],d3
bsr	bo
move	#44*6,d0
move	#2,d1
move	#2,d2
move	#[44*198],d3
bsr	bo
move	#[44*6]+42,d0
move	#2,d1
move	#2,d2
move	#[44*198]+42,d3
bsr	bo

move	#1804,d0
move	#4,d1
move	#15,d2
move	#10292,d3
bsr	bo
move	#6100,d0
move	#2,d1
move	#28,d2
move	#4502,d3
bsr	bo
move	#4514,d3
bsr	bo
move	gamestate,d3
clr	d2
tst	d3
bne	np0
move	#-1,d2

np0:
move	#0,d0
move	#1764,d1
bsr	icon
move	d3,d2
and	#1,d2
move	#10,d0
move	#1776,d1
bsr	icon
move	#20,d0
move	#1788,d1
move	d3,d2
and	#2,d2
bsr	icon
move	#30,d0
move	#4228,d1
clr	d2
cmp	#0,level
bne	nl0
not	d2
nl0:
bsr	icon
move	#1560,d0
move	#4240,d1
clr	d2
cmp	#6,level
bne	nl2
not	d2
nl2:
bsr	icon
move	#1570,d0
move	#4252,d1
clr	d2
cmp	#12,level
bne	nl5
not	d2
nl5:
bsr	icon
move	#1580,d0
move	#6692,d1
clr	d2
cmp	#20,level
bne	nl19
not	d2
nl19:
bsr	icon
move	#1590,d0
move	#6704,d1
clr	d2
cmp	#21,level
bne	nl20
not	d2
nl20:
bsr	icon
move	#3120,d0
move	#6716,d1
clr	d2
cmp	#22,level
bne	nl21
not	d2
nl21:
bsr	icon
clr	d2
move	#3130,d0
move	#9156,d1
bsr	icon
move	#3140,d0
move	#9168,d1
bsr	icon
move	#3150,d0
move	#9180,d1
bsr	icon
move.l	#screen+[44*6]+14,d6
move	#3,d7
move.l	#mainmenut,a0
move	#-1,d4
bsr	type
move	(a7)+,d2
bsr	ramme

mm:
add	#1,rn
move.l	a_stickpo,stickpo
bsr	makestick
tst	feuer
bne	mm
move.l	b_stickpo,stickpo
bsr	makestick
tst	feuer
bne	mm

bsr	ctrl_move
cmp	#7000,d2
blt	nnm
move	d2,d1
move	#-1,d2
cmp	#9168,d1
bgt	i3150
beq	i3140
move	#3130,d0
bra	iol
i3140:
move	#3140,d0
bra	iol
i3150:
move	#3150,d0
iol:
bsr	icon
move	d1,d2
bsr	ramme
humbug:
add	#1,rn
move.l	a_stickpo,stickpo
bsr	makestick
tst	feuer
bne	humbug
move.l	b_stickpo,stickpo
bsr	makestick
tst	feuer
bne	humbug
move	d2,d1
clr	d2
bsr	icon
rts

nnm:
cmp	#1764,d2
bne	ni1
move	#0,gamestate
bra	mainmnu
ni1:
cmp	#1788,d2
bgt	ni23
beq	i3
move	#1,gamestate
bra	mainmnu
i3:
move	#2,gamestate
bra	mainmnu
ni23:
cmp	#4252,d2
bgt	ni56
beq	i6
cmp	#4240,d2
beq	i5
move	#0,level
bra	mainmnu
i5:
move	#6,level
bra	mainmnu
i6:
move	#12,level
bra	mainmnu
ni56:
cmp	#6704,d2
bgt	l21
beq	l20
move	#20,level
bra	mainmnu
l21:
move	#22,level
bra	mainmnu
l20:
move	#21,level
bra	mainmnu

rts

selectt:
dc.b	"SELECT",0
category:
dc.b	"CATEGORY",0
famet:
dc.b	"*FAME*",0
mainmenut:
dc.b	"MAIN MENU",0
controlmenu:
dc.b	"CONTROL",0
even

controlmnu:
bsr	border
move	#1770,d2
clr	x
clr	y
move	#2,mx
move	#4,my
move.l	lk1,baa
move.l	lk2,bab
move	up,upb

controlm:
move	d2,-(a7)
clr	actives

clr	d2
move	#4710,d0
move	#9162,d1
bsr	icon
move	#9162+12,d1
bsr	icon

move.l	#screen+[44*6]+14,d6
move	#3,d7
move.l	#controlmenu,a0
move	#-1,d4
bsr	type

move	#0,d2

cmp.b	#$df,a_stickpo+1
beq	nkeya
not	d2
nkeya:
move	#4700,d0
move	#6698,d1
bsr	icon

move	#0,d2
cmp.l	#$dff00a,a_stickpo
bne	np1a
not	d2
np1a:
move	#4680,d0
move	#1770,d1
bsr	icon

move	#0,d2
cmp.l	#$dff00c,a_stickpo
bne	np2a
not	d2
np2a:
move	#4690,d0
move	#4234,d1
bsr	icon

move	#0,d2
cmp.b	#$df,b_stickpo+1
beq	nkeyb
not	d2
nkeyb:
move	#4700,d0
move	#6698+12,d1
bsr	icon

move	#0,d2
cmp.l	#$dff00c,b_stickpo
bne	np2b
not	d2
np2b:
move	#4690,d0
move	#4246,d1
bsr	icon

move	#0,d2
cmp.l	#$dff00a,b_stickpo
bne	np1b
not	d2
np1b:
move	#4680,d0
move	#1770+12,d1
bsr	icon

move	#2508,d0
move	#6,d1
move	#151,d2
move	#2906,d3
bsr	bo
move	#1842,d0
move	#6,d1
move	#190,d2
move	#2060,d3
bsr	bo

move	(a7)+,d2
bsr	ramme

mm2:
move.l	a_stickpo,stickpo
bsr	makestick
tst	feuer
bne	mm2
move.l	b_stickpo,stickpo
bsr	makestick
tst	feuer
bne	mm2

bsr	ctrl_move
cmp	#1782,d2
bgt	nj1
beq	j1b
cmp.l	#$dff00a,b_stickpo
beq	controlm
move.l	#$dff00a,a_stickpo
bra	controlm
j1b:
cmp.l	#$dff00a,a_stickpo
beq	controlm
move.l	#$dff00a,b_stickpo
bra	controlm
nj1:
cmp	#4246,d2
bgt	nj2
beq	j2b
cmp.l	#$dff00c,b_stickpo
beq	controlm
move.l	#$dff00c,a_stickpo
bra	controlm
j2b:
cmp.l	#$dff00c,a_stickpo
beq	controlm
move.l	#$dff00c,b_stickpo
bra	controlm
nj2:
cmp	#6710,d2
bgt	kbd
beq	kbb

cmp.b	#$df,b_stickpo+1
beq	o7

lea	lk1,a0
lea	lk2,a1

move.b	(a0),d0
cmp.b	(a1),d0
beq	controlm

move.b	(a0),d0
cmp.b	1(a1),d0
beq	controlm

move.b	(a0),d0
cmp.b	2(a1),d0
beq	controlm

move.b	(a0),d0
cmp.b	3(a1),d0
beq	controlm

move.b	1(a0),d0
cmp.b	1(a1),d0
beq	controlm

move.b	1(a0),d0
cmp.b	2(a1),d0
beq	controlm

move.b	1(a0),d0
cmp.b	3(a1),d0
beq	controlm

move.b	2(a0),d0
cmp.b	2(a1),d0
beq	controlm

move.b	2(a0),d0
cmp.b	3(a1),d0
beq	controlm

move.b	3(a0),d0
cmp.b	3(a1),d0
beq	controlm

move.b	up,d0
move.b	up+1,d1
cmp.b	d1,d0
beq	controlm

cmp.b	(a1),d0
beq	controlm
cmp.b	1(a1),d0
beq	controlm
cmp.b	2(a1),d0
beq	controlm
cmp.b	3(a1),d0
beq	controlm

cmp.b	(a0),d1
beq	controlm
cmp.b	1(a0),d1
beq	controlm
cmp.b	2(a0),d1
beq	controlm
cmp.b	3(a0),d1
beq	controlm

o7:

move.l	lk1,a_stickpo
bra	controlm

kbb:

cmp.b	#$df,a_stickpo+1
beq	o7b

lea	lk2,a0
lea	lk1,a1

move.b	(a0),d0
cmp.b	(a1),d0
beq	controlm

move.b	(a0),d0
cmp.b	1(a1),d0
beq	controlm

move.b	(a0),d0
cmp.b	2(a1),d0
beq	controlm

move.b	(a0),d0
cmp.b	3(a1),d0
beq	controlm

move.b	1(a0),d0
cmp.b	1(a1),d0
beq	controlm

move.b	1(a0),d0
cmp.b	2(a1),d0
beq	controlm

move.b	1(a0),d0
cmp.b	3(a1),d0
beq	controlm

move.b	2(a0),d0
cmp.b	2(a1),d0
beq	controlm

move.b	2(a0),d0
cmp.b	3(a1),d0
beq	controlm

move.b	3(a0),d0
cmp.b	3(a1),d0
beq	controlm

move.b	up+1,d0
move.b	up,d1
cmp.b	d1,d0
beq	controlm

cmp.b	(a1),d0
beq	controlm
cmp.b	1(a1),d0
beq	controlm
cmp.b	2(a1),d0
beq	controlm
cmp.b	3(a1),d0
beq	controlm

cmp.b	(a0),d1
beq	controlm
cmp.b	1(a0),d1
beq	controlm
cmp.b	2(a0),d1
beq	controlm
cmp.b	3(a0),d1
beq	controlm

o7b:

move.l	lk2,b_stickpo
bra	controlm

kbd:
move	d2,d1
move	#-1,d2
move	#4710,d0
bsr	icon
move	d1,d2
bsr	ramme
humbug2:
move.l	a_stickpo,stickpo
bsr	makestick
tst	feuer
bne	humbug2
move.l	b_stickpo,stickpo
bsr	makestick
tst	feuer
bne	humbug2
move	d2,d1
clr	d2
bsr	icon
bsr	keyboarddef
clr	onmain
move	d1,d2
bra	controlm

kd:
dc.b	"KEY DEF.",0

even

keyboarddef:
;move	#-1,onmain
movem.l	d0-d7/a0-a6,-(a7)
cmp	#9162,d1
bgt	pl2

lea	lk1,a6
lea	up,a5
bra	humba

pl2:
lea	lk2,a6
lea	up+1,a5

humba:
bsr	border
move.l	#screen+[44*6]+14,d6
move	#3,d7
lea	kd,a0
move	#-1,d4
bsr	type

move	#-1,defingkeys

move	#1810,d0
move	#32,d1
move	#97,d2
move	#6294,d3
bsr	bo
move	#6102,d0
move	#8,d1
move	#97,d2
move	#6326,d3
bsr	bo

move.l	#us,d0
move	d0,sprites+6
swap	d0
move	d0,sprites+2

move.l	#rs,d0
move	d0,sprites+14
swap	d0
move	d0,sprites+10

move.l	#ds,d0
move	d0,sprites+22
swap	d0
move	d0,sprites+18

move.l	#ls,d0
move	d0,sprites+30
swap	d0
move	d0,sprites+26

move.l	#fs,d0
move	d0,sprites+38+8
swap	d0
move	d0,sprites+34+8

move	#0,a4

clr	d3
lea	ls,a0
move.b	(a6),d3
lsl	#1,d3
lea	coords,a1
move.b	(a1,d3.w),d0
move.b	1(a1,d3.w),d1
bsr	places

clr	d3
lea	rs,a0
move.b	1(a6),d3
lsl	#1,d3
lea	coords,a1
move.b	(a1,d3.w),d0
move.b	1(a1,d3.w),d1
bsr	places

clr	d3
lea	ds,a0
move.b	2(a6),d3
lsl	#1,d3
lea	coords,a1
move.b	(a1,d3.w),d0
move.b	1(a1,d3.w),d1
bsr	places

clr	d3
lea	fs,a0
move.b	3(a6),d3
lsl	#1,d3
lea	coords,a1
move.b	(a1,d3.w),d0
move.b	1(a1,d3.w),d1
bsr	places

clr	d3
lea	us,a0
move.b	(a5),d3
lsl	#1,d3
lea	coords,a1
move.b	(a1,d3.w),d0
move.b	1(a1,d3.w),d1
bsr	places

move.l	#-1,(a6)
move.b	#-1,(a5)

lea	upt,a0
bsr	typek

lea	us,a0
bsr	findkey
move.b	d0,(a5)

lea	rtt,a0
bsr	typek

lea	rs,a0
bsr	findkey
move.b	d0,1(a6)

lea	dnt,a0
bsr	typek

lea	ds,a0
bsr	findkey
move.b	d0,2(a6)

lea	ltt,a0
bsr	typek

lea	ls,a0
bsr	findkey
move.b	d0,(a6)

lea	fet,a0
bsr	typek

lea	fs,a0
bsr	findkey
move.b	d0,3(a6)

lea	allright,a0
bsr	typek

ghu:
tst.b	$15+keys
bne	ok98

tst.b	$36+keys
beq	ghu

movem.l	(a7)+,d0-d7/a0-a6
bra	keyboarddef

ok98:
clr	defingkeys

lea	sprites+2,a0
move	#15,d0
muy2:
clr	(a0)
addq.l	#4,a0
dbra	d0,muy2

bsr	border
movem.l	(a7)+,d0-d7/a0-a6
move	up,upp
cmp.b	#$df,a_stickpo+1
beq	nt
move.l	lk1,a_stickpo
nt:
cmp.b	#$df,b_stickpo+1
beq	rts
move.l	lk2,b_stickpo
rts

upt:
dc.b	"PRESS KEY FOR UP",0
rtt:
dc.b	"PRESS KEY FOR RIGHT",0
dnt:
dc.b	"PRESS KEY FOR DOWN",0
ltt:
dc.b	"PRESS KEY FOR LEFT",0
fet:
dc.b	"PRESS KEY FOR TURN",0
allright:
dc.b	"IS THIS CORRECT? Y/N",0
even

typek:
movem.l	d0-d7/a0-a6,-(a7)
vp:
cmp.b	#168,$dff006
bne	vp

move	#1408,d0
move	#44,d1
move	#1,d2
move	#4400,d3

move	#23,d4
mytu:
bsr	bo
add	#44,d3
dbra	d4,mytu

move	#3,d7
move	#-1,d4
move.l	#screen+[100*44]+2,d6
bsr	type
movem.l	(a7)+,d0-d7/a0-a6
rts

findkey:
lea	keys,a1
move	#127,d2
himbu:
clr.b	(a1)+
dbra	d2,himbu

fk2:
lea	keys,a1
move	#127,d2
clr	d3
himbu2:
add.b	(a1)+,d3
bne	zink
dbra	d2,himbu2
bra	fk2

zink:
sub.l	#keys,a1
move	a1,d3
sub	#1,d3
cmp.b	#$45,d3
beq	reset1

cmp.b	lk1,d3
beq	fehler
cmp.b	lk1+1,d3
beq	fehler
cmp.b	lk1+2,d3
beq	fehler
cmp.b	lk1+3,d3
beq	fehler
cmp.b	lk2,d3
beq	fehler
cmp.b	lk2+1,d3
beq	fehler
cmp.b	lk2+2,d3
beq	fehler
cmp.b	lk2+3,d3
beq	fehler
cmp.b	up,d3
beq	fehler
cmp.b	up+1,d3
beq	fehler

clr	d0
clr	d1

lsl	#1,d3
lea	coords,a1
move.b	(a1,d3.w),d0
cmp.b	#-1,d0
beq	fehler
move.b	1(a1,d3.w),d1
move	#15,a4
bsr	places
move	d3,d0
lsr	#1,d0

findkey2:
lea	keys,a1
move	#127,d2
clr	d3
h2imbu:
add.b	(a1)+,d3
dbra	d2,h2imbu
tst	d3
bne	findkey2
cmp.b	#-1,d0
beq	findkey
rts

fehler:
move	#-1,d0
vp2:
cmp.b	#20,$dff006
bne	vp2
btst	#0,$dff005
bne	vp2
move	#$fff,$dff198
bra	findkey2

st:
dc.b	"00",0,0


wide:
dc.b	1,$d
dc.b	$10,$1b
dc.b	$20,$2a
dc.b	$31,$3a
dc.b	-1,-1

coords:
dc.b	29,174
dc.b	48,174
blk.w	12,174
dc.b	0,0,185,110
dc.b	55,186
blk.w	11,186
dc.b	0,0,185,98,200,98,215,98
dc.b	59,198
blk.w	10,198
dc.b	0,0,0,0,185,86,200,86,215,86,0,0
dc.b	64,210
blk.w	9,210
dc.b	0,0,215,110,185,74,200,74,215,74
dc.b	135,222,243,174
dc.b	29,186,215,122,236,198
blk.w	2,-1
blk.w	3,0
dc.b	185,122
blk.w	1,0
dc.b	153,98,153,122,161,110,146,110
blk.w	10,-1
blk.w	5,0
dc.b	153,86
dc.b	29,210,214,210,-1,-1,29,198,45,222,214,222,64,222,195,222
blk.w	24,0

places:
movem.l	d0-d7/a0-a6,-(a7)
cmp	#0,d0
bne	nnull
cmp.l	#rs,a0
blt	ius
beq	irs
cmp.l	#ls,a0
blt	ids
beq	ils
move	#210,d0
move	#148,d1
bra	nnull
ids:
move	#180,d0
move	#148,d1
bra	nnull
ils:
move	#195,d0
move	#148,d1
bra	nnull
ius:
move	#150,d0
move	#148,d1
bra	nnull
irs:
move	#165,d0
move	#148,d1
bra	nnull
nnull:
cmp	#123,d1
bgt	nsm
add	#100,d0
add	#100,d1
nsm:
clr	d4
clr	d5
move.b	(a0),d4
move.b	1(a0),d5
lsl	#1,d5
move.b	3(a0),d6
and	#1,d6
or	d6,d5
move.b	3(a0),d6
and	#4,d6
lsl	#6,d6
or	d6,d4

exg	d4,d5

add	#$2c,d1
add	#$67,d0

move	d0,d6		;d4 -> d6
move	d1,d7		;d5 -> d7

			;FREE: d0,d1,d2,d3,a1,a2,...

moveloop:
bsr	nextf

move	a4,d3
move	d4,d0
mulu	d3,d0

move	d5,d1
mulu	d3,d1

not	d3
and	#$f,d3
addq	#1,d3

move	d6,d2
mulu	d3,d2
add	d2,d0

move	d7,d2
mulu	d3,d2
add	d2,d1

lsr	#4,d0
lsr	#4,d1

move.b	d1,(a0)
move	d1,d2
lsr	#6,d2
and	#4,d2
move	d0,d3
and	#1,d3
or	d3,d2
lsr	#1,d0
move.b	d0,1(a0)
add	#7,d1
move	d1,d3
lsr	#7,d3
and	#2,d3
or	d3,d2
move.b	d1,2(a0)
move.b	d2,3(a0)
sub	#1,a4
cmp	#-1,a4
bne	moveloop

movem.l	(a7)+,d0-d7/a0-a6
rts
ctrl_move:
clr	waited
ctrl_move2:
tst	onmain
beq	nodet
add	#1,waited
cmp	#[50*180],waited
bge	trigdemo
nodet:

bsr	nextf
move.l	b_stickpo,stickpo
move.b	up+1,upp
bsr	makestick
move	stick,d0
move	feuer,d1

move.l	a_stickpo,stickpo
move.b	up,upp
bsr	makestick
or	d0,stick
or	d1,feuer

move	prev,d0
move	stick,prev
not	prev
and	d0,stick

tst	feuer
bne	rts

tst	stick
beq	ctrl_move2

move:
move	#0,d0
move	#0,d1

btst	#0,stick+1
beq	n0
sub	#1,d1
n0:

btst	#1,stick+1
beq	n1
add	#1,d0
n1:

btst	#2,stick+1
beq	n2
add	#1,d1
n2:

btst	#3,stick+1
beq	n3
sub	#1,d0
n3:

add	d0,x
bpl	ok1
sub	d0,x
clr	d0
ok1:
move	mx,d5
cmp	x,d5
bgt	ok2
sub	d0,x
clr	d0
ok2:
add	d1,y
bpl	ok3
sub	d1,y
clr	d1
ok3:
move	my,d5
cmp	y,d5
bgt	ok4
sub	d1,y
clr	d1
ok4:

clr	farge
bsr	ramme

tst	d0
beq	nxm
bmi	nexm
add	#24,d2
nexm:
sub	#12,d2
nxm:

tst	d1
beq	nxmb
bmi	nexmb
add	#4928,d2
nexmb:
sub	#2464,d2
nxmb:
move.b	#4,farge
bsr	ramme
bra	ctrl_move

x:
dc.w	0
y:
dc.w	0

border:
move	#0,d0
move	#44,d1
move	#33,d2
move	#0,d3
bsr	bo

move	#1408,d0
move	#44,d1
move	#1,d2
move	#1452,d3
move	#214,d4

vmu:
bsr	bo
add	#44,d3
dbra	d4,vmu


move	#1452,d0
move	#44,d1
move	#8,d2
move	#10912,d3
bsr	bo
rts

bo:
movem.l	d0-d3,-(a7)

ext.l	d0
ext.l	d3
add.l	#obj,d0
add.l	#screen,d3
neg	d1
add	#44,d1
move	d1,$dff064
move	d1,$dff066
sub	#44,d1
neg	d1
lsl	#6,d2
lsr	#1,d1
add	d2,d1
move.l	#-1,$dff044
move	#%100111110000,$dff040
clr	$dff042

move	#2,d2
hindu:
move.l	d0,$dff048+8
move.l	d3,$dff048+12
move	d1,$dff058
bsr	w
add.l	#256*44,d0
add.l	#256*44,d3
dbra	d2,hindu
movem.l	(a7)+,d0-d3
rts

icon:
movem.l	d0-d3/a0,-(a7)

ext.l	d0
ext.l	d1
tst	d2
beq	inac
add.l	#active,d0
move	actives,d3
lsl	#1,d3
lea	activei,a0
move	d1,(a0,d3.w)
add	#1,actives
bra	acn
inac:
add.l	#inactive,d0

lea	activei,a0
move	actives,d3
sub	#1,d3
bmi	acn
vyi:
cmp	(a0)+,d1
beq	equal
dbra	d3,vyi
bra	acn

equal:
clr	-2(a0)

acn:

add.l	#screen,d1
move	#30,$dff064
move	#34,$dff066
move.l	#-1,$dff044
move	#%100111110000,$dff040
move	#0,$dff042

move	#2,d2
hindu2:
move.l	d0,$dff048+8
move.l	d1,$dff048+12
move	#5+[64*39],$dff058
bsr	w
add.l	#156*40,d0
add.l	#256*44,d1
dbra	d2,hindu2
movem.l	(a7)+,d0-d3/a0
rts

vbi:
movem.l	d0-d7/a0-a6,-(a7)
bsr	mt_music
movem.l	(a7)+,d0-d7/a0-a6
move	#$20,$dff09c
rte

vrnn:
dc.b	"ENTER NAMES",0
even

exit:
tst	gamestate
beq	quit

;			ASK FOR NAMES

bsr	border
move.l	#screen+[44*6]+12,d6
move	#3,d7
move	#-1,d4
lea	vrnn,a0
bsr	type
clr	players

move.l	#[44*32]+8,d5
lea	names,a5
move	#0,d1

getname:
move	players,d1
lsl	#1,d1
lea	no,a3
move	(a3,d1.w),tt
lea	tt,a0
move	#-1,d4
move	#3,d7
clr.l	d6
move	d5,d6
add.l	#screen-6,d6
bsr	type
clr	d1
gka:
bsr	getkey
cmp.b	#-1,d0
beq	hurruga
tst.b	d0
beq	gka
cmp.b	#1,d0
beq	namein
add	#1,d1
cmp	#11,d1
bne	hurpa
move	#10,d1
sub.l	#2,d5
hurpa:
bsr	typethis
move.b	d0,-1(a5,d1.w)
bra	gka

hurruga:
tst	d1
beq	gka
sub.l	#2,d5
sub	#1,d1 
movem.l	d0-d7/a0-a6,-(a7)
move	#1410,d0
move	#2,d1
move	#1,d2
move	d5,d3
move	#23,d4
bingo:
bsr	bo
add	#44,d3
dbra	d4,bingo
movem.l	(a7)+,d0-d7/a0-a6
bra	gka

namein:
tst	d1
beq	allni
add.l	#44*24,d5
clr.b	(a5,d1.w)
ext.l	d1
lsl	#1,d1
sub.l	d1,d5
add.l	#20,a5
add	#1,players
cmp	#9,players
bne	getname

allni:
cmp	#0,players
beq	resset
bra	quit

trigdemo:
move.l	ressetpointer,a7
move	gamestate,oldgs
move	#3,gamestate

quit:
bsr	fademusic
bsr	mt_end
move.l	oldvb,$6c
move.l	oldkeyb+2,$68
move	#$7fff,$dff09a
move	#$7fff,$dff096
move	oldinten,$dff09a
move	olddmaen,$dff096
clr.l	d0
cmp	#3,gamestate
beq	rts
move	gamestate,oldgs
rts

oldvb:
dc.l	0

fademusic:
move	#150,d0
move	d0,d2

fml:
tst	musiced
beq	fml

clr	musiced
move	d0,volume

dbra	d0,fml
rts

setvolume:
movem.l	d0/d7,-(a7)
move	volume,d7
move	tv,d0
mulu	d7,d0
divu	#150,d0
move	d0,tv
movem.l	(a7)+,d0/d7
rts

typethis:
movem.l	d0-d7/a0-a6,-(a7)
clr.l	d6
move	d5,d6
add.l	#screen,d6
move	#3,d7
move	#0,d4
move.b	d0,hikk
lea	hikk,a0
bsr	type
movem.l	(a7)+,d0-d7/a0-a6
add	#2,d5
rts

hikk:
dc.l	0

getkey:
hakka:
bsr	nextf
lea	keys,a1
move	#$5f,d2
clr	d3
h2imbu2:
add.b	(a1)+,d3
tst.b	d3
bne	lead
dbra	d2,h2imbu2
bra	hakka

lead:
clr.b	-1(a1)
sub.l	#keys+1,a1
move	a1,d0
lea	lay,a1
tst.b	keys+$60
bne	ll2
tst.b	keys+$61
beq	nl4
ll2:
lea	lay2,a1
nl4:
move.b	(A1,d0.w),d0
rts

lay:
DC.B	0,"1234567890-=",0,0,"0QWERTYUIOP",0,0,0,"123"
DC.B	"ASDFGHJKL;'",0,0,"456",0,"ZXCVBNM,./",0,".789"
DC.B	" ",-1,0,1,1,0,0,0,0,0,"-",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DC.B	0,0,0,0,0,0

lay2:
dc.b	0,"!@#$",0,0,"&*()",0,"+",0,0,"0QWERTYUIOP[]",0,"123"
dc.b	'ASDFGHJKL:"',0,0,"456",0,"ZXCVBNM<>?",0,".789"
dc.b	" ",-1,0,1,1,0,0,0,0,0,"-",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DC.B	0,0,0,0,0,0

copperlist:
dc.w	$8e,$2c01
dc.w	$90,$2cff
dc.w	$92,$30
dc.w	$94,$d8
dc.w	$100,$3000
dc.w	$102,0
dc.w	$104,%100100
dc.w	$108,0
dc.w	$10a,0

palette:
blk.l	8,0
p2:
blk.l	16,0

pointers:
dc.w	$e0,0
dc.w	$e2,0
dc.w	$e4,0
dc.w	$e6,0
dc.w	$e8,0
dc.w	$ea,0
dc.w	$ec,0
dc.w	$ee,0
dc.w	$f0,0
dc.w	$f2,0

sprites:
dc.w	$120,0
dc.w	$122,0
dc.w	$124,0
dc.w	$126,0
dc.w	$128,0
dc.w	$12a,0
dc.w	$12c,0
dc.w	$12e,0
dc.w	$130,0
dc.w	$132,0
dc.w	$134,0
dc.w	$136,0
dc.w	$138,0
dc.w	$13a,0
dc.w	$13c,0
dc.w	$13e,0

dc.w	$ffff,$fffe

oldinten:
dc.w	0
olddmaen:
dc.w	0

w:
btst	#14,$dff002
bne	w
rts

keyboard:
movem.l	d0-d7/a0-a6,-(a7)

clr	d0
move.b	$bfec01,d0
clr.b	$bfec01
ror.b	#1,d0
not.b	d0

lea	keys,a0
btst	#7,d0
beq.S	keydown
bclr	#7,d0
move.b	#0,(a0,d0.w)
bra.S	rte

keydown:
ext	d0
move.b	#-1,(a0,d0.w)
rte:


move.b	#%1000100,$bfee01
move.b	#-1,$bfec01
move.b	#%10000,$bfee01

move.b	$bfed01,soppel
move	#8,$dff09c

movem.l	(a7)+,d0-d7/a0-a6
rte

oldkeyb:
jmp	2920

soppel:
dc.w	0

type:
movem.l	d0-d7/a0-a6,-(a7)
move.l	#$ffff0000,$dff044
move.l	d6,d3

nextl:
clr.l	d0
move.b	(a0)+,d0

cmp	#32,d0
blt	fover

sub	#32,d0
divu	#20,d0
clr.l	d1
move	d0,d1
mulu	#[40*24],d1
clr	d0
swap	d0
lsl	#1,d0

add	d1,d0
add.l	#font,d0
move.l	d0,d2
add.l	#40*72*2,d2
move.l	d2,$dff04c

move	#%100111110000,$dff040

move	#42,$dff060
move	#38,$dff062
move	#38,$dff064
move	#42,$dff066
move.l	#-1,$dff044
move	#0,$dff042

move	#2,d5
bl2f:
move.l	d2,$dff048+4
move.l	d0,$dff048+8
move.l	d6,$dff048
move.l	d6,$dff048+12
move	#1+[64*24],$dff058
add.l	#[72*40],d0
add.l	#[44*256],d6
wfpq:
btst	#14,$dff002
bne.s	wfpq
dbra	d5,bl2f

sub.l	#[44*256*3]-2,d6

bra.L	nextl

fover:
movem.l	(a7)+,d0-d7/a0-a6
rts

joy:
move.l	stickpo,a0
move	(a0),d0
btst	#8,d0
beq.s	eq1
btst	#9,d0
beq.s	set1
bra.s	nos1

eq1:
btst	#9,d0
beq.s	nos1

set1:
bset	#0,stick+1

nos1:


btst	#0,d0
beq.s	eq2
btst	#1,d0
beq.s	set2
bra.s	nos2

eq2:
btst	#1,d0
beq.s	nos2

set2:
bset	#2,stick+1

nos2:


btst	#9,d0
beq.S	nos3

bset	#3,stick+1

nos3:


btst	#1,d0
beq.s	nos4

bset	#1,stick+1

nos4:
cmp.b	#$a,stickpo+3
beq	fb6
btst	#7,$bfe001
bne	rts2
move	#-1,feuer
movem.l	(a7)+,d0-d7/a0-a6
rts
fb6:
btst	#6,$bfe001
bne	rts2
move	#-1,feuer
rts2:
movem.l	(a7)+,d0-d7/a0-a6
rts

makestick:
movem.l	d0-d7/a0-a6,-(a7)
clr	stick
clr	feuer

cmp	#$df,stickpo
beq	joy

lea	keys,a0
clr	d0

move.b	stickpo,d0
tst.b	(a0,d0.w)
beq	f1
bset	#3,stick+1
f1:

move.b	stickpo+1,d0
tst.b	(a0,d0.w)
beq	f2
bset	#1,stick+1
f2:

move.b	stickpo+2,d0
tst.b	(a0,d0.w)
beq	f3
bset	#2,stick+1
f3:

move.b	upp,d0
tst.b	(a0,d0.w)
beq	f5
bset	#0,stick+1
f5:

move.b	stickpo+3,d0
tst.b	(a0,d0.w)
beq	f4
move	#-1,feuer
f4:
movem.l	(a7)+,d0-d7/a0-a6
rts

stickpo:
dc.l	0
feuer:
dc.w	0
stick:
dc.w	0

farge:
dc.b	4,0

ramme:
movem.l	d0-d5/a0,-(a7)
clr.l	d0
move	d2,d0
add.l	#screen,d0

lea	activei,a0
move	actives,d1
sub	#1,d1
bmi	acq
vyi2:
cmp	(a0)+,d2
beq	equal2
dbra	d1,vyi2
bra	acq

equal2:
add.l	#[44*6]+43,d0

acq:

move	#0,d1
vyhbu:
move.l	d0,a0
clr.l	d3
btst	d1,farge
beq	clr
move.l	#-1,d3

move	#44,d4
move	#29,d5
poi1:
bset	#7,2(a0,d4.w)
bset	#0,9(a0,d4.w)
add	#44,d4
dbra	d5,poi1
bra	ncl

clr:
move	#44,d4
move	#29,d5
poi:
bclr	#7,2(a0,d4.w)
bclr	#0,9(a0,d4.w)
add	#44,d4
dbra	d5,poi

ncl:
move.b	d3,2(a0)
move.b	d3,3(a0)
move.b	d3,4(a0)
move.b	d3,5(a0)
move.b	d3,6(a0)
move.b	d3,7(a0)
move.b	d3,8(a0)
move.b	d3,9(a0)

move.b	d3,1366(a0)
move.b	d3,1367(a0)
move.b	d3,1368(a0)
move.b	d3,1369(a0)
move.b	d3,1370(a0)
move.b	d3,1371(a0)
move.b	d3,1372(a0)
move.b	d3,1373(a0)

add.l	#[256*44],d0
addq	#1,d1
cmp	#3,d1
bne	vyhbu

movem.l	(a7)+,d0-d5/a0
rts

pos:
dc.w	0

upp:
dc.w	0

baa:
dc.l	0
bab:
dc.l	0
upb:
dc.w	0

activei:
blk.w	12,0

onmain:
dc.w	0

actives:
dc.w	0

prev:
dc.w	0

mx:
dc.w	0
my:
dc.w	0

lk1:
dc.l	$20213160
lk2:
dc.l	$4f4e4d61

kbp:
dc.l	0

ressetpointer:
dc.l	0

us:
dc.w	0,0
dc.w	%0001000,0
dc.w	%0011100,0
dc.w	%0111110,0
dc.w	%1111111,0
dc.w	%0001000,0
dc.w	%0001000,0
dc.w	%0001000,0
dc.w	0,0

ds:
dc.w	0,0
dc.w	%0001000,0
dc.w	%0001000,0
dc.w	%0001000,0
dc.w	%1111111,0
dc.w	%0111110,0
dc.w	%0011100,0
dc.w	%0001000,0
dc.w	0,0

ls:
dc.w	0,0
dc.w	%0001000,0
dc.w	%0011000,0
dc.w	%0111000,0
dc.w	%1111111,0
dc.w	%0111000,0
dc.w	%0011000,0
dc.w	%0001000,0
dc.w	0,0

rs:
dc.w	0,0
dc.w	%0001000,0
dc.w	%0001100,0
dc.w	%0001110,0
dc.w	%1111111,0
dc.w	%0001110,0
dc.w	%0001100,0
dc.w	%0001000,0
dc.w	0,0

fs:
dc.w	0,0
dc.w	%0011100,0
dc.w	%0100010,0
dc.w	%1001001,0
dc.w	%1010101,0
dc.w	%1001001,0
dc.w	%0100010,0
dc.w	%0011100,0
dc.w	0,0

no:
dc.b	' 1 2 3 4 5 6 7 8 91011'
tt:
dc.b	'00',0,0

; -----------------------------------------------------
; ------- D.O.C Soundtracker V2.3 - playroutine -------
; -----------------------------------------------------
; ---- Improved and optimized by  Unknown of D.O.C ----
; --------- Based on the playroutine from TJC ---------
; -----------------------------------------------------

mt_init:lea	mt_data,a0
	add.l	#$03b8,a0
	moveq	#$7f,d0
	moveq	#0,d1
mt_init1:
	move.l	d1,d2
	subq.w	#1,d0
mt_init2:
	move.b	(a0)+,d1
	cmp.b	d2,d1
	bgt.s	mt_init1
	dbf	d0,mt_init2
	addq.b	#1,d2

mt_init3:
	lea	mt_data,a0
	lea	mt_sample1(pc),a1
	asl.l	#8,d2
	asl.l	#2,d2
	add.l	#$438,d2
	add.l	a0,d2
	moveq	#$1e,d0
mt_init4:
	move.l	d2,(a1)+
	moveq	#0,d1
	move.w	42(a0),d1
	asl.l	#1,d1
	add.l	d1,d2
	add.l	#$1e,a0
	dbf	d0,mt_init4

	lea	mt_sample1(PC),a0
	moveq	#0,d0
mt_clear:
	move.l	(a0,d0.w),a1
	clr.l	(a1)
	addq.w	#4,d0
	cmp.w	#$7c,d0
	bne.s	mt_clear

	clr.w	$dff0a8
	clr.w	$dff0b8
	clr.w	$dff0c8
	clr.w	$dff0d8
	clr.l	mt_partnrplay
	clr.l	mt_partnote
	clr.l	mt_partpoint

	move.b	mt_data+$3b6,mt_maxpart+1
	rts

mt_end:	clr.w	$dff0a8
	clr.w	$dff0b8
	clr.w	$dff0c8
	clr.w	$dff0d8
	move.w	#$f,$dff096
	rts

mt_music:
move	#-1,musiced

	addq.w	#1,mt_counter
mt_cool:cmp.w	#6,mt_counter
	bne.s	mt_notsix
	clr.w	mt_counter
	bra	mt_rout2

mt_notsix:
	lea	mt_aud1temp(PC),a6
	tst.b	3(a6)
	beq.s	mt_arp1
	lea	$dff0a0,a5		
	bsr.s	mt_arprout
mt_arp1:lea	mt_aud2temp(PC),a6
	tst.b	3(a6)
	beq.s	mt_arp2
	lea	$dff0b0,a5
	bsr.s	mt_arprout
mt_arp2:lea	mt_aud3temp(PC),a6
	tst.b	3(a6)
	beq.s	mt_arp3
	lea	$dff0c0,a5
	bsr.s	mt_arprout
mt_arp3:lea	mt_aud4temp(PC),a6
	tst.b	3(a6)
	beq.s	mt_arp4
	lea	$dff0d0,a5
	bra.s	mt_arprout
mt_arp4:rts

mt_arprout:
	move.b	2(a6),d0
	and.b	#$0f,d0
	tst.b	d0
	beq	mt_arpegrt
	cmp.b	#$01,d0
	beq.s	mt_portup
	cmp.b	#$02,d0
	beq.s	mt_portdwn
	cmp.b	#$0a,d0
	beq.s	mt_volslide
	rts

mt_portup:
	moveq	#0,d0
	move.b	3(a6),d0
	sub.w	d0,22(a6)
	cmp.w	#$71,22(a6)
	bpl.s	mt_ok1
	move.w	#$71,22(a6)
mt_ok1:	move.w	22(a6),6(a5)
	rts

mt_portdwn:
	moveq	#0,d0
	move.b	3(a6),d0
	add.w	d0,22(a6)
	cmp.w	#$538,22(a6)
	bmi.s	mt_ok2
	move.w	#$538,22(a6)
mt_ok2:	move	22(a6),6(a5)
	rts

mt_volslide:
	moveq	#0,d0
	move.b	3(a6),d0
	lsr.b	#4,d0
	tst.b	d0
	beq.s	mt_voldwn
	add.w	d0,18(a6)
	cmp.w	#64,18(a6)
	bmi.s	mt_ok3
	move.w	#64,18(a6)
mt_ok3:	move.w	18(a6),tv
	bsr	setvolume
	move	tv,8(a5)
	rts
mt_voldwn:
	moveq	#0,d0
	move.b	3(a6),d0
	and.b	#$0f,d0
	sub.w	d0,18(a6)
	bpl.s	mt_ok4
	clr.w	18(a6)
mt_ok4:	move	18(a6),tv
	bsr	setvolume
	move	tv,8(a5)
	rts

mt_arpegrt:
	move.w	mt_counter(PC),d0
	cmp.w	#1,d0
	beq.s	mt_loop2
	cmp.w	#2,d0
	beq.s	mt_loop3
	cmp.w	#3,d0
	beq.s	mt_loop4
	cmp.w	#4,d0
	beq.s	mt_loop2
	cmp.w	#5,d0
	beq.s	mt_loop3
	rts

mt_loop2:
	moveq	#0,d0
	move.b	3(a6),d0
	lsr.b	#4,d0
	bra.s	mt_cont
mt_loop3:
	moveq	#$00,d0
	move.b	3(a6),d0
	and.b	#$0f,d0
	bra.s	mt_cont
mt_loop4:
	move.w	16(a6),d2
	bra.s	mt_endpart
mt_cont:
	add.w	d0,d0
	moveq	#0,d1
	move.w	16(a6),d1
	lea	mt_arpeggio(PC),a0
mt_loop5:
	move.w	(a0,d0),d2
	cmp.w	(a0),d1
	beq.s	mt_endpart
	addq.l	#2,a0
	bra.s	mt_loop5
mt_endpart:
	move	d2,6(a5)
	rts

mt_rout2:
	lea	mt_data,a0
	move.l	a0,a3
	add.l	#$0c,a3
	move.l	a0,a2
	add.l	#$3b8,a2
	add.l	#$43c,a0
	move.l	mt_partnrplay(PC),d0
	moveq	#0,d1
	move.b	(a2,d0),d1
	asl.l	#8,d1
	asl.l	#2,d1
	add.l	mt_partnote(PC),d1
	move.l	d1,mt_partpoint
	clr.w	mt_dmacon

	lea	$dff0a0,a5
	lea	mt_aud1temp(PC),a6
	bsr	mt_playit
	lea	$dff0b0,a5
	lea	mt_aud2temp(PC),a6
	bsr	mt_playit
	lea	$dff0c0,a5
	lea	mt_aud3temp(PC),a6
	bsr	mt_playit
	lea	$dff0d0,a5
	lea	mt_aud4temp(PC),a6
	bsr	mt_playit
	move.w	#$01f4,d0
mt_rls:	dbf	d0,mt_rls

	move.w	#$8000,d0
	or.w	mt_dmacon,d0
	move.w	d0,$dff096

	lea	mt_aud4temp(PC),a6
	cmp.w	#1,14(a6)
	bne.s	mt_voice3
	move.l	10(a6),$dff0d0
	move.w	#1,$dff0d4
mt_voice3:
	lea	mt_aud3temp(PC),a6
	cmp.w	#1,14(a6)
	bne.s	mt_voice2
	move.l	10(a6),$dff0c0
	move.w	#1,$dff0c4
mt_voice2:
	lea	mt_aud2temp(PC),a6
	cmp.w	#1,14(a6)
	bne.s	mt_voice1
	move.l	10(a6),$dff0b0
	move.w	#1,$dff0b4
mt_voice1:
	lea	mt_aud1temp(PC),a6
	cmp.w	#1,14(a6)
	bne.s	mt_voice0
	move.l	10(a6),$dff0a0
	move.w	#1,$dff0a4
mt_voice0:
	move.l	mt_partnote(PC),d0
	add.l	#$10,d0
	move.l	d0,mt_partnote
	cmp.l	#$400,d0
	bne.s	mt_stop
mt_higher:
	clr.l	mt_partnote
	addq.l	#1,mt_partnrplay
	moveq	#0,d0
	move.w	mt_maxpart(PC),d0
	move.l	mt_partnrplay(PC),d1
	cmp.l	d0,d1
	bne.s	mt_stop
	clr.l	mt_partnrplay
mt_stop:tst.w	mt_status
	beq.s	mt_stop2
	clr.w	mt_status
	bra.s	mt_higher
mt_stop2:
	rts

mt_playit:
	move.l	(a0,d1.l),(a6)
	addq.l	#4,d1
	moveq	#0,d2
	move.b	2(a6),d2
	and.b	#$f0,d2
	lsr.b	#4,d2

	move.b	(a6),d0
	and.b	#$f0,d0
	or.b	d0,d2
	tst.b	d2
	beq.L	mt_nosamplechange

	moveq	#0,d3
	lea	mt_samples(PC),a1
	move.l	d2,d4
	asl.l	#2,d2
	mulu	#$1e,d4
	move.l	(a1,d2),4(a6)
	move.w	(a3,d4.l),8(a6)
	move.w	2(a3,d4.l),18(a6)
	move.w	4(a3,d4.l),d3
	tst.w	d3
	beq.s	mt_displace
	move.l	4(a6),d2
	add.l	d3,d2
	move.l	d2,4(a6)
	move.l	d2,10(a6)
	move.w	6(a3,d4.l),8(a6)
	move.w	6(a3,d4.l),14(a6)
	move	18(a6),tv
	bsr	setvolume
	move	tv,8(a5)
	bra.s	mt_nosamplechange

mt_displace:
	move.l	4(a6),d2
	add.l	d3,d2
	move.l	d2,10(a6)
	move.w	6(a3,d4.l),14(a6)
	move	18(a6),tv
	bsr	setvolume
	move	tv,8(a5)
mt_nosamplechange:
	tst.w	(a6)
	beq.s	mt_retrout
	move.w	(a6),16(a6)
	move.w	20(a6),$dff096
	move.l	4(a6),(a5)
	move	8(a6),4(a5)
	move	(a6),6(a5)
	move.w	20(a6),d0
	or.w	d0,mt_dmacon

mt_retrout:
	tst.w	(a6)
	beq.s	mt_nonewper
	move.w	(a6),22(a6)

mt_nonewper:
	move.b	2(a6),d0
	and.b	#$0f,d0
	cmp.b	#$0b,d0
	beq.s	mt_posjmp
	cmp.b	#$0c,d0
	beq.s	mt_setvol
	cmp.b	#$0d,d0
	beq.s	mt_break
	cmp.b	#$0e,d0
	beq.s	mt_setfil
	cmp.b	#$0f,d0
	beq.s	mt_setspeed
	rts

mt_posjmp:
	move	#1,mt_status
	moveq	#0,d0
	move.b	3(a6),d0
	subq.b	#1,d0
ext	d0
ext.l	d0
	move.l	d0,mt_partnrplay
	rts

mt_setvol:
	move.b	3(a6),tv+1
	bsr	setvolume
	move	tv,8(a5)
	move.b	3(a6),19(a6)
	rts

mt_break:
	move	#1,mt_status
	rts

mt_setfil:
	moveq	#0,d0
	move.b	3(a6),d0
	and.b	#1,d0
	rol.b	#1,d0
	and.b	#$fd,$bfe001
	or.b	d0,$bfe001
	rts

mt_setspeed:
	move.b	3(a6),d0
	and.b	#$0f,d0
	beq.s	mt_back
	clr.w	mt_counter
	move.b	d0,mt_cool+3
mt_back:rts

mt_aud1temp:
	blk.w	10,0
	dc.w	1
	blk.w	2,0
mt_aud2temp:
	blk.w	10,0
	dc.w	2
	blk.w	2,0
mt_aud3temp:
	blk.w	10,0
	dc.w	4
	blk.w	2,0
mt_aud4temp:
	blk.w	10,0
	dc.w	8
	blk.w	2,0

mt_partnote:	dc.l	0
mt_partnrplay:	dc.l	10
mt_counter:	dc.w	0
mt_partpoint:	dc.l	0
mt_samples:	dc.l	0
mt_sample1:	blk.l	31,0
mt_maxpart:	dc.w	0
mt_dmacon:	dc.w	0
mt_status:	dc.w	0

mt_arpeggio:
	dc.w $0358,$0328,$02fa,$02d0,$02a6,$0280,$025c
	dc.w $023a,$021a,$01fc,$01e0,$01c5,$01ac,$0194,$017d
	dc.w $0168,$0153,$0140,$012e,$011d,$010d,$00fe,$00f0
	dc.w $00e2,$00d6,$00ca,$00be,$00b4,$00aa,$00a0,$0097
	dc.w $008f,$0087,$007f,$0078,$0071,$0000,$0000,$0000

waited:
dc.w	0
musiced:
dc.w	0

volume:
dc.w	150
tv:
dc.w	0
defingkeys:
dc.w	0

;track=$40000
;tsync=track-2
;move	$dff01c,-(a7)
;move	#$7fff,$dff09a
;bsr	readfame
;move	(a7)+,d0
;bset	#15,d0
;move	d0,$dff09a
;rts


sync=$5a5a

readfame:
lea	$dff000,a6
clr	overrid

bsr	track0
move	#160,d0
bsr	seektrack

rf2:
clr.b	overrid
bsr	startmotor
bsr	readtrack
lea	famedata,a1
bsr	dcode
bsr	checkdata
tst.b	overrid
bne	shh
bsr	stopmotor
rts

checkdata:
move	#[9*4]-1,d0
lea	FAMEdata,a0
cnn:
move	#9,d1
cn2:
btst	#7,(a0)
bne	sinni
tst.b	(a0)+
beq	nameok
dbra	d1,cn2
nokr:
addq.l	#2,a0
dbra	d0,cnn
rts


nameok:
add	d1,a0
bra	nokr

sinni:
add.b	#1,overrid+1
move.b	#-1,overrid
rts

shh:
bsr	stopmotor
lea	famedata,a1
move	#215,d0
gtt:
clr	(a1)+
dbra	d0,gtt
cmp.b	#5,overrid+1
blt	rf2
rts

writefame:
lea	$dff000,a6
;bsr	track0
;move	#160,d0
;bsr	seektrack
bsr	startmotor

lea	famedata,a0
bsr	code
bsr	writetrack
bsr	stopmotor
rts


existing:
blk.b	4,0
dc.w	0

code:
lea	codes,a2
lea	track,a1
move	#215,d0
clr	d2

codeword:
clr	d3

move	(a0)+,d1

rol	#2,d1
move.b	d1,d2
and	#3,d2
or.b	(a2,d2.w),d3
lsl	#5,d3

rol	#2,d1
move.b	d1,d2
and	#3,d2
or.b	(a2,d2.w),d3

ror	#2,d3
move.b	d3,(a1)+
rol	#2,d3

lsl	#5,d3

rol	#2,d1
move.b	d1,d2
and	#3,d2
or.b	(a2,d2.w),d3
lsl	#5,d3

rol	#2,d1
move.b	d1,d2
and	#3,d2
or.b	(a2,d2.w),d3

ror	#4,d3
move.b	d3,(a1)+
rol	#4,d3

lsl	#5,d3

rol	#2,d1
move.b	d1,d2
and	#3,d2
or.b	(a2,d2.w),d3

ror	#1,d3
move.b	d3,(a1)+
rol	#1,d3

lsl	#5,d3

rol	#2,d1
move.b	d1,d2
and	#3,d2
or.b	(a2,d2.w),d3
lsl.l	#5,d3

rol	#2,d1
move.b	d1,d2
and	#3,d2
or.b	(a2,d2.w),d3

ror	#3,d3
move.b	d3,(a1)+
rol	#3,d3

lsl.l	#5,d3

rol	#2,d1
move.b	d1,d2
and	#3,d2
or.b	(a2,d2.w),d3

move.b	d3,(a1)+


dbra	d0,codeword

rts

codes:
dc.b	%00101,%00010,%01001,%01010

dcodes:
dc.b	0,0,1,0,0,0,0,0,0,2,3
even

dcode:
lea	track,a0
lea	dcodes,a2
move	#215,d0
clr	d2

dcodeword:
move.b	(a0)+,d1
lsl	#8,d1
move.b	(a0)+,d1

clr	d3

rol	#5,d1
move.b	d1,d2
and	#%11111,d2
or.b	(a2,d2.w),d3
lsl	#2,d3

rol	#5,d1
move.b	d1,d2
and	#%11111,d2
or.b	(a2,d2.w),d3
lsl	#2,d3

rol	#5,d1
move.b	d1,d2
and	#%11111,d2
or.b	(a2,d2.w),d3
lsl	#2,d3

lsl.l	#1,d1
move.b	(a0)+,d1
lsl	#8,d1
move.b	(a0)+,d1
ror.l	#1,d1

rol	#5,d1
move.b	d1,d2
and	#%11111,d2
or.b	(a2,d2.w),d3
lsl	#2,d3

rol	#5,d1
move.b	d1,d2
and	#%11111,d2
or.b	(a2,d2.w),d3
lsl	#2,d3

rol	#5,d1
move.b	d1,d2
and	#%11111,d2
or.b	(a2,d2.w),d3
lsl	#2,d3

rol	#1,d1
rol.l	#1,d1
rol	#8,d1

move.b	(a0)+,d1
lsl	#6,d1

rol	#5,d1
move.b	d1,d2
and	#%11111,d2
or.b	(a2,d2.w),d3
lsl	#2,d3

rol	#5,d1
move.b	d1,d2
and	#%11111,d2
or.b	(a2,d2.w),d3

move	d3,(a1)+

dbra	d0,dcodeword

rts

trackno:
dc.w	0


seektrack:
movem.l	d6/d7/a5,-(a7)
and	#$fffe,trackno
move	d0,d2
and	#1,d2
and	#$fffe,trackno
or	d2,trackno
lsr	#1,d0
sta:
tst	d0
beq	t0a
move	trackno,d6
lsr	#1,d6
cmp.b	d6,d0
blt	inw
bgt	otw
movem.l	(a7)+,d6/d7/a5
rts

otw:
move.b	#%11110111,d7
move	driveno,d6
rol.b	d6,d7
and	#%11111100,d7

move.b	d7,$bfd100
or	#1,d7
move.b	d7,$bfd100

add	#2,trackno
bsr	stepwait
bra	sta

inw:
move.b	#%11110111,d7
move	driveno,d6
rol.b	d6,d7
and	#%11111110,d7

move.b	d7,$bfd100
or	#1,d7
move.b	d7,$bfd100

lea	tracknos,a5
sub	#2,trackno
bsr	stepwait
bra	sta


track0:
movem.l	d6/d7/a5,-(a7)
t0a:

clr	trackno

t0:
btst	#4,$bfe001
beq	rtsres675

move.b	#%11110111,d7
move	driveno,d6
rol.b	d6,d7
and	#%11111010,d7

move.b	d7,$bfd100
or	#1,d7
move.b	d7,$bfd100

bsr	stepwait
bra	t0

rtsres675:
movem.l	(a7)+,d6/d7/a5
rts

stepwait:
move	d0,-(a7)
move	#70,tw
ws2:
move.b	$dff006,d0
ws1:
cmp.b	$dff006,d0
beq	ws1
sub	#1,tw
bne	ws2
move	(a7)+,d0
rts

driveno:
dc.w	0

motorstates:
dc.b	128,128,128,128

tw:
dc.w	0

tracknos:
blk.b	4,0

startmotor:
move.b	#%01111111,$bfd100

move.b	#%11110111,d7
move	driveno,d6
rol.b	d6,d7
and	#%01111001,d7

move.b	d7,$bfd100

clr	motorstate
rts

motorstate:
dc.w	0

stopmotor:
move.b	#%11111111,$bfd100

move.b	#%11110111,d7
move	driveno,d6
rol.b	d6,d7
and	#%01111001,d7

move.b	d7,$bfd100

move	#128,motorstate

rts

changedrive:
move	driveno,d1
lea	tracknos,a0
move.b	trackno+1,(a0,d1.w)
move.b	(a0,d0.w),trackno+1
lea	motorstates,a0
move.b	motorstate+1,(a0,d1.w)
move.b	(a0,d1.w),motorstate+1

move	d0,driveno


move.b	#%11110111,d7
move	driveno,d6
rol.b	d6,d7
and	#%11111111,d7

move.b	d7,$bfd100
rts


readtrack:
movem.l	d0/d6/a5,-(a7)
move	#-1,d0
move	driveno,d6
add	#3,d6
bclr	d6,d0
move.b	d0,$bfd100
movem.l	(a7)+,d0/d6/a5

clr.l	creg

re:
add.l	#1,creg
cmp.l	#20000,creg
beq	override
btst	#5,$bfe001
bne	re

move	#$7fff,$9e(a6)
move	#2,$9c(a6)
move	#sync,$7e(a6)
move	#%1001010100000000,$9e(a6)
move.l	#track,$20(a6)
move	#$8210,$96(a6)
move	#$4000,$24(a6)
move	#$8000+541,$24(a6)
move	#$8000+541,$24(a6)

clr.l	creg

gnugnu:
add.l	#1,creg
cmp.l	#20000,creg
beq	override
btst	#1,$1f(a6)
beq	gnugnu

move	#$4000,$24(a6)
rts

override:
add.b	#1,overrid+1
move.b	#-1,overrid
move	#$4000,$24(a6)
rts

overrid:
dc.w	0


creg:
dc.l	0

writetrack:
movem.l	d0/d6/a5,-(a7)
move	#-1,d0
move	driveno,d6
add	#3,d6
bclr	d6,d0
move.b	d0,$bfd100
wfdr:
btst	#5,$bfe001
bne	wfdr

move	#10000,d0
gr:
dbra	d0,gr

move	#$7fff,$9e(a6)
move	#%1001000100000000,$9e(a6)
move	#sync,tsync
move	#$8210,$96(a6)

move	#14,d0
repp:
move.l	#track,$20(a6)
move	#$4000,$24(a6)
move	#$c000+541,$24(a6)
move	#$c000+541,$24(a6)
move	#2,$9c(a6)
gnu21:
btst	#1,$1f(a6)
beq	gnu21
dbra	d0,repp

move.l	#tsync,$20(a6)
move	#$4000,$24(a6)
move	#$c000+542,$24(a6)
move	#$c000+542,$24(a6)
move	#2,$9c(a6)
gnu22:
btst	#1,$1f(a6)
beq	gnu22

move	#$4000,$24(a6)
movem.l	(a7)+,d0/d6/a5

w2:
btst	#1,$1f(a6)
beq	w2

move	#2,$9c(a6)
move	#$4000,$24(a6)
rts


findname:
clr.l	names
clr.l	names+4
clr	names+6

move.l	#[44*196]+8,d5
lea	names,a5
clr	d1

gkka:
bsr	getkey
cmp.b	#-1,d0
beq	hurkruga
tst.b	d0
beq	gkka
cmp.b	#1,d0
beq	namekin
add	#1,d1
cmp	#11,d1
bne	hurkpa
move	#10,d1
sub.l	#2,d5
hurkpa:
bsr	typethis
move.b	d0,-1(a5,d1.w)
bra	gkka

hurkruga:
tst	d1
beq	gkka
sub.l	#2,d5
sub	#1,d1 
movem.l	d0-d7/a0-a6,-(a7)
move	#1410,d0
move	#2,d1
move	#1,d2
move	d5,d3
move	#23,d4

bkingo:
bsr	bo
add	#44,d3
dbra	d4,bkingo
movem.l	(a7)+,d0-d7/a0-a6
bra	gkka

namekin:
clr.b	(a5,d1.w)
rts

read:
dc.w	0

setprefs:
dc.w	0

defpref:
dc.w	0,0,0,$df,$f00c,$4f4e,$4d61,$114c,0,0,0

b:

org	top
load	top

names=top
players=top+200
gamestate=top+202
level=top+204
a_stickpo=top+206
b_stickpo=top+210
up=top+214
rn=top+216
oldgs=top+218
nrs=top+220
recscores=top+222
;end

blk.b	[20*10],0
dc.w	0
dc.w	0
dc.w	0
dc.l	$dff00c
dc.l	$4f4e4d61
dc.w	$114c
dc.w	0
dc.w	0
dc.w	0

org top
load top
;>extern "df0:main.c",top-menul-maincl	;ASS
;;>extern "df0:menu",top-maincl-menul

lea	dosname,a1
move.l	4,a6
jsr	-408(a6)

move.l	d0,a6
lea	mname(pc),a0
move.l	a0,d1
move.l	#1005,d2
jsr	-30(a6)
bmi	rts

move.l	d0,fhd
move.l	d0,d1
move.l	#top-maincl-menul,d2
move.l	#-1,d3
jsr	-42(a6)

move.l	fhd,d1
jsr	-36(a6)

lea	mgname(pc),a0
move.l	a0,d1
move.l	#1005,d2
jsr	-30(a6)

move.l	d0,fhd
move.l	d0,d1
move.l	#top-maincl,d2
move.l	#-1,d3
jsr	-42(a6)

move.l	fhd,d1
jsr	-36(a6)

dong:
move	#$7fff,$dff09a
move	#$7fff,$dff09c
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

lea	cp,a0
lea	top-mainl-menul-works-4096,a1
move	#cpe-cp-1,d0
g:
move.b	(a0)+,(a1)+
dbra	d0,g
jmp	top-mainl-menul-works-4096

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


rts1:
rts

fhd:
dc.l	0

mname:
dc.b	"code",0

mgname:
dc.b	"music",0

dosname:
dc.b	"dos.library",0
even


