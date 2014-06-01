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
#include "keyint.m"
#include "../osc_bsp/system.h"

.section  .text         #start code section


/*
 *  adc_int_installer
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
 *      05/18/2014	Albert Gural	Initial revision.
 *
 */

.global adc_int_installer
.type	adc_int_installer, @function

adc_int_installer:
	SAVE

	# Set FIFO speed
	STWI	ADC_RATE_BASE, 0x000078

	# Set Trigger default level (2's complement), delay
	STWI	TRIG_LEVEL_BASE, 0
	STWI	TRIG_DELAY_BASE, 0

	# Install the interrupt handler
	mov		r4, r0
	movi	r5, 6
	MOVWI	r6, test_adc2
	mov		r7, r0
	PUSH	r0
	call	alt_ic_isr_register
	POP		r0

	# Clear the edge capture register (write 1 to clear).
	MOVWI	r8, TRIG_INT_BASE
	MOVWI	r9, 0xFFFFFFFF
	stw		r9, PIO_EDGE_CAP(r8)

	# Enable ADC interrupts.
	MOVWI	r8, TRIG_INT_BASE
	MOVWI	r9, 0x00000002
	stw		r9, PIO_IRQ_MASK(r8)

	# Turn on FIFO write
	STWI	ADC_CTRL_BASE, 0x09
	STWI	ADC_CTRL_BASE, 0x01

	# Reset trigger counter [ch. A], [+ slope]
	STWI	TRIG_CTRL_BASE, 0x04
	STWI	TRIG_CTRL_BASE, 0x00

key_int_installer_done:
	RESTORE
	ret



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
	SAVE

	# Clear interrupts.
	MOVWI	r8, TRIG_INT_BASE
	stw		r0, PIO_IRQ_MASK(r8)

	# Get the edge capture register.
	MOVWI	r8, TRIG_INT_BASE
	ldw		r8, PIO_EDGE_CAP(r8)

	# Only ch A trigger interrupts for now.
	andi	r8, r8, 0x02
	beq		r8, r0, test_adc2_done

	# Pause FIFO write, enable reading
	STWI	ADC_CTRL_BASE, 0x02

	mov		r10, r0
test_adc2_clear_front:
	# Bitbang clock pulse
	STWI	ADC_CTRL_BASE, 0x06
	STWI	ADC_CTRL_BASE, 0x02

	addi	r10, r10, 1
	movi	r13, 34
	bltu	r10, r13, test_adc2_clear_front

	mov		r10, r0

test_adc2_loop:
	# Bitbang clock pulse
	STWI	ADC_CTRL_BASE, 0x06
	STWI	ADC_CTRL_BASE, 0x02

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
	movi	r14, 240
	beq		r10, r14, test_adc2_draw_vaxis

	movui	r13, 0x003C
	sthio 	r13, (r9)

	movi	r14, 136
	beq		r11, r14, test_adc2_draw_thresh
	beq		r11, r12, test_adc2_draw_pt

test_adc2_draw_col_loop_cont:
	addi	r9, r9, 1024
	addi	r11, r11, 1
	movi	r13, 272
	bltu	r11, r13, test_adc2_draw_col_loop

	addi	r10, r10, 1
	movi	r13, 480
	bltu	r10, r13, test_adc2_loop

test_adc2_done:
	# Clear the edge capture register (write 1 to clear).
	MOVWI	r8, TRIG_INT_BASE
	MOVWI	r9, 0xFFFFFFFF
	stw		r9, PIO_EDGE_CAP(r8)

	# Re-enable interrupts.
	MOVWI	r8, TRIG_INT_BASE
	MOVWI	r9, 0x00000002
	stw		r9, PIO_IRQ_MASK(r8)

	# Turn on FIFO write
	STWI	ADC_CTRL_BASE, 0x09
	STWI	ADC_CTRL_BASE, 0x01

	# Reset trigger counter [ch. A], [+ slope]
	STWI	TRIG_CTRL_BASE, 0x04
	STWI	TRIG_CTRL_BASE, 0x00

	RESTORE
	ret

test_adc2_draw_pt:
	movui	r13, 0xE003
	sthio 	r13, (r9)
	br		test_adc2_draw_col_loop_cont

test_adc2_draw_thresh:
	movui	r13, 0x1F00
	sthio 	r13, (r9)
	br		test_adc2_draw_col_loop_cont

test_adc2_draw_vaxis:
	movui	r13, 0x1F00
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
