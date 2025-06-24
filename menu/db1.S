;SS!

track=$20000
tracksync=track-2
codes=tracksync-512
dcodes=codes-512
rft=dcodes-2

a=$150
org	a
load	$60000

dc.b	"DOS",0
dc.l	0,880

move	#$7fff,$dff09a
lea	ds(pc),a0
lea	$150+[ds-a],a1
move	#511,d0

ngugi:
move	(a0)+,(a1)+
dbra	d0,ngugi

jmp	$150+[ds-a]

ds:
lea	$2dd8,a7
bsr.L	init

lea	$7f000,a0
move	#1000,d0
nnnnL:
clr	(a0)+
dbra	d0,nnnnl

rag:
move	#2,d0
move	#15,d1
bsr.S	superread
move	#17,d0
move	#18,d1
bsr.S	superread
move	#-1,setprefs
bra.S	rag

superread:
bsr.L	track0
bsr.L	startmotor

lea	$30000,a1
bsr.S	read

bsr.L	stopmotor

lea	$10000,a1
lea	$7f000,a0
move	#1000,d0
n1:
move	(a0)+,(a1)+
dbra	d0,n1

move	#$4e75,$30000+$1a8
move.l	$30000+$1aa,-(a7)
jsr	$30000

lea	$10000,a1
lea	$7f000,a0
move	#1000,d0
n2:
move	(a1)+,(a0)+
dbra	d0,n2

cmp	#20,trackno
bgt.S	mr
move	setprefs,$48538
move	#$4889,$483ec
move	#$4889,$48470
mr:
move.l	(a7)+,a0
jsr	(a0)

rts

read:
;adr. -> a1  track -> d0  tracks -> d1
movem.l	d0-d7/a0-a6,-(a7)
move	d0,rft

rt:
sub	#1,d1
bmi.S	rtsres

move	rft,d0
add	#1,rft
bsr.L	seektrack

bsr.L	readtrack
move	d1,-(a7)
bsr.L	dcode
move	(a7)+,d1

bra.S	rt


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
bgt.S	ndc

move	d1,d2
and	#$ff,d2
move.b	d0,(a1,d2.w)

ndc:

bchg	#0,d1
bchg	#1,d1
beq.S	nc
bchg	#2,d1
bchg	#3,d1
beq.S	nc
bchg	#4,d1
bchg	#5,d1
beq.S	nc
bchg	#6,d1
bchg	#7,d1
beq.S	nc
bchg	#8,d1
bchg	#9,d1
beq.S	nc
bchg	#10,d1
bchg	#11,d1
beq.S	nc
bchg	#12,d1
bchg	#13,d1
beq.S	nc
bchg	#14,d1
bchg	#15,d1
nc:
addq	#1,d0
cmp	#256,d0
blt.S	nr




lea	$dff000,a6

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
beq.S	t0a
move	trackno,d6
lsr	#1,d6
cmp.b	d6,d0
blt.S	inw
bgt.S	otw
and	#1,trackno
lsl	#1,d0
or	d0,trackno
movem.l	(a7)+,d6/d7/a5
rts

otw:
move.b	#%11110100,d7

move.b	d7,$bfd100
or	#1,d7
move.b	d7,$bfd100

add	#2,trackno
bsr.S	stepwait
bra.S	sta

inw:
move.b	#%11110110,d7

move.b	d7,$bfd100
or	#1,d7
move.b	d7,$bfd100

lea	tracknos,a5
sub	#2,trackno
bsr.S	stepwait
bra.S	sta


track0:
movem.l	d6/d7/a5,-(a7)
t0a:

and	#1,trackno

t0:
btst	#4,$bfe001
beq.S	rtsres675

move.b	#%11110010,d7

move.b	d7,$bfd100
or	#1,d7
move.b	d7,$bfd100

bsr.S	stepwait
bra.S	t0

rtsres675:
movem.l	(a7)+,d6/d7/a5
rts

stepwait:
move	#600,tw
w1:
sub	#1,tw
bne.S	w1
rts

tw:
dc.w	0

tracknos:
blk.b	4,0

startmotor:
move.b	#%01111111,$bfd100

move.b	#%01110000,$bfd100

clr	motorstate
rts

motorstate:
dc.w	0

stopmotor:
move.b	#%11111111,$bfd100

move.b	#%01110000,$bfd100

move	#128,motorstate

rts

readtrack:
movem.l	d0/d6/a5,-(a7)
move	trackno,d0
lsl	#2,d0
and	#4,d0
not	d0
bclr	#3,d0
move.b	d0,$bfd100
movem.l	(a7)+,d0/d6/a5

re:
btst	#5,$bfe001
bne.S	re

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
bne.S	wo
btst	#7,$bfe001
bne.S	w

wo:

move	#$4000,$24(a6)
rts

setprefs:
dc.w	0
b:
