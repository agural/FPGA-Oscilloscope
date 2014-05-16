################################################################################
#                                                                              #
#                                    Key UI                                    #
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
#include "keyui.m"
#include "../osc_bsp/system.h"
#include "../osc_bsp/HAL/inc/alt_types.h"
#include "../osc_bsp/drivers/inc/altera_avalon_pio_regs.h"
#include "../osc_bsp/HAL/inc/sys/alt_irq.h"

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

 /*void gen_pb_interrupt_handler(void* isr_context) {
	IOWR_ALTERA_AVALON_PIO_IRQ_MASK(0x00051010, 0);

	int edge_cap = IORD_ALTERA_AVALON_PIO_EDGE_CAP(0x00051010);
	int x = (edge_cap & 0x0002) >> 1;
	x *= 2;

	IOWR_ALTERA_AVALON_PIO_EDGE_CAP(0x00051010, 0x000fffff);
	IOWR_ALTERA_AVALON_PIO_IRQ_MASK(0x00051010, 0x000fffff);
	return;
}*/

.global key_handler
.type key_handler,@function

keyHandler:
	#TODO

KeyHandlerDone:
	ret
	


.section  .data     #start data section

#TODO
  
