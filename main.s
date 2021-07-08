; Set demo compatibility
; 0: 68000 only, Kickstart 1.3 only, PAL only
; 1: All CPUs, Kickstarts and display modes
; 2: 68010+, Kickstart 3.0+, all display modes
COMPATIBILITY = 1

; Set to 1 to require fast memory
FASTMEM	= 0

; Set to 1 to enable pause on right mouse button
; with single-step on left mouse button
RMBPAUSE = 1

; Set to 1 if you use FPU code in your interrupt
FPUINT = 0

; Set to 1 if you use the copper, blitter or sprites, respectively
COPPER	=	1
BLITTER	=	0
SPRITE	=	0

; Set to 1 to get address of topaz font data in TopazCharData
TOPAZ = 0

; Set to 1 when writing the object file to enable section hack
SECTIONHACK = 0

	; Demo startup must be first for section hack to work
	include	DemoStartup.S

screenWidth	equ	40
depth		equ	4

_Precalc:
	; Called as the very first thing, before system shutdown
	rts

_Exit:
	; Called after system restore
	moveq	#0,d0
	rts

_Main:
	; Main demo routine, called by the startup.
	; Demo will quit when this routine returns.

	lea	copper,a1
	move.l	a1,$dff080

.loop:
	cmp.w #100, framecount
	blt.s .loop
	rts


framecount: dc.w 0

_Interrupt:
	; Called by the vblank interrupt.

	add.w #1,framecount

	lea	bitplanes,a1
	lea	$dff0e0,a2
	moveq	#depth,d0
.bitplaneloop:
	move.l	a1,(a2)
	lea	screenWidth(a1),a1
	addq	#4,a2
	dbra	d0,.bitplaneloop

	rts

	section data_c

copper:
	dc.l	$008e2c81,$00902cc1
	dc.l	$00920038,$009400d0
	dc.w	$0100,(depth<<12)|$200
	dc.l	$01020000,$01060000,$010c0011
	dc.w	$108,screenWidth*depth-screenWidth
	dc.w	$10a,screenWidth*depth-screenWidth
	dc.l	$01fc0000

	include	"gen/hello-copper.s"

	dc.l	$fffffffe

bitplanes:
	incbin	"gen/hello.raw"

	section	chip,bss_c
Chip:
