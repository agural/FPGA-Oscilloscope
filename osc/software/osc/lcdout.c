/****************************************************************************/
/*                                                                          */
/*                                  LCDOUT                                  */
/*                           LCD Output Functions                           */
/*                       Digital Oscilloscope Project                       */
/*                                 EE/CS 52                                 */
/*                                                                          */
/****************************************************************************/

/*
   This file contains the functions for doing output to the LCD screen for the
   Digital Oscilloscope project.  The functions included are:
      clear_region - clear a region of the display
      plot_char    - output a character
      plot_hline   - draw a horizontal line
      plot_string  - output a string
      plot_vline   - draw a vertical line

   The local functions included are:
      none

   The locally global variable definitions included are:
      none


   Revision History
      3/8/94   Glen George       Initial revision.
      3/13/94  Glen George       Updated comments.
      3/13/94  Glen George       Simplified code in plot_string function.
      3/17/97  Glen George       Updated comments.
      3/17/97  Glen George       Change plot_char() and plot_string() to use
			         enum char_style instead of an int value.
      5/27/98  Glen George       Change plot_char() to explicitly declare the
			         size of the external array to avoid linker
			         errors.
*/



/* library include files */
  /* none */

/* local include files */
#include  "interfac.h"
#include  "scopedef.h"
#include  "lcdout.h"




/*
   clear_region

   Description:      This function clears the passed region of the display.
                     The region is described by its upper left corner pixel
                     coordinate and the size (in pixels) in each dimension.

   Arguments:        x_ul (int)   - x coordinate of upper left corner of the
   				    region to be cleared.
   		     y_ul (int)   - y coordinate of upper left corner of the
   				    region to be cleared.
		     x_size (int) - horizontal size of the region.
		     y_size (int) - vertical size of the region.
   Return Value:     None.

   Input:            None.
   Output:           A portion of the screen is cleared (set to PIXEL_WHITE).

   Error Handling:   No error checking is done on the coordinates.

   Algorithms:       None.
   Data Structures:  None.

   Global Variables: None.

   Author:           Glen George
   Last Modified:    Mar. 8, 1994

*/

void  clear_region(int x_ul, int y_ul, int x_size, int y_size)
{
    /* variables */
    int  x;		/* x coordinate to clear */
    int  y;		/* y coordinate to clear */



    /* loop, clearing the display */
    for (x = x_ul; x < (x_ul + x_size); x++)  {
        for (y = y_ul; y < (y_ul + y_size); y++)  {

	    /* clear this pixel */
	    plot_pixel(x, y, PIXEL_WHITE);
        }
    }


    /* done clearing the display region - return */
    return;

}




/*
   plot_hline

   Description:      This function draws a horizontal line from the passed
                     position for the passed length.  The line is always drawn
                     with the color PIXEL_BLACK.  The position (0,0) is the
		     upper left corner of the screen.

   Arguments:        start_x (int) - starting x coordinate of the line.
   		     start_y (int) - starting y coordinate of the line.
		     length (int)  - length of the line (positive for a line
		     		     to the "right" and negative for a line to
				     the "left").
   Return Value:     None.

   Input:            None.
   Output:           A horizontal line is drawn at the specified position.

   Error Handling:   No error checking is done on the coordinates.

   Algorithms:       None.
   Data Structures:  None.

   Global Variables: None.

   Author:           Glen George
   Last Modified:    Mar. 7, 1994

*/

void  plot_hline(int start_x, int start_y, int length)
{
    /* variables */
    int  x;		/* x position while plotting */

    int  init_x;	/* starting x position to plot */
    int  end_x;		/* ending x position to plot */



    /* check if a line to the "right" or "left" */
    if (length > 0)  {

        /* line to the "right" - start at start_x, end at start_x + length */
	init_x = start_x;
	end_x = start_x + length;
    }
    else  {

        /* line to the "left" - start at start_x + length, end at start_x */
	init_x = start_x + length;
	end_x = start_x;
    }


    /* loop, outputting points for the line (always draw to the "right") */
    for (x = init_x; x < end_x; x++)
        /* plot a point of the line */
	plot_pixel(x, start_y, PIXEL_BLACK);


    /* done plotting the line - return */
    return;

}




/*
   plot_vline

   Description:      This function draws a vertical line from the passed
                     position for the passed length.  The line is always drawn
                     with the color PIXEL_BLACK.  The position (0,0) is the
		     upper left corner of the screen.

   Arguments:        start_x (int) - starting x coordinate of the line.
   		     start_y (int) - starting y coordinate of the line.
		     length (int)  - length of the line (positive for a line
		     		     going "down" and negative for a line
				     going "up").
   Return Value:     None.

   Input:            None.
   Output:           A vertical line is drawn at the specified position.

   Error Handling:   No error checking is done on the coordinates.

   Algorithms:       None.
   Data Structures:  None.

   Global Variables: None.

   Author:           Glen George
   Last Modified:    Mar. 7, 1994

*/

void  plot_vline(int start_x, int start_y, int length)
{
    /* variables */
    int  y;		/* y position while plotting */

    int  init_y;	/* starting y position to plot */
    int  end_y;		/* ending y position to plot */



    /* check if an "up" or "down" line */
    if (length > 0)  {

        /* line going "down" - start at start_y, end at start_y + length */
	init_y = start_y;
	end_y = start_y + length;
    }
    else  {

        /* line going "up" - start at start_y + length, end at start_y */
	init_y = start_y + length;
	end_y = start_y;
    }


    /* loop, outputting points for the line (always draw "down") */
    for (y = init_y; y < end_y; y++)
        /* plot a point of the line */
	plot_pixel(start_x, y, PIXEL_BLACK);


    /* done plotting the line - return */
    return;

}




/*
   plot_char

   Description:      This function outputs the passed character to the LCD
                     screen at passed location.  The passed location is given
                     as a character position with (0,0) being the upper left
		     corner of the screen.  The character can be drawn in
		     "normal video" (black on white) or "reverse video" (white
		     on black).

   Arguments:        pos_x (int)             - x coordinate (in character
   				               cells) of the character.
		     pos_y (int)             - y coordinate (in character
   				               cells) of the character.
		     c (char)                - the character to plot.
		     style (enum char_style) - style with which to plot the
		     		               character (NORMAL or REVERSE).
   Return Value:     None.

   Input:            None.
   Output:           A character is output to the LCD screen.

   Error Handling:   No error checking is done on the coordinates or the
   		     character (to ensure there is a bit pattern for it).

   Algorithms:       None.
   Data Structures:  The character bit patterns are stored in an external
   		     array.

   Global Variables: None.

   Author:           Glen George
   Last Modified:    May 27, 2008

*/

void  plot_char(int pos_x, int pos_y, char c, enum char_style style)
{
    /* variables */

    /* pointer to array of character bit patterns */
    extern const unsigned char   char_patterns[(VERT_SIZE - 1) * 128];

    int  bits;          /* a character bit pattern */

    int  col;		/* column loop index */
    int  row;           /* character row loop index */

    int  x;		/* x pixel position for the character */
    int  y;		/* y pixel position for the character */



    /* setup the pixel positions for the character */
    x = pos_x * HORIZ_SIZE;
    y = pos_y * VERT_SIZE;


    /* loop outputting the bits to the screen */
    for (row = 0; row < VERT_SIZE; row++)  {

        /* get the character bits for this row from the character table */
	if (row == (VERT_SIZE - 1))
	    /* last row - blank it */
	    bits = 0;
	else
	    /* in middle of character, get the row from the bit patterns */
            bits = char_patterns[(c * (VERT_SIZE - 1)) + row];

	/* take care of "normal/reverse video" */
	if (style == REVERSE)
	    /* invert the bits for "reverse video" */
	    bits = ~bits;

        /* get the bits "in position" (high bit is output first */
	bits <<= (8 - HORIZ_SIZE);


	/* now output the row of the character, pixel by pixel */
	for (col = 0; col < HORIZ_SIZE; col++)  {

            /* output this pixel in the appropriate color */
	    if ((bits & 0x80) == 0)
	        /* blank pixel - output in PIXEL_WHITE */
		plot_pixel(x + col, y, PIXEL_WHITE);
	    else
	        /* black pixel - output in PIXEL_BLACK */
		plot_pixel(x + col, y, PIXEL_BLACK);

	    /* shift the next bit into position */
	    bits <<= 1;
        }


	/* next row - update the y position */
	y++;
    }


    /* all done, return */
    return;

}




/*
   plot_string

   Description:      This function outputs the passed string to the LCD screen
                     at passed location.  The passed location is given as a
                     character position with (0,0) being the upper left corner
		     of the screen.  There is no line wrapping, so the entire
		     string must fit on the passed line (pos_y).  The string
		     can be drawn in "normal video" (black on white) or
		     "reverse video" (white on black).

   Arguments:        pos_x (int)             - x coordinate (in character
   				               cells) of the start of the
					       string.
		     pos_y (int)             - y coordinate (in character
   				               cells) of the start of the
					       string.
		     s (const char *)        - the string to output.
		     style (enum char style) - style with which to plot
		     		               characters of the string.
   Return Value:     None.

   Input:            None.
   Output:           A string is output to the LCD screen.

   Error Handling:   No checking is done to insure the string is fully on the
   		     screen (the x and y coordinates and length of the string
		     are not checked).

   Algorithms:       None.
   Data Structures:  None.

   Global Variables: None.

   Author:           Glen George
   Last Modified:    Mar. 17, 1997

*/

void  plot_string(int pos_x, int pos_y, const char *s, enum char_style style)
{
    /* variables */
      /* none */



    /* loop, outputting characters from string s */
    while (*s != '\0')

        /* output this character and move to the next character and screen position */
	plot_char(pos_x++, pos_y, *s++, style);


    /* all done, return */
    return;

}
