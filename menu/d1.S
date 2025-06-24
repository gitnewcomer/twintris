

top=$7f000
a=top-10000
dbt=a-2
track=dbt-11400
tracksync=track-2

org	a
load	a

move	$dff01c,-(a7)
move	#$7fff,$dff09a

bsr	init

bsr	startmotor
move	#160,d0
bsr	seektrack

lea	$40000,a0
bsr	code
bsr	writetrack

;bsr	startmotor
;wa:
;btst	#6,$bfe001
;bne	wa
bra	exit

rft:
dc.w	0

write:
;adr. -> a0  track -> d0  tracks -> d1
movem.l	d0-d7/a0-a6,-(a7)

move	d0,rft

wt:
sub	#1,d1
bmi	rtsres

move	rft,d0
add	#1,rft
bsr	seektrack

move	d1,-(a7)
bsr	code
move	(a7)+,d1

bsr	writetrack

bra	wt


read:
;adr. -> a1  track -> d0  tracks -> d1
movem.l	d0-d7/a0-a6,-(a7)
move	d0,rft

rt:
sub	#1,d1
bmi	rtsres

move	rft,d0
add	#1,rft
bsr	seektrack

bsr	readtrack
move	d1,-(a7)
bsr	dcode
move	(a7)+,d1

bra	rt


rtsres:
movem.l	(a7)+,d0-d7/a0-a6
rts


init:

lea	codes,a0
lea	dcodes,a1
clr	d0
move	#%0101010101010101,d1
nr:
move	d1,(a0)+

cmp	#15,d0
bgt	ndc

move	d1,d2
and	#$ff,d2
move.b	d0,(a1,d2.w)

ndc:

bchg	#0,d1
bchg	#1,d1
beq	nc
bchg	#2,d1
bchg	#3,d1
beq	nc
bchg	#4,d1
bchg	#5,d1
beq	nc
bchg	#6,d1
bchg	#7,d1
beq	nc
bchg	#8,d1
bchg	#9,d1
beq	nc
bchg	#10,d1
bchg	#11,d1
beq	nc
bchg	#12,d1
bchg	#13,d1
beq	nc
bchg	#14,d1
bchg	#15,d1
nc:
addq	#1,d0
cmp	#256,d0
blt	nr




move.b	#%11110111,d1
move	#3,d2
lea	existing,a0

td:
move.b	#%01111111,$bfd100
move.b	d1,$bfd100
move	#5000,d0
n:
dbra	d0,n
move.b	#%11111111,$bfd100
move.b	d1,$bfd100

clr.b	(a0)
move	#1,d0
t35:
move.b	#%11111111,$bfd100
move.b	d1,$bfd100
btst	#5,$bfe001
bne	nex
dbra	d0,t35
move.b	#-1,(a0)

nex:
addq.l	#1,a0

rol.b	#1,d1

dbra	d2,td

move.b	#-1,existing

lea	$dff000,a6

clr	d0
lea	existing+1,a0
lup:
bsr	changedrive
bsr	track0
addq	#1,d0
tst.b	(a0)+
bne	lup

move	#0,d0
bsr	changedrive
rts

existing:
blk.b	4,0
dc.w	0

codes:
blk.w	256,0
dcodes:
blk.b	256,0

code:
lea	codes,a2
lea	track,a1
move	#$15ff,d0

codeword:
clr	d1
move.b	(a0)+,d1
lsl	#1,d1
move	(a2,d1.w),(a1)+
dbra	d0,codeword

rts

dcode:
lea	track,a0
lea	dcodes,a2
move	#$15ff,d0
clr	d1

dcodeword:
move.b	(a0)+,d1
move.b	(a2,d1.w),d2
lsl	#4,d2
move.b	(a0)+,d1
or.b	(a2,d1.w),d2
move.b	d2,(a1)+

dbra	d0,dcodeword

rts

trackno:
dc.w	0


seektrack:
movem.l	d6/d7/a5,-(a7)
and	#$fffe,trackno
move	d0,d2
and	#1,d2
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
and	#1,trackno
lsl	#1,d0
or	d0,trackno
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

and	#1,trackno

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
move	#600,tw
w1:
sub	#1,tw
bne	w1
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
and	#%01111000,d7

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
and	#%01111000,d7

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
move	trackno,d0
lsl	#2,d0
and	#4,d0
not	d0
move	driveno,d6
add	#3,d6
bclr	d6,d0
move.b	d0,$bfd100
movem.l	(a7)+,d0/d6/a5

re:
btst	#5,$bfe001
bne	re

move	#$7fff,$9c(a6)
move	#$7fff,$9e(a6)
move	#$4298,$7e(a6)
move	#%1001010100000000,$9e(a6)
move.l	#track,$20(a6)
move	#$8210,$96(a6)
move	#$4000,$24(a6)
move	#$8000+5632+1,$24(a6)
move	#$8000+5632+1,$24(a6)

w:
btst	#1,$1f(a6)
bne	wo
btst	#7,$bfe001
bne	w

wo:

move	#$4000,$24(a6)
rts

writetrack:
movem.l	d0/d6/a5,-(a7)
move	trackno,d0
lsl	#2,d0
and	#4,d0
not	d0
move	driveno,d6
add	#3,d6
bclr	d6,d0
move.b	d0,$bfd100
movem.l	(a7)+,d0/d6/a5

wfdr:
btst	#5,$bfe001
bne	wfdr

move	#20000,d0
vbt:
dbra	d0,vbt

move	#$7fff,$9e(a6)
move	#%1001000100000000,$9e(a6)
move	#$7fff,$9c(a6)
move	#$4298,tracksync;4889 for hiscores
move.l	#tracksync,$20(a6)
move	#$8210,$96(a6)
move	#$4000,$24(a6)
move	#$c000+5632+2,$24(a6)
move	#$c000+5632+2,$24(a6)

w2:
btst	#1,$1f(a6)
beq	w2

move.l	#tracksync,$20(a6)
move	#$4000,$24(a6)
move	#$c000+5632+2,$24(a6)
move	#$c000+5632+2,$24(a6)
move	#2,$9c(a6)

w3:
btst	#1,$1f(a6)
beq	w3

move	#2,$9c(a6)
move	#$4000,$24(a6)
rts

exit:
move	(a7)+,d0
bset	#15,d0
move	d0,$9a(a6)
rts:
rts

