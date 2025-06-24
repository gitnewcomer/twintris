;SS!

;btl1.S

menulen=202336
menuclen=84112
mainclen=100284
mainlen=274916

a=$150
org	a
load	$60000

dc.b	"DOS",0
dc.l	0,880

move.l	4,a6
move.l	#0,a1
jsr	-294(a6)
lea	wport(pc),a1
move.l	d0,$10(a1)
jsr	-354(a6)
lea	wio(pc),a1
clr.l	d0
clr.l	d1
lea	wtrddevice(pc),a0
jsr	-444(a6)
lea	wio(pc),a1
lea	wport(pc),a5
move.l	a5,14(a1)
move	#2,28(a1)
move.l	#b2+menulen,40(a1)
move.l	#512*361,36(a1)
move.l	#512*22,44(a1)
jsr	-456(a6)

move	#$7fff,$dff09a
lea	ds(pc),a0
lea	ds,a1
move	#[[b-ds]/2]-1,d0

ngugi:
move	(a0)+,(a1)+
dbra	d0,ngugi

jmp	ds

wtrddevice:
dc.b	"trackdisk.device",0
even
wio:
blk.l	20,0
wport:
blk.l	8,0

ds:
lea	b2+menulen+menuclen,a0
move	#mainclen/2,d0
lea	b2,a1
fn:
move	(a0)+,(a1)+
dbne	d0,fn


move	#$4e75,b2+menulen+$1a8
move	#$f180,b2+menulen+$2a
move.l	b2+menulen+$1aa,-(a7)
jsr	b2+menulen

move.l	(a7)+,a0
move.l	a0,menustart

move	#$4889,11852(a0)
move	#$4889,11984(a0)

jsr	(a0)

lea	b2+menulen,a0
lea	b2,a1
move	mainclen/2,d0
cw:
move	(a0),d1
move	(a1),(a0)+
move	d1,(a1)+
dbne	d0,cw

lea	$7f000,a0
lea	b,a1
move	#200,d0
cd:
move	(a0)+,(a1)+
dbne	d0,cd

move	#$f180,b2+menulen+$2a
move	#$4e75,b2+menulen+$1a8
move.l	b2+menulen+$1aa,-(a7)
jsr	b2+menulen

lea	b,a0
lea	$7f000,a1
move	#200,d0
cdb:
move	(a0)+,(a1)+
dbne	d0,cdb

move.l	(a7)+,a0
move.l	a0,mainstart
jsr	(a0)

lll:
move.l	menustart,a0
lea	b2,a1
move.l	#$7f000,d0
sub.l	a0,d0
cc:
move	(a0),d1
move	(a1),(a0)+
move	d1,(a1)+
subq.l	#2,d0
bne	cc

move.l	menustart,a0
jsr	(a0)

move.l	menustart,a0
lea	b2,a1
move.l	#$7f000,d0
sub.l	a0,d0
cc2:
move	(a1),d1
move	(a0),(a1)+
move	d1,(a0)+
subq.l	#2,d0
bne	cc2

move.l	mainstart,a0
jsr	(a0)

bra	lll

menustart:
dc.l	0
mainstart:
dc.l	0
b:
b2=b+400
