################################################################################
#                                                                              #
#                               Convenient Macros                              #
#                  Convenient assembly macros for general use                  #
#                                   EE/CS 52                                   #
#                                                                              #
################################################################################


/*
 *  Albert Gural
 *  EE/CS 52
 *  TA: Dan Pipe-Mazo
 *
 *  File Description:	Provides macros for convenience.
 *
 *  Revision History:
 *		05/14/2014	Albert Gural	Wrote initial macros (PUSH, POP, SAVE, RESTORE).
 *      06/02/2014  Albert Gural 	Updated with more macros (STWI, MOVWI).
 *
 */


/*
 *  STWI
 *
 *  Description: Acts like sthio, but for word-size values. Also, can be
 *  directly supplied with the address and immediage value (no need for
 *  the value to be passed in a register).
 *
 *  Arguments:
 *  addr - immediate that gives the address of the memory to write to
 *  val  - immediate that gives the value to write to that memory
 *
 *  Return Value: (none)
 *
 */

.macro STWI	addr, val
	PUSH	r9
	PUSH	r10
	
	MOVWI	r9, \addr
	MOVWI	r10, \val
	stwio	r10, (r9)
	
	POP		r10
	POP		r9
.endm


/*
 *  MOVWI
 *
 *  Description: Acts like movhi, but for word-size values.
 *
 *  Arguments:
 *  reg - register to write value to
 *  val - value to update register with
 *
 *  Return Value: (none)
 *
 */

.macro MOVWI reg, val
	movhi	\reg, %hi(\val)
	ori		\reg, \reg, %lo(\val)
.endm


/*
 *  PUSH
 *
 *  Description: Pushes the supplied register on to the stack.
 *
 *  Arguments:
 *  reg - The register
 *
 *  Return Value: (none)
 *
 */

.macro PUSH reg
	subi sp, sp, 4
	stw \reg, 0(sp)
.endm


/*
 *  POP
 *
 *  Description: Pops from the stack to the supplied register
 *
 *  Arguments:
 *  reg - The register
 *
 *  Return Value: (none)
 *
 */

.macro POP reg
	ldw \reg, 0(sp)
	addi sp, sp, 4
.endm


/*
 *  SAVE
 *
 *  Description: Sets up the stack frame correctly so that a function can use
 *  the stack, then restore it to the same it was before the function was called.
 *
 *  Arguments: (none)
 *
 *  Return Value: (none)
 *
 */

.macro SAVE
	PUSH	r31
	PUSH	fp
	mov		fp, sp
.endm


/*
 *  RESTORE
 *
 *  Description: Restores the stack frame to the state it was in before the
 *  matching SAVE was called. This requires that the stack pointer not be
 *  tampered with in any non-trivial way (that is, in a way besides standard
 *  push/pop). Also requires that pushes and pops are always balanced correctly.
 *
 *  Arguments: (none)
 *
 *  Return Value: (none)
 *
 */

.macro RESTORE
	mov		sp, fp
	POP		fp
	POP		r31
.endm
