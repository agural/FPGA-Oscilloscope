################################################################################
#                                                                              #
#                                  ADC Test Code                               #
#                      Test code for ADC (requires display)                    #
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
#include "macros.m"
#include "../osc_bsp/system.h"

.section  .text         #start code section

/*
 *  test_adc2
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

.global test_adc2
.type test_adc2, @function

test_adc2:
	# Turn on FIFO write, set up write speed 1MHz
	STWI	ADC_CTRL_BASE, 0x09000078
	STWI	ADC_CTRL_BASE, 0x01000078
	mov		r10, r0

test_adc2_pause:
	addi	r10, r10, 1
	movi	r9, 100
	bltu	r10, r9, test_adc2_pause

	# Pause FIFO write, enable reading
	STWI	ADC_CTRL_BASE, 0x02000078
	mov		r10, r0

test_adc2_loop:
	# Bitbang clock pulse
	STWI	ADC_CTRL_BASE, 0x06000078
	STWI	ADC_CTRL_BASE, 0x02000078

	MOVWI	r11, ADC_RAW_BASE
	ldwio	r12, (r11)
	andi	r12, r12, 0xFF
	movui	r13, 127
	sub		r12, r13, r12
	andi	r12, r12, 0xFF
	addi	r12, r12, 8

test_adc2_draw_col:
	MOVWI	r9, VRAM_CTRL_BASE
	add		r9, r9, r10
	add		r9, r9, r10
	mov		r11, r0

test_adc2_draw_col_loop:
	movui	r13, 0x003C
	sthio 	r13, (r9)
	beq		r11, r12, test_adc2_draw_pt

test_adc2_draw_col_loop_cont:
	addi	r9, r9, 1024
	addi	r11, r11, 1
	movi	r13, 272
	bltu	r11, r13, test_adc2_draw_col_loop

	addi	r10, r10, 1
	movi	r13, 480
	bltu	r10, r13, test_adc2_loop

	br		test_adc2

test_adc2_draw_pt:
	movui	r13, 0xE003
	sthio 	r13, (r9)
	br		test_adc2_draw_col_loop_cont










.global test_adc
.type test_adc, @function

test_adc:
	movhi	r9, %hi(ADC_RAW_BASE)
	ori		r9, r9, %lo(ADC_RAW_BASE)

clear_display:
	movhi	r8, %hi(VRAM_CTRL_BASE)
	ori		r8, r8, %lo(VRAM_CTRL_BASE)
	movi	r12, 512
	movi	r13, 272
	mov		r10, r0

loop_clr:
	movui	r14, 0x003C
	sthio 	r14, (r8)
	addi	r8, r8, 2
	addi	r11, r11, 1
	bltu	r11, r12, loop_clr

	mov		r11, r0
	addi	r10, r10, 1
	bltu	r10, r13, loop_clr

draw_sig:
	mov		r11, r0
	movi	r12, 480

draw_sig_loop:
	movhi	r8, %hi(VRAM_CTRL_BASE)
	ori		r8, r8, %lo(VRAM_CTRL_BASE)

	mov		r10, r0
	ldwio	r10, (r9)
	movui	r13, 127
	sub		r10, r13, r10
	andi	r10, r10, 0xFF
	addi	r10, r10, 8

	slli	r10, r10, 10
	add		r8, r8, r10
	add		r8, r8, r11
	add		r8, r8, r11

clear_col:
	movhi	r14, %hi(VRAM_CTRL_BASE)
	ori		r14, r14, %lo(VRAM_CTRL_BASE)
	add		r14, r14, r11
	add		r14, r14, r11
	mov		r15, r0

clear_col_loop:
	movui	r16, 0x003C
	sthio 	r16, (r14)
	addi	r14, r14, 1024

	addi	r15, r15, 1
	movi	r16, 272
	bltu	r15, r16, clear_col_loop

draw_sig_loop_2:
	movui	r13, 0xE003
	sthio 	r13, (r8)

	addi	r11, r11, 1
	bltu	r11, r12, draw_sig_loop

	mov		r11, r0
	br		draw_sig_loop

test_adc_done:
	ret



.section  .data     #start data section

#TODO
