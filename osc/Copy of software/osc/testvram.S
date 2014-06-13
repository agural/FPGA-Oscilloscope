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
#include "../osc_bsp/system.h"

.equ	VRAM_OFFSET, 0x00080000

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

.global TestVRAM
.type TestVRAM,@function

TestVRAM:
	movhi	r8, %hi(VRAM_OFFSET)
	ori		r8, r8, %lo(VRAM_OFFSET)
	mov		r9, r0
	sthio	r9, (r8)
	addi	r8, r8, 2
	addi	r9, r9, 1
	jmpi	TestVRAM

TestVRAMdone:
	ret



.section  .data     #start data section

#TODO
