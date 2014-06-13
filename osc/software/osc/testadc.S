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
	STWI	TRIG_ERROR_BASE, 5

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

	# Pause FIFO write.
	STWI	ADC_CTRL_BASE, 0x00

	mov		r10, r0
adc_int_handler_clear_front:
	# Bitbang clock pulse.
	STWI	ADC_CTRL_BASE, 0x01
	STWI	ADC_CTRL_BASE, 0x00

	# Keep going until 480 good remaining points (for display)
	addi	r10, r10, 1
	movi	r13, 13
	bltu	r10, r13, adc_int_handler_clear_front

	movia	r8, sample_buffer_A
	mov		r10, r0

adc_int_handler_loop:
	# Bitbang clock pulse.
	STWI	ADC_CTRL_BASE, 0x01
	STWI	ADC_CTRL_BASE, 0x00

	# Get ch. A, ch. B, and logic data.
	MOVWI	r11, ADC_RAW_BASE
	ldwio	r12, (r11)

	# r12 for ch. A, r13 for ch. B, r14 for logic.
	srli	r13, r12, 8
	srli	r14, r12, 16
	movui	r15, 128

	# Convert analog channels to non-signed values.
	add		r12, r12, r15
	add		r13, r13, r15

	# Keep only the bottom byte.
	andi	r12, r12, 0xFF
	andi	r13, r13, 0xFF
	andi	r14, r14, 0xFF

	# CH. A
	# Retrieve the current buffer contents.
	# Then update the current buffer with the new value.
	movia	r8, sample_buffer_A
	add		r8, r8, r10
	stb		r12, (r8)

	# CH. B
	# Retrieve the current buffer contents.
	# Then update the current buffer with the new value.
	movia	r8, sample_buffer_B
	add		r8, r8, r10
	stb		r13, (r8)

	# LOGIC ANALYZER
	# Retrieve the current buffer contents.
	# Then update the current buffer with the new value.
	movia	r8, sample_buffer_L
	add		r8, r8, r10
	stb		r14, (r8)

	addi	r10, r10, 1
	movi	r15, 480
	bltu	r10, r15, adc_int_handler_loop

	# Sample done.
	movia	r8, sample_complete
	movi	r9, 1
	stb		r9, (r8)

adc_int_handler_done:

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

.global clear_display
.type clear_display, @function

clear_display:
	SAVE

	# Get display address and background color.
	MOVWI	r8, VRAM_CTRL_BASE
	movui	r9, 272
	slli	r9, r9, 10
	add		r9, r8, r9
	movui	r15, 0x001C

	# Loop over all screen pixels, clearing them.
clear_display_loop:
	sthio 	r15, (r8)
	addi	r8, r8, 2
	bltu	r8, r9, clear_display_loop

clear_display_done:
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

.global plot_pixel
.type plot_pixel, @function

plot_pixel:
	SAVE

	push	r4
	push	r5

	# Each row takes 1024 bytes, so shift row var by 10 bits.
	slli	r5, r5, 10
	# Add twice to account for 16-bit VRAM storage.
	add		r5, r5, r4
	add		r5, r5, r4
	# Now get the absolute address.
	MOVWI	r4, VRAM_CTRL_BASE
	add		r5, r5, r4
	# Store the color.
	sth		r6, (r5)

	pop		r5
	pop		r4

plot_pixel_done:
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

.global set_sample_rate
.type set_sample_rate, @function

set_sample_rate:
	SAVE

	# Divide fastest sample rate by desired sample rate
	# to get number of ticks to pause (not collect samples)
	# between collecting samples.
	MOVWI	r8, ADC_RATE_BASE
	MOVWI	r9, 180000000
	divu	r9, r9, r4
	stw		r9, (r8)

	# Always return 480 samples.
	movui	r2, 480

set_sample_rate_done:
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

.global set_trigger
.type set_trigger, @function

set_trigger:
	SAVE

	# Convert [0 to 127] to signed 8-bit [-127 to 127].
	# Then update trigger level.
	MOVWI	r8, TRIG_LEVEL_BASE
	slli	r9, r4, 1
	subi	r9, r9, 127
	andi	r9, r9, 0xFF
	stw		r9, (r8)

	# Slope is second bit of TRIG_CTRL. Modify the given
	# argument, then update slope.
	beq		r5, r0, set_trigger_slope_pos
	movi	r8, 0x02
	MOVWI	r9, TRIG_CTRL_BASE
	stw		r8, PIO_OUTSET(r9)
	br		set_trigger_done

set_trigger_slope_pos:
	movi	r8, 0x02
	MOVWI	r9, TRIG_CTRL_BASE
	stw		r8, PIO_OUTCLR(r9)

set_trigger_done:
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

.global set_delay
.type set_delay, @function

set_delay:
	SAVE

	# Simply set the delay...
	MOVWI	r8, TRIG_DELAY_BASE
	stw		r4, (r8)

set_delay_done:
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

.global start_sample
.type start_sample, @function

start_sample:
	SAVE

	# Clear the edge capture register (write 1 to clear).
	MOVWI	r8, TRIG_INT_BASE
	MOVWI	r9, 0xFFFFFFFF
	stw		r9, PIO_EDGE_CAP(r8)

	# Enable trigger interrupts.
	MOVWI	r9, 0x00000002
	# If auto-trigger, enable time-outs as well.
	slli	r8, r4, 2
	add		r9, r8, r9

	MOVWI	r8, TRIG_INT_BASE
	stw		r9, PIO_IRQ_MASK(r8)

	# Clear FIFO, turn on FIFO write.
	STWI	ADC_CTRL_BASE, 0x04
	STWI	ADC_CTRL_BASE, 0x02

	# Restart trigger counter [ch. A], [+ slope]
	MOVWI	r8, TRIG_CTRL_BASE
	movi	r9, 1
	stw		r9, PIO_OUTSET(r8)
	stw		r9, PIO_OUTCLR(r8)

start_sample_done:
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

.global sample_done
.type sample_done, @function

sample_done:
	SAVE

	# Test if sample occurred.
	movia	r8, sample_complete
	ldb		r9, (r8)
	beq		r9, r0, sample_null

	# If so, reset sample complete variable and return map to buffers.
	stb		r0, (r8)
	movia	r2, sample_map
	br		sample_done_done

sample_null:
	# Otherwise, return null.
	mov		r2, r0

sample_done_done:
	RESTORE
	ret


sample_map:
	.word	sample_buffer_A
	.word	sample_buffer_B
	.word	sample_buffer_L


.section  .data     #start data section

sample_complete:	.byte			# 0 = still trying to get sample; 1 = sample done.
sample_buffer_A:	.skip	480		# Buffer stores display-worth of ADC samples (ch. A).
sample_buffer_B:	.skip	480		# Buffer stores display-worth of ADC samples (ch. B).
sample_buffer_L:	.skip	480		# Buffer stores display-worth of ADC samples (Logic).
