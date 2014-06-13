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
 *  File Description:	TODO
 *
 *  Table of Contents:	TODO
 *
 *  Revision History:
 *		05/14/2014	Albert Gural	Wrote initial macros (PUSH, POP, SAVE, RESTORE).
 *
 */


/*
 *  MOVWI
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

.macro MOVWI reg, val
	movhi	\reg, %hi(\val)
	ori		\reg, \reg, %lo(\val)
.endm


/*
 *  PUSH
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

.macro PUSH reg
	subi sp, sp, 4
	stw \reg, 0(sp)
.endm


/*
 *  POP
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

.macro POP reg
	ldw \reg, 0(sp)
	addi sp, sp, 4
.endm


/*
 *  SAVE
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

.macro SAVE
	PUSH	r31
	PUSH	fp
	mov		fp, sp
.endm


/*
 *  RESTORE
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

.macro RESTORE
	mov		sp, fp
	POP		fp
	POP		r31
.endm
