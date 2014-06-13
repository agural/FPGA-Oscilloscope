################################################################################
#                                                                              #
#                             Key Interrupt Handler                            #
#                 	 Rotary Encoder and Menu Button Routines                   #
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
 *		05/14/2014	Albert Gural	Begain writing assembly functions to handle
 *									keypress interrupts.
 *
 */

 /*  Local Include Files   */
#include "macros.m"
#include "keyint.m"
#include "interfac.h"
#include "../osc_bsp/system.h"


.section  .text         #start code section


/*
 *  key_int_installer
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

.global key_int_installer
.type	key_int_installer, @function

key_int_installer:
	SAVE

	# asdf
	movia	r8, adc_speed
	movi	r9, 0x040000
	stw		r9, (r8)
	movia	r8, trig_level
	movi	r9, 0
	stb		r9, (r8)
	movia	r8, trig_delay
	movi	r9, 240
	sth		r9, (r8)
	# asdf

	# Enable all switch interrupts.
	movhi	r8, %hi(KEY_INPUT_BASE)
	ori		r8, r8, %lo(KEY_INPUT_BASE)
	movhi	r9, %hi(SWITCH_ALL)
	ori		r9, r9, %lo(SWITCH_ALL)
	stw		r9, PIO_IRQ_MASK(r8)

	# Install the interrupt handler
	mov		r4, r0
	movi	r5, KEY_INPUT_IRQ
	movhi	r6, %hi(key_handler)
	ori		r6, r6, %lo(key_handler)
	mov		r7, r0
	PUSH	r0
	call	alt_ic_isr_register
	POP		r0

key_int_installer_done:
	RESTORE
	ret


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
 *      05/18/2014	Albert Gural	Initial revision.
 *
 */

.type key_handler,@function

key_handler:
	SAVE

	# Key should now be available. Update key_press.
	movi	r8, 1
	movia	r9, key_press
	stb		r8, (r9)

	# Clear interrupts.
	movhi	r8, %hi(KEY_INPUT_BASE)
	ori		r8, r8, %lo(KEY_INPUT_BASE)
	stw		r0, PIO_IRQ_MASK(r8)

	# Get the edge capture register.
	movhi	r8, %hi(KEY_INPUT_BASE)
	ori		r8, r8, %lo(KEY_INPUT_BASE)
	ldw		r8, PIO_EDGE_CAP(r8)

	# Check each bit (starting at 0) and see if set.
	movi	r9, 1
	movi	r11, 0

loop_keys:
	and		r10, r8, r9
	bne		r10, r0, key_lookup
	slli	r9, r9, 1
	addi	r11, r11, 1
	br		loop_keys

	# Once the key is found (r11), use the lookup table to set key_value.
key_lookup:
	movia	r8, key_map
	add		r8, r8, r11
	ldb		r8,	(r8)

	movia	r10, key_value
	stb		r8, (r10)

	# Remove later!!!
	movi	r12, 10
	beq		r11, r12, inc_speed
	movi	r12, 11
	beq		r11, r12, dec_speed

	movi	r12, 16
	beq		r11, r12, inc_level
	movi	r12, 17
	beq		r11, r12, dec_level

	movi	r12, 18
	beq		r11, r12, inc_delay
	movi	r12, 19
	beq		r11, r12, dec_delay
key_lookup_cont:
	# <END Remove later!!!>

	# Clear the edge capture register (write 1 to clear).
	movhi	r8, %hi(KEY_INPUT_BASE)
	ori		r8, r8, %lo(KEY_INPUT_BASE)
	movhi	r9, %hi(SWITCH_ALL)
	ori		r9, r9, %lo(SWITCH_ALL)
	stw		r9, PIO_EDGE_CAP(r8)

	# Re-enable interrupts.
	movhi	r8, %hi(KEY_INPUT_BASE)
	ori		r8, r8, %lo(KEY_INPUT_BASE)
	movhi	r9, %hi(SWITCH_ALL)
	ori		r9, r9, %lo(SWITCH_ALL)
	stw		r9, PIO_IRQ_MASK(r8)

key_handler_done:
	RESTORE
	ret

# hashtag
dec_speed:
	movia	r13, adc_speed
	ldw		r14, (r13)
	slli	r14, r14, 1
	MOVWI	r15, 0x00FFFFFF
	and		r14, r14, r15
	beq		r14, r0, set_speed_2
dec_speed_cont:
	MOVWI	r15, ADC_RATE_BASE
	stw		r14, (r15)
	stw		r14, (r13)

	# Turn on FIFO write
	STWI	ADC_CTRL_BASE, 0x04
	STWI	ADC_CTRL_BASE, 0x02

	br		key_lookup_cont

inc_speed:
	movia	r13, adc_speed
	ldwio	r14, (r13)
	srli	r14, r14, 1
	beq		r14, r0, set_speed_1
inc_speed_cont:
	MOVWI	r15, ADC_RATE_BASE
	stwio	r14, (r15)
	stwio	r14, (r13)

	# Turn on FIFO write
	STWI	ADC_CTRL_BASE, 0x04
	STWI	ADC_CTRL_BASE, 0x02

	br		key_lookup_cont

set_speed_1:
	movi	r14, 1
	br		inc_speed_cont

set_speed_2:
	MOVWI	r14, 0x00800000
	br		dec_speed_cont



dec_level:
	movia	r13, trig_level
	ldb		r14, (r13)
	subi	r14, r14, 5
	movi	r15, -128
	blt		r14, r15, set_level_2
dec_level_cont:
	MOVWI	r15, TRIG_LEVEL_BASE
	stw		r14, (r15)
	stb		r14, (r13)

	# Turn on FIFO write
	STWI	ADC_CTRL_BASE, 0x04
	STWI	ADC_CTRL_BASE, 0x02

	br		key_lookup_cont

inc_level:
	movia	r13, trig_level
	ldb		r14, (r13)
	addi	r14, r14, 5
	movi	r15, 127
	bgt		r14, r15, set_level_1
inc_level_cont:
	MOVWI	r15, TRIG_LEVEL_BASE
	stw		r14, (r15)
	stb		r14, (r13)

	# Turn on FIFO write
	STWI	ADC_CTRL_BASE, 0x04
	STWI	ADC_CTRL_BASE, 0x02

	br		key_lookup_cont

set_level_1:
	movi	r14, 127
	br		inc_level_cont

set_level_2:
	MOVWI	r14, -128
	br		dec_level_cont



dec_delay:
	movia	r13, trig_delay
	ldh		r14, (r13)
	subi	r14, r14, 10
	ble		r14, r0, set_delay_2
dec_delay_cont:
	MOVWI	r15, TRIG_DELAY_BASE
	stw		r14, (r15)
	sth		r14, (r13)

	# Turn on FIFO write
	STWI	ADC_CTRL_BASE, 0x04
	STWI	ADC_CTRL_BASE, 0x02

	br		key_lookup_cont

inc_delay:
	movia	r13, trig_delay
	ldh		r14, (r13)
	addi	r14, r14, 10
	movi	r15, 1000
	bgeu	r14, r15, set_delay_1
inc_delay_cont:
	MOVWI	r15, TRIG_DELAY_BASE
	stw		r14, (r15)
	sth		r14, (r13)

	# Turn on FIFO write
	STWI	ADC_CTRL_BASE, 0x04
	STWI	ADC_CTRL_BASE, 0x02

	br		key_lookup_cont

set_delay_1:
	MOVWI	r14, 50000
	br		inc_delay_cont

set_delay_2:
	mov		r14, r0
	br		dec_delay_cont

# hashtag


/*
 *  key_available
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

.global key_available
.type	key_available, @function

key_available:
	SAVE

	# Simply return the value in key_press.
	movia	r2, key_press
	ldb		r2, (r2)

key_available_done:
	RESTORE
	ret


/*
 *  key_available
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

.global	getkey
.type	getkey, @function

getkey:
	SAVE

	# Block until legal key arrives (which is also when key_press = TRUE).
	movia	r8, key_value
	ldb		r8, (r8)
	movi	r9, KEY_ILLEGAL
	beq		r8, r9, getkey

	# Get return value.
	movia	r2, key_value
	ldb		r2, (r2)

	# Update key_value with KEY_ILLEGAL.
	movia	r10, key_value
	stb		r9, (r10)

	# Update key_press with FALSE.
	movia	r10, key_press
	stb		r0, (r10)

getkey_done:
	RESTORE
	ret


/*
 *  key_map
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

key_map:	.byte	KEY_MENU
			.byte	KEY_UP
			.byte	KEY_DOWN
			.byte	KEY_LEFT
			.byte	KEY_RIGHT
			.byte	KEY_MENU
			.byte	KEY_MENU
			.byte	KEY_MENU
			.byte	KEY_MENU
			.byte	KEY_MENU
			.byte	KEY_MENU
			.byte	KEY_MENU
			.byte	KEY_MENU
			.byte	KEY_MENU
			.byte	KEY_MENU
			.byte	KEY_MENU
			.byte	KEY_MENU
			.byte	KEY_MENU
			.byte	KEY_MENU
			.byte	KEY_ILLEGAL


.section  .data     #start data section

key_press:	.byte	0		# Gives whether a key has been pressed.
key_value:	.byte	0		# Gives the value of the pressed key.
			.align	4
adc_speed:	.word	0		# Gives compare value for ADC clock speed.
trig_delay:	.hword	0		# Gives trigger delay.
trig_level:	.byte	0		# Gives trigger level.

