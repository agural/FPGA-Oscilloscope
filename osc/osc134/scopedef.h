/****************************************************************************/
/*                                                                          */
/*                                SCOPEDEF.H                                */
/*                           General Definitions                            */
/*                               Include File                               */
/*                       Digital Oscilloscope Project                       */
/*                                 EE/CS 52                                 */
/*                                                                          */
/****************************************************************************/

/*
   This file contains the general definitions for the Digital Oscilloscope
   project.  This includes constant and structure definitions along with the
   function declarations for the assembly language functions.


   Revision History:
      3/8/94   Glen George       Initial revision.
      3/13/94  Glen George       Updated comments.
      3/17/97  Glen George       Removed KEYCODE_UNUSED (no longer used).
      5/3/06   Glen George       Added conditional definitions for handling
                                 different architectures.
      5/9/06   Glen George       Updated declaration of start_sample() to
                                 match the new specification.
      5/27/08  Glen George       Added check for __nios__ definition to also
                                 indicate the compilation is for an Altera
			         NIOS CPU.
*/



#ifndef  __SCOPEDEF_H__
    #define  __SCOPEDEF_H__


/* library include files */
  /* none */

/* local include files */
#include  "interfac.h"
#include  "lcdout.h"




/* constants */

/* general constants */
#define  FALSE       0
#define  TRUE        !FALSE
#define  NULL        (void *) 0

/* display size (in characters) */
#define  LCD_WIDTH   (SIZE_X / HORIZ_SIZE)
#define  LCD_HEIGHT  (SIZE_Y / VERT_SIZE)




/* macros */

/* let __nios__ also mean a NIOS compilation */
#ifdef  __nios__
  #define  NIOS			/* use the standard NIOS defintion */
#endif

/* add the definitions necessary for the Altera NIOS chip */
#ifdef  NIOS
  #define  FLAT_MEMORY		/* use the flat memory model */
#endif


/* if a flat memory model don't need far pointers */
#ifdef  FLAT_MEMORY
  #define  far
#endif




/* structures, unions, and typedefs */

/* program states */
enum status  {  MENU_ON,	/* menu is displayed with the cursor in it */
		MENU_OFF,	/* menu is not displayed - no cursor */
		NUM_STATES	/* number of states */
	     };

/* key codes */
enum keycode  {  KEYCODE_MENU,      /* <Menu>     */
	         KEYCODE_UP,        /* <Up>       */
	         KEYCODE_DOWN,      /* <Down>     */
	         KEYCODE_LEFT,      /* <Left>     */
	         KEYCODE_RIGHT,     /* <Right>    */
	         KEYCODE_ILLEGAL,   /* other keys */
		 NUM_KEYCODES       /* number of key codes */
              }; 




/* function declarations */

/* keypad functions */
unsigned char  key_available(void);     /* key is available */
int            getkey(void);  		/* get a key */

/* display functions  */
void  clear_display(void);			      /* clear the display */
void  plot_pixel(unsigned int, unsigned int, int);    /* output a pixel */

/* sampling parameter functions */
int   set_sample_rate(long int);	/* set the sample rate */
void  set_trigger(int, int);		/* set trigger level and slope */
void  set_delay(long int);		/* set the trigger delay time */

/* sampling functions */
void                start_sample(int);	/* capture a sample */
unsigned char far  *sample_done(void);	/* sample captured status */


#endif
