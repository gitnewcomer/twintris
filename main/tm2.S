;SS!
;	WRITE ";TEST" EVERYWHERE!

>extern	"playfield",playfield
>extern "brickpic",brickpic
>extern "font2",font
>extern "pause",pause
>extern "hinder",hinder	;TEST
>extern "musikk",mt_data
>extern "snda",snda
>extern "sndb",sndb
>extern "sndc",sndc
>extern "sndd",sndd
>extern "snde",snde
>extern "sndf",sndf
>extern "demoplay",record

*****

top=$7f000
font=top-11520
playfield=font-51200
pointers=playfield-17920
pause=pointers-540
hinder=pause-24000	;TEST
mt_data=hinder-105520
snda=mt_data-1834
sndb=snda-8496
sndc=sndb-7904
sndd=sndc-14856
snde=sndd-4764
sndf=snde-1886
		recordlen=3600
		makerecord=0
record=sndf-recordlen
beg=record-22144
medscreenadr=beg-[256*40*2]

;--------
org	beg
load	beg

******

movem.l	d1-d7/a0-a6,-(a7)
bsr.L	mt_init

cmp	#3,gamestate
bne	vvuyf
move	rn,orn
move	startl,olv
move	#21,rn
move	#21,startl
vvuyf:

move	rn,a_rn
move	a_rn,b_rn

move.b	$bfee01,oldcrs
move.b	$bfef01,oldcrs+1

brickpic=pointers

clr	nrs	;antall reg. poengsummer

move	startl,level
clr	eqc

move	#0,bplcon0

**	initialisation of keyboard
move	$dff002,olddmaen
move	$dff01c,oldinten
bset	#7,olddmaen
bset	#7,oldinten

lea	keys,a0
move	#63,d0
bvtr:
clr	(a0)+
dbra	d0,bvtr

move	#5,credits
move	#1,samelvl

move	#$7fff,$dff09a
move.l	$68,oldkeyb+2
move.l	$6c,oldvb
move.l	#keyboard,$68
bsr.L	initsprites
move.l	#mt_musica,$6c
move	#$c018,$dff09a

vf0:
tst.b	$dff006
bne.S	vf0
btst	#0,$dff005
bne.S	vf0

move	#$7fff,$dff096
move	#%1000011111100000,$dff096

**	finished

move.b	#%10001010,$bfed01

tst	c_countspeed
bne.s	nsd

bsr.L	savedef

nsd:

move.b	#0,$bfee01

lea	pause,a0
lea	pl01a,a1
lea	pl01b,a2
move	#134,d0

move.b	#0,$bfef01
move.b	#-1,$bfe501

avb:
move	(a0)+,d1
move	d1,(a1)
move	d1,(a2)
addq.l	#4,a1
addq.l	#4,a2
dbra	d0,avb

lea	pause+[2*135],a0
lea	pl01a+2,a1
lea	pl01b+2,a2
move	#134,d0

move.b	#-1,$bfe401
move.b	#1,$bfe701

aqqvb:
move	(a0)+,d1
move	d1,(a1)
move	d1,(a2)
addq.l	#4,a1
addq.l	#4,a2
dbra	d0,aqqvb

move.b	#20,$bfe601

move.l	#sprite_a1,d0
move	d0,sprites+6
swap	d0
move	d0,sprites+2
move.l	#sprite_b1,d0
move	d0,sprites+14
swap	d0
move	d0,sprites+10

move.b	#%00000001,$bfee01
move.b	#%01001001,$bfef01
move.b	#%01110101,$bfed01

jompgame:
move.b	#%00000000,in
move.b	#%00000000,superin

lea	a_stats+2,a0
move	#13,d0

qmv:
clr	(a0)
addq.l	#4,a0
dbra	d0,qmv

move.l	a_screen,a0
add.l	#13+[40*8*6],a0
move	#4,d2
ssl0:
move	#[8*20]-1,d0
ssl1:
move	#13,d1
ssl2:
clr.b	(a0)+
dbra	d1,ssl2
add.l	#40-14,a0
dbra	d0,ssl1
add.l	#[40*256]-[40*8*20],a0
dbra	d2,ssl0

move.l	a_screen,a0
add.l	#13+[40*8*26],a0
move	#13,d0

repl1:
move.b	#%01111111,40(a0)
move.b	#%10000000,256*40(a0)
move.b	#%11000000,257*40(a0)
move.b	#%11111111,(a0)+
dbra	d0,repl1

move	#85,rcs
move	#85,a_rcs
move	#85,b_rcs

maingame:
*	kill screen

move	#0,bplcon0

move.l	a_screen,a0
add.l	#2+[40*8*6],a0
move	#4,d0
move	#30,$dff066
move	#0,$dff074
move	#%000111110000,$dff040
move	#0,$dff042

ks1l0:
move.l	a0,$dff048+12
move	#5+[64*20*8],$dff058
qp:
btst	#14,$dff002
bne.S	qp
add.l	#[40*256],a0

dbra	d0,ks1l0

move.l	a_screen,a0
add.l	#[40*[256-24]]+2,a0
move	#4,d0
move	#30,$dff066
move	#0,$dff074
move	#%000111110000,$dff040
move	#0,$dff042

sks1l0:
move.l	a0,$dff048+12
move	#5+[64*24],$dff058
sqp:
btst	#14,$dff002
bne.S	sqp
add.l	#[40*256],a0

dbra	d0,sks1l0

move.l	b_screen,a0
add.l	#2+[40*8*6],a0
move	#4,d0
move	#30,$dff066
move	#0,$dff074
move	#%000111110000,$dff040
move	#0,$dff042

ks1l0b:
move.l	a0,$dff048+12
move	#5+[64*20*8],$dff058
qpq:
btst	#14,$dff002
bne.S	qpq
add.l	#[40*256],a0

dbra	d0,ks1l0b

move.l	b_screen,a0
add.l	#[40*[256-24]]+2,a0
move	#4,d0
move	#30,$dff066
move	#0,$dff074
move	#%000111110000,$dff040
move	#0,$dff042

ssks1l0:
move.l	a0,$dff048+12
move	#5+[64*24],$dff058
ssqp:
btst	#14,$dff002
bne.S	ssqp
add.l	#[40*256],a0

dbra	d0,ssks1l0

tst	gamestate
beq.s	nrrwww
tst	superin
bne.s	nrrwww
move	startl,level

nrrwww:


move	b_score,score
bsr.L	for_a

bsr.L	loaddef

bsr.L	for_b


wff:
tst.b	$dff006
bne.S	wff
btst	#0,$dff005
bne.S	wff

move.l	#copperlist,$dff084	;ASS
move	#0,$dff08a	;ASS


move.l	a_screen,d0
move	#4,d1
lea	e0+2,a1

ppl1:

move	d0,4(a1)
swap	d0
move	d0,(a1)
swap	d0
add.l	#8,a1

add.l	#[40*256],d0

dbra	d1,ppl1


bsr.L	randomnum
bsr.L	for_a
bsr.L	randomnum
bsr.L	for_b
move	d0,a_klossno
move	d0,b_klossno
bsr.L	clrnext

bsr.L	for_a
move.b	#$75,rtoc+1
bsr.L	setupnew
bsr	sn2
sub	#1,score
move.b	#$71,rtoc+1
bsr.L	for_b
move.b	#$75,rtoc+1
bsr.L	setupnew
bsr	sn2
sub	#1,score
move.b	#$71,rtoc+1

move	#16,a_feilno
move	#-1,a_wfr
move	#16,b_feilno
move	#-1,b_wfr
move	#16,feilno
move	#-1,wfr

move.l	a_screen,a0
sub.l	#39,a0
clr.l	d0
move	a_timeleft,d0
bpl	sf1
clr	d0
sf1:
divs	#50,d0
add.l	#[8*26*40]+[256*80],a0
sub	#1,d0
bpl	wgba
clr	d0

wgba:

or.b	#%00111100,(a0)
and.b	#%11000011,256*40(a0)
and.b	#%11000011,256*80(a0)
sub.l	#40,a0

dbra	d0,wgba

clr.l	d0
move	a_timeleft,d0
bpl	sf2
clr	d0
sf2:
divs	#50,d0
neg	d0
add	#160,d0
bpl	wbwa
clr	d0
wbwa:
and.b	#%11000011,(a0)
and.b	#%11000011,256*40(a0)
or.b	#%00111100,256*80(a0)
sub.l	#40,a0
dbra	d0,wbwa

move.l	b_screen,a0
sub.l	#39,a0
clr.l	d0
move	b_timeleft,d0
bpl	w2gb
clr	d0
w2gb:
divs	#50,d0
add.l	#[8*26*40]+[256*80],a0
sub	#1,d0
bpl	wgb
clr	d0

wgb:
or.b	#%00111100,(a0)
and.b	#%11000011,256*40(a0)
and.b	#%11000011,256*80(a0)
sub.l	#40,a0

dbra	d0,wgb

clr.l	d0
move	b_timeleft,d0
bpl	wbw2
clr	d0
wbw2:
divs	#50,d0
neg	d0
add	#160,d0
bpl	wbw
clr	d0
wbw:
and.b	#%11000011,(a0)
and.b	#%11000011,256*40(a0)
or.b	#%00111100,256*80(a0)
sub.l	#40,a0
dbra	d0,wbw

move.l	a_screen,a0
sub.l	#28,a0
clr.l	d0
move	a_linesleft,d0
mulu	#8,d0
add.l	#[8*26*40]+[256*80],a0
sub	#1,d0
bpl	lwgba
clr	d0

lwgba:

or.b	#%00111100,(a0)
and.b	#%11000011,256*40(a0)
and.b	#%11000011,256*80(a0)
sub.l	#40,a0

dbra	d0,lwgba

move	a_linesleft,d0
mulu	#8,d0
neg	d0
add	#160,d0

lwbwa:
and.b	#%11000011,(a0)
and.b	#%11000011,256*40(a0)
or.b	#%00111100,256*80(a0)
sub.l	#40,a0
dbra	d0,lwbwa


move.l	b_screen,a0
sub.l	#28,a0
clr.l	d0
move	b_linesleft,d0
mulu	#8,d0
add.l	#[8*26*40]+[256*80],a0
sub	#1,d0
bpl	lwgb
clr	d0

lwgb:

or.b	#%00111100,(a0)
and.b	#%11000011,256*40(a0)
and.b	#%11000011,256*80(a0)
sub.l	#40,a0

dbra	d0,lwgb

move	b_linesleft,d0
mulu	#8,d0
neg	d0
add	#160,d0

lwbw:
and.b	#%11000011,(a0)
and.b	#%11000011,256*40(a0)
or.b	#%00111100,256*80(a0)
sub.l	#40,a0
dbra	d0,lwbw


move	superin,d0
and	d0,in

clr	linesfound
clr	a_linesfound
clr	b_linesfound

btst	#7,join
bne.L	nha

move	level,d0
sub	#1,d0
lsl	#1,d0
lea	hinders,a0
move	(A0,d0.w),d0
ext.l	d0
cmp	#-1,d0
beq	nha
add.l	#hinder,d0

move	#20,$dff064
move	#30,$dff066
move.l	#-1,$dff044
move	#%100111110000,$dff040
move	#0,$dff042
move.l	a_screen,d1
add.l	#2+[8*6*40],d1
move	#4,d2
q3nq:
move.l	d0,$dff048+8
move.l	d1,$dff048+12
move	#5+[8*20*64],$dff058
q3bv:
btst	#14,$dff002
bne.S	q3bv
add.l	#30*20*8,d0
add.l	#256*40,d1
dbra	d2,q3nq

nha:

btst	#6,join
bne.L	nhb

move	level,d0
sub	#1,d0
lsl	#1,d0
lea	hinders,a0
move	(A0,d0.w),d0
ext.l	d0
cmp	#-1,d0
beq	nhb

add.l	#hinder,d0

move	#20,$dff064
move	#30,$dff066
move.l	#-1,$dff044
move	#%100111110000,$dff040
move	#0,$dff042
move.l	b_screen,d1
add.l	#2+[8*6*40],d1
move	#4,d2
q3n4q:
move.l	d0,$dff048+8
move.l	d1,$dff048+12
move	#5+[8*20*64],$dff058
q3b4v:
btst	#14,$dff002
bne.S	q3b4v
add.l	#30*20*8,d0
add.l	#256*40,d1
dbra	d2,q3n4q
nhb:

nhr:
move	mt_state,mt_on

tst	gamestate
beq.S	nomedsc
tst	superin
bne.s	nomedsc

clr	eqc
bsr.L	medscreen

move	#0,bplcon0

nomedsc:

tst	credits
beq.L	nj2

btst	#7,join
beq.S	nj1

move.l	a_screen,d6
add.l	#2+[40*8*10],d6
lea	joinn,a0
move	#0,d4
move	#7,d7
bsr.L	type
add.l	#[40*25],d6
lea	inn,a0
bsr.L	type
add.l	#[40*25],d6
lea	any,a0
bsr.L	type
add.l	#[40*25],d6
lea	time,a0
bsr.L	type

nj1:
btst	#6,join
beq.S	nj2

move.l	b_screen,d6
add.l	#2+[40*8*10],d6
lea	joinn,a0
move	#0,d4
move	#7,d7
bsr.L	type
add.l	#[40*25],d6
lea	inn,a0
bsr.L	type
add.l	#[40*25],d6
lea	any,a0
bsr.L	type
add.l	#[40*25],d6
lea	time,a0
bsr.L	type

nj2:

bsr	typecreds
*****	¡¡¡¡ INITIALIZATION COMPLETED !!!!   *****
wfl12:
cmp.b	#10,$dff006
bne.S	wfl12
btst	#0,$dff005
bne.S	wfl12

move	#$5000,bplcon0

move.l	#0,d0
move.b	#$2c+153,copperwait

wfl1:
cmp.b	#10,$dff006
bne.S	wfl1
btst	#0,$dff005
bne.S	wfl1

move	#17,d1
sub	d0,d1
sub.b	d1,copperwait

lea	$dff180,a1
lea	palette+2,a0
move	#31,d1
clr.l	d2
clr.l	d3
clr.l	d4

fl1:
move	(a0),d2
move	d2,d3
move	d3,d4
and	#$f,d4
and	#$f0,d3
and	#$f00,d2

mulu	d0,d2
mulu	d0,d3
mulu	d0,d4
lsr	#4,d2
lsr	#4,d3
lsr	#4,d4
and	#$f,d4
and	#$f0,d3
and	#$f00,d2

or	d4,d3
or	d3,d2
move	d2,(a1)+
addq.l	#4,a0
dbra	d1,fl1

add	#1,d0
cmp	#16,d0
bne.S	wfl1



jg:
bsr	nextframe
move.l	a_stickpo,stickpo
bsr	makestick
tst	feuer
bne.s	jg
move.l	b_stickpo,stickpo
bsr	makestick
tst	feuer
bne.s	jg

************************************************
**************************************************
**						**
**						**
**						**
**		* T W I N T R I S *		**
**						**
**	 Copyringht © 1990 by SwEinstein	**
**						**
**		( Amiga version )		**
**						**
**						**
**						**
**************************************************
************************************************

repetative:
;move	$dff012,d0
;cmp	rbutt,d0
;beq.S	finestuffbaby

;move	d0,rbutt
;move	#500,d0
;vq:
;dbra	d0,vq

;bra.S	repetative

finestuffbaby:

tst.b	keys+$45
beq.L	noquit
move	#-1,b
bra	quit
noquit:

tst.b	keys+$54
bne	rere
tst.b	keys+$59
beq.s	nore
rere:
clr	b
clr	eqc
bra	quit
nore:

move.b	copperwait,d0
add	#208,d0

wfl9:
cmp.b	$dff006,d0
beq.S	wfl9

wfl0:
cmp.b	$dff006,d0
bne.S	wfl0

tst.b	keys+$53
bne.s	mc
tst.b	keys+$58
beq	nmc
mc:
clr.b	keys+$53
clr.b	keys+$58
not	mt_state
move	mt_state,mt_on
bne.s	nmc
move	#$f,d0
tst	sprio
beq.s	takeall
move	ch3,d1
bclr	d1,d0
takeall:
move	d0,$dff096
nmc:

tst.b	keys+$52
bne	ec
tst.b	keys+$57
beq	nec
ec:
clr.b	keys+$52
clr.b	keys+$57
not	eff_on
nec:

tst	shake
bne.L	onein
tst.b	in
bne.L	onein
cmp.b	#128,join
bhi.L	onein


vnbn:

	;both out (finished as loser or winner)


move.l	a_stickpo,stickpo
bsr	makestick
tst	feuer
beq	ani

bra	wq

ani:
move.l	b_stickpo,stickpo
bsr	makestick
tst	feuer
beq	onein

bra	wq

onein:

tst	shake
beq.S	sh0

move.l	sinepos,a0
move.b	(a0),d0
ext	d0
add.l	#1,sinepos
cmp.l	#sinepos,sinepos
bne.S	npbm
sh0:
move.l	#sine11+1,sinepos
add	#1,shake
bmi.S	npbm
clr	shake
npbm:
move	shake,d1
muls	d1,d0
asr	#8,d0
add	#$2c,d0
move.b	d0,copperwait
move.b	d0,copperlist+2
move.b	d0,copperlist+6

tst.b	$50+keys
beq.S	sorrya
bchg	#7,on
bne.S	pon
move.b	#$66,sprite_a1+2
bra.s	poff
pon:
move.b	#$ef,sprite_a1+2
poff:

clr.b	keys+$50

sorrya:

tst.b	$55+keys
beq.S	sorryb
bchg	#6,on
bne.S	ponb
move.b	#$66,sprite_b1+2
bra.s	poffb
ponb:
move.b	#$ef,sprite_b1+2
poffb:

clr.b	keys+$55

sorryb:
tst.b	$33+keys
beq.S	sorrya2
tst.b	$25+keys
beq.S	sorrya2
tst.b	$12+keys
beq.S	sorrya2
tst.b	$60+keys
beq.S	sorrya2
tst.b	$1d+keys
beq.S	sorrya2

clr	a_linesleft
sorrya2:
tst.b	$33+keys
beq.S	sorryb2
tst.b	$25+keys
beq.S	sorryb2
tst.b	$12+keys
beq.S	sorryb2
tst.b	$60+keys
beq.S	sorryb2
tst.b	$1e+keys
beq.S	sorryb2

clr	linesleft
sorryb2:

tst.b	join
beq.L	nojoin		;joining...

move.l	a_stickpo,stickpo
bsr	makestick
tst	feuer
beq.L	nja
btst	#7,join
beq.L	nja

lea	a_stats+2,a0
move	#6,d0

qmvi:
clr	(a0)
addq.l	#4,a0
dbra	d0,qmvi

move.l	a_screen,a0
add.l	#13+[40*8*6],a0
move	#4,d2
ssl0i:
move	#[8*20]-1,d0
ssl1i:
move	#6,d1
ssl2i:
clr.b	(a0)+
dbra	d1,ssl2i
add.l	#40-7,a0
dbra	d0,ssl1i
add.l	#[40*256]-[40*8*20],a0
dbra	d2,ssl0i

move.l	a_screen,a0
add.l	#13+[40*8*26],a0
move	#6,d0

repl1i:
move.b	#%01111111,40(a0)
move.b	#%10000000,256*40(a0)
move.b	#%11000000,257*40(a0)
move.b	#%11111111,(a0)+
dbra	d0,repl1i

sub	#1,credits
bsr.L	typecreds

move	level,d0

subq	#1,d0
lsl	#1,d0
lea	speeds,a0
move	(a0,d0.w),a_rcs
bclr	#7,join
bset	#7,on
bset	#7,in
bset	#7,superin
clr	a_score
move	#-1,a_wfr
move.l	a_screen,a0
add.l	#2+[40*8*6],a0
move	#4,d0
move	#30,$dff066
move	#0,$dff074
move	#%000111110000,$dff040
move	#0,$dff042

ks1l01:
move.l	a0,$dff048+12
move	#5+[64*20*8],$dff058
qp1:
btst	#14,$dff002
bne.S	qp1
add.l	#[40*256],a0

dbra	d0,ks1l01

move	level,d0
sub	#1,d0
lsl	#1,d0
lea	hinders,a0
move	(A0,d0.w),d0
ext.l	d0
cmp	#-1,d0
beq	nja
add.l	#hinder,d0

move	#20,$dff064
move	#30,$dff066
move.l	#-1,$dff044
move	#%100111110000,$dff040
move	#0,$dff042
move.l	a_screen,d1
add.l	#2+[8*6*40],d1
move	#4,d2
qnq:
move.l	d0,$dff048+8
move.l	d1,$dff048+12
move	#5+[8*20*64],$dff058
qbv:
btst	#14,$dff002
bne.S	qbv
add.l	#30*20*8,d0
add.l	#256*40,d1
dbra	d2,qnq


nja:

move.l	b_stickpo,stickpo
bsr	makestick
tst	feuer
beq.L	njb
btst	#6,join
beq.L	njb

lea	b_stats+2,a0
move	#6,d0

qbvi:
clr	(a0)
addq.l	#4,a0
dbra	d0,qbvi

move.l	a_screen,a0
add.l	#13+[40*8*6]+7,a0
move	#4,d2
bssl0i:
move	#[8*20]-1,d0
bssl1i:
move	#6,d1
bssl2i:
clr.b	(a0)+
dbra	d1,bssl2i
add.l	#40-7,a0
dbra	d0,bssl1i
add.l	#[40*256]-[40*8*20],a0
dbra	d2,bssl0i

move.l	a_screen,a0
add.l	#13+[40*8*26]+7,a0
move	#6,d0

brepl1i:
move.b	#%01111111,40(a0)
move.b	#%10000000,256*40(a0)
move.b	#%11000000,257*40(a0)
move.b	#%11111111,(a0)+
dbra	d0,brepl1i


sub	#1,credits
bsr.L	typecreds

move	level,d0
subq	#1,d0
lsl	#1,d0
lea	speeds,a0
move	(a0,d0.w),rcs

bclr	#6,join
bset	#6,on
bset	#6,in
bset	#6,superin
clr	score
move	#-1,wfr
move.l	b_screen,a0
add.l	#2+[40*8*6],a0
move	#4,d0
move	#30,$dff066
move	#0,$dff074
move	#%000111110000,$dff040
move	#0,$dff042

ks1l09:
move.l	a0,$dff048+12
move	#5+[64*20*8],$dff058
qp9:
btst	#14,$dff002
bne.S	qp9
add.l	#[40*256],a0

dbra	d0,ks1l09

move	level,d0
sub	#1,d0
lsl	#1,d0
lea	hinders,a0
move	(A0,d0.w),d0
ext.l	d0
cmp	#-1,d0
beq	njb
add.l	#hinder,d0

move	#20,$dff064
move	#30,$dff066
move.l	#-1,$dff044
move	#%100111110000,$dff040
move	#0,$dff042
move.l	b_screen,d1
add.l	#2+[8*6*40],d1
move	#4,d2
qnqb:
move.l	d0,$dff048+8
move.l	d1,$dff048+12
move	#5+[8*20*64],$dff058
q2bv:
btst	#14,$dff002
bne.S	q2bv
add.l	#30*20*8,d0
add.l	#256*40,d1
dbra	d2,qnqb

njb:

nojoin:

tst	credits
bne.L	stc

btst	#7,join
beq.S	npa

move.l	a_screen,a0
add.l	#2+[40*8*6],a0
move	#4,d0
move	#30,$dff066
move	#0,$dff074
move	#%000111110000,$dff040
move	#0,$dff042

k2s1l0:
move.l	a0,$dff048+12
move	#5+[64*20*8],$dff058
q2p:
btst	#14,$dff002
bne.S	q2p
add.l	#[40*256],a0

dbra	d0,k2s1l0
move	#-1,eqc
npa:

btst	#6,join
beq.S	npb

move.l	b_screen,a0
add.l	#2+[40*8*6],a0
move	#4,d0
move	#30,$dff066
move	#0,$dff074
move	#%000111110000,$dff040
move	#0,$dff042

k3s1l0:
move.l	a0,$dff048+12
move	#5+[64*20*8],$dff058
q3p:
btst	#14,$dff002
bne.S	q3p
add.l	#[40*256],a0

dbra	d0,k3s1l0

move	#-1,eqc
npb:
clr	join
stc:

move	in,d0
and	d0,on

bsr.L	for_a	
btst	#7,on
beq.S	na
bsr.L	gameplay
na:

bsr.L	for_b
btst	#6,on
beq.S	nb
bsr.L	gameplay
nb:

tst	palette+2
beq	nfr
sub	#$111,palette+2
nfr:

tst	a_upflag
beq	nohupp
tst	upflag
beq	nohupp

tst	didlast
bne	hupped

move	#-1,didlast

bsr	for_a
bsr	blitup
move	b_klossno,tklossno
move	b_turnament,tturnament
bsr	test
tst	succ
bne	fuuuc
bsr	blitup

bsr	for_b
bra	nohupp

fuuuc:
bsr	blitup
move	a_klossno,soppel
move	a_turnament,soppel+2
bsr	for_b
bsr	blitup
move	soppel,tklossno
move	soppel+2,tturnament
bsr	test
tst	succ
bne	cccn
bsr	blitup
bsr	for_a
bsr	blitup
move	soppel,klossno
move	soppel+2,turnament
move	soppel,tklossno
move	soppel+2,tturnament
bsr	blitup
bsr	for_b
bra	nohupp

cccn:

bsr	blitup
move	#$fff,palette+2

move	#7,d0
bsr	mseff

bra	hupped

nohupp:
clr	didlast
hupped:

tst	eqc
beq	neqqq
btst	#7,in
beq	oneout
move.l	#playfield+0,d0
move.l	#playfield+26,d1
bra	homo
oneout:
move.l	#playfield+26,d0
move.l	#playfield+0,d1
homo:
move	#4,d2
vqi:
move.l	d0,$dff048+8
move.l	d1,$dff048+12
move	#26,$dff060+4
move	#26,$dff060+6
move.l	#-1,$dff044
move	#%100111110000,$dff040
move	#0,$dff042
move	#7+[64*40],$dff058
vqb:
btst	#14,$dff002
bne	vqb
add.l	#[256*40],d0
add.l	#[256*40],d1
dbra	d2,vqi

sub.l	#[256*40*5]-[40*40]-2,d0
sub.l	#[256*40*5]-[40*40]-2,d1

move	#4,d2
vqi2:
move.l	d0,$dff048+8
move.l	d1,$dff048+12
move	#30,$dff060+4
move	#30,$dff060+6
move.l	#-1,$dff044
move	#%100111110000,$dff040
move	#0,$dff042
move	#5+[64*216],$dff058
vqb2:
btst	#14,$dff002
bne	vqb2
add.l	#[256*40],d0
add.l	#[256*40],d1
dbra	d2,vqi2

btst	#7,in
beq	oneout2

move	#4,d2
move.l	#playfield+26+[40*40],d0
move.l	#playfield+[40*40],d1
move	#$ff,$dff070
hetro:
move.l	d1,$dff048+8
move.l	d0,$dff048+12
move.l	d0,$dff048+4
move	#38,$dff060+4
move	#38,$dff060+6
move.l	#-1,$dff044
move	#%110111110100,$dff040
move	#0,$dff042
move	#1+[64*216],$dff058
bbb:
btst	#14,$dff002
bne	bbb
add.l	#[256*40],d0
add.l	#[256*40],d1
dbra	d2,hetro

move.l	#playfield+[40*40]+12,d0
move.l	#playfield+[40*40]+38,d1

move	#4,d2
vqi22:
move.l	d0,$dff048+8
move.l	d1,$dff048+12
move	#38,$dff060+4
move	#38,$dff060+6
move.l	#$ff00ff00,$dff044
move	#%100111110000,$dff040
move	#0,$dff042
move	#1+[64*216],$dff058
vqb22:
btst	#14,$dff002
bne	vqb22
add.l	#[256*40],d0
add.l	#[256*40],d1
dbra	d2,vqi22

bra	neqqq

oneout2:
move	#4,d2
move.l	#playfield+12+[40*40],d0
move.l	#playfield+38+[40*40],d1
move	#$ff00,$dff070
hetrob:
move.l	d1,$dff048+8
move.l	d0,$dff048+12
move.l	d0,$dff048+4
move	#38,$dff060+4
move	#38,$dff060+6
move.l	#-1,$dff044
move	#%110111110100,$dff040
move	#0,$dff042
move	#1+[64*216],$dff058
bbbb:
btst	#14,$dff002
bne	bbbb
add.l	#[256*40],d0
add.l	#[256*40],d1
dbra	d2,hetrob

move.l	#playfield+[40*40],d1
move.l	#playfield+[40*40]+26,d0

move	#4,d2
vqi22b:
move.l	d0,$dff048+8
move.l	d1,$dff048+12
move	#38,$dff060+4
move	#38,$dff060+6
move.l	#$00ff00ff,$dff044
move	#%100111110000,$dff040
move	#0,$dff042
move	#1+[64*216],$dff058
vqb22b:
btst	#14,$dff002
bne	vqb22b
add.l	#[256*40],d0
add.l	#[256*40],d1
dbra	d2,vqi22b

neqqq:
move	superin,d0
and	d0,in
bra.L	repetative

gameplay:
tst	newing
beq	nnw
bsr	sn2
bsr.L	blitup
bra.L	finished

nnw:

tst	linesleft
bne.L	gp2

move.l	screen,a0
sub.l	#28,a0
clr.l	d0
move	linesleft,d0
mulu	#8*40,d0
add.l	#[8*26*40]+[256*80],a0
ext.l	d0
sub.l	d0,a0

move	linesfound,d0
lsl	#3,d0
sub	#1,d0
bpl.S	nsf
clr	d0
nsf:

rumm2:
and.b	#%11000011,(a0)
and.b	#%11000011,256*40(a0)
or.b	#%00111100,256*80(a0)
sub.l	#40,a0
dbra	d0,rumm2

tst.l	emptying
bne.L	empty

tst	timeleft
bmi	vvqvv
bne.S	counttime
vvqvv:
move	fb,d0
bclr	d0,in
bsr.L	clrnext
bsr.L	typescore
bra.L	finished

counttime:
sub	#50,timeleft
bpl.S	stok
clr	timeleft
stok:
add	#5,score

move.l	screen,a0
sub.l	#39,a0
clr.l	d0
move	timeleft,d0
divu	#50,d0
mulu	#40,d0
add.l	#[8*26*40]+[256*80],a0
ext.l	d0
sub.l	d0,a0
and.b	#%11000011,(a0)
and.b	#%11000011,256*40(a0)
or.b	#%00111100,256*80(a0)

bsr.L	typescore
bra.L	finished

gp2:
tst	timeleft
bmi.L	notime

sub	#1,timeleft
bpl.S	sok2
clr	timeleft
sok2:

move.l	screen,a0
sub.l	#39,a0
clr.l	d0
move	timeleft,d0
divu	#50,d0
mulu	#40,d0
add.l	#[8*26*40]+[256*80],a0
ext.l	d0
sub.l	d0,a0
and.b	#%11000011,(a0)
and.b	#%11000011,256*40(a0)
or.b	#%00111100,256*80(a0)

tst	linesleft
bpl	notime
tst	timeleft
beq	go2go2
bra	notime
ti3:

cmp	#2000,d0
blt	ti12

cmp	#2127,d0
bgt	ti12
sub	#2000,d0
lsl	#1,d0
move	d0,volume
bra	notime

ti12:
cmp	#1936,d0
bgt	notime
bne	notime
move.l	#19,mt_partnrplay
clr	mt_status
move	#15,$dff096
bsr	mt_higher
move	#255,volume
bra	notime


go2go2:
bsr	gameover		;make game over (no return)

notime:
tst	linesleft
bmi.S	nolinesf

cmp	#1,linesfound
blt.S	nolinesf

move.l	screen,a0
sub.l	#28,a0
clr.l	d0
move	linesleft,d0
mulu	#8,d0
add.l	#[8*26*40]+[256*80],a0
sub	#1,d0

lwgba7:

or.b	#%00111100,(a0)
and.b	#%11000011,256*40(a0)
and.b	#%11000011,256*80(a0)
sub.l	#40,a0

dbra	d0,lwgba7

move	linesleft,d0
mulu	#8,d0
neg	d0
add	#160,d0

lwbwa7:
and.b	#%11000011,(a0)
and.b	#%11000011,256*40(a0)
or.b	#%00111100,256*80(a0)
sub.l	#40,a0
dbra	d0,lwbwa7

nolinesf:
tst.l	emptying
bne.L	empty

cmp	#10,feilno
blt.s	nfn
tst.b	extrapos
beq.S	fine
sub	#1,feilno
bra.S	nfn
fine:

bra.L	testlines
nolines:
bsr.L	setupnew
bra	finished
nfn:

bsr.L	blitup

nqp:

***		test movements			***
	
bsr	makestick

**	**	**	joystick	**	**	**


*	*	*	shoot	*	*	*

tst	wfr
beq.S	wfp
tst	feuer
bne.L	nos
clr	wfr
bra.L	nos
wfp:

tst	feuer
beq.L	nos

move	#-1,wfr
add	#4,tturnament

movem.l	d0/d1/a0/a1,-(a7)

move	#4,d0
bsr	mseff

movem.l	(a7)+,d0/d1/a0/a1

and	#%1100,tturnament
bsr.L	test
tst	succ
bne	nos

add	#4,tturnament
and	#%1100,tturnament
tst	textrapos
bne	jct
sub	#1,tklosspos
jct:
clr	textrapos
bsr.L	test
tst	succ
bne	nos

add	#4,tturnament
and	#%1100,tturnament
add	#1,tklosspos
clr	textrapos
bsr.L	test
tst	succ
bne	nos

add	#4,tturnament
and	#%1100,tturnament
tst	textrapos
bne	jct3
sub	#1,tklosspos
jct3:
clr	textrapos
sub	#1,tklosspos
bsr.L	test
tst	succ
bne	nos



nos:

clr	ndir
*	*	*	left	*	*	*

btst	#3,stick+1
beq.S	nol

move	#-256,ndir

nol:

*	*	*	right	*	*	*

btst	#1,stick+1
beq.L	nor

move	#256,ndir

nor:
tst	wind
beq.S	nowind

move	rn,d7
move	rp,d6
move	c_rn,rn
move	c_rp,rp
clr.l	d0
bsr.L	randomnum
move	rn,c_rn
move	rp,c_rp
move	d7,rn
move	d6,rp

clr.l	d1
ext.l	d0
move	wind,d1
divs	d1,d0
tst	stick
bne	nowind
add	d0,ndir

nowind:

tst	ndir
beq.S	nodir
move	ndir,dir
bra.S	keepdir

nodir:
tst.b	extrapos
bne.S	keepdir
clr	dir

keepdir:
bsr.L	tstdir
bsr.L	tstdir
*	*	*	down	*	*	*
btst	#2,stick+1
bne.S	dwn
move	rcs,countspeed
bra.S	nod

dwn:
add	#64,countspeed

nod:
*	*	*	fall	*	*	*

	move	countspeed,d0
	move.b	count,d1
	add	d0,count
	sub.b	count,d1
	beq.L	seuck

	neg.b	d1
	ext	d1
	tst	d1
	beq.L	seuck

	cmp	#8,d1
	blt.s	single

move	d1,-(a7)

	add	#[40*8],tklosspos
	move	tklosspos,realdpos

	bsr.L	test

move	(a7)+,d1

	tst	succ
	beq.S	zyr

	sub	#[40*8],tklosspos

single:
	mulu	#40,d1
	add	d1,tklosspos
move	tklosspos,realdpos

	bsr.L	test

	tst	succ
	beq.S	zyr

	clr	feilno
	bra.L	seuck

	zyr:

clr.l	d0
	move	realdpos,d0
move	d0,tklosspos
	divu	#40,d0
	and	#%111,d0
	mulu	#40,d0
	sub	d0,tklosspos

	bsr.L	test

	add	#1,feilno
cmp	#1,feilno
bne	zxyt

move	#6,d0
bsr	mseff

	zxyt:
	move	rcs,countspeed
	move	#$00ff,count
	seuck:


bsr.L	blitup

finished:
tst	spriv
beq	nothingnew
sub	#1,spriv
bne	nothingnew
clr	sprio
nothingnew:

tst	warp
beq	finis
move	#$8000,d0
or	warp,d0
move	d0,$dff096
move	#50,d1
mvv:
dbra	d1,mvv

move.l	ch,a0
move	#1,4(a0)
move.l	#psuedo,(a0)
clr	warp
finis:
rts

mseff:
tst	eff_on
beq	rts

move.l	ch2,a1

mulu	#14,d0
lea	seff,a0
add	d0,a0

move	sprio,d0
cmp	12(a0),d0
bgt	rts

clr	d0
move	ch3,d1
bset	d1,d0
move	d0,$dff096

move	12(a0),sprio

move	8(a0),(a1)
move	8(a0),spriv

move.l	ch,a1
move	#0,4(a1)

move	4(a0),4(a1)
move	6(a0),6(a1)
move	10(a0),8(a1)
move.l	(a0),(a1)
move	d0,warp
rts

typescore:
clr.l	d0
move	score,d0
lea	asciiscore+5,a0
move	#4,d1

sivu:
divu	#10,d0
swap	d0
add.b	#'0',d0
move.b	d0,-(a0)
clr	d0
swap	d0
dbra	d1,sivu

lea	asciiscore,a0
move	#7,d7
move.l	screen,d6
add.l	#[40*[256-24]]+2,d6
clr	d4
bra.L	type

typecreds:
movem.l	d0-d7/a0-a6,-(a7)
clr	asciiscore+2
move.b	#'0',asciiscore
move.b	credits+1,asciiscore+1
add.b	#$30,asciiscore+1
lea	asciiscore,a0
move	#5,d7
move.l	#playfield,d6
add.l	#[40*[256-24]]+18,d6
clr	d4
bsr.L	type
movem.l	(a7)+,d0-d7/a0-a6
rts

tstdir:
move	dir,d0
add	d0,textrapos
cmp	#8*256,textrapos
blt.S	novert
sub	#8*256,textrapos
add	#1,tklosspos
novert:
tst	textrapos
bpl.S	nuvert
add	#8*256,textrapos
sub	#1,tklosspos
nuvert:
bra.L	test

wq:

lea	jompgame,a0
move	#-1,b

tst	credits
bne.S	vqqq
tst	superin
bne.S	vqqq
tst	gamestate
bne.s	vqqq
bra	quit
vqqq:

sub	#1,level
move	#-1,samelvl

tst	superin
beq.S	dontcontinue

add	#1,level
clr	samelvl

lea	maingame,a0

dontcontinue:
move.l	a0,-(a7)
bsr.L	fadeout
move.l	(a7)+,a0
jmp	(a0)

quit:
clr	getout
bsr	fadeout
tst	b
bne.S	rq
tst	gamestate
bne	rq
move	startl,level
move	#5,credits
clr	samelvl
cmp.l	#10,mt_partnrplay
bge	jompgame
move	#-1,samelvl
bra.L	jompgame

rq:
bsr	fademusic
bsr.L	mt_end

move.l	oldkeyb+2,$68
move.l	oldvb,$6c
move	#$7fff,$dff096
move	#$7fff,$dff09a
move	olddmaen,$dff096
move	oldinten,$dff09a
movem.l	(a7)+,d1-d7/a0-a6
clr.l	d0
cmp	#3,gamestate
bne	rts
move	orn,rn
move	olv,startl
move.b	oldcrs,$bfee01
move.b	oldcrs+1,$bfef01
move.b	icr,$bfed01

rts

olddmaen:
dc.w	0
oldinten:
dc.w	0

copperlist:
dc.w	$8e,$2c31
dc.w	$90,$2cff
dc.w	$104,4+[8*4]
dc.w	$100,0

dms:
dc.w	$120,0
dc.w	$122,0
dc.w	$12c,0
dc.w	$12e,0
dc.w	$13c,0
dc.w	$13e,0
dc.w	$124,0
dc.w	$126,0
dc.w	$128,0
dc.w	$12a,0
dc.w	$138,0
dc.w	$13a,0

sprites:
dc.w	$130,0
dc.w	$132,0
dc.w	$134,0
dc.w	$136,0


dc.w	$108,0
dc.w	$10a,0

palette:
dc.w	$180,0

lowcol:
dc.w	$182,0
dc.w	$184,0
dc.w	$186,0
dc.w	$188,0
dc.w	$18a,$08f
dc.w	$18c,$048
dc.w	$18e,$06c
dc.w	$190,$fff
dc.w	$192,$0f0
dc.w	$194,$080
dc.w	$196,$0c0
dc.w	$198,$fff
dc.w	$19a,$0ff
dc.w	$19c,$088
dc.w	$19e,$0cc
dc.w	$1a0,$fff
dc.w	$1a2,$f00
dc.w	$1a4,$800
dc.w	$1a6,$c00
dc.w	$1a8,$fff
dc.w	$1aa,$f0f
dc.w	$1ac,$808
dc.w	$1ae,$c0c
dc.w	$1b0,$440
dc.w	$1b2,$ff0
dc.w	$1b4,$880
dc.w	$1b6,$cc0
dc.w	$1b8,$fff
dc.w	$1ba,$fc8
dc.w	$1bc,$864
dc.w	$1be,$c86

dc.w	$92,$38
dc.w	$94,$d0

copperwait:
dc.w	$2c01,$fffe

dc.w	$100
bplcon0:
dc.w	$5000

e0:
dc.w	$e0,6
dc.w	$e2,0
dc.w	$e4,6
dc.w	$e6,4
dc.w	$e8,6
dc.w	$ea,8
dc.w	$ec,6
dc.w	$ee,12
dc.w	$f0,7
dc.w	$f2,16

stopcopper:
dc.w	$c401,$fffe
dc.w	$9c,$8010

dc.w	$ffe1,$fffe

dc.w	$1621,$fffe
cp1:
dc.w	$180,$000
dc.w	$1921,$fffe
dc.w	$180,0

dc.w	$1a21,$fffe
cp2:
dc.w	$180,$000
dc.w	$1d21,$fffe
dc.w	$180,0

dc.w	$1e21,$fffe
cp3:
dc.w	$180,$000
dc.w	$2121,$fffe
dc.w	$180,0

dc.w	$2221,$fffe
cp4:
dc.w	$180,$000
dc.w	$2521,$fffe
dc.w	$180,0

testlist2:
dc.w	$180,0
dc.w	$ffff,$fffe

klossno:
dc.w [4*5*8*4]*3
klosspos:
dc.w 0
feilno:
dc.w 0

tklossno:
dc.w [4*5*8*4]*4
tklosspos:
dc.w 0
a_klossno:
dc.w [4*5*8*4]*3
a_klosspos:
dc.w 0
a_feilno:
dc.w 0

a_tklossno:
dc.w [4*5*8*4]*4
a_tklosspos:
dc.w 0
b_klossno:
dc.w 0
b_klosspos:
dc.w 0
b_feilno:
dc.w 0

b_tklossno:
dc.w [4*5*8*4]*4
b_tklosspos:
dc.w 0

blitup:
clr.l	d0
move	klosspos,d3
move	d3,d0
add.l	screen,d0
clr.l	d1
move	klossno,d1
add	turnament,d1
add.l	#pointers,d1

lsl	#3,d3
move	extrapos,d7
lsr	#8,d7
or	d7,d3
lsl	#4,d3
lsl	#8,d3
or	#%0000101101011010,d3
move	d3,$dff040

move	#40-6,$dff066
move	#10,$dff064
move	#40-6,$dff060
move	#0,$dff042

move	#4,d6
move	#-1,$dff044
move	#0,$dff046

bul1:
move.l	d1,$dff050
move.l	d0,$dff054
move.l	d0,$dff048

move	#3+[64*32],$dff058
wf1:
btst	#14,$dff002
bne.S	wf1

add.l	#[16*224],d1
add.l	#[40*256],d0

dbra	d6,bul1
rts

test:
clr.l	d0
move	tklosspos,d3
move	d3,d0
add.l	screen,d0
clr.l	d1
move	tklossno,d1
add	tturnament,d1
add.l	#pointers,d1

lsl	#3,d3
move	textrapos,d7
lsr	#8,d7
or	d7,d3
lsl	#4,d3
lsl	#8,d3
or	#%0000101010100000,d3
move	d3,$dff040

move	#40-6,$dff066
move	#10,$dff064
move	#40-6,$dff060
move	#0,$dff042

move	#-1,$dff044
move	#0,$dff046

move	#1,d7
					add.l	#[224*16],d1

glasnost:


move.l	d1,$dff050
move.l	d0,$dff048

move	#3+[64*32],$dff058
add.l	#[256*40],d0
sub.l	#[16*224],d1

btst	#13,$dff002
beq.S	nosucc
dbra	d7,glasnost
bra.S	success
nosucc:

clr	succ
move	klossno,tklossno
move	klosspos,tklosspos
move	turnament,tturnament
move	extrapos,textrapos

bra.s	nosuccess

success:
move	#-1,succ
move	textrapos,extrapos
move	tklossno,klossno
move	tklosspos,klosspos
move	tturnament,turnament

nosuccess:
rts

fadeout:
move.l	#16,d0

owfl1:
cmp.b	#10,$dff006
bne.S	owfl1
btst	#0,$dff005
bne.S	owfl1

move	#17,d1
sub	d0,d1
add.b	d1,copperwait

lea	$dff180,a1
lea	palette+2,a0
move	#31,d1
clr.l	d2
clr.l	d3
clr.l	d4

ofl1:
move	(a0),d2
move	d2,d3
move	d3,d4
and	#$f,d4
and	#$f0,d3
and	#$f00,d2

mulu	d0,d2
mulu	d0,d3
mulu	d0,d4
lsr	#4,d2
lsr	#4,d3
lsr	#4,d4
and	#$f,d4
and	#$f0,d3
and	#$f00,d2

or	d4,d3
or	d3,d2
move	d2,(a1)+
addq.l	#4,a0
dbra	d1,ofl1

sub	#1,d0
cmp	#0,d0
bne.S	owfl1

clr	bplcon0
move.b	#$2c,copperwait
rts

setupnew:
bsr.L	randomnum

and	#%111,d0
cmp	#7,d0
beq.S	setupnew

clr	textrapos
clr	extrapos
clr	turnament
clr	linesfound

mulu	#[16*4*8],d0

bsr.L	clrnext

move	d0,klossno
move	#5+[40*8],klosspos
bsr.L	blitup

add	#1,score

move	ns,d0
move	klossno,ns
move	d0,klossno

move	#5+[40*8*5],klosspos
move	klosspos,tklosspos
move	klossno,tklossno
add	#1,rcs
move	rcs,countspeed
clr	feilno
clr	tturnament
bsr.L	test

move	#-1,newing
rts

sn2:
clr	newing

tst	succ
beq.L	gameover

*	fix statistics...

rtoc:
rts
clr.l	d0
move	klossno,d0
divu	#[16*4*8],d0
move	d0,d7
ext.l	d0
lsl	#2,d0
move.l	stats,a0
add.l	d0,a0

move.l	screen,a1
move	(a0)+,d0
ext.l	d0
add.l	d0,a1
add.l	#[40*8*26],a1
add	#1,(a0)
move	(a0),d0
mulu	#40,d0
ext.l	d0
sub.l	d0,a1

move.b	#%11111111,(a1)
move.b	#%01111111,40(a1)
move.b	#%10000000,[40*256](a1)
move.b	#%11000000,[40*257](a1)
move.b	#%00111111,80(a1)
move.b	#%11111100,[40*258](a1)
move.b	#%11111111,[40*256*2](a1)

move	#0,d0
add.l	#[2*40*256],a1
add	#1,d7

rclq:
clr.b	d1
btst	d0,d7
beq.S	nset
move.b	#-1,d1
nset:
move.b	d1,(a1)
add.l	#[40*256],a1

addq	#1,d0
cmp	#3,d0
bne.S	rclq

bsr.L	typescore
rts

count:
dc.w	256

countspeed:
dc.w	0

rcs:
dc.w	[256*8]/24

stick:
dc.w	0

succ:
dc.w	0

turnament:
dc.w	0
tturnament:
dc.w	0

wfr:
dc.w	0
a_count:
dc.w	256

a_countspeed:
dc.w	0

a_rcs:
dc.w	[256*8]/24

a_succ:
dc.w	0

a_turnament:
dc.w	0
a_tturnament:
dc.w	0

a_wfr:
dc.w	0
b_count:
dc.w	256

b_countspeed:
dc.w	0

b_rcs:
dc.w	[256*8]/24

b_succ:
dc.w	0

b_turnament:
dc.w	0
b_tturnament:
dc.w	0

b_wfr:
dc.w	0

gameover:
bsr.L	clrnext
move.l	screen,d6
add.l	#2+[40*8*20],d6
lea	game,a0
move	#-1,d4
move	#1,d7
bsr.L	type
move.l	screen,d6
add.l	#4+[40*8*20]+[40*20],d6
lea	over,a0
move	#4,d7
bsr.L	type




lea	recscores,a0
move	nrs,d0
lsl	#2,d0
add	d0,a0

tst	gamestate
bne	nopn

move	#10,(a0)
cmp	#7,fb
bne	nopn2
move	#11,(a0)
bra	nopn2

nopn:
cmp	#3,gamestate
beq	nopn3
move	p1n,(a0)
cmp	#7,fb
beq	nopn2
move	p2n,(a0)

nopn2:

move	score,2(a0)
add	#1,nrs


nopn3:

move	fb,d0
bclr	d0,superin

addq.l	#4,a7
bra.L	finished

game:
dc.b	'GAME',0
over:
dc.b	'OVER',0

realdpos:
dc.w	0

testlines:
clr	linesfound

move.l	screen,d0
add.l	#2+[40*8*7],d0
move.l	screen,d4
add.l	#2+[40*8*7]+[256*40],d4
move	#18,d1

tll:
move	#%110000000011,$dff040
move	#0,$dff042
move.l	#-1,$dff044
move.l	d0,$dff048+4
move.l	d4,$dff048+8
move	#5+64,$dff058
wf3:
btst	#14,$dff002
bne.S	wf3

btst	#13,$dff002
bne.L	emptyline
contls:
add.l	#[40*8],d0
add.l	#[40*8],d4
dbra	d1,tll

tst.l	emptying
beq.L	nolines
move	linesfound,d0
sub	#1,d0
move	d0,d5
mulu	#20,d0
add	d0,score

move	#5,d0
bsr	mseff

move	#500,d0
vv:
dbra	d0,vv

sub	#1,d5
bmi.L	finished
lsl	#2,d5
lea	nums,a0
move.l	(a0,d5.w),a0
move.l	screen,d6
add.l	#[40*8],d6
move	#0,d7
move	#0,d4
bsr.L	type

bra.L	finished

emptyline:
movem.l	d0-d7/a0-a6,-(a7)
add	#1,linesfound
add	#10,score
add	#1,lines
tst	linesleft
bmi.S	stillok
sub	#1,linesleft
bpl.S	stillok
clr	linesleft
stillok:

move	#20,d0
sub	d1,d0

lea	emptying,a0
move	#31,d2
sub	d1,d2
lsr	#3,d2
bset	d1,(a0,d2.w)

move.l	screen,a0
add.l	#[40*8*6]-38,a0
mulu	#40*8,d0
add	d0,a0

cmp.l	#[20*40*8],d0
beq.L	bottomline

*	a0 peker på bånn' av linja over.

move	#9,d6
repl:
tst.b	-80(a0)
beq.S	ntop
btst	#7,-79(a0)
beq.S	fullrep
move.b	#0,-40(a0)
move.b	#0,(a0)
move.b	#-1,255*40(a0)
move.b	#-1,256*40(a0)
bra.S	ntop
fullrep:
move.b	#%00000011,-40(a0)
move.b	#%00000001,(a0)
move.b	#%11111110,255*40(a0)
move.b	#%11111111,256*40(a0)
ntop:
tst.b	120(a0)
beq.S	nbot
btst	#0,[256*40]+119(a0)
beq.S	fullrep2
move.b	#-1,40(a0)
move.b	#-1,80(a0)
move.b	#0,[257*40](a0)
move.b	#0,258*40(a0)
bra.S	nbot
fullrep2:
move.b	#%11111111,40(a0)
move.b	#%01111111,80(a0)
move.b	#%10000000,257*40(a0)
move.b	#%11000000,258*40(a0)
nbot:
addq.l	#1,a0
dbra	d6,repl

bottomline:

move	#19,d0
sub	d1,d0
move.l	screen,a0
add.l	#[40*8*6]-38,a0
mulu	#40*8,d0
add	d0,a0

*	a0 peker på bånn' av linja over.

move	#9,d6
krepl:
tst.b	-80(a0)
beq.S	kntop
btst	#7,-79(a0)
beq.S	kfullrep
move.b	#0,-40(a0)
move.b	#0,(a0)
move.b	#-1,255*40(a0)
move.b	#-1,256*40(a0)
bra.S	kntop
kfullrep:
move.b	#%00000011,-40(a0)
move.b	#%00000001,(a0)
move.b	#%11111110,255*40(a0)
move.b	#%11111111,256*40(a0)
kntop:
tst.b	120(a0)
beq.S	knbot
btst	#0,[256*40]+119(a0)
beq.S	kfullrep2
move.b	#-1,40(a0)
move.b	#-1,80(a0)
move.b	#0,[257*40](a0)
move.b	#0,258*40(a0)
bra.S	knbot
kfullrep2:
move.b	#%11111111,40(a0)
move.b	#%01111111,80(a0)
move.b	#%10000000,257*40(a0)
move.b	#%11000000,258*40(a0)
knbot:
addq.l	#1,a0
dbra	d6,krepl

move	#19,d0
sub	d1,d0
move.l	screen,a0
add.l	#2+[6*40*8],a0
mulu	#40*8,d0
add	d0,a0
move	#2,d7
add.l	#[40*256],a0

klp:
add.l	#[40*256],a0
move.l	a0,$dff048+12
move	#%000111110000,$dff040
move	#0,$dff074
move	#30,$dff066
move	#0,$dff042
move	#5+[64*8],$dff058
wfb:
btst	#14,$dff002
bne.S	wfb
dbra	d7,klp

move	#24,kc
movem.l	(a7)+,d0-d7/a0-a6
bra.L	contls


empty:
sub	#1,kc
bne.S	bra

move	linesfound,d0
sub	#1,d0
ext.l	d0

bsr	mseff

move	#31,d1

knokk:
lea	emptying,a0
move	#31,d2
sub	d1,d2
lsr	#3,d2
btst	d1,(a0,d2.w)
beq.S	noknock
bclr	d1,(a0,d2.w)
bsr.L	dock

noknock:
dbra	d1,knokk

add	#5,shake

bra.L	finished

bra:
*	color	1

move	kc,d0
cmp	#16,d0
ble.S	sub1
move	#15,d0
bra.S	nosub
sub1:
sub	#1,d0
nosub:
move	d0,d1
lsl	#4,d1
or	d1,d0
lsl	#4,d1
or	d1,d0
move	d0,lowcol+2

*	color	2

move	kc,d0
sub	#9,d0
bpl.S	nund
move	#0,d0
nund:
move	d0,d1
lsl	#4,d1
or	d1,d0
lsl	#4,d1
or	d1,d0
move	d0,lowcol+6

*	color	3

move	kc,d0
sub	#5,d0
bpl.S	nunde
move	#0,d0
nunde:
cmp	#15,d0
ble.S	nanm
move	#15,d0
nanm:
move	d0,d1
lsl	#4,d1
or	d1,d0
lsl	#4,d1
or	d1,d0
move	d0,lowcol+10

bra.L	finished

dock:
movem.l	d0-d7/a0-a6,-(a7)

sub	#5,shake
move.l	screen,d0
move.l	screen,d2
add.l	#10+[40*8*8]-40,d0
add.l	#10+[40*8*9]-40,d2
move	#17,d3
move	d1,d7
sub	d1,d3
lsl	#3,d3
move	d3,d4
mulu	#40,d4
ext.l	d4
add.l	d4,d0
add.l	d4,d2
add	#16,d3
lsl	#6,d3
add	#5,d3
move	#4,d1
pdl:
move	#30,$dff066
move	#30,$dff064
move	#%100111110000,$dff040
move	#%10,$dff042
move.l	d0,$dff048+8
move.l	d2,$dff048+12
move.l	#-1,$dff044
move	d3,$dff058
wf4:
btst	#14,$dff002
bne.S	wf4
add.l	#[40*256],d0
add.l	#[40*256],d2
dbra	d1,pdl
movem.l	(a7)+,d0-d7/a0-a6
rts



*16 tilfeldige tall mellom 0 og 255

rp:
dc.w	0
a_rp:
dc.w	0
b_rp:
dc.w	0
randomtable:
dc.b	249,26,4,199,141,158,245,140,205,208,33,207,216,215,151,68
dc.b	201,60,15,43,170,13,98,191,88,253,91,148,218,66,242,218,97

even

a_rn:
dc.w	0
b_rn:
dc.w	0

randomnum:
move	rn,d0
lea	randomtable,a0
clr.l	d1
move	rp,d1
add.l	d1,a0
move.b	(a0)+,d2
lsl	#8,d2
move.b	(a0)+,d2
add	#1,rp
cmp	#31,rp
ble	nrr
clr	rp
nrr:
move	d0,d3
eor	d2,d0
ror.b	d3,d0
move	d0,rn
rts

a_score:
dc.w	0
b_score:
dc.w	0

ns:
dc.w	0
a_ns:
dc.w	0
b_ns:
dc.w	0

clrnext:
move.l	screen,d2
add.l	#[40*8],d2
move	#26,$dff060+6
move	#0,$dff074
move	#%000111110000,$dff040
move	#0,$dff042
move	#4,d1

cln:
move.l	d2,$dff048+12
move	#7+[64*4*8],$dff058
wfz:
btst	#14,$dff002
bne.S	wfz
add.l	#[40*256],d2
dbra	d1,cln

rts

score:
dc.w	0

lines:
dc.w	0

kc:
dc.w	0

emptying:
dc.l	0

screen:
dc.l	playfield

a_lines:
dc.w	0

a_kc:
dc.w	0

a_emptying:
dc.l	0

a_screen:
dc.l	playfield

b_lines:
dc.w	0

b_kc:
dc.w	0

b_emptying:
dc.l	0

b_screen:
dc.l	playfield+$1a

stats:
dc.l	a_stats

for_a:
move	upflag,b_upflag
move	linesfound,b_linesfound
move	newing,b_newing
move	linesleft,b_linesleft
move	timeleft,b_timeleft
move	extrapos,b_extrapos
move	textrapos,b_textrapos
move	ndir,b_ndir
move	dir,b_dir
move	ns,b_ns
move	score,b_score
move	lines,b_lines
move	kc,b_kc
move.l	emptying,b_emptying
move	rp,b_rp
move	rn,b_rn
move	wfr,b_wfr
move	tturnament,b_tturnament
move	turnament,b_turnament
move	succ,b_succ
move	rcs,b_rcs
move	countspeed,b_countspeed
move	count,b_count
move	feilno,b_feilno
move	klossno,b_klossno
move	klosspos,b_klosspos
move	tklossno,b_tklossno
move	tklosspos,b_tklosspos

move.b	up,upp
clr	upflag
move	a_linesfound,linesfound
move	a_newing,newing
move	a_linesleft,linesleft
move	a_timeleft,timeleft
move	a_ns,ns
move	a_score,score
move	a_lines,lines
move	a_kc,kc
move.l	a_emptying,emptying
move	a_rp,rp
move	a_rn,rn
move	a_wfr,wfr
move	a_tturnament,tturnament
move	a_turnament,turnament
move	a_succ,succ
move	a_rcs,rcs
move	a_countspeed,countspeed
move	a_count,count
move	a_feilno,feilno
move	a_klossno,klossno
move	a_klosspos,klosspos
move	a_tklossno,tklossno
move	a_tklosspos,tklosspos
move	a_extrapos,extrapos
move	a_textrapos,textrapos
move	a_dir,dir
move.l	#a_stats,stats
move.l	a_stickpo,stickpo
move	#7,fb
move.l	#playfield,screen
rts

for_b:
move	upflag,a_upflag
move	newing,a_newing
move	linesleft,a_linesleft
move	timeleft,a_timeleft
move	extrapos,a_extrapos
move	textrapos,a_textrapos
move	dir,a_dir
move	score,a_score
move	lines,a_lines
move	kc,a_kc
move.l	emptying,a_emptying
move	rp,a_rp
move	rn,a_rn
move	wfr,a_wfr
move	tturnament,a_tturnament
move	turnament,a_turnament
move	succ,a_succ
move	rcs,a_rcs
move	countspeed,a_countspeed
move	count,a_count
move	feilno,a_feilno
move	klossno,a_klossno
move	klosspos,a_klosspos
move	tklossno,a_tklossno
move	tklosspos,a_tklosspos
move	ns,a_ns
move	linesfound,a_linesfound

move.b	up+1,upp
clr	upflag
move	b_linesfound,linesfound
move	b_newing,newing
move	b_linesleft,linesleft
move	b_timeleft,timeleft
move	b_ns,ns
move	b_score,score
move	b_lines,lines
move	b_kc,kc
move.l	b_emptying,emptying
move	b_rp,rp
move	b_rn,rn
move	b_wfr,wfr
move	b_tturnament,tturnament
move	b_turnament,turnament
move	b_succ,succ
move	b_rcs,rcs
move	b_countspeed,countspeed
move	b_count,count
move	b_feilno,feilno
move	b_klossno,klossno
move	b_klosspos,klosspos
move	b_tklossno,tklossno
move	b_tklosspos,tklosspos
move	b_extrapos,extrapos
move	b_textrapos,textrapos
move	b_dir,dir
move.l	#b_stats,stats
move.l	b_stickpo,stickpo
move	#6,fb
move.l	#playfield+$1a,screen
rts

a_linesfound:
dc.w	0
b_linesfound:
dc.w	0

savedef:
move	ns,c_ns
move	lines,c_lines
move	kc,c_kc
move.l	emptying,c_emptying
move	rp,c_rp
move	rn,c_rn
move	wfr,c_wfr
move	tturnament,c_tturnament
move	turnament,c_turnament
move	succ,c_succ
move	countspeed,c_countspeed
move	count,c_count
move	feilno,c_feilno
move	klossno,c_klossno
move	klosspos,c_klosspos
move	tklossno,c_tklossno
move	tklosspos,c_tklosspos
rts

loaddef:
move	#255,volume

move.b	#%11000000,in

move	superin,join
not	join
and	#%1100000000000000,join
move	superin,in
move	superin,on
move	rn,a_rn
move	rn,b_rn
clr	newing
clr	ndir
clr	dir
clr	extrapos
clr	textrapos
clr	a_newing
clr	a_ndir
clr	a_dir
clr	a_extrapos
clr	a_textrapos
clr	b_ndir
clr	b_dir
clr	b_extrapos
clr	b_newing
clr	b_textrapos
add	#1,level
cmp	#19,level
bne.S	nround

move	#1,level

nround:

lea	tili,a0
move	level,d0
sub	#1,d0
lsl	#2,d0
move	(a0,d0.w),c_timeleft
move	2(a0,d0.w),c_linesleft

lea	title,a0
move	level,d0
sub	#1,d0
mulu	#6,d0
ext.l	d0
add.l	d0,a0
move.l	a_screen,d6
add.l	#[16+[8*40]],d6
move	#%1,d7
move	#0,d4
bsr.L	type

move	level,d0
subq	#1,d0
lsl	#1,d0
lea	speeds,a0
move	(a0,d0.w),a_rcs
move	(a0,d0.w),b_rcs
move	(a0,d0.w),rcs

move	level,d0
sub	#1,d0
lsl	#1,d0
lea	winds,a0
move	(a0,d0.w),wind

lea	melody,a0
move	(a0,d0.w),d1
tst	d1
beq.L	samelevel
tst	samelvl
bmi.L	samelevel
bne	slv2

move	d1,-(a7)

tst	mt_on
beq.S	fmoo

pea	fmoo

fademusic:
tst	mt_on
beq	rts

move	#256,d0


fmo:

bsr.L	nextframe
move	d0,volume
move	d0,-(a7)
move	(a7)+,d0
sub	#2,d0
bpl.S	fmo
move	#15,$dff096

move	#40,d0
va:
bsr.L	nextframe
dbra	d0,va
rts

fmoo:

move	(a7)+,d1
slv2:

ext.l	d1
move.l	d1,mt_partnrplay
clr	mt_status
move	#15,$dff096
bsr.L	mt_higher

move.l	mt_partnrplay,d0

divu	#10,d0
clr	d1
lea	preferred,a0
move.b	(a0,d0.w),d1
move	d1,ch3
clr.l	d0
move	d1,d0
lsl	#4,d0
add.l	#$dff0a0,d0
move.l	d0,ch
mulu	#28,d1
ext.l	d1
add.l	#mt_aud1temp+26,d1
move.l	d1,ch2

move	#255,volume

samelevel:

move	c_linesleft,linesleft
move	c_timeleft,timeleft
move	c_ns,ns
move	c_lines,lines
move	c_kc,kc
move.l	c_emptying,emptying
move	c_rp,rp
move	c_tturnament,tturnament
move	c_turnament,turnament
move	c_succ,succ
move	c_countspeed,countspeed
move	c_count,count
move	c_feilno,feilno
move	c_klossno,klossno
move	c_klosspos,klosspos
move	c_tklossno,tklossno
move	c_tklosspos,tklosspos

move	c_linesleft,b_linesleft
move	c_timeleft,b_timeleft
move	c_ns,b_ns
move	c_lines,b_lines
move	c_kc,b_kc
move.l	c_emptying,b_emptying
move	c_rp,b_rp
move	c_tturnament,b_tturnament
move	c_turnament,b_turnament
move	c_succ,b_succ
move	c_countspeed,b_countspeed
move	c_count,b_count
move	c_feilno,b_feilno
move	c_klossno,b_klossno
move	c_klosspos,b_klosspos
move	c_tklossno,b_tklossno
move	c_tklosspos,b_tklosspos
rts

c_ns:dc.w0
c_screen:dc.l0
c_lines:dc.w0
c_kc:dc.w0
c_emptying:dc.l0
c_rp:dc.w0
c_rn:dc.w0
c_wfr:dc.w0
c_tturnament:dc.w0
c_turnament:dc.w0
c_succ:dc.w0
c_countspeed:dc.w0
c_count:dc.w0
c_feilno:dc.w0
c_klossno:dc.w0
c_klosspos:dc.w0
c_tklossno:dc.w0
c_tklosspos:dc.w0

stickpo:
dc.l	0
fb:
dc.w	0

in:
dc.w	%1100000000000000

on:
dc.w	%1100000000000000

testcopy:
cmp	#$8a,testlist2
beq	finaltest
move.b	#%10001010,$bfed01
move.b	#0,$bfee01
move.b	#0,$bfef01
move.b	#-1,$bfe501
move.b	#-1,$bfe401
move.b	#0,$bfe701
move.b	#20,$bfe601
move.b	#%00000001,$bfee01
move.b	#%01001001,$bfef01
move.b	#%01110101,$bfed01
move	#$8a,testlist2
move	#8,$dff09c
movem.l	(a7)+,d0-d7/a0-a6
rte

finaltest:
move	#$180,testlist2

sfcs:
cmp.l	#0,csum
beq	nocopy
cmp	#$5300,$dff010
beq	nocopy
;bra	nocopy	;TEST


copy:
move	#$7fff,$dff09a

msc3:
tst.b	$dff006
bne	msc3
btst	#0,$dff005
bne	msc3
move	#32,$dff096

move	#0,bplcon0

move.l	#medscreenadr,d0
move	#-1,stopcopper

swap	d0
move	d0,e0+2
swap	d0
move	d0,e0+6
add.l	#40*256,d0
swap	d0
move	d0,e0+10
swap	d0
move	d0,e0+14

move	#1,d0
vyy2:
cmp.b	#100,$dff006
bne.s	vyy2
vty2:
cmp.b	#99,$dff006
bne.s	vty2
vtq2:
cmp.b	#98,$dff006
bne.s	vtq2
vvb2:
cmp.b	#97,$dff006
bne.s	vvb2
move	d0,palette+2
add	#1,d0
cmp	#6,d0
bne	vyy2

move	#%111111,$dff096
move	#$ff0,lowcol+2
move	#$884,lowcol+6
move	#$cc2,lowcol+10
move.l	#medscreenadr,$dff048+12
move	#0,$dff066
move	#0,$dff074
move	#%111110000,$dff040
move	#0,$dff042
move	#20+[512*64],$dff058
wbwbw:
btst	#14,$dff002
bne	wbwbw

move.l	#medscreenadr,d6
lea	copytext,a0
clr	d4
move	#32,d7
move	#12,d0

greenmen:
move	#20,d1
ggpok:
eor.b	#"#",(a0)
bclr	#7,(a0)+
dbra	d1,ggpok
sub	#21,a0
bsr	type
move	#20,d1
ggpok2:
eor.b	#$a3,(a0)+
dbra	d1,ggpok2
add.l	#40*18,d6
dbra	d0,greenmen

move	#$2000,bplcon0

bra	johnny

nocopy:
move.b	#%01110111,$bfed01
move.b	#0,$bfee01
move.b	#0,$bfef01
move	#8,$dff09c
movem.l	(a7)+,d0-d7/a0-a6
rte

copytext:;                   ;
dc.b	$83,$83,"bwwfmwjlm",$82,$83,"gjg",$83,"zb",$83,$a3
dc.b	"ojhf",$83,"wkjp",$83,"dbnf",$9c,$83,"tfoo#"
dc.b	$83,$83,"wkfm",$83,"kvqqz",$83,"vs",$83,"bmg",$83,$a3
dc.b	$83,$83,"lqgfq",$83,"bm",$83,"lqjdjmbo",$83,$a3
dc.b	$83,$83,"tjwk",$83,"nbmvbo",$83,"eqln",$83,$83,$a3
blk.b	20,$83
dc.b	$a3
dc.b	$83,$83,"gjdjwbo",$83,"nbqhfwjmd",$83,$a3
dc.b	$83,$83,"hqfefogfq",$83,"pwq",$8d,$83,$92,$95,$83,$a3
dc.b	$83,"g",$8e,$96,$92,$97,$91,$83,"kv`hfoklufm",$8e,$a3
dc.b	$83,$83,$83,$83,$83,$83,$83,$83,$83,$83,$83,$83,$83,$83,$83,$83
dc.b	"abbo#"
dc.b	$83,$83,$83,$83,$83,$83,$83,"dfqnbmz",$83,$83,$83,$83,$83,$83,$a3
blk.b	20,$83
dc.b	$a3
dc.b	$83,$83,$83,"sqj`f",$99,$83,$90,$9a,$8f,$9a,$96,$83,$e7
dc.b	$ee,$83,$83,$a3
even

type:
movem.l	d0-d7/a0-a6,-(a7)
move.l	#$ffff0000,$dff044
move.l	d6,d3

nextl:
clr.l	d0
move.b	(a0)+,d0
tst	d0
beq.L	fover

cmp	#32,d0
bge.S	notco

move	d0,d7
bra.s	nextl

notco:
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

tst	d4
bne.S	bqy
bqn:
move	#%110111000010,$dff040
move	#0,$dff070
bra.s	bqo
bqy:
move	#%111111000010,$dff040
bqo:

move	#38,$dff060
move	#38,$dff062
move	#38,$dff064
move	#38,$dff066
move.l	#-1,$dff044
move	#0,$dff042

move	#1,d5
bl2f:
move.l	d2,$dff048+4
move.l	d0,$dff048+8
move.l	d6,$dff048
move.l	d6,$dff048+12
move	#1+[64*24],$dff058
add.l	#[72*40],d0
add.l	#[40*256],d6
wfpq:
btst	#14,$dff002
bne.s	wfpq
dbra	d5,bl2f

add.l	#[72*40],d0
move.l	d2,$dff04c

move	#38,$dff060
move	#38,$dff062
move	#38,$dff064
move	#38,$dff066
move.l	#-1,$dff044
move	#0,$dff042

move	#0,d5
bl2f2:

move	#%111111000010,$dff040

btst	d5,d7
bne.S	nbg

move	#%111100000010,$dff040

nbg:

tst	d4
bne.S	keepb

move	#%111111000000,$dff040

btst	d5,d7
bne.S	keepb

move	#%111100000000,$dff040

keepb:

move.l	d2,$dff048+4
move.l	d0,$dff048+8
move.l	d6,$dff048
move.l	d6,$dff048+12
cmp	#32,d7
beq	ohoh
move	#1+[64*24],$dff058
ohoh:
add.l	#[40*256],d6
wfpq2:
btst	#14,$dff002
bne.s	wfpq2
addq	#1,d5
cmp	#3,d5
bne.S	bl2f2

addq.l	#2,d3
move.l	d3,d6

bra.L	nextl

fover:
movem.l	(a7)+,d0-d7/a0-a6
rts

johnny:
nop
nop
jimmi:
bra	jimmi

asciiscore:
dc.b	"00000",0
even

linesfound:
dc.w	0

nums:
dc.l	one,two,tre

one:
dc.b	'DOUBLE!',0
two:
dc.b	'TRIPLE!',0
tre:
dc.b	'QUAD!!!',0

a_stats:
dc.w	13,0,14,0,15,0,16,0,17,0,18,0,19,0
b_stats:
dc.w	0,0,-1,0,-2,0,-3,0,-4,0,-5,0,-6,0


keyboard:
movem.l	d0-d7/a0-a6,-(a7)

btst	#1,$bfed01
bne	testcopy

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


move.b	#%1000101,$bfee01
move.b	#-1,$bfec01
move.b	#%10001,$bfee01

move.b	$bfed01,soppel
move	#8,$dff09c

movem.l	(a7)+,d0-d7/a0-a6
rte

oldkeyb:
jmp	2920

keys:
blk.b	128,0

ndir:
dc.w	0
dir:
dc.w	0
extrapos:
dc.w	0
textrapos:
dc.w	0
a_ndir:
dc.w	0
a_dir:
dc.w	0
a_extrapos:
dc.w	0
a_textrapos:
dc.w	0
b_ndir:
dc.w	0
b_dir:
dc.w	0
b_extrapos:
dc.w	0
b_textrapos:
dc.w	0


linesleft:
dc.w	20
timeleft:
dc.w	0
a_linesleft:
dc.w	20
a_timeleft:
dc.w	0
b_linesleft:
dc.w	20
b_timeleft:
dc.w	0
c_linesleft:
dc.w	0
c_timeleft:
dc.w	0

tili:
dc.w	300,3		;level 1a
dc.w	600,6		;level 1b
dc.w	900,9		;level 1c
dc.w	1200,12		;level 1d
dc.w	1500,15		;level 1e
dc.w	1800,18		;level 1f

dc.w	2000,5		;level 2a
dc.w	3000,10		;level 2b
dc.w	5000,10		;level 2c
dc.w	2000,15		;level 2d
dc.w	7000,7		;level 2e
dc.w	7000,10		;level 2f

dc.w	5000,15		;level 3a
dc.w	5000,20		;level 3b
dc.w	6000,15		;level 3c
dc.w	6000,15		;level 3d
dc.w	8000,10		;level 3e
dc.w	8000,15		;level 3f

blk.l	2,0
dc.w	-1,-1		;trad
dc.w	4000,-1		;time1
dc.w	8000,-1		;time2
title:
dc.b	%001,' 1A ',0
dc.b	%001,' 1B ',0
dc.b	%011,' 1C ',0
dc.b	%001,' 1D ',0
dc.b	%001,' 1E ',0
dc.b	%011,' 1F ',0

dc.b	%111,' 2A ',0
dc.b	%111,' 2B ',0
dc.b	%101,' 2C ',0
dc.b	%111,' 2D ',0
dc.b	%111,' 2E ',0
dc.b	%101,' 2F ',0

dc.b	%100,' 3A ',0
dc.b	%100,' 3B ',0
dc.b	%110,' 3C ',0
dc.b	%100,' 3D ',0
dc.b	%100,' 3E ',0
dc.b	%110,' 3F ',0
blk.b	2*6,0
dc.b	%111,'TRAD',0
dc.b	%101,'TIME',0
dc.b	%101,'TIME',0

superin:
dc.w	%0000000000000000
join:
dc.w	%1100000000000000


joinn:
dc.b	'JOIN',0
inn:
dc.b	' IN',0
any:
dc.b	'ANY-',0
time:
dc.b	'TIME!',0
even

hinders:
dc.w	-1
dc.w	-1
dc.w	-1
dc.w	-1
dc.w	-1
dc.w	-1
dc.w	0
dc.w	0
dc.w	10
dc.w	10
dc.w	20
dc.w	20
dc.w	0
dc.w	0
dc.w	10
dc.w	10
dc.w	20
dc.w	20
blk.w	2,-1
dc.w	-1,-1,-1

wind:
dc.w	256

winds:
dc.w	0,0,0,0,0,0,0,0,0,0,0,0,256,192,128,96,64,0
blk.w	11,0
dc.w	0,0,0

melody:
dc.w	-1,0,9,0,19,0,30,0,39,0,63,0,52,0,73,0,81,0
blk.w	2,0
dc.w	63,39,30

sprite_a1:
dc.w	$6658,$6600
dc.w	0,0
dc.w	0,0
pl01a:
blk.w	135*2,0

sprite_b1:
dc.w	$66c0,$6600
dc.w	0,0
dc.w	0,0
pl01b:
blk.w	135*2,0

sine11:
dc.b	0,0,69,116,126,96,36,-36,-97,-127,-117,-70
sinepos:
dc.l	sine11+1

shake:
dc.w	0

dummy:
dc.l	0

layer1:
dc.w	$d0,$70
blk.l	24,0
layer2:
dc.w	0,0,$e0,$70
blk.l	24,0
layer3:
dc.w	0,0,$f0,$70
blk.l	24,0
layer4:
dc.w	0,0,$100,$70
blk.l	24,0
layer5:
dc.w	0,0,$110,$70
blk.l	24,0
layer6:
dc.w	0,0,$120,$70
blk.l	24,0
dc.w	0,0

positions:
dc.w	$e8,$70
dc.w	$100,$70
dc.w	$110,$70
dc.w	$120,$70
dc.w	$130,$70
dc.w	$140,$70


initsprites:

lea	dms,a0
move.l	#layer1,d0
move	#5,d1
ss1:
swap	d0
move	d0,2(a0)
swap	d0
move	d0,6(a0)
add.l	#4+100,d0
add.l	#8,a0
dbra	d1,ss1

move	#5,d0
move	gamestate,d1
lea	sptexts,a0
lsl	#2,d1
move.l	(a0,d1.w),a0
lea	layer1+4,a1
clr.l	d2

mnqnb:
move.b	(a0)+,d2
sub.b	#32,d2
ext	d2
divu	#20,d2
move	d2,d3
swap	d2
lsl	#1,d2
mulu	#[24*40],d3
add	d3,d2
move.l	#font,a2
ext.l	d2
add.l	d2,a2

move	#23,d7
an:
move	(a2),(a1)+
move	[72*40](a2),(a1)+
add.l	#40,a2
dbra	d7,an
add.l	#8,a1
dbra	d0,mnqnb

rts

fixpos:
movem.l	d0-d7/a0-a6,-(a7)
lea	layer1,a0
lea	positions,a1
move	#5,d0

qqbv:
move	(a1)+,d1
ror	#1,d1
move.b	d1,1(a0)
rol	#1,d1
and	#1,d1
move	(a1)+,d2
add.b	copperwait,d2
sub.b	#$2c,d2
move.b	d2,(a0)
move	d2,d3
lsr	#6,d3
and	#%100,d3
or	d3,d1

add	#24,d2
move.b	d2,2(a0)
lsr	#7,d2
and	#2,d2
or	d2,d1
move.b	d1,3(a0)
add.l	#104,a0
dbra	d0,qqbv
movem.l	(a7)+,d0-d7/a0-a6
rts

sptexts:
dc.l	te0,te1,te2,te3

te0:
dc.b	"ARCADE"
te1:
dc.b	"COMPO "
te2:
dc.b	"CUP   "
te3:
dc.b	"DEMO  "

movesprites:
movem.l	d0-d7/a0-a6,-(a7)
lea	positions,a0
move	#5,d0
lea	sinetable,a1
move	tablepos,d1

msl:
move	24(a1,d1.w),d2
add	#280,d2
move	d2,(a0)+

move	(a1,d1.w),d2
add	#$80,d2
move	d2,(a0)+

add	#14,d1
add	#14,d7

dbra	d0,msl

movem.l	(a7)+,d0-d7/a0-a6

sub	#2,tablepos
bpl.S	rts
move	#98,tablepos

rts:
rts

tablepos:
dc.w	0

sinetable:
dc.w	0,7,13,20,26,32,38,43,47,50,53,55,55,55,55,53,50,47
dc.w	43,38,32,27,20,14,7,0,-7,-14,-21,-27,-33,-39,-44,-48
dc.w	-51,-54,-55,-56,-56,-56,-54,-51,-48,-44,-39,-34,-28,-21,-15,-8
dc.w	0,7,13,20,26,32,38,43,47,50,53,55,55,55,55,53,50,47
dc.w	43,38,32,27,20,14,7,0,-7,-14,-21,-27,-33,-39,-44,-48
dc.w	-51,-54,-55,-56,-56,-56,-54,-51,-48,-44,-39,-34,-28,-21,-15,-8

ydiff:
dc.w	0


speeds:
dc.w	88,100,113,140,163,200
dc.w	250,263,270,275,280,285
dc.w	290,295,300,305,310,320
blk.w	2,0
dc.w	88,300,400

rbutt:
dc.w	0

; -----------------------------------------------------
; ------- D.O.C Soundtracker V2.3 - playroutine -------
; -----------------------------------------------------
; ---- Improved and optimized by  Unknown of D.O.C ----
; --------- Based on the playroutine from TJC ---------
; -----------------------------------------------------

mt_init:
bset	#1,$bfe001

;				FIND CHECKSUM FOR CODE!
lea	beg,a0
move	#[[end-beg]/4]-1,d0
clr.l	d1
fcl:
add.l	(a0)+,d1
dbra	d0,fcl
sub.l	sfcs+2,d1
tst.l	csum
bne.s	nvgvvg
move.l	d1,csum
nvgvvg:

	lea	mt_data,a0
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

mt_musica:
move	#$10,$dff09c

movem.l	d0-d7/a0-a6,-(a7)
sub	#1,ch1occ
bpl	chsocc1
clr	ch1occ
chsocc1:

sub	#1,ch2occ
bpl	chsocc2
clr	ch2occ
chsocc2:

sub	#1,ch3occ
bpl	chsocc3
clr	ch3occ
chsocc3:

sub	#1,ch4occ
bpl	chsocc4
clr	ch4occ
chsocc4:

bsr	movesprites
bsr	fixpos
tst	mt_on
beq.L	rte_iii
bsr.L	mt_music
rte_iii:
bsr	setvolume

sub	#2,cp1+2
bpl	nr1
clr	cp1+2
nr1:

sub	#2,cp2+2
bpl	nr2
clr	cp2+2
nr2:

sub	#2,cp3+2
bpl	nr3
clr	cp3+2
nr3:

sub	#2,cp4+2
bpl	nr4
clr	cp4+2
nr4:

move	volume,d0
lsr	#4,d0
cmp	#16,d0
blt	nggg
move	#15,d0
nggg:


btst	#0,sch+1
beq	nc1
move	d0,cp1+2
nc1:

btst	#1,sch+1
beq	nc2
move	d0,cp2+2
nc2:

btst	#2,sch+1
beq	nc3
move	d0,cp3+2
nc3:

btst	#3,sch+1
beq	nc4
move	d0,cp4+2
nc4:
clr	sch

movem.l	(a7)+,d0-d7/a0-a6

rte_ii:
rte

mt_music:

	addq.w	#1,mt_counter
mt_cool:cmp.w	#6,mt_counter
	bne.s	mt_notsix
	clr.w	mt_counter
	bra.L	mt_rout2

mt_notsix:
	lea	mt_aud1temp(PC),a6
	tst.b	3(a6)
	beq.s	mt_arp1
	tst	ch1occ
	bne	mt_arp1
	lea	$dff0a0,a5		
	bsr.s	mt_arprout
mt_arp1:lea	mt_aud2temp(PC),a6
	tst.b	3(a6)
	beq.s	mt_arp2
	tst	ch2occ
	bne	mt_arp2
	lea	$dff0b0,a5
	bsr.s	mt_arprout
mt_arp2:lea	mt_aud3temp(PC),a6
	tst.b	3(a6)
	beq.s	mt_arp3
	tst	ch3occ
	bne	mt_arp3
	lea	$dff0c0,a5
	bsr.s	mt_arprout
mt_arp3:lea	mt_aud4temp(PC),a6
	tst.b	3(a6)
	beq.s	mt_arp4
	tst	ch4occ
	bne	mt_arp4
	lea	$dff0d0,a5
	bra.s	mt_arprout
mt_arp4:rts

mt_arprout:
	move.b	2(a6),d0
	and.b	#$0f,d0
	tst.b	d0
	beq.L	mt_arpegrt
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
mt_ok4:	move	d7,-(a7)
move.w	18(a6),d7
move.l	a5,a4
add.l	#volumes-$dff0a0,a4
and	#127,d7
mulu	volume,d7
lsr	#8,d7
move	d7,8(a5)
move	d7,(a4)
move	(a7)+,d7
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
	bsr.L	mt_playit
	addq.l	#4,d1
	lea	$dff0b0,a5
	lea	mt_aud2temp(PC),a6
	bsr.L	mt_playit
	addq.l	#4,d1
	lea	$dff0c0,a5
	lea	mt_aud3temp(PC),a6
	bsr.L	mt_playit
	addq.l	#4,d1
	lea	$dff0d0,a5
	lea	mt_aud4temp(PC),a6
	bsr.L	mt_playit
	addq.l	#4,d1
	move.w	#$01f4,d0
mt_rls:	dbf	d0,mt_rls

	move.w	#$8000,d0
	or.w	mt_dmacon,d0
	move.w	d0,$dff096

	lea	mt_aud4temp(PC),a6
tst	26(a6)
bne	mt_voice3
	cmp.w	#1,14(a6)
	bne.s	mt_voice3
	move.l	10(a6),$dff0d0
	move.w	#1,$dff0d4
mt_voice3:
	lea	mt_aud3temp(PC),a6
tst	26(a6)
bne	mt_voice2
	cmp.w	#1,14(a6)
	bne.s	mt_voice2
	move.l	10(a6),$dff0c0
	move.w	#1,$dff0c4
mt_voice2:
	lea	mt_aud2temp(PC),a6
tst	26(a6)
bne	mt_voice1
	cmp.w	#1,14(a6)
	bne.s	mt_voice1
	move.l	10(a6),$dff0b0
	move.w	#1,$dff0b4
mt_voice1:
	lea	mt_aud1temp(PC),a6
tst	26(a6)
bne	mt_voice0
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
	moveq	#0,d2
	move.b	2(a6),d2
	and.b	#$f0,d2
	lsr.b	#4,d2

	move.b	(a6),d0
	and.b	#$f0,d0
	or.b	d0,d2
tst	26(a6)
bne	mt_nonewper
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
move	d7,-(a7)
	move.w	18(a6),d7
move.l	a5,a4
add.l	#volumes-$dff0a0,a4
and	#127,d7
mulu	volume,d7
lsr	#8,d7
move	d7,8(a5)
move	d7,(a4)
move	(a7)+,d7
	bra.s	mt_nosamplechange

mt_displace:
move	20(a6),d2
or	d2,sch
	move.l	4(a6),d2
	add.l	d3,d2
	move.l	d2,10(a6)
	move.w	6(a3,d4.l),14(a6)
move	d7,-(a7)
	move.w	18(a6),d7
move.l	a5,a4
add.l	#volumes-$dff0a0,a4
and	#127,d7
mulu	volume,d7
lsr	#8,d7
move	d7,8(a5)
move	d7,(a4)
move	(a7)+,d7
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
tst	26(a6)
bne	novol
	cmp.b	#$0c,d0
	beq.s	mt_setvol
novol:
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
move	d7,-(a7)
	move.b	3(a6),d7
move.l	a5,a4
add.l	#volumes-$dff0a0,a4
and	#127,d7
mulu	volume,d7
lsr	#8,d7
move	d7,8(a5)
move	d7,(a4)
move	(a7)+,d7
	rts

mt_break:
	move	#1,mt_status
	rts

mt_setfil:
	moveq	#0,d0
	move.b	3(a6),d0
	and.b	#1,d0
	rol.b	#1,d0
;	and.b	#$fd,$bfe001
;	or.b	d0,$bfe001
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
ch1occ:
dc.w	0
mt_aud2temp:
	blk.w	10,0
	dc.w	2
	blk.w	2,0
ch2occ:
dc.w	0
mt_aud3temp:
	blk.w	10,0
	dc.w	4
	blk.w	2,0
ch3occ:
dc.w	0
mt_aud4temp:
	blk.w	10,0
	dc.w	8
	blk.w	2,0
ch4occ:
dc.w	0

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

;mt_data:	blk.b	0,0

nextframe:
cmp.b	#00,$dff006
beq.S	nextframe
nextframe2:
cmp.b	#00,$dff006
bne.s	nextframe2
btst	#0,$dff005
beq.S	nextframe2
rts

volume:
dc.w	256

sch:
dc.w	0

volumes:
blk.b	16*4,0

setvolume:
tst	ch1occ
bne	nv1
move	volumes,$dff0a8
nv1:
tst	ch2occ
bne	nv2
move	volumes+16,$dff0b8
nv2:
tst	ch3occ
bne	nv3
move	volumes+32,$dff0c8
nv3:
tst	ch4occ
bne	nv4
move	volumes+48,$dff0d8
nv4:
rts

oldvb:
dc.l	0

mt_on:
dc.w	0

eff_on:
dc.w	-1

samelvl:
dc.w	0

medscreen:
cmp	#3,gamestate
beq	rts
msc:
tst.b	$dff006
bne	msc
btst	#0,$dff005
bne	msc
move	#32,$dff096

move	#0,bplcon0

move.l	#medscreenadr,d0

swap	d0
move	d0,e0+2
swap	d0
move	d0,e0+6
add.l	#40*256,d0
swap	d0
move	d0,e0+10
swap	d0
move	d0,e0+14

move	#1,d0
vyy:
cmp.b	#100,$dff006
bne	vyy
vty:
cmp.b	#99,$dff006
bne	vty
vtq:
cmp.b	#98,$dff006
bne	vtq
vvb:
cmp.b	#97,$dff006
bne	vvb
move	d0,palette+2
add	#1,d0
cmp	#6,d0
bne	vyy

move	#$ff0,lowcol+2
move	#$884,lowcol+6
move	#$cc2,lowcol+10
move.l	#medscreenadr,$dff048+12
move	#0,$dff066
move	#0,$dff074
move	#%111110000,$dff040
move	#0,$dff042
move	#20+[512*64],$dff058

vww:
btst	#14,$dff002
bne	vww

move	p1n,d0
mulu	#20,d0
lea	top,a0
move	a_score,12(a0,d0.w)

move	p2n,d0
mulu	#20,d0
move	b_score,12(a0,d0.w)

cmp	#1,gamestate
beq	tourn

cup:

tst	round
beq	nomezz

move	a_score,d0

cmp	b_score,d0
beq	pconfok
bgt	nomezz

move	p1n,d1
move	p2n,d2
mulu	#20,d1
mulu	#20,d2
lea	top,a0
move	#9,d0
vbt:
move	(a0,d1),d3
move	(a0,d2),(a0,d1)
move	d3,(a0,d2)
addq.l	#2,a0
dbra	d0,vbt

move	nrs,d0
subq	#1,d0
bmi	nomezz
lea	recscores,a0

move	p1n,d1
move	p2n,d2

crs:
cmp	(a0),d1
bne	np1
move	d2,(a0)
bra	np2
np1:
cmp	(a0),d2
bne	np2
move	d1,(a0)
np2:
addq.l	#4,a0
dbra	d0,crs

nomezz:
move	players,d0
sub	#1,d0
lsl	#2,d0
lea	cups,a0

move.l	(A0,d0.w),a0
move	round,d0
lsl	#1,d0
tst.b	(a0,d0.w)
bmi	champ
tst	round
beq	vn
bsr	winner
vn:
move.b	(a0,d0.w),p1n+1
move.b	1(a0,d0.w),p2n+1
add	#1,round

bra	pconfok

tourn:
move	round,d0
add	#1,round
lsl	#1,d0
cmp	players,d0
bge	findchamp

move	d0,p1n
addq	#1,d0

cmp	players,d0
blt	normal


cmp	#1,players
beq	make1player

lea	top+12,a0
move	players,d1
subq	#2,d1
move	#20000,d2
clr	d3
hingg:
cmp	(a0),d2
blt	hurp
move	(a0),d2
move	d3,d0
hurp:
addq	#1,d3
add.l	#20,a0
dbra	d1,hingg



normal:


move	d0,p2n


pconfok:
move	#0,credits
move	#0,join
move.b	#%11000000,on
move.b	#%11000000,in
move.b	#%11000000,superin
pof2:

move	p1n,d0
mulu	#20,d0
lea	top,a0

move	p2n,d0
mulu	#20,d0
lea	top,a0

move.l	#medscreenadr+[40*28],d6
move	#32,d7
move.l	#rol,a0
clr	d4
bsr	type

move.l	#medscreenadr+[40*115],d6
move	#32,d7
move.l	#ror,a0
clr	d4
bsr	type

move	p1n,d0
mulu	#20,d0

ext.l	d0
add.l	#top,d0
move.l	d0,a0
move	#32,d7
move.l	#medscreenadr+[40*52],d6
clr	d4
bsr	type

move	p2n,d0
mulu	#20,d0

ext.l	d0
add.l	#top,d0
move.l	d0,a0
move	#32,d7
move.l	#medscreenadr+[40*139],d6
clr	d4
bsr	type

move.l	#medscreenadr+[40*180],d6
lea	pft,a0
clr	d4
move	#32,d7
bsr	type

move.l	#medscreenadr+[40*204],d6
lea	pft2,a0
clr	d4
move	#32,d7
bsr	type

move	#$2000,bplcon0
move	#5000,d0
vnki:
dbra	d0,vnki

jg2:
move.l	a_stickpo,stickpo
bsr	makestick
tst	feuer
bne	jg2

move.l	b_stickpo,stickpo
bsr	makestick
tst	feuer
bne	jg2

jp:
move.l	a_stickpo,stickpo
bsr	makestick
tst	feuer
bne	fout

move.l	b_stickpo,stickpo
bsr	makestick
tst	feuer
beq	jp

clr	tf
kfp:
bsr	makestick
tst	feuer
beq	jp
add	#1,tf
cmp	#15000,tf
bne	kfp

bra	fout2

fout:
clr	tf
kfp2:
bsr	makestick
tst	feuer
beq	jp
add	#1,tf
cmp	#15000,tf
bne	kfp2

fout2:

move	#0,bplcon0
move	#0,lowcol+2
clr	lowcol+6
clr	lowcol+10
clr	palette+2

move.l	a_screen,d0
move	#4,d1
lea	e0+2,a1

ppl12:

move	d0,4(a1)
swap	d0
move	d0,(a1)
swap	d0
add.l	#8,a1

add.l	#[40*256],d0

dbra	d1,ppl12

move	#$8020,$dff096
clr	score
clr	a_score
clr	b_score
rts

tf:
dc.w	0

findchamp:
move.l	#medscreenadr,d6
lea	rlt,a0
clr	d4
move	#32,d7
bsr	type

move.l	#medscreenadr+[40*40],d6

move	#"1.",rank
move	players,d0
sub	#1,d0

move	#$2000,bplcon0

rankl:
move	#-1,d3
veeee:
dbra	d3,veeee
veeee2:
dbra	d3,veeee2
veeee3:
dbra	d3,veeee3

lea	rank,a0
clr	d4
move	#32,d7
bsr	type

move	#0,d1
lea	top,a1
move	players,d3
subq	#1,d3

wgb8:
cmp	12(a1),d1
bgt	snuggle
move	12(a1),d1
move.l	a1,a0
snuggle:
add	#20,a1
dbra	d3,wgb8

clr.l	d3
move	12(a0),d3
clr	12(a0)

add.l	#6,d6
bsr	type

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


add.l	#20,a1
add.l	#10+[23*40],d6

add.b	#1,rank
dbra	d0,rankl

f_jg2:
move.l	a_stickpo,stickpo
bsr	makestick
tst	feuer
bne	f_jg2

move.l	b_stickpo,stickpo
bsr	makestick
tst	feuer
bne	f_jg2

f_jp:
tst.b	keys+$45
bne	f_fout2
move.l	a_stickpo,stickpo
bsr	makestick
tst	feuer
bne	f_fout

move.l	b_stickpo,stickpo
bsr	makestick
tst	feuer
beq	f_jp

clr	tf
f_kfp:
bsr	makestick
tst	feuer
beq	f_jp
add	#1,tf
cmp	#15000,tf
bne	f_kfp

bra	f_fout2

rlt:
dc.b	"RANKING LIST",0
even

f_fout:
clr	tf
f_kfp2:
bsr	makestick
tst	feuer
beq	f_jp
add	#1,tf
cmp	#15000,tf
bne	f_kfp2

f_fout2:

add.l	#4,a7
bra	quit

rank:
dc.b	"1. ",0

make1player:
move	#0,credits
move	#0,join
move.b	#%10000000,on
move.b	#%10000000,in
move.b	#%10000000,superin
move	p1n,p2n
move	#-1,eqc
bra	pof2

credits:
dc.w	5

pft:
dc.b	"KEEP FIRE BUTTON",0
pft2:
dc.b	"PRESSED !  (1 SEC)",0
even

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
move	#-1,upflag
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
bne	rts
move	#-1,feuer
rts
fb6:
btst	#6,$bfe001
bne	rts
move	#-1,feuer
rts

champ:
move.l	#wt,a0
move.l	#medscreenadr+[40*108],d6
clr	d4
move	#32,d7
bsr	type
move	#$2000,bplcon0

move.l	#top,a0
move.l	#medscreenadr+[40*128],d6
clr	d4
move	#32,d7
bsr	type

d_jg2:
move.l	a_stickpo,stickpo
bsr	makestick
tst	feuer
bne	d_jg2

move.l	b_stickpo,stickpo
bsr	makestick
tst	feuer
bne	d_jg2

d_jp:
move.l	a_stickpo,stickpo
bsr	makestick
tst	feuer
bne	d_fout

move.l	b_stickpo,stickpo
bsr	makestick
tst	feuer
beq	d_jp

clr	tf
d_kfp:
bsr	makestick
tst	feuer
beq	d_jp
add	#1,tf
cmp	#15000,tf
bne	d_kfp

bra	d_fout2

d_fout:
clr	tf
d_kfp2:
bsr	makestick
tst	feuer
beq	d_jp
add	#1,tf
cmp	#15000,tf
bne	d_kfp2

d_fout2:

add.l	#4,a7
bra	quit

winner:
movem.l	d0-d7/a0-a6,-(a7)
move.l	#wt,a0
move.l	#medscreenadr+[40*108],d6
clr	d4
move	#32,d7
bsr	type
move	#$2000,bplcon0

move	p1n,d0
mulu	#20,d0
ext.l	d0
lea	top,a0
add.l	d0,a0
move.l	#medscreenadr+[40*128],d6
move	#0,d4
move	#32,d7
bsr	type

e_jg2:
move.l	a_stickpo,stickpo
bsr	makestick
tst	feuer
bne	e_jg2

move.l	b_stickpo,stickpo
bsr	makestick
tst	feuer
bne	e_jg2

e_jp:
move.l	a_stickpo,stickpo
bsr	makestick
tst	feuer
bne	e_fout

move.l	b_stickpo,stickpo
bsr	makestick
tst	feuer
beq	e_jp

clr	tf
e_kfp:
bsr	makestick
tst	feuer
beq	e_jp
add	#1,tf
cmp	#15000,tf
bne	e_kfp

bra	e_fout2

e_fout:
clr	tf
e_kfp2:
bsr	makestick
tst	feuer
beq	e_jp
add	#1,tf
cmp	#15000,tf
bne	e_kfp2

e_fout2:

rtex:
move.l	#medscreenadr,$dff048+12
move	#0,$dff066
move	#0,$dff074
move	#%111110000,$dff040
move	#0,$dff042
move	#20+[512*64],$dff058

v2ww:
btst	#14,$dff002
bne	v2ww

movem.l	(a7)+,d0-d7/a0-a6
rts

wt:
dc.b	'WINNER:',0
rol:
dc.b	"READY ON THE LEFT:",0

ror:
dc.b	"READY ON THE RIGHT:",0

even

p1n:
dc.w	0
p2n:
dc.w	1

eqc:
dc.w	0

feuer:
dc.w	0

recording:
bsr	rms
move	stick,d0
and	#14,d0
tst	feuer
beq	fr
bset	#0,d0
fr:
move.l	recpo,a0
not	recphase

tst	recphase
bne	nrml
lsl	#4,d0
or.b	d0,(a0)
addq.l	#1,recpo
rts
nrml:
move.b	d0,(a0)
rts

readrec:
bra	norecording+[[recording-norecording]*makerecord]

norecording:
move.l	recpo,a0
cmp.l	#record+recordlen-2,a0
bne	nevada
move.b	#-1,keys+$45
nevada:
move.b	(a0),d0
tst	recphase
beq	natural

addq.l	#1,recpo
lsr	#4,d0

natural:
not	recphase

btst	#0,d0
beq	nofeu2
move	#-1,feuer
nofeu2:

and	#%1110,d0
move	d0,stick
rts


makestick:

clr	stick
clr	feuer

cmp	#3,gamestate
beq	readrec

rms:
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

move.b	stickpo+3,d0
tst.b	(a0,d0.w)
beq	f4
move	#-1,feuer
f4:

move.b	upp,d0
tst.b	(a0,d0.w)
beq	rts
move	#-1,upflag
bset	#0,stick+1
rts

seff:
dc.l	sndb		;0 - 1 LINE
dc.w	8496/2,428,50,64,194
dc.l	sndc		;1 - 2 LINES
dc.w	7904/2,428,47,64,196
dc.l	sndd		;2 - 3 LINES
dc.w	14856/2,428,88,64,198
dc.l	sndd		;3 - 4 LINES
dc.w	14856/2,856,176,64,200
dc.l	snde		;4 - TURN
dc.w	4764/2,107,7,64,5
dc.l	sndf		;5 - DISSOLVE
dc.w	1886/2,1028,14,64,7
dc.l	snda		;6 - HIT
dc.w	917,214,5,32,6
dc.l	sndd
dc.w	14856/2,150,40,64,300
;dc.l	sndf		;7 - change
;dc.w	1886/2,500,10,64,300

warp:
dc.w	0
newing:
dc.w	0
a_newing:
dc.w	0
b_newing:
dc.w	0

getout:
dc.w	0

cups:
dc.l	c1,c2,c3,c4,c5,c6,c7,c8,c9

c1:
dc.b	-1
c2:
dc.b	0,1
dc.b	-1
c3:
dc.b	0,1
dc.b	0,2
dc.b	-1
c4:
dc.b	0,1
dc.b	2,3
dc.b	0,2
dc.b	-1
c5:
dc.b	0,1
dc.b	2,3
dc.b	2,4
dc.b	0,2
dc.b	-1
c6:
dc.b	0,1
dc.b	2,3
dc.b	4,5
dc.b	0,2
dc.b	0,4
dc.b	-1
c7:
dc.b	0,1
dc.b	2,3
dc.b	4,5
dc.b	0,2
dc.b	4,6
dc.b	0,4
dc.b	-1
c8:
dc.b	0,1
dc.b	2,3
dc.b	4,5
dc.b	6,7
dc.b	0,2
dc.b	4,6
dc.b	0,4
dc.b	-1
c9:
dc.b	0,1
dc.b	2,3
dc.b	4,5
dc.b	6,7
dc.b	0,2
dc.b	6,8
dc.b	4,6
dc.b	0,4
dc.b	-1
even

psuedo:
dc.l	0

ch:
dc.l	$dff0d0
ch2:
dc.l	ch4occ
ch3:
dc.w	3

mt_state:
dc.w	-1

level:
dc.w	0

preferred:
dc.b	1,1,2,2,1,1,1,1,3

even

round:
dc.w	0

sprio:
dc.w	0
spriv:
dc.w	0

icr:
dc.w	0

upp:
dc.w	0

upflag:
dc.w	0

a_upflag:
dc.w	0

b_upflag:
dc.w	0

csum:
dc.l	0

orn:
dc.w	0
olv:
dc.w	0

recpo:
dc.l	record
recphase:
dc.w	0

oldcrs:
dc.w	0

soppel:
dc.l	0

didlast:
dc.w	0

b:
dc.w	-1

end:

org	top
load	top
dc.b	"SPILLER 1"
blk.b	20-9,0
dc.b	"SPILLER 2"
blk.b	20-9,0

players=top+200
gamestate=top+202
startl=top+204
a_stickpo=top+206
b_stickpo=top+210
up=top+214
rn=top+216
;oldgs
nrs=top+220
recscores=top+222	;must be last

;end

org	players
load	players

dc.w	2
dc.w	3	;0=1/2pl. 1=tournament 2=cup 3=demo
dc.w	0
dc.l	$dff00c
dc.l	$dff00a;$4f4e4d61
dc.w	$3e4c
dc.w	0

end
org	$7f800
load	$7f800

fcsum:
lea	beg,a0
move	#[[end-beg]/4]-1,d0
clr.l	d1
fcl2:
add.l	(a0)+,d1
dbra	d0,fcl2
rts
