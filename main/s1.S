;SS!
top=$7ff00
topaz=top-1280
a=topaz-20000
keys=a-128
screen=keys-[80*256*2]
scrbuf=screen-[640*2]
samplepos=$40000

>extern	"topaz_8",topaz
>extern "testbass",samplepos

org	a
load	a

bsr.L	init

lea	mainscreen,a5
bsr.L	drawscreen

main:
btst	#6,$bfe001
beq.S	chi
btst	#2,$16(a6)
bne	main
bsr	rightbutt
bra.S	main

chi:
bsr.L	checkicons
bra.s	main

rightbutt:
ps3:
cmp.b	#20,6(a6)
bne	ps3
btst	#0,5(a6)
beq	ps3
lea	testp,a0
bsr	changesprite
move.l	testp,d0
cmp.l	eqp,d0
blt	ls
move.l	testp,rngp2
move.l	eqp,rngp1
bra.s	lso
ls:
move.l	testp,rngp1
move.l	eqp,rngp2
lso:
move.l	utspos,a0
move.l	utslen,d0
bsr	putsprites
btst	#2,$16(a6)
beq	ps3
movem.l	(a7)+,d0-d7/a0-a6
bra	noicon

me:
movem.l	d0-d7/a0-a6,-(a7)
move.b	pointer+1,d0
move.b	rng1+1,d1
cmp.b	d1,d0
blt	ps21
add.b	#8,d1
cmp.b	d1,d0
bgt	ps21
lea	rngp1,a0
bra	drag
ps21:
move.b	rng2+1,d1
cmp.b	d1,d0
blt	ps2
add.b	#8,d1
cmp.b	d1,d0
bgt	ps2
lea	rngp2,a0
bra	drag
ps2:
cmp.b	#20,6(a6)
bne	ps2
btst	#0,5(a6)
beq	ps2
lea	rngp1,a0
bsr	changesprite
move.l	rngp1,rngp2
move.l	utspos,a0
move.l	utslen,d0
bsr	putsprites
btst	#2,$16(a6)
beq	ps2
movem.l	(a7)+,d0-d7/a0-a6
bra	noicon

drag:
move.l	a0,-(a7)
bsr	changesprite
move.l	rngp1,d0
cmp.l	rngp2,d0
ble	obser
move.l	rngp2,rngp1
move.l	d0,rngp2
move.l	utspos,a0
move.l	utslen,d0
bsr	putsprites
cmp.l	#rngp1,(a7)
beq	rg2
move.l	#rngp1,(a7)
bra.s	obser
rg2:
move.l	#rngp2,(a7)
obser:
move.l	(a7)+,a0
btst	#2,$16(a6)
beq	drag
movem.l	(a7)+,d0-d7/a0-a6
bra	noicon

pressbutt:
pea	noicon

release:
btst	#6,$bfe001
bne.S	release
rts

noicon:
btst	#6,$bfe001
beq.S	noicon
btst	#2,$16(a6)
beq.s	noicon
move	#7000,d0
w:dbra	d0,w
rts

updatemem:
lea	samplepos,a0
move	#17,d0
lea	samples,a1
lea	lengths,a2
mv:
move.l	(a1),d1
cmp.l	d1,a0
beq.S	next
blt.S	next

move.l	(A1),a2
move.l	a0,a3
move	(A2),d2
subq	#1,d2
bull:
move	(a2)+,(a3)+
dbra	d2,bull

move.l	a0,(a1)

next:
add	(a2)+,a0
dbra	d0,mv

checkicons:
cmp	#128,y
bge	pressedsample
move.l	a5,a0
nexticon:
move	(a0),d7
bmi.S	noicon
move	x,d0
move	y,d1
cmp	2(a0),d0
blt.L	nthisi
cmp	4(a0),d1
blt.L	nthisi
cmp	6(a0),d0
bge.S	nthisi
cmp	8(a0),d1
bge.S	nthisi
tst	d7
beq.S	routcalling
not	10(a0)
bsr.L	flagtype2
vtt:
btst	#6,$bfe001
beq.S	vtt
move	#5000,d0
vyty:
dbra	d0,vyty
rts


routcalling:
move.l	a0,a4
bsr.L	actives
hlll:
btst	#6,$bfe001
bne.S	runrout
move	x,d0
move	y,d1
cmp	2(a4),d0
blt.S	leftme
cmp	4(a4),d1
blt.S	leftme
cmp	6(a4),d0
bge.S	leftme
cmp	8(a4),d1
bge.S	leftme
bra.S	hlll

leftme:
move.l	a4,a0
bsr.L	inactives
wr:
btst	#6,$bfe001
beq.S	wr
rts

runrout:
move.l	a4,a0
bsr.L	inactives
move.l	10(a4),a0
jsr	(a0)
rts

nthisi:
add	#12,a0
tst	d7
bne.S	only12
addq.l	#2,a0
only12:
tst.b	(a0)+
bne.S	only12
move	a0,d0
btst	#0,d0
beq.L	nexticon
addq.l	#1,a0
bra.L	nexticon

pressedsample:
tst.l	utslen
beq	rts
movem.l	d0-d7/a0-a6,-(a7)
ps:
lea	poip,a0
bsr	changesprite
btst	#6,$bfe001
beq	ps
movem.l	(a7)+,d0-d7/a0-a6
bra	noicon

changesprite:
move.l	utslen,d3
move.l	d3,d4
move	x,d0

clr	d4
swap	d4
mulu	x,d4
swap	d4
clr	d4
and.l	#$ffff,d3
mulu	x,d3
add.l	d3,d4

sub.l	a5,a5
cmp.l	#$ffff,d0
ble.S	qnuu
move.l	d0,a5
lsr.l	#4,d0
qnuu:

move.l	d4,d5
clr	d5
swap	d5
divu	#640,d5
move	d5,d3
swap	d3
move	d4,d5
divu	#640,d5
move	d5,d3

cmp.l	#0,a5
beq.S	qnuuu
move.l	a5,d0
lsr.l	#4,d3
qnuuu:

lea	samples,a1
move	instrument,d0
lsl	#2,d0
sub.l	(a1,d0.w),d3
add.l	utspos,d3
move.l	d3,(a0)
move.l	utspos,a0
move.l	utslen,d0
bra	putsprites

actives:
pea	typeicon2
vvs:
move	4(a0),d0
add	#60,d0
ri:
cmp.b	$6(a6),d0
bne.S	ri
cmp	#255,d0
ble.S	uh

btst	#0,$5(a6)
beq.S	vvs
bra.s	active

uh:
btst	#0,$5(a6)
bne.S	vvs

active:
move	#3,o3+2
move	#3,o3o+2

move	(a0)+,d7
move	(a0)+,d0
move	d0,d2
lea	screen,a1
move	(a0)+,d1
mulu	#160,d1
add	d1,a1

addq.l	#6,a0
move.l	a0,a2

tst	d7
bne.S	add2ac
addq.l	#2,a0
add2ac:

move	d0,d2
lsr	#3,d2
move.b	#%01111111,(a1,d2.w)
add	#80,d2
move.b	#%01111111,(a1,d2.w)
add	#80,d2
move.b	#%11011111,(a1,d2.w)
add	#80,d2
move.b	#%00011111,(a1,d2.w)
add	#80,d2

move	#11,d6
ver3:
move.b	#%11110000,(a1,d2.w)
add	#80,d2
move.b	#%00000000,(a1,d2.w)
add	#80,d2
dbra	d6,ver3

moveq	#-1,d6
ww:
add	#1,d6
tst.b	(a0,d6.w)
bne.S	ww
addq	#2,d6
lsl	#3,d6
add	d6,d0
move	d0,-6(a2)
sub	d6,d0
lsr	#3,d6
subq	#1,d6
add	d6,d2

move.b	#%11111011,(a1,d2.w)
add	#80,d2
move.b	#%00000011,(a1,d2.w)
add	#80,d2
move.b	#%11111110,(a1,d2.w)
add	#80,d2
move.b	#%00000000,(a1,d2.w)

sub	#[160*13]+80,d2
move	#11,d5
vrr:
move.b	#%00001111,(a1,d2.w)
add	#80,d2
move.b	#%00001111,(a1,d2.w)
add	#80,d2
dbra	d5,vrr

sub	#[160*14],d2
move	d6,d5
subq	#1,d5
vrt:
move.b	#-1,(a1,d2.w)
add	#80,d2
move.b	#-1,(a1,d2.w)
add	#80,d2
move.b	#-1,(a1,d2.w)
add	#80,d2
move.b	#-1,(a1,d2.w)
sub	#241,d2
dbra	d5,vrt

add	#[160*14],d2
move	d6,d5
subq	#1,d5
vrt5:
move.b	#-1,(a1,d2.w)
add	#80,d2
move.b	#0,(a1,d2.w)
add	#80,d2
move.b	#-1,(a1,d2.w)
add	#80,d2
move.b	#0,(a1,d2.w)
sub	#239,d2
dbra	d5,vrt5

rts

typeicon:
divu	#160,d1
add	#16,d1
move	d1,-4(a2)
sub	#16,d1
o3o:
move	#0,d2
add	#8,d0
add	#4,d1

bsr.L	type
add	d6,a0
btst	#0,d6
beq.S	dscreen
addq.l	#1,a0

dscreen:
tst	(a0)
bmi.L	rts
pea	typeicon

tst	(a0)
bne.S	flagtype
bra.S	inactive
flagtype:
tst	10(a0)
bne.L	active
bra.S	inactive

inactives:
pea	typeicon2
vvs2:
move	4(a0),d0
add	#60,d0
inri:
cmp.b	$6(a6),d0
bne.S	inri
cmp	#255,d0
ble.S	inuh

btst	#0,$5(a6)
beq.S	vvs2
bra.s	inactive

inuh:
btst	#0,$5(a6)
bne.S	vvs2

inactive:
move	#0,o3+2
move	#0,o3o+2

move	(a0)+,d7
move	(a0)+,d0
move	d0,d2
lea	screen,a1
move	(a0)+,d1
mulu	#160,d1
add	d1,a1

addq.l	#6,a0
move.l	a0,a2

tst	d7
bne.S	add2
addq.l	#2,a0
add2:

move	d0,d2
lsr	#3,d2
move.b	#%01111111,(a1,d2.w)
add	#80,d2
move.b	#%00000000,(a1,d2.w)
add	#80,d2
move.b	#%11011111,(a1,d2.w)
add	#80,d2
move.b	#%11000000,(a1,d2.w)
add	#80,d2

move	#11,d6

ver3ac:
move.b	#%11110000,(a1,d2.w)
add	#80,d2
move.b	#%11110000,(a1,d2.w)
add	#80,d2
dbra	d6,ver3ac

moveq	#-1,d6
wwac:
add	#1,d6
tst.b	(a0,d6.w)
bne.S	wwac
addq	#2,d6
lsl	#3,d6
add	d6,d0
move	d0,-6(a2)
sub	d6,d0
lsr	#3,d6
subq	#1,d6
add	d6,d2

move.b	#%11111011,(a1,d2.w)
add	#80,d2
move.b	#%11111000,(a1,d2.w)
add	#80,d2
move.b	#%11111110,(a1,d2.w)
add	#80,d2
move.b	#%11111110,(a1,d2.w)

sub	#[160*13]+80,d2
move	#11,d5
vrrac:
move.b	#%00001111,(a1,d2.w)
add	#80,d2
move.b	#%00000000,(a1,d2.w)
add	#80,d2
dbra	d5,vrrac

sub	#[160*14],d2
move	d6,d5
subq	#1,d5
vrtac:
move.b	#-1,(a1,d2.w)
add	#80,d2
move.b	#0,(a1,d2.w)
add	#80,d2
move.b	#-1,(a1,d2.w)
add	#80,d2
move.b	#0,(a1,d2.w)
sub	#241,d2
dbra	d5,vrtac

add	#[160*14],d2
move	d6,d5
subq	#1,d5
vrt5ac:
move.b	#-1,(a1,d2.w)
add	#80,d2
move.b	#-1,(a1,d2.w)
add	#80,d2
move.b	#-1,(a1,d2.w)
add	#80,d2
move.b	#-1,(a1,d2.w)
sub	#239,d2
dbra	d5,vrt5ac

rts

typeicon2:
movem.l	d0-d7/a0-a6,-(a7)
divu	#160,d1
add	#16,d1
move	d1,-4(a2)
sub	#16,d1
o3:
move	#3,d2
add	#8,d0
add	#4,d1

bsr.L	type

movem.l	(a7)+,d0-d7/a0-a6
rts

flagtype2:
tst	10(a0)
bne.L	actives
bra.L	inactives

drawscreen:
move.l	a5,a0
bra.L	dscreen

putppointers:
clr.b	ppointer1+1
clr.b	ppointer2+1
lea	fetchbuf1,a2
lea	ppointer1,a5
bsr	ppp
beq	s2
tst	phase
beq	s2
lea	fetchbuf2,a2
bsr	pp
bra	s3
s2:
lea	fetchbuf2,a2
bsr	ppp
s3:
lea	fetchbuf3,a2
lea	ppointer2,a5
bsr	ppp
beq	s4
tst	phase
beq	s4
lea	fetchbuf4,a2
bsr	pp
bra	s5
s4:
lea	fetchbuf4,a2
bsr	ppp
s5:
not	phase
rts

ppp:
tst	fetching(a2)
beq.S	nfe1
move.l	fetchpos(a2),d3
move.l	utspos,a0
move.l	utslen,d0
bsr.L	putppos
pp:
tst	fetching(a2)
beq.S	nfe1
clr.l	d3
move	fetchspeed(a2),d3
move	d3,d4
and	#127,d4
add	d4,[fetchspeed+2](a2)
move	[fetchspeed+2](a2),d4
and	#$7f,[fetchspeed+2](a2)
and	#$ff80,d4
add	d4,d3
lsr	#7,d3
add.l	d3,fetchpos(a2)
tst.l	fetchloop2(a2)
beq	nfe0
move.l	fetchloop2(a2),d1
add.l	fetchfrom(a2),d1
cmp.l	fetchpos(a2),d1
bgt.S	nfe1
move.l	fetchloop1(a2),d1
add.l	fetchfrom(a2),d1
move.l	d1,fetchpos(a2)
nfe0:
move	#-1,d1
nfe1:
rts

vblank:
btst	#5,$1f(a6)
beq.L	rte1

movem.l	d0-d7/a0-a6,-(a7)

bsr	putppointers

move	oldm,d0
move	d0,d1
lsr	#8,d1
and	#$ff,d0
move	$a(a6),d2
move	d2,oldm
move	d2,d3
lsr	#8,d3
and	#$ff,d2

clr	flytt

sub.b	d0,d2
sub.b	d1,d3
ext	d2
ext	d3
lsl	#1,d2
add	d2,x
cmp	#642,x
blo.S	xok
bge.S	farright
cmp	#128,y
blt.S	clx
move	x,flytt
clx:
clr	x
bra.S	xok
farright:
cmp	#128,y
blt.S	cx
move	x,flytt
sub	#640,flytt
cx:
move	#640,x
xok:

add	d3,y
cmp	#256,y
blo.S	yok
bge.S	below
clr	y
bra.S	yok
below:
move	#255,y
yok:

move	x,d0
lsr	#1,d0
add	#$80,d0
move	d0,d1
lsr	#1,d0
move.b	d0,pointer+1
and	#1,d1
move.b	d1,pointer+3
move	y,d0
add	#$2c,d0
move.b	d0,pointer
move	d0,d1
lsr	#6,d1
and	#%100,d1
or.b	d1,pointer+3
add	#22,d0
move.b	d0,pointer+2
move	d0,d1
lsr	#7,d1
and	#%10,d1
or.b	d1,pointer+3

tst	flytt
beq.S	rtr

clr	ym
move	flytt,d0
bra.L	intercept

rtr:
clr	d0
clr	d1
tst.b	keys+$4c
beq.S	noup
subq	#1,d1
noup:
tst.b	keys+$4d
beq.S	nodn
addq	#1,d1
nodn:
tst.b	keys+$4e
beq.S	nolt
subq	#1,d0
nolt:
tst.b	keys+$4f
beq.S	nort
addq	#1,d0
nort:
tst.b	keys+$61
beq.S	nosh
muls	#10,d0
muls	#10,d1
nosh:
tst.b	keys+$65
beq.S	noalt
muls	#50,d0
muls	#50,d1
noalt:

move	d1,ym

tst	d0
bne.L	intercept
tst	d1
bne.L	intercept

tst	update
beq.S	rteres
subq	#1,update
bra.L	icp2
rteres:
movem.l	(a7)+,d0-d7/a0-a6

rte1:
move	#$20,$9c(a6)
rte

flytt:
dc.w	0

init:
lea	$dff000,a6
move	$1c(a6),oldinten
move	2(a6),olddmaen
move	#$7fff,$9a(a6)
move	#$7fff,$9c(a6)
move	#$7fff,$96(a6)
move.l	#screen,d0
move	d0,e0+6
swap	d0
move	d0,e0+2
swap	d0
add.l	#80,d0
move	d0,e0+14
swap	d0
move	d0,e0+10
lea	spr,a0
move	#7,d0
move.l	#null,d1
ins:
move	d1,6(a0)
swap	d1
move	d1,2(a0)
swap	d1
addq.l	#8,a0
dbra	d0,ins

move.l	#pointer,d0
move	d0,spr+6
swap	d0
move	d0,spr+2

move.l	#spointer,d0
move	d0,spr+14
swap	d0
move	d0,spr+10

move.l	#rng1,d0
move	d0,spr+22
swap	d0
move	d0,spr+18

move.l	#rng2,d0
move	d0,spr+30
swap	d0
move	d0,spr+26

move.l	#loop1,d0
move	d0,spr+38
swap	d0
move	d0,spr+34

move.l	#loop2,d0
move	d0,spr+46
swap	d0
move	d0,spr+42

move.l	#ppointer1,d0
move	d0,spr+54
swap	d0
move	d0,spr+50

move.l	#ppointer2,d0
move	d0,spr+62
swap	d0
move	d0,spr+58

move.b	#%00010111,$bfed01
move.b	#%10001000,$bfed01

move	#%1000011001000000,$96(a6)
move.l	#screen,$54(a6)
clr	$66(a6)
move	#%100000000,$40(a6)
clr	$42(a6)
move	#40+[64*512],$58(a6)
bsr.L	wfb
lea	scrbuf,a0
move	#639,d0
bvbtny:
clr	(A0)+
dbra	d0,bvbtny

move.l	samples,a0
move.l	lengths,d0
move.l	a0,utspos
move.l	d0,utslen
bsr.L	putsprites
bsr.L	drawwave

move.l	#copperlist,$84(a6)
clr	$8a(a6)
move.l	$6c,olv3
move.l	#vblank,$6c
move.l	$68,oldkeyb
move.l	$70,oldaudi
move.l	#keyboard,$68
move	$a(a6),oldm
move	#%1100000000101000,$9a(a6)
move	#%1000011111110000,$96(a6)
rts

wfb:
btst	#6,2(a6)
bne.S	wfb
rts:
rts

oldinten:
dc.w	0
olddmaen:
dc.w	0

keyboard:
movem.l	d0-d7/a0-a6,-(a7)

move.b	$bfed01,soppel
move	#8,$9c(a6)

clr	d0
move.b	$bfec01,d0
ror.b	#1,d0
not.b	d0

lea	keys,a0
btst	#7,d0
beq.S	keydown
bclr	#7,d0
ext	d0
clr.b	(a0,d0.w)
bra.S	pulse

keydown:
ext	d0
move.b	#-1,(a0,d0.w)

pulse:
move.b	#%1000100,$bfee01
move.b	#-1,$bfec01

tst	canplay
beq.L	rte

tst.b	(a0,d0.w)
beq.L	rte

lsl	#1,d0
lea	keyper,a1
move	(a1,d0.w),d1
beq.L	ntone

lsr	#1,d0
clr.b	(a0,d0.w)

tst	hifi
beq.L	lofi

move	#%0000000010000000,$9a(a6)

move	octave,d2
lsr	d2,d1
move	d1,fetchper(a1)

move	instrument,d2
lsl	#2,d2
lea	samples,a0
lea	fetchbuf1,a1
move.l	(a0,d2.w),fetchpos(a1)
move.l	(a0,d2.w),fetchfrom(a1)
lea	lengths,a0
move.l	(a0,d2.w),fetchlen(a1)
lea	loops,a0
lsl	#1,d2
move.l	(a0,d2.w),fetchloop1(a1)
move.l	4(a0,d2.w),fetchloop2(a1)
move.l	fetchloop2(a1),d0
asr.l	#1,d0
move.l	d0,sstate
move	#-1,fetching(a1)

move	#64,$a8(a6)
move	fetchper(a1),$a6(a6)
move.l	#fetch,$70
tst.l	fetchloop2(a1)
bne.S	loop
;move.l	#fetchnoloop,$70
;move.l	fetchlen,sstate
loop:
move	#0,$aa(a6)
move	#%1000000010000000,$9a(a6)

bra.L	rte

lofi:
move	channel,d0
add	#1,channel
and	#3,channel
clr	d7
bset	d0,d7
move	d7,$96(a6)
lsl	#7,d7
move	d7,$9a(a6)

move	#500,d3
byuu:
dbra	d3,byuu

move	d0,d3
mulu	#28,d3
lea	fetchbuf1,a1
add	d3,a1

move	octave,d2
lsr	d2,d1
move	d1,fetchper(a1)
move	d1,d6

move	instrument,d2
lsl	#2,d2
lea	samples,a0
move.l	(a0,d2.w),fetchpos(a1)
move.l	(a0,d2.w),fetchfrom(a1)
lea	lengths,a0
move.l	(a0,d2.w),fetchlen(a1)
lea	loops,a0
lsl	#1,d2
move.l	(a0,d2.w),fetchloop1(a1)
move.l	4(a0,d2.w),fetchloop2(a1)

bclr	#0,[fetchfrom+3](a1)
bclr	#0,[fetchloop1+3](a1)
bclr	#0,[fetchloop2+3](a1)

lsl	#4,d0
add	#$a0,d0
move.l	fetchfrom(a1),(a6,d0.w)
tst.l	fetchloop2(a1)
bne.S	fl2
move.l	fetchlen(a1),d1
bra.S	nfl2
fl2:
move.l	fetchloop2(a1),d1
nfl2:
lsr.l	#1,d1
add	#4,d0
move	d1,(a6,d0.w)
add	#4,d0
move	#64,(a6,d0.w)
sub	#2,d0
move	fetchper(a1),d3
move	d3,(a6,d0.w)
move.l	#[2837516*128]/40,d2
divu	d3,d2
move	d2,fetchspeed(a1)

lsr	#7,d7
bset	#15,d7
move	d7,$96(a6)
move	#-1,fetching(a1)

move	#1000,d3
b2yuu:
dbra	d3,b2yuu

and	#15,d7
lsl	#7,d7
move	d7,$9c(a6)
bset	#15,d7
move.l	#handledmasample,$70
move	d7,$9a(a6)

tst.l	fetchloop2(a1)
beq.S	nloop

move.l	fetchloop1(a1),d1
add.l	fetchfrom(a1),d1
sub	#6,d0
move.l	d1,(a6,d0.w)
move.l	fetchloop2(a1),d1
sub.l	fetchloop1(a1),d1
lsr.l	#1,d1
add	#4,d0
move	d1,(a6,d0.w)

bra.L	rte

nloop:
subq	#6,d0
move.l	#null,(a6,d0.w)
addq	#4,d0
move	#1,(a6,d0.w)
bra.S	rte

ntone:
tst.b	keys+$40
beq.S	nspc

clr	fetchbuf1+fetching
clr	fetchbuf2+fetching
clr	fetchbuf3+fetching
clr	fetchbuf4+fetching
move	#%0000011110000000,$9a(a6)
move	#$f,$96(a6)
clr.b	ppointer1+1
clr.b	ppointer2+1
clr.b	keys+$40

bra.S	rte

nspc:

tst.b	keys+$50
beq.S	nf1
move	#0,octave
bra.S	rte

nf1:
tst.b	keys+$51
beq.S	nf2
move	#1,octave
bra.S	rte

nf2:
tst.b	keys+$52
beq.S	nf3
move	#2,octave
bra.S	rte

nf3:

rte:
move.b	#%10000,$bfee01

move.b	$bfed01,soppel
move	#8,$9c(a6)

movem.l	(a7)+,d0-d7/a0-a6
rte

oldkeyb:
dc.l	0

keyper:
dc.w	0,0,404,360,0,302,270,240,0,202,180,0,150,134,0,0
dc.w	428,380,340,320,286,254,226,214,190,180,160,144,0,0,0,0
dc.w	0,808,720,0,604,538,480,0,404,360,0,0,0,0,0,0
dc.w	0,856,762,678,640,570,508,452,428,380,340
blk.w	128-$3a,0

soundreplay:
rte

handledmasample:
movem.l	d0-d7/a0-a6,-(a7)
move	$1e(a6),d0

and	#%11110000000,d0
and	$1c(a6),d0

btst	#7,d0
beq.S	nb7
move	#0,d1
bra.S	fb
nb7:
btst	#8,d0
beq.S	nb8
move	#1,d1
bra.S	fb
nb8:
btst	#9,d0
beq.S	nb9
move	#2,d1
bra.S	fb
nb9:
move	#3,d1

fb:
move	d1,d2
mulu	#28,d2
lea	fetchbuf1,a0
add	d2,a0

tst.l	fetchloop2(a0)
beq	noli

move.l	fetchloop1(a0),d3
add.l	fetchfrom(a0),d3
move.l	d3,fetchpos(a0)

move	d0,$9c(a6)
movem.l	(a7)+,d0-d7/a0-a6
rte

noli:
clr	fetching(a0)
move	d0,$9a(a6)
movem.l	(a7)+,d0-d7/a0-a6
rte


fetch:
movem.l	d0/a0/d1,-(a7)

frykt:
subq.l	#1,sstate
bmi.S	exept
move.l	fetchpos,a0
move.b	(a0)+,d0
rol	#8,d0
move.b	(a0)+,d0
move	d0,$aa(a6)
move.l	a0,fetchpos

movem.l	(a7)+,d0/a0/d1
move	#%10000000,$9c(a6)
rte

exept:
move.l	fetchloop2,d0
add.l	fetchfrom,d0
move.l	fetchpos,a0
cmp.l	a0,d0
beq.S	restor

move.b	(a0),d0
rol	#8,d0
move.l	fetchloop1,a0
add.l	fetchfrom,a0
move.b	(a0)+,d0
move	d0,$aa(a6)

move.l	a0,fetchpos
move.l	fetchloop2,d1
sub.l	fetchloop1,d1
subq.l	#1,d1
asr.l	#1,d1
move.l	d1,sstate
move	#-1,$dff180
movem.l	(a7)+,d0/a0/d1
move	#%10000000,$9c(a6)
move	#0,$dff180
rte

restor:
move.l	fetchloop1,d1
add.l	fetchfrom,d1
move.l	d1,fetchpos
move.l	fetchloop2,d1
sub.l	fetchloop1,d1
subq.l	#2,d1
lsr.l	#1,d1
move.l	d1,sstate
bra.L	frykt

olv3:
dc.l	0

exit:
move.b	#%10011110,$bfed01
move	#$7fff,$9a(a6)
move.l	oldkeyb,$68
move.l	olv3,$6c
move.l	oldaudi,$70
move	oldinten,d0
bset	#15,d0
move	d0,$9a(a6)
move	#$7fff,$96(a6)
move	olddmaen,d0
bset	#15,d0
move	d0,$96(a6)
rts

oldaudi:
dc.l	0

copperlist:
dc.w	$9c,%1010000000000000
dc.w	$180,0
dc.w	$182,$ffc
dc.w	$184,$880
dc.w	$186,$444
dc.w	$1a2,$ff0
dc.w	$1a4,$880
dc.w	$1a6,$cc0
dc.w	$1aa,$fff
dc.w	$1ac,$0f0
dc.w	$1ae,$ccc
dc.w	$1b2,$fff
dc.w	$1b4,$0ff
dc.w	$1b6,$aaa
dc.w	$1ba,$f00
dc.w	$108,80
dc.w	$10a,80
dc.w	$100,$a000
dc.w	$102,0
dc.w	$104,$3f
dc.w	$92,$3c
dc.w	$94,$d4
dc.w	$8e,$2c81
dc.w	$90,$2cc1

e0:
dc.w	$e0,0
dc.w	$e2,0
dc.w	$e4,0
dc.w	$e6,0

spr:
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

dc.w	$2821,$fffe
dc.w	$180,$ccc
dc.w	$2921,$fffe
dc.w	$180,$fff
dc.w	$2a21,$fffe
dc.w	$180,$ccc
dc.w	$2b21,$fffe
dc.w	$180,$666


dc.w	$ab21,$fffe
dc.w	$108,[128*128]-48
dc.w	$ac21,$fffe
bc:
dc.w	$180,0
dc.w	$182,$0ff
dc.w	$100,$9000
dc.w	$108,-128-80

dc.w	$eb21,$fffe
dc.w	$180,$060
dc.w	$ec21,$fffe
dc.w	$180,0

dc.w	$ffff,$fffe

null:
dc.l	0

x:
dc.w	320
y:
dc.w	128
oldm:
dc.w	0

pointer:
dc.w	0,0
dc.w	%1000000000000000,0
dc.w	%1100000000000000,0
dc.w	%0110000000000000,%1000000000000000
dc.w	%0111000000000000,0
dc.w	%0011100000000000,%0100000000000000
dc.w	%0011110000000000,0
dc.w	%0001111000000000,%0010000000000000
dc.w	%0001111100000000,0
dc.w	%0000111110000000,%0001000000000000
dc.w	%0000111111000000,0
dc.w	%0000011111100000,%0000100000000000
dc.w	%0000011111110000,0
dc.w	%0000001111111000,%0000010000000000
dc.w	%0000001111111100,0
dc.w	%0000000111111110,%0000001000000000
dc.w	%0000000111111000,%0000000000000000
dc.w	%0000000011111000,%0000000100000000
dc.w	%0000000011001100,%0000000000010000
dc.w	%0000000001000110,%0000000010001010
dc.w	%0000000000000110,%0000000000000001
dc.w	%0000000000000010,%0000000000000001
dc.w	%0000000000000000,%0000000000000000,0,0

type:
movem.l	d0-d7/a0-a6,-(a7)

moveq	#-1,d6
ww2:
addq	#1,d6
addq	#8,d0
tst.b	(a0)+
bne.S	ww2

subq.l	#1,a0
subq	#1,d6
sub	#16,d0

move	d6,-(a7)
move	d0,-(a7)

move	#2920,a3
newlett:
bsr.S	typeletter
dbra	d6,newlett

move	(a7)+,d0
move	(a7)+,d6

newlett2:
clr	d3
move.b	-(a0),d3
bsr.L	letter
dbra	d6,newlett2

rtsres:
movem.l	(a7)+,d0-d7/a0-a6
rts

typeletter:
tst	d6
beq.S	bt
cmp	#2920,a3
beq.S	bt
cmp	#1000,a3
beq.L	mid
move	#1000,a3
add	#8,d0
add	#1,d6
bra.S	mid
bt:
move	#$ff00,d4
move	d0,d5
and	#$7,d5
lsr	d5,d4

move	d0,d5
lsr	#3,d5
lea	screen,a1
move	d1,d7
mulu	#160,d7
add	d7,a1
add	d5,a1

move	#8,d7
move.l	a1,a3
add	d5,a3

sbcl:
btst	#0,d2
beq.S	pl1off
or.b	d4,1(a1)
ror	#8,d4
or.b	d4,(a1)
bra.S	pl1set
pl1off:
not	d4
and.b	d4,1(a1)
ror	#8,d4
and.b	d4,(a1)
not	d4
pl1set:

ror	#8,d4

btst	#1,d2
beq.S	pl2off
or.b	d4,81(a1)
ror	#8,d4
or.b	d4,80(a1)
bra.S	pl2set
pl2off:
not	d4
and.b	d4,81(a1)
ror	#8,d4
and.b	d4,80(a1)
not	d4
pl2set:

ror	#8,d4
add	#160,a1
dbra	d7,sbcl

sub	#8,d0
rts

mid:

move	d0,d5
lsr	#3,d5
lea	screen,a1
move	d1,d7
mulu	#160,d7
add	d7,a1
add	d5,a1

move	#8,d7

sbc:
btst	#0,d2
beq.S	pl1off2
move.b	#-1,(a1)
bra.S	pl1set2
pl1off2:
clr.b	(A1)
pl1set2:

btst	#1,d2
beq.S	pl2off6
move.b	#-1,80(a1)
bra.S	pl2set7
pl2off6:
clr.b	80(a1)
pl2set7:

add	#160,a1
dbra	d7,sbc

sub	#8,d0
rts


letter:
move	d0,d5
lsr	#3,d5
lea	screen,a3
move	d1,d7
mulu	#160,d7
add	d7,a3
add	d5,a3

lea	topaz,a2
clr.l	d5
sub	#32,d3
move	d3,d5
divu	#80,d5
move	d5,d4
mulu	#8*80,d4
add	d4,a2
swap	d5
add	d5,a2
move.l	a2,a5

move	d0,d4
sub	#3,d4
and	#7,d4

move	#7,d5
move.l	a3,a4
cmp	#5,d4
blt.S	pl2
subq.l	#1,a4
pl2:
move.b	(a2),d7
lsl	#8,d7
lsr	d4,d7
not	d7
and.b	d7,161(a4)
ror	#8,d7
and.b	d7,160(a4)
not	d7
or.b	d7,240(a4)
ror	#8,d7
or.b	d7,241(a4)

add	#160,a4
add	#80,a2
dbra	d5,pl2

move.l	a5,a2
move	d0,d4
sub	#1,d4
and	#7,d4
cmp	#7,d4
blt.S	ok
subq.l	#1,a3
ok:
move	#7,d5
pl:
move.b	(a2),d7
lsl	#8,d7
lsr	d4,d7
or.b	d7,1(a3)
ror	#8,d7
or.b	d7,(a3)
not	d7
and.b	d7,80(a3)
ror	#8,d7
and.b	d7,81(a3)
add	#160,a3
add	#80,a2
dbra	d5,pl

sub	#8,d0
rts

dingo:
addq.l	#8,a7
bra.L	exit
rts

hex:
dc.w	0

changehex:
not	hex
beq.S	dec
move.l	#" HEX",dectxt
bra.S	decc
dec:
move.l	#" DEC",dectxt
decc:
move	hexcoo,d0
move	hexcoo+2,d1
add	#8,d0
add	#4,d1
move	#0,d2
lea	dectxt,a0
bsr.L	type
rts

changehifi:
add	#1,hifimode
cmp	#3,hifimode
bne	n3
clr	hifimode
move	#"POLY",hifitxt
clr	hifi
move	#3,poly
bra	hific
n3:
cmp	#1,hifimode
bne	n1
move	#"MONO",hifitxt
clr	hifi
move	#1,poly
bra	hific
n1:
move	#"HIFI",hifitxt
move	#-1,hifi
move	#1,poly

hific:
move	hificoo,d0
move	hificoo+2,d1
add	#8,d0
add	#4,d1
move	#0,d2
lea	hifitxt,a0
bsr.L	type
rts

mainscreen:
dc.w	1,640-[8*15],0,0,0
suckflag:
dc.w	-1
dc.b	" ENABLE UNDO ",0
even
dc.w	0,0,100,0,0
dc.l	dingo
dc.b	"     ON/OFF    ",0
even
dc.w	0
hexcoo:
dc.w	96,0,0,0
dc.l	changehex
dectxt:
dc.b	" DEC ",0
even
dc.w	0
hificoo:
dc.w	96,0,0,0
dc.l	changehex
hifitxt:
dc.b	"POLY",0
even
dc.w	0,352,112,0,0
dc.l	utsnitt
dc.b	"VIEW",0
even
dc.w	-1

utsint:
movem.l	d0-d7/a0-a6,-(a7)

bsr	putppointers

move	oldm,d0
move	d0,d1
lsr	#8,d1
and	#$ff,d0
move	$a(a6),d2
move	d2,oldm
move	d2,d3
lsr	#8,d3
and	#$ff,d2

sub.b	d2,d0
sub.b	d1,d3
ext	d0
ext	d3

move	d3,ym

intercept:
move	#3,update
ext.l	d0
btst	#2,$dff016
beq.S	unn1
move.l	utslen,d1
cmp.l	#640,d1
bge.S	norm
unn1:
move	d0,d1
bra.S	unnorm
norm:

asr.l	#7,d1
muls	d0,d1
divs	#640/128,d1

unnorm:
ext.l	d1
add.l	d1,utspos

move.l	utspos,a0
move.l	utslen,d0
lea	samples,a1
move	instrument,d1
lsl	#2,d1
move.l	(a1,d1.w),d3
cmp.l	d3,a0
bge.S	notunder
move.l	(a1,d1.w),a0
move.l	a0,utspos
notunder:
move.l	a0,d4
add.l	d0,d4
lea	lengths,a1
add.l	(a1,d1.w),d3
cmp.l	d3,d4
blt.S	notover
sub.l	d3,d4
sub.l	d4,a0
move.l	a0,utspos
notover:

move	ym,d0
ext.l	d0

btst	#2,$dff016
beq.S	gunn1
move.l	utslen,d1
cmp.l	#640,d1
bge.S	gnorm
gunn1:
move	d0,d1
bra.S	gunnorm
gnorm:

asr.l	#7,d1
muls	d0,d1
divs	#640/128,d1

gunnorm:
ext.l	d1
move.l	utslen,d2
add.l	d1,utslen

tst.l	utslen
bge.S	ntl
clr.l	utslen
move.l	d2,d1
neg.l	d1
ntl:

btst	#0,d1
beq.S	norest
not	rest
beq.S	norest
addq.l	#1,d1
norest:

asr.l	#1,d1
sub.l	d1,utspos

move.l	utspos,a0
move.l	utslen,d0
lea	samples,a1
move	instrument,d1
lsl	#2,d1
move.l	(a1,d1.w),d3
cmp.l	d3,a0
bge.S	gnotunder
move.l	(a1,d1.w),a0
move.l	a0,utspos
gnotunder:
move.l	a0,d4
add.l	d0,d4
lea	lengths,a1
add.l	(a1,d1.w),d3
cmp.l	d3,d4
blt.S	gnotover
sub.l	d3,d4
sub.l	d4,a0
move.l	a0,utspos
gnotover:
lea	samples,a1
move	instrument,d1
lsl	#2,d1
move.l	(a1,d1.w),d3
cmp.l	d3,a0
bge.S	gnotunder3
move.l	d3,a0
lea	lengths,a1
move.l	(a1,d1.w),d0
move.l	d0,utslen
move.l	a0,utspos
gnotunder3:
bsr.L	putsprites
bsr.L	drawwave

icp2:

cmp	#1,printnow
beq.S	gp1
bgt.S	gp2

move.l	utspos,d0
move	instrument,d1
lsl	#2,d1
lea	samples,a1
sub.l	(a1,d1.w),d0
move	#6,d1
bsr.L	convert
lea	ascii,a0
move	#0,d0
move	#119,d1
move	#3,d2
bsr.L	type
bra.S	gexint

gp1:
move.l	utslen,d0
move	#6,d1
bsr.S	convert
lea	ascii,a0
move	#292,d0
move	#119,d1
move	#3,d2
bsr.L	type
bra.S	gexint

gp2:
move.l	utspos,d0
add.l	utslen,d0
move	instrument,d1
lsl	#2,d1
lea	samples,a1
sub.l	(a1,d1.w),d0
move	#6,d1
bsr.S	convert
lea	ascii,a0
move	#584,d0
move	#119,d1
move	#3,d2
bsr.L	type
move	#-1,printnow

bra.S	gexint

gexint:
add	#1,printnow
move	#$20,$dff09c
movem.l	(a7)+,d0-d7/a0-a6
rte

printnow:
dc.w	0

rest:
dc.w	0

ym:
dc.w	0

update:
dc.w	0

convert:
lea	asciinum,a0
add	d1,a0
clr.b	(a0)
tst	hex
beq.S	decimal

move.l	d0,d3
newc:
move.b	d3,d2
and	#$f,d2
add	#'0',d2
cmp.b	#'9',d2
ble.S	okk2
add.b	#'`'-'9',d2
okk2:
move.b	d2,-(a0)
lsr.l	#4,d3
bne.S	newc
move.b	#'$',-(a0)
bra.S	just

decimal:
move.l	d0,d2
clr	d2
swap	d2
divu	#10,d2
move	d0,d2
nyttsiffer:
divu	#10,d2
swap	d2
add	#'0',d2
move.b	d2,-(a0)
clr	d2
swap	d2
tst	d2
bne.S	nyttsiffer

just:
cmp.l	#asciinum,a0
ble.S	conved
move.b	#' ',-(a0)
bra.S	just
conved:
rts

ascii:
dc.b	" "
asciinum:
dc.b	"0000000000",0

utspos:
dc.l	samplepos

utslen:
dc.l	640

utsnitt:
move.l	#utsint,$6c
bsr.L	release
move.l	#vblank,$6c
bsr.L	noicon
rts


instrument:
dc.w	0

samples:
dc.l	samplepos	;undo buffer
dc.l	0		;cut/paste buffer
blk.l	16,0		;normal instruments

lengths:
dc.l	6570
blk.l	17,0

loops:
dc.l	0,0
blk.l	17*2,0

eqp:
dc.l	0
testp:
dc.l	0
rngp1:
dc.l	1000
rngp2:
dc.l	1100
loopp1:
dc.l	1980
loopp2:
dc.l	0;2191
poip:
dc.l	5000

putsprites:
move.l	a0,d1
move	instrument,d2
lsl	#2,d2
lea	samples,a1
sub.l	(a1,d2.w),d1			;d1 er venstrekanten.
lea	loops,a1
lsl	#1,d2
move.l	loopp1,(a1,d2.w)
move.l	loopp2,4(a1,d2.w)
tst.l	d0
bne.S	fouhb
clr.b	rng1+1
clr.b	rng2+1
clr.b	loop1+1
clr.b	loop2+1
clr.b	spointer+1
rts
fouhb:

move.l	d0,d7
divu	#20,d7
ext.l	d7
neg.l	d7
move.l	d7,a3
neg.l	d7
add.l	d0,d7

move	#$80,d6

move.l	rngp1,d3
lea	rng1,a1
bsr.S	putsprite


move.l	loopp1,d3
lea	loop1,a1

tst.l	loopp2
bne.S	ps22
bsr.L	nosprite
bra.S	nol
ps22:

bsr.S	putsprite

nol:

move.l	poip,d3
lea	spointer,a1
bsr.S	putsprite

move	#$71,d6

move.l	rngp2,d3
lea	rng2,a1
bsr.S	putsprite

lea	loop2,a1
move.l	loopp2,d3
beq.S	nosprite
bsr.S	putsprite

rts

putsprite:
sub.l	d1,d3
cmp.l	d7,d3
bgt.S	nosprite
cmp.l	d3,a3
bgt.S	nosprite

;			Her er d3 ant. bytes fra v. kant.

;			* ant.pix / ant. bytes

clr	d2
tst.l	d3
bpl.S	pll
not	d2
neg.l	d3
pll:

move.l	d3,d4

clr	d4
swap	d4
mulu	#320,d4
swap	d4
clr	d4
and.l	#$ffff,d3
mulu	#320,d3
add.l	d3,d4

sub.l	a5,a5
cmp.l	#$ffff,d0
ble.S	nuu
move.l	d0,a5
lsr.l	#4,d0
nuu:

move.l	d4,d5
clr	d5
swap	d5
divu	d0,d5
move	d5,d3
swap	d3
move	d4,d5
divu	d0,d5
move	d5,d3

cmp.l	#0,a5
beq.S	nuuu
move.l	a5,d0
lsr.l	#4,d3
nuuu:

tst	d2
beq.S	pl22
not	d3
pl22:

;			Her skal d3 være ant. pix. fra v. kant.

add	d6,d3
move	d3,d5
and	#1,d5
or	#2,d5
move.b	d5,3(a1)
lsr	#1,d3
move.b	d3,1(a1)
rts
nosprite:
clr.b	1(a1)
rts

putppos:
move.l	a0,d1
move	instrument,d2
lea	samples,a1
lsl	#2,d2
sub.l	(a1,d2.w),d1			;d1 er venstrekanten.
sub.l	(a1,d2.w),d3
tst.l	d0
bne.S	fouh
clr.b	1(a5)
rts
fouh:

move.l	d0,d7
divu	#20,d7
ext.l	d7
neg.l	d7
move.l	d7,a3
neg.l	d7
add.l	d0,d7

sub.l	d1,d3
cmp.l	d7,d3
bgt.S	nospriteq
cmp.l	d3,a3
bgt.S	nospriteq

;			Her er d3 ant. bytes fra v. kant.

;			* ant.pix / ant. bytes

clr	d2
tst.l	d3
bpl.S	pllq
not	d2
neg.l	d3
pllq:

move.l	d3,d4

clr	d4
swap	d4
mulu	#320,d4
swap	d4
clr	d4
and.l	#$ffff,d3
mulu	#320,d3
add.l	d3,d4

sub.l	a4,a4
cmp.l	#$ffff,d0
ble.S	nuuq
move.l	d0,a4
lsr.l	#4,d0
nuuq:

move.l	d4,d5
clr	d5
swap	d5
divu	d0,d5
move	d5,d3
swap	d3
move	d4,d5
divu	d0,d5
move	d5,d3

cmp.l	#0,a4
beq.S	nuuuq
move.l	a4,d0
lsr.l	#4,d3
nuuuq:

tst	d2
beq.S	pl22q
not	d3
pl22q:

;			Her skal d3 være ant. pix. fra v. kant.

add	#$80,d3
move	d3,d5
and	#1,d5
or	#2,d5
move.b	d5,3(a5)
lsr	#1,d3
move.b	d3,1(a5)
rts
nospriteq:
clr.b	1(a5)
rts


drawwave:		;ADR.L -> a0   LEN.L -> d0
move	#$bf1,bset
tst.l	d0
bne.S	vvfft
move	#$bb1,bset
vvfft:
clr.l	d1
swap	d0
move	d0,d1
divu	#640,d1
swap	d0
move	d1,d2
swap	d2
move	d0,d1
divu	#640,d1
move	d1,d2		;d2 er faktor.
divu	#640,d1
clr.l	d3
lsr	#1,d1
move	d1,d3		;d3 er desimaler (15 bit)
clr.l	d4		;d4 teller desimaler.l
moveq	#7,d5		;d5 er bit-counter

move	#$5288,addq
cmp	#$4000,d3
blt.S	nopr
move	#$5388,addq
addq	#1,d2
not	d3
bclr	#15,d3
nopr:

lea	screen+[160*[256-128]]+[128*64],a1
lea	scrbuf,a2

move	#79,d7
drs:
move	(a2),d6

move.b	(a0),d0
ext	d0
bclr	#0,d0
lsl	#6,d0
move	d0,(a2)+
bclr	d5,(a1,d6.w)
bset:
bset	d5,(a1,d0.w)

add	d2,a0
add	d3,d4
bpl.S	noof
addq:
addq.l	#1,a0
bclr	#15,d4
noof:

dbra	d5,drs
moveq	#7,d5
addq.l	#1,a1
dbra	d7,drs
rts

spointer:
dc.l	$ac602c02
blk.l	128,$80000000
dc.l	0

ppointer1:
dc.l	$ac002c02
blk.l	128,$80000000
dc.l	0

ppointer2:
dc.l	$ac002c02
blk.l	128,$80000000
dc.l	0

rng1:
dc.l	$ac702c02
dc.w	$0000,$ffff ,$0000,$8000 ,$3ab8,$8820 ,$2ba0,$8180
dc.w	$3ba0,$8800 ,$2ba8,$8300 ,$2ab8,$8020 
blk.l	120,$8000
dc.l	$ffff
dc.l	0

rng2:
dc.l	$ac802c02
dc.l	$ffff
blk.l	120,1
dc.w	$1d5c,$0411
dc.w	$15d0,$00c1 ,$1dd0,$0401 ,$15d4,$0181 ,$155c,$0011
dc.w	$0000,$0001 ,$0000,$ffff
dc.l	0

loop1:
dc.l	$ac902c02
dc.w	$0000,$ffff ,$0000,$8000 ,$23ee,$82a2 ,$23ea,$8140
dc.w	$22ae,$8002 ,$23e8,$8140 ,$3be8,$82a0
blk.l	120,$8000
dc.l	$ffff
dc.l	0

loop2:
dc.l	$aca02c02
dc.l	$ffff
blk.l	120,1
dc.w	$47dc,$0545
dc.w	$47d4,$0281 ,$455c,$0005 ,$47d0,$0281 ,$77d0,$0541
dc.w	$0000,$0001 ,$0000,$ffff
dc.l	0

soppel:
dc.l	0

canplay:
dc.w	-1

fetchlen=0
fetchfrom=4
fetchloop1=8
fetchloop2=12
fetchpos=16
fetchper=20
fetching=22
fetchspeed=24

fetchbuf1:
blk.b	28,0
fetchbuf2:
blk.b	28,0
fetchbuf3:
blk.b	28,0
fetchbuf4:
blk.b	28,0

sstate:
dc.l	0

hifi:
dc.w	0

channel:
dc.w	0

octave:
dc.w	0

phase:
dc.w	0

hifimode:
dc.w	0

poly:
dc.w	3

b:
