################################################################################
#                                                                              #
#                               Display Test Code                              #
#                 	         Test code for display                             #
#                                   EE/CS 52                                   #
#                                                                              #
################################################################################


/*
 *  Albert Gural
 *  EE/CS 52
 *  TA: Dan Pipe-Mazo
 *
 *  File Description:	TODO
 *
 *  Table of Contents:	TODO
 *
 *  Revision History:
 *      02/09/2012  Dan Pipe-Mazo	Initial Revision.
 *		05/14/2014	Albert Gural	Begain writing testcode assembly.
 *
 */

 /*  Local Include Files   */
#include "../osc_bsp/system.h"

#.equ	VRAM_OFFSET, 0x00080000

.section  .text         #start code section

/*
 *  key_handler
 *
 *  Description:
 *
 *  Operation:
 *
 *  Arguments:
 *
 *  Return Value:
 *
 *  Local Variables:
 *
 *  Shared Variables:
 *
 *  Global Variables:
 *
 *  Input:
 *
 *  Output:
 *
 *  Error Handling:
 *
 *  Limitations:
 *
 *  Algorithms:
 *  Data Structures:
 *
 *  Registers Changed:
 *
 *  Revision History:
 *      02/09/2012    Dan Pipe-Mazo     initial revision
 *
 */

.global test_disp
.type test_disp,@function

test_disp:
	movhi	r8, %hi(VRAM_CTRL_BASE)
	ori		r8, r8, %lo(VRAM_CTRL_BASE)
	mov		r11, r0
	mov		r12, r0

disp:
	movi	r13, 136
	bltu	r12, r13, draw_top
	br 		draw_bot
disp_cont:
	addi	r8, r8, 2
	addi	r11, r11, 1
	movi	r13, 272
	bgeu	r12, r13, draw_border
	movi	r13, 0x0200
	bgeu	r11, r13, disp_reset
	br		disp

draw_top:
	movi	r13, 240
	bltu	r11, r13, draw_red
	br		draw_yellow

draw_bot:
	movi	r13, 240
	bltu	r11, r13, draw_green
	br		draw_blue

draw_red:
	movi	r9, 0x1F00
	sthio	r9, (r8)
	br 		disp_cont

draw_yellow:
	movui	r9, 0xFF03
	sthio 	r9, (r8)
	br		disp_cont

draw_green:
	movui	r9, 0xE003
	sthio 	r9, (r8)
	br		disp_cont

draw_blue:
	movi	r9, 0x007C
	sthio 	r9, (r8)
	br		disp_cont

draw_border:
	movi	r9, 0x1F7C
	movi	r12, 272
	movi	r13, 480

draw_border_top:
	movhi	r8, %hi(VRAM_CTRL_BASE)
	ori		r8, r8, %lo(VRAM_CTRL_BASE)
	addi	r8, r8, 0x0400
	mov		r11, r0
dbt_loop:
	sthio	r9, (r8)
	addi	r8, r8, 2
	addi	r11, r11, 1
	bgeu	r11, r13, draw_border_bot
	br		dbt_loop

draw_border_bot:
	movhi	r8, %hi(VRAM_CTRL_BASE)
	ori		r8, r8, %lo(VRAM_CTRL_BASE)
	movhi	r14, %hi(277504)
	ori		r14, r14, %lo(277504)
	add		r8, r8, r14
	mov		r11, r0
dbb_loop:
	sthio	r9, (r8)
	addi	r8, r8, 2
	addi	r11, r11, 1
	bgeu	r11, r13, draw_border_left
	br		dbb_loop

draw_border_left:
	movhi	r8, %hi(VRAM_CTRL_BASE)
	ori		r8, r8, %lo(VRAM_CTRL_BASE)
	mov		r11, r0
dbl_loop:
	sthio	r9, (r8)
	addi	r8, r8, 0x0400
	addi	r11, r11, 1
	bgeu	r11, r12, draw_border_right
	br		dbl_loop

draw_border_right:
	movhi	r8, %hi(VRAM_CTRL_BASE)
	ori		r8, r8, %lo(VRAM_CTRL_BASE)
	add		r8, r8, r13
	add		r8, r8, r13
	subi	r8, r8, 1
	mov		r11, r0
dbr_loop:
	sthio	r9, (r8)
	addi	r8, r8, 0x0400
	addi	r11, r11, 1
	bgeu	r11, r12, test_disp_done
	br		dbr_loop

disp_reset:
	mov		r11, r0
	addi	r12, r12, 1
	br		disp

test_disp_done:
	ret



.section  .data     #start data section

#TODO
