;SS!
top=$7f000
font=top-[40*45]
sinedata=font-3072
mt_data=sinedata;-153258
scrad=mt_data-[48*128*7]
>extern "sinedata",sinedata
>extern "font",font
;>extern "mod.twr-spaceknights",mt_data

org	scrad-12866
load	scrad-12866
a:
lea	cube2,a0
fc2l:
move	(a0),d0
cmp	#2920,d0
beq	ff
cmp	#1111,d0
bne	fc2lo
addq.l	#2,a0
bra	fc2l
fc2lo:
asr	#1,d0
move	d0,(a0)+
bra	fc2l
ff:

bsr	extsinetable
bsr	initmusikk

move.l	$6c,-(a7)
move	$dff01c,-(a7)
bsr	initcopper

vvt:
btst	#6,$bfe001
bne	vvt
bra	emain:
movem.l	d0-d7/a0-a6,-(a7)

move	#$10,$dff09c
move	#0,call+2

bsr	change

tst	rentegn
bne	vektordritt
bsr	clearphase
bsr	fixrotations

vektordritt:
add	#1,counter
add	#1,ccounter
move.l	prog,a0
jsr	(a0)

bsr	drawobj
bsr	mt_music
bsr	scrolltext

movem.l	(a7)+,d0-d7/a0-a6
move	#$8010,call+2
rte

change:
tst.l	changeto
beq	rts
tst	changing
beq	harder
move.l	changeto,prog
clr	counter
move	#1150,zo
clr	xys
clr	rentegn
clr	xzs
clr	yzs
move	#514,xy
move	#514,xz
move	#1026,yz
clr.l	changeto
clr	changeno
clr	changing
rts
harder:
add	#1,changeno
move	changeno,changing
rts

scrolltext:
btst	#14,$dff002
bne	scrolltext
heelp:
cmp.b	#$2c,$dff006
bhi	heelp

sub	#1,countpos
bpl	nfir
move	#7,countpos
move.l	tpos,a1
clr	d0
move.b	(a1),d0
cmp	#32,d0
bge	norm
lsl	#2,d0
lea	progs,a0
add	d0,a0
move.l	(a0),changeto
move	#32,d0
norm:
sub	#32,d0
ext.l	d0
divu	#20,d0
move	d0,d1
ext.l	d1
mulu	#15*40,d1
swap	d0
lsl	#1,d0
add	d1,d0
lea	font,a0
add	d0,a0
move.l	a0,$dff050
move.l	#scroller+34,$dff054
move	#%100111110000,$dff040
clr	$dff042
move	#34,$dff066
move	#38,$dff064
move	#1+[15*64],$dff058
addq.l	#1,tpos
cmp.l	#end-1,a1
bne	nfir
move.l	#text,tpos
nfir:
move.l	#scroller,$dff054
move.l	#scroller+2,$dff050
move	#0,$dff064
move	#0,$dff066
move	#%1110100111110000,$dff040
clr	$dff042
move	#18+[64*15],$dff058
byy:
btst	#14,$dff002
bne	byy
rts

countpos:
dc.w	0

scroller:
blk.b	[36*15],0

tpos:
dc.l	text

text:
dc.b	6,'                   HELLO.                '
DC.B	" HOW DO YOU LIKE MY VECTORS?    I DON'T LIKE",3
DC.B	"THEM TOO MUCH EITHER...   THEY SHOULD HAVE BEEN FILLED,"
dc.b	" RIGHT?",2
DC.B	"      NORMAL VECORS",1," JUST AREN'T ",'"IN" THESE DAYS!'
dc.b	"    BUT WHO",5
DC.B	' CARES?   DEMOS ARE SHIT ANYWAY...      WHO AM I? '
DC.B	"     THE CLASSICAL QUESTION HAS A GOOD ANSWER THIS TIME:"
dc.b	"      ",4," I AM SWEINSTEIN.      "
dc.b	"               ",7,"THE MUSIC IS MADE BY TIMEWALKER.    "
end:
even

prog:
dc.l	none

progs:
dc.l	none,rule1,rule2,program1,program2,program3,program4
dc.l	noteprog

counter:
dc.w	0


none:
move.l	#nothing,coords
move	#514,xy
move	#514,xz
move	#514,yz
move	#500,zo
move	#0,xys
move	#0,xzs
move	#0,yzs
rts

rule1:
cmp	#1,counter
ble	initr1
cmp	#21,counter
ble	closeupr1
rts

closeupr1:
sub	#50,zo
add	#1,xys
rts

initr1:
move.l	#one,coords
move	#00,yzs
move	#20,xzs
move	#00,xys
move	#514,xy
move	#514,xz
move	#514,yz
move	#1200,zo
rts

rule2:
cmp	#1,counter
ble	initr2
cmp	#21,counter
ble	closeupr2
rts

closeupr2:
sub	#50,zo
add	#1,xys
rts

initr2:
move.l	#two,coords
move	#00,yzs
move	#20,xzs
move	#00,xys
move	#514,xy
move	#514,xz
move	#514,yz
move	#1200,zo
rts

rule3:
rts

program4:
cmp	#1,counter
ble	initp4
cmp	#101,counter
ble	zoom
zov:
cmp	#41,ccounter
ble	noflop
move	#1,ccounter
noflop:

cmp	#33,ccounter
bne	tourn
move	#64,yzs2
tourn:

cmp	#8,ccounter
bne	nouturn
move	#0,yzs2
nouturn:


move	xy,xy4
move	xz,xz4
move	yz,yz4
move	xys,xys4
move	xzs,xzs4
move	yzs,yzs4

move	xy1,xy
move	xz1,xz
move	yz1,yz
move	xys1,xys
move	xzs1,xzs
move	yzs1,yzs

move.l	#c,coords
bsr	fixrotations
bsr	drawobj

move	xy,xy1
move	xz,xz1
move	yz,yz1


move	xy2,xy
move	xz2,xz
move	yz2,yz
move	xys2,xys
move	xzs2,xzs
move	yzs2,yzs

move.l	#u,coords

move	up,byo
move	us,d0
add	d0,up
move	uss,d0
add	d0,us
cmp	#96,up
blt	dontturnit
move	us,d0
neg	us
move	uss,d0
add	d0,us
dontturnit:

bsr	fixrotations
bsr	drawobj

move	#0,byo

move	xy,xy2
move	xz,xz2
move	yz,yz2
move	xys,xys2
move	xzs,xzs2
move	yzs,yzs2


move	xy3,xy
move	xz3,xz
move	yz3,yz
move	xys3,xys
move	xzs3,xzs
move	yzs3,yzs

move.l	#l,coords
bsr	fixrotations
bsr	drawobj

move	xy,xy3
move	xz,xz3
move	yz,yz3
move	xys,xys3
move	xzs,xzs3
move	yzs,yzs3


move	xy4,xy
move	xz4,xz
move	yz4,yz
move	xys4,xys
move	xzs4,xzs
move	yzs4,yzs

move.l	#t,coords

rts

zoom:
sub	#20,zo
bra	zov

byo:
dc.w	0

initp4:
move	#1,ccounter
move	#2140,zo

move	#514,xy1
move	#514,xz1
move	#514,yz1
move	#0,xys1
move	#0,xzs1
move	#20,yzs1

move	#514,xy2
move	#514,xz2
move	#642,yz2
move	#0,xys2
move	#16,xzs2
move	#0,yzs2

move	#514,xy3
move	#514,xz3
move	#514,yz3
move	#0,xys3
move	#16,xzs3
move	#70,yzs3

move	#514,xy
move	#514,xz
move	#514,yz
move	#0,xys
move	#42,xzs
move	#24,yzs

rts

us:
dc.w	0
uss:
dc.w	1
up:
dc.w	-96

program3:
cmp	#1,counter
ble	initseks
btst	#0,counter+1
bne	rein
move	#-1,rentegn
move.l	#sekskant,coords
rts
rein:
clr	rentegn
move.l	#sekskant2,coords
rts

initseks:
move.l	#sekskant,coords
move	#2,xys
move	#20,xzs
move	#150,zo
move	#514,xy
move	#514,xz
move	#514,yz
rts

program2:
pea	cubes
cmp	#1,counter
ble	fixcube2
rts

cubes:
move.l	#cube1,coords
move	xy,-(a7)
move	xz,-(a7)
move	yz,-(a7)
add	#10,xy2
sub	#0,xz2
add	#2,yz2
and	#2047,xy2
and	#2047,xz2
and	#2047,yz2
move	xy2,xy
move	xz2,xz
move	yz2,yz
bsr	drawobj
move	(a7)+,yz
move	(a7)+,xz
move	(a7)+,xy

move.l	#cube2,coords
rts

xy1:
dc.w	514
xz1:
dc.w	514
yz1:
dc.w	1026

xy2:
dc.w	514
xz2:
dc.w	514
yz2:
dc.w	1026

xy3:
dc.w	514
xz3:
dc.w	514
yz3:
dc.w	1026

xy4:
dc.w	514
xz4:
dc.w	514
yz4:
dc.w	1026

xys1:
dc.w	0
xzs1:
dc.w	0
yzs1:
dc.w	0

xys2:
dc.w	0
xzs2:
dc.w	0
yzs2:
dc.w	0

xys3:
dc.w	0
xzs3:
dc.w	0
yzs3:
dc.w	0

xys4:
dc.w	0
xzs4:
dc.w	0
yzs4:
dc.w	0

fixcube2:
move	#200,zo
move	#30,xys
move	#0,xzs
move	#2,yzs
move	#514,xy2
move	#514,xz2
move	#1026,yz2
rts

noteprog:
cmp	#1,counter
beq	initnote
rts
initnote:
move.l	#note,coords
move	#1538,xy
move	#514,xz
move	#514,yz
move	#30,xzs
move	#-40,xys
move	#6,yzs
move	#200,zo
rts

program1:
cmp	#1,counter
ble	initdisk
cmp	#51,counter
ble	closeup
cmp	#52,counter
ble	flipup
cmp	#69,counter
ble	lokkopp
cmp	#115,counter
ble	snurrfort
cmp	#141,counter
ble	rts
cmp	#142,counter
ble	mekksnurr
rts

initdisk:
move	#1150,zo
lea	lokk2,a0
lea	lokk,a1

vev:
move	(a0)+,d0
cmp	#2920,d0
beq	rts
move	d0,(a1)+
bra	vev

mekksnurr:
add	#2,yzs
rts

closeup:
move.l	#disk,coords
sub	#20,zo
sub	#10,yz
rts

flipup:
sub	#12,yz
rts

lokkopp:
cmp	#69,counter
bne	nff
move	#-20,xys
nff:
lea	lokk,a0
move	#5,d0
lol:
add	#2,(a0)
addq.l	#6,a0
dbra	d0,lol

move	#2,d0
addq.l	#2,a0
lol2:
add	#2,(a0)
addq.l	#8,a0
dbra	d0,lol2
rts

snurrfort:
add	#1,xys
rts

extsinetable:
lea	sinedata,a5
lea	sinedata+2048,a6

move	#255,d0
vuvu:
move	(a5)+,(a6)+
dbra	d0,vuvu
rts

fixrotations:
move	xzs,d0
add	d0,xz
move	yzs,d0
add	d0,yz
move	xys,d0
add	d0,xy
and	#2046,xz
and	#2046,yz
and	#2046,xy
rts

xys:	dc.w	0
xzs:	dc.w	0
yzs:	dc.w	0

initcopper:
move	#$8020,$dff096

lea	from44,a0
move	#$2c51,d0
move	#75,d1
move.l	#$1800000,d2
move.l	d2,d3
if44:
move	d0,(a0)+
move	#$fffe,(a0)+

move	d0,d2
lsr	#8,d2
sub	#44,d2
lsr	#4,d2

move.l	d2,(a0)+
add	#128,d0
move	d0,(A0)+
move	#$fffe,(a0)+
not	d2
and	#$f,d2
move.l	d2,(a0)+
add	#128,d0
dbra	d1,if44

lea	from78,a0
move	#$7851,d0
move	#14,d1
if78:
move	d0,(a0)+
move	#$fffe,(a0)+

move	d0,d2
lsr	#8,d2
sub	#44,d2
lsr	#4,d2

move.l	d2,(a0)+
add	#128,d0
move	d0,(A0)+
move	#$fffe,(a0)+
not	d2
and	#$f,d2
move.l	d2,(a0)+
add	#128,d0
dbra	d1,if78

lea	from87,a0
move	#$8751,d0
move	#120,d1
if87:
move	d0,(a0)+
move	#$fffe,(a0)+
move	d0,d2
lsr	#8,d2
sub	#44,d2
lsr	#4,d2

move.l	d2,(a0)+
add	#128,d0
move	d0,(A0)+
move	#$fffe,(a0)+
not	d2
and	#$f,d2
move.l	d2,(a0)+
add	#128,d0
dbra	d1,if87

lea	from100,a0
move	#$0051,d0
move	#43,d1
if100:
move	d0,(a0)+
move	#$fffe,(a0)+

move	d0,d2
lsr	#8,d2
add	#212,d2
lsr	#4,d2

move.l	d2,(a0)+
add	#128,d0
move	d0,(A0)+
move	#$fffe,(a0)+
not	d2
and	#$f,d2
move.l	d2,(a0)+
add	#128,d0
dbra	d1,if100

initcopper2:
move	#$7fff,$dff09a
tst.b	$dff006
bne	initcopper2
btst	#0,$dff005
bne	initcopper2
move	#$7fff,$dff09c
move	#$7fff,$dff096
move.l	#main,$6c
move	#$c010,$dff09a
move	#%1000011111010000,$dff096
move.l	#copperlist,$dff084
clr	$dff08a

move.l	#scrad,d0
move	d0,e0+6
swap	d0
move	d0,e0+2
move.l	#scroller+2,d0
move	d0,e0+14
swap	d0
move	d0,e0+10
move.l	#scroller,d0
move	d0,e0+22
swap	d0
move	d0,e0+18
rts

clearphase:
btst	#14,$dff002
bne.S	clearphase

tst	mode
bne	odd

move.l	#scrad+[128*48],d0
move.l	d0,screen
add.l	#18432,d0
move	d0,e0+6
swap	d0
move	d0,e0+2
swap	d0
bra	nbb

odd:
move.l	#scrad+18432+[128*48],d0
move.l	d0,screen
sub.l	#18432,d0
move	d0,e0+6
swap	d0
move	d0,e0+2
swap	d0

nbb:
not	mode


move.l	screen,$dff048+12
move	#16,$dff066
move	#%100000000,$dff040
clr	$dff042
move	#16+[256*64],$dff058

fling:
btst	#14,$dff002
bne	fling

rts


drawobj:
move.l	coords,a6
obl:
clr	evenukk

;	Bla opp data for 1. pkt.

move	(a6)+,a0
	cmp	#2920,a0
	beq	frover
	cmp	#1111,a0
	bne	newline
	move	d2,-(a7)
	move	d3,-(a7)
	subq.l	#2,a7
	move	#-1,evenukk
	subq.l	#4,a6

newline:

move	(a6)+,a1
move	(a6)+,a2

add	byo,a1

;	Finn sinuser og cosinuser

lea	sinedata,a5
lea	sinedata+512,a4

move	xy,d0
move	(a5,d0.w),d2
move	(a4,d0.w),d3

move	xz,d0
move	(a5,d0.w),d4
move	(a4,d0.w),d5

move	yz,d0
move	(a5,d0.w),d6
move	(a4,d0.w),d7

asr	#8,d2
asr	#8,d3
asr	#8,d4
asr	#8,d5
asr	#8,d6
asr	#8,d7


tst	evenukk
bne	secondpoint

;		DO X FOR X/Y

move	a0,d0
muls	d2,d0

move	a1,d1
muls	d3,d1
add	d1,d0

move	d0,a3


;		DO Y FOR X/Y

move	a1,d0
muls	d2,d0

move	a0,d1
muls	d3,d1
sub	d1,d0

move	d0,a4


;		DO X FOR X/Z

move	a3,d0
muls	d4,d0

asr.l	#7,d0

move	a2,d1
muls	d5,d1

add	d1,d0
move	d0,a0


;		DO Z FOR X/Z

move	a2,d0
muls	d4,d0

move	a3,d1
muls	d5,d1
asr.l	#7,d1

sub	d1,d0
move	d0,a5

move	a0,a3


;		DO Y FOR Y/Z

move	a4,d0
muls	d6,d0
asr.l	#7,d0

move	a5,d1
muls	d7,d1
asr.l	#7,d1

sub	d1,d0
move	d0,a1


;		DO Z FOR Y/Z

move	a5,d0
muls	d6,d0
asr.l	#7,d0

move	a4,d1
muls	d7,d1
asr.l	#7,d1

add	d1,d0
move	d0,a5

move	a1,a4



move	a3,-(a7)
move	a4,-(a7)
move	a5,-(a7)

*****
secondpoint:

move	(a6)+,a0
move	(a6)+,a1
move	(a6)+,a2

add	byo,a1

;		DO X FOR X/Y

move	a0,d0
ext.l	d0
muls	d2,d0

move	a1,d1
ext.l	d1
muls	d3,d1
add	d1,d0

move	d0,a3


;		DO Y FOR X/Y

move	a1,d0
muls	d2,d0

move	a0,d1
muls	d3,d1
sub	d1,d0

move	d0,a4


;		DO X FOR X/Z

move	a3,d0
muls	d4,d0

asr.l	#7,d0

move	a2,d1
muls	d5,d1

add	d1,d0
move	d0,a0


;		DO Z FOR X/Z

move	a2,d0
muls	d4,d0

move	a3,d1
muls	d5,d1
asr.l	#7,d1

sub	d1,d0
move	d0,a5

move	a0,a3


;		DO Y FOR Y/Z

move	a4,d0
muls	d6,d0
asr.l	#7,d0

move	a5,d1
muls	d7,d1
asr.l	#7,d1

sub	d1,d0
move	d0,a1


;		DO Z FOR Y/Z

move	a5,d0
muls	d6,d0
asr.l	#7,d0

move	a4,d1
muls	d7,d1
asr.l	#7,d1

add	d1,d0
move	d0,a5

move	a1,a4



move	a3,-(a7)
move	a4,-(a7)
move	a5,-(a7)







move	(a7)+,d5
move	(a7)+,d3
move	(a7)+,d2
move	(a7)+,d4
move	(a7)+,d1
move	(a7)+,d0

asr	#8,d4
asr	#8,d5

add	zo,d4
add	zo,d5
ext.l	d0
ext.l	d1
ext.l	d2
ext.l	d3

tst	evenukk
bne	pass

divs	d4,d0
divs	d4,d1
add	xo,d0
add	yo,d1
pass:

divs	d5,d2
divs	d5,d3

add	xo,d2
add	yo,d3

tst	changing
beq	drawall
sub	#1,changing
bra	dda
drawall:

move.l	screen,a4
bsr	drawline
dda:

bra	obl

changing:
dc.w	0
changeno:
dc.w	0
changeto:
dc.l	0

frover:
rts

xo:
dc.w	256
yo:
dc.w	256
zo:
dc.w	1150
xy:
dc.w	514
xz:
dc.w	514
yz:
dc.w	1026



Drawline:
;x1 -> d0  y1 -> d1  x2 -> d2  y2 -> d3
;Screen -> a4

LD_Width=48
LD_Height=256
LD_Minterm=%11101010


;	--------------------------------------
;	   -|	---------------------	|-
;	   -|	--     (c) 1989    --	|-
;	   -|	--  SwEinstein of  --	|-
;	   -|	--       CULT      --	|-
;	   -|	---------------------	|-
;	--------------------------------------


movem	d0-d7,-(a7)
move.l	a4,-(a7)
sub.l	#16+[128*48],a4

move	d2,d6
sub	d0,d6			;DELTA x IN D6
bne	nopoint

move	d1,d7
sub	d3,d7			;DELTA y IN D7
bne	nopoint

				;JUST A POINT!
move	d1,d5
mulu	#LD_width,d5
move	d0,d1
lsr	#3,d1
add	d1,d5
add	d5,a4
not	d0
bset	d0,(a4)
bra	rtsm

nopoint:
move	d1,d7
sub	d3,d7			;DELTA y IN D7

move	#$0041,d5

cmp	d6,d7
ble.S	LD_nset0
bset	#2,d5
bset	#3,d5
LD_nset0:

eor	d6,d7
btst	#15,d7
bne.S	LD_nch
bchg	#3,d5
LD_nch:

eor	d6,d7
bpl.S	LD_d7p
neg	d7
LD_d7p:
move	d6,d4
bpl.s	LD_d6p
neg	d6
not	d4
LD_d6p:
cmp	d4,d7
bhi.S	LD_nb2
bset	#4,d5
LD_nb2:

cmp	d6,d7
blt.S	LD_d7g
move	d7,d4
move	d6,d7
move	d4,d6
LD_d7g:

move	d7,d4
lsl	#1,d4
cmp	d4,d6
bgt.S	LD_sign
bclr	#6,d5
LD_sign:

ld_wb:
btst	#14,$dff002
bne.S	ld_wb

move	d5,$dff042

move	#ld_width,$dff060
move	#ld_width,$dff06c

move.l	#-1,$dff044	;MASK

move	d7,d5
sub	d6,d5
lsl	#2,d5
move	d5,$dff064		;4 ( y - x )

move	d7,d5
lsl	#2,d5
move	d5,$dff062		;4 ( y )

move	d0,d4
lsl	#8,d4
lsl	#4,d4
or	#%101100000000+ld_minterm,d4
move	d4,$dff040		;SELECT START BIT

move	#$8000,$dff074		;NORMAL LINE
move	#$ffff,$dff072		;NO TEXTURE

move	d7,d5
lsl	#1,d5
sub	d6,d5
ext.l	d5
move.l	d5,$dff050		;( 2y - x )

move	d1,d5
mulu	#LD_width,d5
lsr	#3,d0
add	d0,d5
add	d5,a4
move.l	a4,$dff048
move.l	a4,$dff048+12

lsl	#6,d6
or.b	#2,d6
move	d6,$dff058		;START!!

LD_vbu:
btst	#14,$dff002
bne.S	LD_vbu

rtsm:

move.l	(a7)+,a4
movem	(a7)+,d0-d7

rts:
rts


exit:
bsr	mt_end
move	(a7)+,d0
move.l	(a7)+,$6c
bset	#15,d0
move	d0,$dff09a
rts

copperlist:
dc.w	$180,$00f
dc.w	$182,$ff0
dc.w	$184,$00f
dc.w	$186,$ff0
call:
dc.w	$9c,$8010
dc.w	$100,$1000
dc.w	$120,$6
dc.w	$122,0
dc.w	$102,$33
dc.w	$8e,$2c2c
dc.w	$90,$2cff
dc.w	$92,$48
dc.w	$94,$c0
dc.w	$108,16
dc.w	$10a,4
dc.w	$2c01,$fffe
e0:
dc.w	$e0,0
dc.w	$e2,0
dc.w	$e4,0,$e6,0
dc.w	$e8,0,$ea,0

from44:
blk.l	76*4,0

dc.w	$7801,$fffe
dc.w	$100,$2000
from78:
blk.l	15*4,0
dc.w	$8701,$fffe
dc.w	$100,$1000
from87:
blk.l	121*4,0
dc.w	$ffe1,$fffe
from100:
blk.l	44*4,0
dc.w	$2c01,$fffe
dc.w	$180,$000
dc.w	$ffff,$fffe

gname:
dc.b	'graphics.library',0
even

coords:
dc.l	nothing

nothing:
dc.w	0,0,0,0,0,0
dc.w	2920

note:
dc.w	-23,8,100,-23,-8,100,1111,-17,-17,100,1111
dc.w	-8,-23,100,1111,8,-23,100,1111,17,-17,100
dc.w	1111,23,-8,100,1111,23,8,100,1111,17,17,100
dc.w	1111,8,23,100,1111,-8,23,100,1111,-17,17,100
dc.w	1111,-23,8,100
dc.w	1111,-23,112,100,1111,-48,96,100
dc.w	1111,-64,80,100,1111,-23,96,100
dc.w	2920

one:
dc.w	-96,127,15,95,127,15
dc.w	1111,31,112,15,1111,31,-128,15,1111,-64,-96,15
dc.w	1111,-32,-96,15
dc.w	1111,-32,112,15,1111,-96,127,15,1111,-95,127,-16

dc.w	-96,127,-16,95,127,-16
dc.w	1111,31,112,-16,1111,31,-128,-16,1111,-64,-96,-16
dc.w	1111,-32,-96,-16
dc.w	1111,-32,112,-16,1111,-96,127,-16

dc.w	95,127,15,95,127,-16
dc.w	31,112,15,31,112,-16
dc.w	31,-128,15,31,-128,-16
dc.w	-64,-96,15,-64,-96,-16
dc.w	-32,112,15,-32,112,-16
dc.w	-96,127,15,-96,127,-16
dc.w	-32,-96,15,-32,-96,-16

dc.w	2920

two:
dc.w	127,47,15,95,127,15
dc.w	1111,-128,127,15,1111,31,-31,15,1111,39,-72,15
dc.w	1111,0,-88,15,1111,-64,-88,15,1111,-96,-80,15
dc.w	1111,-48,-112,15,1111,31,-128,15,1111,63,-112,15
dc.w	1111,111,-80,15,1111,95,-48,15,1111,-48,79,15
dc.w	1111,79,79,15,1111,127,47,15

dc.w	127,47,-15,95,127,-15
dc.w	1111,-128,127,-15,1111,31,-31,-15,1111,39,-72,-15
dc.w	1111,0,-88,-15,1111,-64,-88,-15,1111,-96,-80,-15
dc.w	1111,-48,-112,-15,1111,31,-128,-15,1111,63,-112,-15
dc.w	1111,111,-80,-15,1111,95,-48,-15,1111,-48,79,-15
dc.w	1111,79,79,-15,1111,127,47,-15,1111,127,45,15

dc.w	-128,127,-15,-128,127,15
dc.w	-96,-80,-15,-96,-80,15

dc.w	2920

HOVERCAR:
dc.w	-12,0,4,-8,0,4,1111,-4,4,4,1111,0,4,4,1111,4,4,4
dc.w	1111,10,0,4,1111,16,0,4,1111,16,4,4,1111,-12,-4,4
dc.w	1111,-12,0,4
dc.w	2920

DISK:
dc.w	127,-128,-3,127,127,-3
dc.w	1111,-111,127,-3
dc.w	1111,-128,110,-3
dc.w	1111,-128,-128,-3
dc.w	1111,127,-128,-3
dc.w	1111,127,-128,4

dc.w	-128,-128,4,127,-128,4
dc.w	1111,127,127,4
dc.w	1111,-111,127,4
dc.w	1111,-128,110,4
dc.w	1111,-128,-128,4
dc.w	1111,-128,-128,-3

dc.w	-111,127,4,-111,127,-3
dc.w	-128,110,4,-128,110,-3
dc.w	127,127,4,127,127,-3

dc.w	-100,-128,4,-100,20,4
dc.w	1111,99,20,4
dc.w	1111,99,-128,4

dc.w	99,127,4,99,48,4
dc.w	1111,-71,48,4
dc.w	1111,-71,128,4


lokk:
dc.w	-71,48,-3,-71,128,-3
dc.w	65,48,-3,65,127,-3

dc.w	-51,52,-3,-17,52,-3
dc.w	1111,-17,123,-3
dc.w	1111,-51,123,-3
dc.w	1111,-51,52,-3


dc.w	2920

lokk2:
dc.w	-71,48,4,-71,128,4
dc.w	65,48,4,65,127,4

dc.w	-51,52,4,-17,52,4
dc.w	1111,-17,123,4
dc.w	1111,-51,123,4
dc.w	1111,-51,52,4


dc.w	2920

CUBE1:

dc.w	-128,-128,127 , 128,-128,127
dc.w	1111 , 127,127,127
dc.w	1111 , -128,127,127
dc.w	1111 , -128,-128,127

dc.w	-128,-128,-128 , 127,-128,-128
dc.w	1111 , 127,127,-128
dc.w	1111 , -128,127,-128
dc.w	1111 , -128,-128,-128

dc.w	-128,-128,-128 , -128,-128,127
dc.w	-128,127,-128 , -128,127,127
dc.w	127,-128,-128 , 127,-128,127
dc.w	127,127,-128  , 127,127,127

dc.w	0,0,-128 , 0,0,-64
dc.w	0,0,63 , 0,0,127
dc.w	2920

CUBE2:

dc.w	-128,-128,127 , 128,-128,127
dc.w	1111 , 127,127,127
dc.w	1111 , -128,127,127
dc.w	1111 , -128,-128,127

dc.w	-128,-128,-128 , 127,-128,-128
dc.w	1111 , 127,127,-128
dc.w	1111 , -128,127,-128
dc.w	1111 , -128,-128,-128

dc.w	-128,-128,-128 , -128,-128,127
dc.w	-128,127,-128 , -128,127,127
dc.w	127,-128,-128 , 127,-128,127
dc.w	127,127,-128  , 127,127,127

dc.w	2920


SEKSKANT:

dc.w	-128,-53,-53,-128,53,-53
dc.w	1111,-53,128,-53,1111,53,128,-53
dc.w	1111,128,53,-53,1111,128,-53,-53
dc.w	1111,53,-128,-53,1111,-53,-128,-53
dc.w	1111,-128,-53,-53,1111,-128,-53,53

dc.w	1111,-128,53,53
dc.w	1111,-53,128,53,1111,53,128,53
dc.w	1111,128,53,53,1111,128,-53,53
dc.w	1111,53,-128,53,1111,-53,-128,53
dc.w	1111,-128,-53,53

dc.w	-128,-53,53,-53,-53,128
dc.w	1111,53,-53,128
dc.w	1111,128,-53,53,1111,128,-53,-53
dc.w	1111,53,-53,-128,1111,-53,-53,-128
dc.w	1111,-128,-53,-53

dc.w	-128,53,53,-53,53,128
dc.w	1111,53,53,128
dc.w	1111,128,53,53,1111,128,53,-53
dc.w	1111,53,53,-128,1111,-53,53,-128
dc.w	1111,-128,53,-53,1111,-128,53,53

dc.w	2920

sekskant2:
dc.w	53,-128,53,53,-53,128
dc.w	1111,53,53,128,1111,53,128,53,1111,53,128,-53
dc.w	1111,53,53,-128,1111,53,-53,-128,1111,53,-128,-53
dc.w	1111,53,-128,53

dc.w	-53,-128,53,-53,-53,128
dc.w	1111,-53,53,128,1111,-53,128,53,1111,-53,128,-53
dc.w	1111,-53,53,-128,1111,-53,-53,-128,1111,-53,-128,-53
dc.w	1111,-53,-128,53

dc.w	64,0,0,0,0,64
dc.w	1111,-64,0,0,1111,0,0,-64
dc.w	1111,64,0,0
dc.w	1111,0,64,0
dc.w	1111,-64,0,0
dc.w	1111,0,-64,0
dc.w	1111,0,0,64
dc.w	1111,0,64,0
dc.w	1111,0,0,-64
dc.w	1111,0,-64,0
dc.w	1111,64,0,0

dc.w	2920,2920,2920

;	T

dc.w	0-15,0-15,0,30-15,0-15,0,30-15
dc.w	0-15,0,30-15,5-15,0,30-15,5-15,0,27-15
dc.w	2-15,0,27-15,2-15,0,17-15,2-15
dc.w	0,17-15,2-15,0,17-15,27-15,0
dc.w	17-15,27-15,0,20-15,30-15,0
dc.w	20-15,30-15,0,10-15,30-15,0
dc.w	10-15,30-15,0,13-15,27-15,0,13-15
dc.w	27-15,0,13-15,2-15,0
dc.w	13-15,2-15,0,3-15,2-15,0,3-15,2-15,0
dc.w	0-15,5-15,0,0-15,5-15,0,0-15,0-15,0

dc.w	2920,2920,2920

C:
dc.w	-128,32,-128,-128,-32,-128,1111,-80,-32,-128
dc.w	1111,-80,-16,-128,1111,-112,-16,-128
dc.w	1111,-112,16,-128,1111,-80,16,-128
dc.w	1111,-80,32,-128,1111,-128,32,-128

dc.w	2920

u:

dc.w	-64,-32,0,-48,-32,0
dc.w	1111,-48,16,0,1111,-16,16,0
dc.w	1111,-16,-32,0,1111,0,-32,0
dc.w	1111,0,32,0,1111,-64,32,0
dc.w	1111,-64,-32,0

dc.w	2920

l:
dc.w	16,-32,0,32,-32,0,1111,32,16,0,1111,80,16,0,1111,80,32,0
dc.w	1111,16,32,0,1111,16,-32,0

dc.w	2920
t:
dc.w	80,-32,0,80,-16,0,1111,104,-16,0,1111,104,32,0
dc.w	1111,120,32,0,1111,120,-16,0,1111,144,-16,0
dc.w	1111,144,-32,0,1111,80,-32,0

dc.w	2920

mode:
dc.w	-1

screen:
dc.l	0

evenukk:
dc.w	0

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
mt_ok2:	move.w	22(a6),6(a5)
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
mt_ok3:	move.w	18(a6),8(a5)
	rts
mt_voldwn:
	moveq	#0,d0
	move.b	3(a6),d0
	and.b	#$0f,d0
	sub.w	d0,18(a6)
	bpl.s	mt_ok4
	clr.w	18(a6)
mt_ok4:	move.w	18(a6),8(a5)
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
	move.w	d2,6(a5)
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
	beq.s	mt_nosamplechange

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
	move.w	18(a6),8(a5)
	bra.s	mt_nosamplechange

mt_displace:
	move.l	4(a6),d2
	add.l	d3,d2
	move.l	d2,10(a6)
	move.w	6(a3,d4.l),14(a6)
	move.w	18(a6),8(a5)
mt_nosamplechange:
	tst.w	(a6)
	beq.s	mt_retrout
	move.w	(a6),16(a6)
	move.w	20(a6),$dff096
	move.l	4(a6),(a5)
	move.w	8(a6),4(a5)
	move.w	(a6),6(a5)
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
	not.w	mt_status
	moveq	#0,d0
	move.b	3(a6),d0
	subq.b	#1,d0
	move.l	d0,mt_partnrplay
	rts

mt_setvol:
	move.b	3(a6),8(a5)
	rts

mt_break:
	not.w	mt_status
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
mt_partnrplay:	dc.l	0
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

rentegn:
dc.w	0
ccounter:
dc.w	0
b:
