/****************************************************************************/
/*                                                                          */
/*                                 LCDOUT.H                                 */
/*                           LCD Output Functions                           */
/*                               Include File                               */
/*                       Digital Oscilloscope Project                       */
/*                                EE/CS  52                                 */
/*                                                                          */
/****************************************************************************/

/*
   This file contains the constants and function prototypes for the LCD output
   functions used in the Digital Oscilloscope project and defined in lcdout.c.


   Revision History:
      3/8/94   Glen George       Initial revision.
      3/13/94  Glen George       Updated comments.
      3/17/97  Glen George       Added enumerated type char_style and updated
                                    function prototypes.
*/




#ifndef  __LCDOUT_H__
    #define  __LCDOUT_H__


/* library include files */
  /* none */

/* local include files */
  /* none */




/* constants */

/* character output styles */

/* size of a character (includes 1 pixel space to the left and below character) */
#define  VERT_SIZE    8         /* vertical size (in pixels -> 7+1) */
#define  HORIZ_SIZE   6         /* horizontal size (in pixels -> 5+1) */




/* structures, unions, and typedefs */

/* character output styles */
enum  char_style  {  NORMAL,    /* "normal video" */
                     REVERSE	/* "reverse video" */
	          };




/* function declarations */

void  clear_region(int, int, int, int);		  /* clear part of the display */

void  plot_hline(int, int, int);		  /* draw a horizontal line */
void  plot_vline(int, int, int);		  /* draw a vertical line */

void  plot_char(int, int, char, enum char_style); /* output a character */
void  plot_string(int, int, const char *, enum char_style);  /* output a string */


#endif
