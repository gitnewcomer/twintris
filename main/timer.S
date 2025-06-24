move	#15,d0
lea	$bfe001,a0
ggt:
move.b	(a0),-(a7)
addq.l	#$100,a0
dbra	d0,ggt

move	$dff01c,-(a7)
move	#$7fff,$dff09a

move.b	#0,$bfee01
move.b	#0,$bfdf01
move.b	#50,$bfe501
move.b	#-1,$bfe401
move.b	#15,$bfe601
move.b	#0,$bfe701
move.b	#%00000001,$bfee01
move.b	#%01000001,$bfef01
move	#8,$dff09c

ssss:
move	$bfe600,$dff180
btst	#6,$bfe001
beq	exit
btst	#1,$bfed01
beq	ssss

exit:

;move.b	#%
;move.b	#

move	(a7)+,d0
bset	#15,d0
move	d0,$dff09a

move	#15,d0
lea	$bfe001,a0
gg2t:
move.b	(a7)+,(a0)
addq.l	#$100,a0
dbra	d0,gg2t


rts
