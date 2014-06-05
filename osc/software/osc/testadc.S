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
	STWI	ADC_RATE_BASE, 0x040000

	# Set Trigger default level (2's complement), delay
	STWI	TRIG_LEVEL_BASE, 0
	STWI	TRIG_DELAY_BASE, 240

	# Install the interrupt handler
	mov		r4, r0
	movi	r5, 6
	MOVWI	r6, adc_int_handler
	mov		r7, r0
	PUSH	r0
	call	alt_ic_isr_register
	POP		r0

	# Clear the edge capture register (write 1 to clear).
	MOVWI	r8, TRIG_INT_BASE
	MOVWI	r9, 0xFFFFFFFF
	stw		r9, PIO_EDGE_CAP(r8)

	# Enable ADC interrupts. [TYPEOFINTERUPT]
	MOVWI	r8, TRIG_INT_BASE
	MOVWI	r9, 0x00000002
	stw		r9, PIO_IRQ_MASK(r8)

	# Turn on FIFO write
	STWI	ADC_CTRL_BASE, 0x09
	STWI	ADC_CTRL_BASE, 0x01

	# Reset trigger counter [ch. A], [+ slope]
	STWI	TRIG_CTRL_BASE, 0x04
	STWI	TRIG_CTRL_BASE, 0x00

adc_int_installer_done:
	RESTORE
	ret


/*
 *  adc_int_handler
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

.global adc_int_handler
.type adc_int_handler, @function

adc_int_handler:
	SAVE

	# Clear interrupts.
	MOVWI	r8, TRIG_INT_BASE
	stw		r0, PIO_IRQ_MASK(r8)

	# Get the edge capture register.
	ldw		r9, PIO_EDGE_CAP(r8)

	# Only ch A trigger interrupts for now. [TYPEOFINTERRUPT]
	andi	r9, r9, 0x02
	beq		r9, r0, adc_int_handler_done

	# Pause FIFO write, enable reading
	STWI	ADC_CTRL_BASE, 0x02

	mov		r10, r0
adc_int_handler_clear_front:
	# Bitbang clock pulse
	STWI	ADC_CTRL_BASE, 0x06
	STWI	ADC_CTRL_BASE, 0x02

	addi	r10, r10, 1
	movi	r13, 13
	bltu	r10, r13, adc_int_handler_clear_front

	movia	r8, sample_buffer_A
	mov		r10, r0

adc_int_handler_loop:
	# Bitbang clock pulse
	STWI	ADC_CTRL_BASE, 0x06
	STWI	ADC_CTRL_BASE, 0x02

	MOVWI	r11, ADC_RAW_BASE
	ldwio	r12, (r11)
	movui	r13, 128
	add		r12, r12, r13
	andi	r12, r12, 0xFF

	stb		r12, (r8)
	addi	r8, r8, 1
	addi	r10, r10, 1
	movi	r13, 480
	bltu	r10, r13, adc_int_handler_loop

	call	draw_trace

adc_int_handler_done:
	# Clear the edge capture register (write 1 to clear).
	MOVWI	r8, TRIG_INT_BASE
	MOVWI	r9, 0xFFFFFFFF
	stw		r9, PIO_EDGE_CAP(r8)

	# Re-enable interrupts. [TYPEOFINTERRUPT]
	MOVWI	r8, TRIG_INT_BASE
	MOVWI	r9, 0x00000002
	stw		r9, PIO_IRQ_MASK(r8)

	# Turn on FIFO write
	STWI	ADC_CTRL_BASE, 0x09
	STWI	ADC_CTRL_BASE, 0x01

	# Restart trigger counter [ch. A], [+ slope]
	STWI	TRIG_CTRL_BASE, 0x04
	STWI	TRIG_CTRL_BASE, 0x00

	RESTORE
	ret






.global draw_trace
.type draw_trace, @function

draw_trace:
	SAVE
	push	r4
	push	r5
	push	r6

	movia	r8, sample_buffer_A
	#movia	r9, sample_buffer_Ao
	mov		r10, r0

draw_trace_loop:
	ldb		r12, (r8)
	movui	r15, 255
	sub		r12, r15, r12
	andi	r12, r12, 0xFF
	addi	r12, r12, 8

	MOVWI	r9, VRAM_CTRL_BASE
	add		r9, r9, r10
	add		r9, r9, r10

	mov		r11, r0
draw_trace_col_loop:
	MOVWI	r15, 0x001C
	sthio	r15, (r9)

	movi	r15, 136
	beq		r11, r15, draw_grid_pt

	movi	r15, 240
	beq		r10, r15, draw_grid_pt

	beq		r11, r12, draw_trace_pt

draw_trace_col_loop_continue:
	addi	r9, r9, 0x400
	addi	r11, r11, 1
	movi	r15, 272
	bltu	r11, r15, draw_trace_col_loop

	addi	r8, r8, 1
	addi	r10, r10, 1
	movi	r15, 480
	bltu	r10, r15, draw_trace_loop


/*
draw_trace_loop:
	ldb		r12, (r9)
	movui	r13, 255
	sub		r12, r13, r12
	andi	r12, r12, 0xFF
	addi	r12, r12, 5

	push	r4
	push	r5
	push	r6

	mov		r4, r12
	mov		r5, r10
	movui	r6, 0x003C
	call	draw_pixel
	addi	r4, r4, 1
	call	draw_pixel
	addi	r4, r4, 1
	call	draw_pixel
	addi	r4, r4, 1
	call	draw_pixel
	addi	r4, r4, 1
	call	draw_pixel
	addi	r4, r4, 1
	call	draw_pixel
	addi	r4, r4, 1
	call	draw_pixel

	subi	r4, r4, 6
	call	draw_pixel
	addi	r4, r4, 1
	call	draw_pixel
	addi	r4, r4, 1
	call	draw_pixel
	addi	r4, r4, 1
	call	draw_pixel
	addi	r4, r4, 1
	call	draw_pixel
	addi	r4, r4, 1
	call	draw_pixel
	addi	r4, r4, 1
	call	draw_pixel

	pop		r6
	pop		r5
	pop		r4


	ldb		r12, (r8)
	stb		r12, (r9)
	movui	r13, 255
	sub		r12, r13, r12
	andi	r12, r12, 0xFF
	addi	r12, r12, 8

	push	r4
	push	r5
	push	r6

	mov		r4, r12
	mov		r5, r10
	movui	r6, 0xE003
	call	draw_pixel

	pop		r6
	pop		r5
	pop		r4

	addi	r8, r8, 1
	addi	r9, r9, 1
	addi	r10, r10, 1
	movi	r13, 480
	bltu	r10, r13, draw_trace_loop
*/

draw_trace_done:
	pop		r6
	pop		r5
	pop		r4
	RESTORE
	ret

draw_grid_pt:
	MOVWI	r15, 0x1F00
	sthio	r15, (r9)
	br		draw_trace_col_loop_continue

draw_trace_pt:
	MOVWI	r15, 0xE07F
	sthio	r15, (r9)
	br		draw_trace_col_loop_continue



.global draw_grid
.type draw_grid, @function

draw_grid:
	SAVE
	push	r4
	push	r5
	push	r6

	movui	r6, 0x1F00

	movui	r4, 136
	mov		r5, r0
draw_grid_horiz:
	call	draw_pixel
	movui	r6, 0x003C
	addi	r4, r4, 1
	call	draw_pixel
	addi	r4, r4, 1
	call	draw_pixel
	addi	r4, r4, 1
	call	draw_pixel
	movui	r6, 0x1F00
	subi	r4, r4, 3

	addi	r5, r5, 1
	movi	r8, 480
	bltu	r5, r8, draw_grid_horiz

	mov		r4, r0
	movui	r5, 240
draw_grid_vert:
	call	draw_pixel

	addi	r4, r4, 1
	movi	r8, 272
	bltu	r4, r8, draw_grid_vert

draw_grid_done:
	pop		r6
	pop		r5
	pop		r4
	RESTORE
	ret






draw_pixel:
	SAVE

	push	r4
	push	r5

	slli	r4, r4, 10
	add		r4, r4, r5
	add		r4, r4, r5
	MOVWI	r5, VRAM_CTRL_BASE
	add		r4, r4, r5
	sth		r6, (r4)

	pop		r5
	pop		r4

draw_pixel_done:
	RESTORE
	ret

/*
adc_int_handler_draw_pt:
	movui	r13, 0xE003
	sthio 	r13, (r9)
	br		adc_int_handler_draw_col_loop_cont

adc_int_handler_draw_thresh:
	movui	r13, 0x1F00
	sthio 	r13, (r9)
	br		adc_int_handler_draw_col_loop_cont

adc_int_handler_draw_vaxis:
	movui	r13, 0x1F00
	sthio 	r13, (r9)
	br		adc_int_handler_draw_col_loop_cont
*/


/*
draw_trace_col:
	MOVWI	r9, VRAM_CTRL_BASE
	add		r9, r9, r10
	add		r9, r9, r10
	mov		r11, r0

draw_trace_col_loop:
	movi	r14, 240
	beq		r10, r14, adc_int_handler_draw_vaxis

	movui	r13, 0x003C
	sthio 	r13, (r9)

	movi	r14, 136
	beq		r11, r14, adc_int_handler_draw_thresh
	beq		r11, r12, adc_int_handler_draw_pt

adc_int_handler_draw_col_loop_cont:
	addi	r9, r9, 1024
	addi	r11, r11, 1
	movi	r13, 272
	bltu	r11, r13, adc_int_handler_draw_col_loop

	addi	r10, r10, 1
	movi	r13, 480
	bltu	r10, r13, adc_int_handler_loop
*/



.global clear_display_x
.type clear_display_x, @function

clear_display_x:
	SAVE

	movhi	r8, %hi(VRAM_CTRL_BASE)
	ori		r8, r8, %lo(VRAM_CTRL_BASE)
	movi	r12, 512
	movi	r13, 272
	mov		r10, r0

loop_clr_x:
	movui	r14, 0x001C
	sthio 	r14, (r8)
	addi	r8, r8, 2
	addi	r11, r11, 1
	bltu	r11, r12, loop_clr_x

	mov		r11, r0
	addi	r10, r10, 1
	bltu	r10, r13, loop_clr_x

	RESTORE
	ret



.global clear_display_y
.type clear_display_y, @function

clear_display_y:
	SAVE

	movhi	r8, %hi(VRAM_CTRL_BASE)
	ori		r8, r8, %lo(VRAM_CTRL_BASE)
	movi	r12, 512
	movi	r13, 272
	mov		r10, r0

loop_clr_y:
	movui	r14, 0x0000
	sthio 	r14, (r8)
	addi	r8, r8, 2
	addi	r11, r11, 1
	bltu	r11, r12, loop_clr_y

	mov		r11, r0
	addi	r10, r10, 1
	bltu	r10, r13, loop_clr_y

	RESTORE
	ret



/*
.global test_adc
.type test_adc, @function

test_adc:
	movhi	r9, %hi(ADC_RAW_BASE)
	ori		r9, r9, %lo(ADC_RAW_BASE)

clear_displayx:
	movhi	r8, %hi(VRAM_CTRL_BASE)
	ori		r8, r8, %lo(VRAM_CTRL_BASE)
	movi	r12, 512
	movi	r13, 272
	mov		r10, r0

loop_clrx:
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
*/


.section  .data     #start data section

sample_buffer_A:	.skip	480		# Buffer stores display-worth of ADC samples.
sample_buffer_Ao:	.skip	480		# Buffer stores display-worth of ADC samples.
