;SS!

>extern "donald duck",duck

top=$7f000
duck=top-[48*256*4]-32
mt_data=duck
a=mt_data-20000
screen=a-[40*256*4]
keys=screen-128

org	a
load	a



;bsr	mt_init

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
move	#%1000011111100000,$dff096
move.l	$6c,oldvbi
;move.l	#vbi,$6c
move.l	$68,oldkeyb+2
move.l	#keyboard,$68
move	#$c008,$dff09a

move.l	#copperlist,$dff084
clr	$dff08a

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

lea	palette,a0
move	#$180,d0
move	#15,d1
move.l	#duck+[48*256*4],a1
pon:
move	d0,(a0)+
addq	#2,d0
move	(a1)+,(a0)+
dbra	d1,pon

exit:
bsr	fademusic
bsr	mt_end
move.l	oldvbi,$6c
move.l	oldkeyb+2,$68
move	#$7fff,$dff09a
move	#$7fff,$dff096
move	oldinten,$dff09a
move	olddmaen,$dff096
clr.l	d0
rts

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

musiced:
dc.w	0

tv:
dc.w	0

volume:
dc.w	150

oldvbi:
dc.l	0
