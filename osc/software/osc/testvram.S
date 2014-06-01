################################################################################
#                                                                              #
#                                 VRAM Test Code                               #
#                 	            Test code for VRAM                             #
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

.global test_vram
.type test_vram,@function

test_vram:
	SAVE

	movhi	r8, %hi(VRAM_CTRL_BASE)
	ori		r8, r8, %lo(VRAM_CTRL_BASE)
	movhi	r9, %hi(VRAM_CTRL_SPAN)
	ori		r9, r9, %lo(VRAM_CTRL_SPAN)
	add		r9, r8, r9
	movui	r12, 0x7000

	#call	write_read_all

	call	write_all
	call	read_all

	nop
	call	read_all

test_vram_fail:
	nop
	br 		test_vram_fail

test_vram_done:
	RESTORE
	ret


.type write_all, @function

write_all:
	mov		r10, r8
	mov		r11, r0

write_all_loop:
	sthio	r11, (r10)
	addi	r10, r10, 2
	addi	r11, r11, 1
	bgeu	r10, r9, write_all_done
	bgeu	r11, r12, write_all_reset_cnt
	br		write_all_loop

write_all_reset_cnt:
	mov		r11, r0
	br		write_all_loop

write_all_done:
	ret


.type read_all, @function

read_all:
	mov		r10, r8
	mov		r11, r0

read_all_loop:
	ldhio	r13, (r10)
	bne		r13, r11, test_vram_fail
	addi	r10, r10, 2
	addi	r11, r11, 1
	bgeu	r10, r9, read_all_done
	bgeu	r11, r12, read_all_reset_cnt
	br		read_all_loop

read_all_reset_cnt:
	mov		r11, r0
	br		write_all_loop

read_all_done:
	ret




.section  .data     #start data section

#TODO
