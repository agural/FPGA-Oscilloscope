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
#include "keyint.m"
#include "interfac.h"
#include "../keytest_bsp/system.h"
/*#include "../keytest_bsp/drivers/inc/altera_avalon_pio_regs.h"
#include "../keytest_bsp/HAL/inc/sys/alt_irq.h"
*/
.section  .text         #start code section


.macro PUSH reg
	subi sp, sp, 4
	stw \reg, 0(sp)
.endm

.macro POP reg
	ldw \reg, 0(sp)
	addi sp, sp, 4
.endm

.macro SAVE
	PUSH	r31
	PUSH	fp
	mov		fp, sp
.endm

.macro RESTORE
	mov		sp, fp
	POP		fp
	POP		r31
.endm


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

 /*void gen_pb_interrupt_handler(void* isr_context) {
	IOWR_ALTERA_AVALON_PIO_IRQ_MASK(0x00051010, 0);

	int edge_cap = IORD_ALTERA_AVALON_PIO_EDGE_CAP(0x00051010);
	int x = (edge_cap & 0x0002) >> 1;
	x *= 2;

	IOWR_ALTERA_AVALON_PIO_EDGE_CAP(0x00051010, 0x000fffff);
	IOWR_ALTERA_AVALON_PIO_IRQ_MASK(0x00051010, 0x000fffff);
	return;
}*/


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

key_lookup:
	movia	r8, key_map
	add		r8, r8, r11
	ldb		r8,	(r8)

	movia	r10, key_value
	stb		r8, (r10)

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

key_hndler_done:
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

.global key_available
.type	key_available, @function

key_available:
	SAVE
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

