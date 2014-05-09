/****************************************************************************/
/*                                                                          */
/*                                 TRACUTIL                                 */
/*                         Trace Utility Functions                          */
/*                       Digital Oscilloscope Project                       */
/*                                 EE/CS 52                                 */
/*                                                                          */
/****************************************************************************/

/*
   This file contains the utility functions for handling traces (capturing
   and displaying data) for the Digital Oscilloscope project.  The functions
   included are:
      clear_saved_areas  - clear all the save areas
      do_trace           - start a trace
      init_trace         - initialize the trace routines
      plot_trace         - plot a trace (sampled data)
      restore_menu_trace - restore the saved area under the menus
      restore_trace      - restore the saved area of a trace
      set_display_scale  - set the type of displayed scale (and display it)
      set_mode           - set the triggering mode
      set_save_area      - determine an area of a trace to save
      set_trace_size     - set the number of samples in a trace
      trace_done         - inform this module that a trace has been completed
      trace_rdy          - determine if system is ready to start another trace
      trace_rearm        - re-enable tracing (in one-shot triggering mode)

   The local functions included are:
      none

   The locally global variable definitions included are:
      cur_scale    - current scale type
      sample_size  - the size of the sample for the trace
      sampling     - currently doing a sample
      saved_area   - saved trace under a specified area
      saved_axis_x - saved trace under the x lines (axes or grid)
      saved_axis_y - saved trace under the y lines (axes or grid)
      saved_menu   - saved trace under the menu
      saved_pos_x  - starting position (x coorindate) of area to save
      saved_pos_y  - starting position (y coorindate) of area to save
      saved_end_x  - ending position (x coorindate) of area to save
      saved_end_y  - ending position (y coorindate) of area to save
      trace_status - whether or not ready to start another trace


   Revision History
      3/8/94   Glen George       Initial revision.
      3/13/94  Glen George       Updated comments.
      3/13/94  Glen George       Fixed inversion of signal in plot_trace.
      3/13/94  Glen George       Added sampling flag and changed the functions
      			    	 init_trace, do_trace and trace_done to update
				 the flag.  Also the function trace_rdy now
				 uses it.  The function set_mode was updated
				 to always say a trace is ready for normal
				 triggering.
      3/13/94  Glen George       Fixed bug in trace restoring due to operator
			         misuse (&& instead of &) in the functions
				 set_axes, restore_menu_trace, and
				 restore_trace.
      3/13/94  Glen George       Fixed bug in trace restoring due to the clear
			         function (clear_saved_areas) not clearing all
				 of the menu area.
      3/13/94  Glen George       Fixed comparison bug when saving traces in
			         plot_trace.
      3/13/94  Glen George       Changed name of set_axes to set_display_scale
			         and the name of axes_state to cur_scale to
				 more accurately reflect the function/variable
				 use (especially if add scale display types).
      3/17/97  Glen George       Updated comments.
      3/17/97  Glen George       Changed set_display_scale to use plot_hline
			         and plot_vline functions to output axes.
      5/3/06   Glen George       Updated formatting.
      5/9/06   Glen George       Updated do_trace function to match the new
                                 definition of start_sample().
      5/9/06   Glen George       Removed normal_trg variable, its use is now
                                 handled by the get_trigger_mode() accessor.
      5/9/06   Glen George       Added tick marks to the axes display.
      5/9/06   Glen George       Added ability to display a grid.
      5/27/08  Glen George       Added is_sampling() function to be able to
	                         tell if the system is currently taking a
				 sample.
      5/27/08  Glen George       Changed set_mode() to always turn off the
	                         sampling flag so samples with the old mode
                                 setting are ignored.
      6/3/08   Glen George       Fixed problems with non-power of 2 display
				 sizes not working.
*/



/* library include files */
  /* none */

/* local include files */
#include  "scopedef.h"
#include  "lcdout.h"
#include  "menu.h"
#include  "menuact.h"
#include  "tracutil.h"




/* locally global variables */

static int  trace_status;	/* ready to start another trace */

static int  sampling;           /* currently sampling data */

static int  sample_size; 	/* number of data points in a sample */

static enum scale_type  cur_scale;	/* current display scale type */

/* traces (sampled data) saved under the axes */
static unsigned char  saved_axis_x[2 * Y_TICK_CNT + 1][PLOT_SIZE_X/8];	/* saved trace under x lines */
static unsigned char  saved_axis_y[2 * X_TICK_CNT + 1][PLOT_SIZE_Y/8];	/* saved trace under y lines */

/* traces (sampled data) saved under the menu */
static unsigned char  saved_menu[MENU_SIZE_Y][(MENU_SIZE_X + 7)/8];

/* traces (sampled data) saved under any area */
static unsigned char  saved_area[SAVE_SIZE_Y][SAVE_SIZE_X/8]; /* saved trace under any area */
static int	      saved_pos_x;    /* starting x position of saved area */
static int	      saved_pos_y;    /* starting y position of saved area */
static int	      saved_end_x;    /* ending x position of saved area */
static int	      saved_end_y;    /* ending y position of saved area */




/*
   init_trace

   Description:      This function initializes all of the locally global
                     variables used by these routines.  The saved areas are
		     set to non-existant with cleared saved data.  Normal
		     normal triggering is set, the system is ready for a
		     trace, the scale is turned off and the sample size is set
		     to the screen size.

   Arguments:        None.
   Return Value:     None.

   Input:            None.
   Output:           None.

   Error Handling:   None.

   Algorithms:       None.
   Data Structures:  None.

   Global Variables: trace_status - set to TRUE.
		     sampling     - set to FALSE.
		     cur_scale    - set to SCALE_NONE (no displayed scale).
		     sample_size  - set to screen size (SIZE_X).
		     saved_axis_x - cleared.
		     saved_axis_y - cleared.
		     saved_menu   - cleared.
		     saved_area   - cleared.
		     saved_pos_x  - set to off-screen.
		     saved_pos_y  - set to off-screen.
		     saved_end_x  - set to off-screen.
		     saved_end_y  - set to off-screen.

   Author:           Glen George
   Last Modified:    May 9, 2006

*/

void  init_trace()
{
    /* variables */
      /* none */



    /* initialize system status variables */

    /* ready for a trace */
    trace_status = TRUE;

    /* not currently sampling data */
    sampling = FALSE;

    /* turn off the displayed scale */
    cur_scale = SCALE_NONE;

    /* sample size is the screen size */
    sample_size = SIZE_X;


    /* clear save areas */
    clear_saved_areas();

    /* also clear the general saved area location variables (off-screen) */
    saved_pos_x = SIZE_X + 1;
    saved_pos_y = SIZE_Y + 1;
    saved_end_x = SIZE_X + 1;
    saved_end_y = SIZE_Y + 1;


    /* done initializing, return */
    return;

}




/*
   set_mode

   Description:      This function sets the locally global triggering mode
                     based on the passed value (one of the possible enumerated
		     values).  The triggering mode is used to determine when
		     the system is ready for another trace.  The sampling flag
                     is also reset so a new sample will be started (if that is
                     appropriate).

   Arguments:        trigger_mode (enum trigger_type) - the mode with which to
   							set the triggering.
   Return Value:     None.

   Input:            None.
   Output:           None.

   Error Handling:   None.

   Algorithms:       None.
   Data Structures:  None.

   Global Variables: sampling     - set to FALSE to turn off sampling
	             trace_status - set to TRUE if not one-shot triggering.

   Author:           Glen George
   Last Modified:    May 27, 2008

*/

void  set_mode(enum trigger_type trigger_mode)
{
    /* variables */
      /* none */



    /* if not one-shot triggering - ready for trace too */
    trace_status = (trigger_mode != ONESHOT_TRIGGER);


    /* turn off the sampling flag so will start a new sample */
    sampling = FALSE;


    /* all done, return */
    return;

}




/*
   is_sampling

   Description:      This function determines whether the system is currently
                     taking a sample or not.  This is just the value of the
		     sampling flag.

   Arguments:        None.
   Return Value:     (int) - the current sampling status (TRUE if currently
   		     trying to take a sample, FALSE otherwise).

   Input:            None.
   Output:           None.

   Error Handling:   None.

   Algorithms:       None.
   Data Structures:  None.

   Global Variables: sampling - determines if taking a sample or not.

   Author:           Glen George
   Last Modified:    May 27, 2008

*/

int  is_sampling()
{
    /* variables */
      /* none */



    /* currently sampling if sampling flag is set */
    return  sampling;

}




/*
   trace_rdy

   Description:      This function determines whether the system is ready to
                     start another trace.  This is determined by whether or
		     not the system is still sampling (sampling flag) and if
		     it is ready for another trace (trace_status flag).

   Arguments:        None.
   Return Value:     (int) - the current trace status (TRUE if ready to do
   		     another trace, FALSE otherwise).

   Input:            None.
   Output:           None.

   Error Handling:   None.

   Algorithms:       None.
   Data Structures:  None.

   Global Variables: sampling     - determines if ready for another trace.
   		     trace_status - determines if ready for another trace.

   Author:           Glen George
   Last Modified:    Mar. 13, 1994

*/

int  trace_rdy()
{
    /* variables */
      /* none */



    /* ready for another trace if not sampling and trace is ready */
    return  (!sampling && trace_status);

}




/*
   trace_done

   Description:      This function is called to indicate a trace has been
                     completed.  If in normal triggering mode this means the
		     system is ready for another trace.

   Arguments:        None.
   Return Value:     None.

   Input:            None.
   Output:           None.

   Error Handling:   None.

   Algorithms:       None.
   Data Structures:  None.

   Global Variables: trace_status - may be set to TRUE.
   		     sampling     - set to FALSE.

   Author:           Glen George
   Last Modified:    May 9, 2006

*/

void  trace_done()
{
    /* variables */
      /* none */



    /* done with a trace - if retriggering, ready for another one */
    if (get_trigger_mode() != ONESHOT_TRIGGER)
        /* in a retriggering mode - set trace_status to TRUE (ready) */
	trace_status = TRUE;

    /* no longer sampling data */
    sampling = FALSE;


    /* done so return */
    return;

}




/*
   trace_rearm

   Description:      This function is called to rearm the trace.  It sets the
                     trace status to ready (TRUE).  It is used to rearm the
		     trigger in one-shot mode.

   Arguments:        None.
   Return Value:     None.

   Input:            None.
   Output:           None.

   Error Handling:   None.

   Algorithms:       None.
   Data Structures:  None.

   Global Variables: trace_status - set to TRUE.

   Author:           Glen George
   Last Modified:    Mar. 8, 1994

*/

void  trace_rearm()
{
    /* variables */
      /* none */



    /* rearm the trace - set status to ready (TRUE) */
    trace_status = TRUE;


    /* all done - return */
    return;

}




/*
   set_trace_size

   Description:      This function sets the locally global sample size to the
                     passed value.  This is used to scale the data when
		     plotting a trace.

   Arguments:        size (int) - the trace sample size.
   Return Value:     None.

   Input:            None.
   Output:           None.

   Error Handling:   None.

   Algorithms:       None.
   Data Structures:  None.

   Global Variables: sample_size - set to the passed value.

   Author:           Glen George
   Last Modified:    Mar. 8, 1994

*/

void  set_trace_size(int size)
{
    /* variables */
      /* none */



    /* set the locally global sample size */
    sample_size = size;


    /* all done, return */
    return;

}




/*
   set_display_scale

   Description:      This function sets the displayed scale type to the passed
   		     argument.  If the scale is turned on, it draws it.  If it
		     is turned off (SCALE_NONE), it restores the saved trace
		     under the scale.  Scales can be axes with tick marks
                     (SCALE_AXES) or a grid (SCALE_GRID).

   Arguments:        scale (scale_type) - new scale type.
   Return Value:     None.

   Input:            None.
   Output:           Either a scale is output or the trace under the old scale
   		     is restored.

   Error Handling:   None.

   Algorithms:       None.
   Data Structures:  None.

   Global Variables: cur_scale    - set to the passed value.
   		     saved_axis_x - used to restore trace data under x-axis.
   		     saved_axis_y - used to restore trace data under y-axis.

   Author:           Glen George
   Last Modified:    May 9, 2006

*/

void  set_display_scale(enum scale_type scale)
{
    /* variables */
    int  p;             /* x or y coordinate */

    int  i;		/* loop indices */
    int  j;



    /* whenever change scale type, need to clear out previous scale */
    /* unnecessary if going to SCALE_GRID or from SCALE_NONE or not changing the scale */
    if ((scale != SCALE_GRID) && (cur_scale != SCALE_NONE) && (scale != cur_scale))  {

        /* need to restore the trace under the lines (tick, grid, or axis) */

	/* go through all points on horizontal lines */
	for (j = -Y_TICK_CNT; j <= Y_TICK_CNT; j++)  {

	    /* get y position of the line */
	    p = X_AXIS_POS + j * Y_TICK_SIZE;
	    /* make sure it is in range */
	    if (p >= PLOT_SIZE_Y)
	        p = PLOT_SIZE_Y - 1;
	    if (p < 0)
	        p = 0;

	    /* look at entire horizontal line */
	    for (i = 0; i < PLOT_SIZE_X; i++)  {
	        /* check if this point is on or off (need to look at bits) */
		if ((saved_axis_x[j + Y_TICK_CNT][i / 8] & (0x80 >> (i % 8))) == 0)
		    /* saved pixel is off */
		    plot_pixel(i, p, PIXEL_WHITE);
		else
		    /* saved pixel is on */
		    plot_pixel(i, p, PIXEL_BLACK);
	    }
	}

	/* go through all points on vertical lines */
	for (j = -X_TICK_CNT; j <= X_TICK_CNT; j++)  {

	    /* get x position of the line */
	    p = Y_AXIS_POS + j * X_TICK_SIZE;
	    /* make sure it is in range */
	    if (p >= PLOT_SIZE_X)
	        p = PLOT_SIZE_X - 1;
	    if (p < 0)
	        p = 0;

	    /* look at entire vertical line */
	    for (i = 0; i < PLOT_SIZE_Y; i++)  {
	        /* check if this point is on or off (need to look at bits) */
		if ((saved_axis_y[j + X_TICK_CNT][i / 8] & (0x80 >> (i % 8))) == 0)
		    /* saved pixel is off */
		    plot_pixel(p, i, PIXEL_WHITE);
		else
		    /* saved pixel is on */
		    plot_pixel(p, i, PIXEL_BLACK);
	    }
	}
    }


    /* now handle the scale type appropriately */
    switch (scale)  {

    	case SCALE_AXES:    /* axes for the scale */
    	case SCALE_GRID:    /* grid for the scale */

		            /* draw x lines (grid or tick marks) */
			    for (i = -Y_TICK_CNT; i <= Y_TICK_CNT; i++)  {

				/* get y position of the line */
				p = X_AXIS_POS + i * Y_TICK_SIZE;
				/* make sure it is in range */
				if (p >= PLOT_SIZE_Y)
				    p = PLOT_SIZE_Y - 1;
				if (p < 0)
				    p = 0;

				/* should we draw a grid, an axis, or a tick mark */
				if (scale == SCALE_GRID)
				    /* drawing a grid line */
			            plot_hline(X_GRID_START, p, (X_GRID_END - X_GRID_START));
				else if (i == 0)
				    /* drawing the x axis */
			            plot_hline(X_AXIS_START, p, (X_AXIS_END - X_AXIS_START));
				else
				    /* must be drawing a tick mark */
			            plot_hline((Y_AXIS_POS - (TICK_LEN / 2)), p, TICK_LEN);
			    }

		            /* draw y lines (grid or tick marks) */
			    for (i = -X_TICK_CNT; i <= X_TICK_CNT; i++)  {

				/* get x position of the line */
				p = Y_AXIS_POS + i * X_TICK_SIZE;
				/* make sure it is in range */
				if (p >= PLOT_SIZE_X)
				    p = PLOT_SIZE_X - 1;
			        if (p < 0)
				    p = 0;

				/* should we draw a grid, an axis, or a tick mark */
				if (scale == SCALE_GRID)
				    /* drawing a grid line */
			            plot_vline(p, Y_GRID_START, (Y_GRID_END - Y_GRID_START));
				else if (i == 0)
				    /* drawing the y axis */
			            plot_vline(p, Y_AXIS_START, (Y_AXIS_END - Y_AXIS_START));
				else
				    /* must be drawing a tick mark */
			            plot_vline(p, (X_AXIS_POS - (TICK_LEN / 2)), TICK_LEN);
			    }

			    /* done with the axes */
			    break;

        case SCALE_NONE:    /* there is no scale */
			    /* already restored plot so nothing to do */
			    break;

    }


    /* now remember the new (now current) scale type */
    cur_scale = scale;


    /* scale is taken care of, return */
    return;

}




/*
   clear_saved_areas

   Description:      This function clears all the saved areas (for saving the
                     trace under the axes, menus, and general areas).

   Arguments:        None.
   Return Value:     None.

   Input:            None.
   Output:           None.

   Error Handling:   None.

   Algorithms:       None.
   Data Structures:  None.

   Global Variables: saved_axis_x - cleared.
		     saved_axis_y - cleared.
		     saved_menu   - cleared.
		     saved_area   - cleared.

   Author:           Glen George
   Last Modified:    May 9, 2006

*/

void  clear_saved_areas()
{
    /* variables */
    int  i;		/* loop indices */
    int  j;



    /* clear x-axis and y-axis save areas */
    for (j = 0; j <= (2 * Y_TICK_CNT); j++)
        for (i = 0; i < (SIZE_X / 8); i++)
            saved_axis_x[j][i] = 0;
    for (j = 0; j <= (2 * X_TICK_CNT); j++)
        for (i = 0; i < (SIZE_Y / 8); i++)
            saved_axis_y[j][i] = 0;

    /* clear the menu save ares */
    for (i = 0; i < MENU_SIZE_Y; i++)
        for (j = 0; j < ((MENU_SIZE_X + 7) / 8); j++)
	    saved_menu[i][j] = 0;

    /* clear general save area */
    for (i = 0; i < SAVE_SIZE_Y; i++)
        for (j = 0; j < (SAVE_SIZE_X / 8); j++)
	    saved_area[i][j] = 0;


    /* done clearing the saved areas - return */
    return;

}




/*
   restore_menu_trace

   Description:      This function restores the trace under the menu when the
                     menus are turned off.  (The trace was previously saved.)

   Arguments:        None.
   Return Value:     None.

   Input:            None.
   Output:           The trace under the menu is restored to the LCD screen.

   Error Handling:   None.

   Algorithms:       None.
   Data Structures:  None.

   Global Variables: saved_menu - used to restore trace data under the menu.

   Author:           Glen George
   Last Modified:    Mar. 13, 1994

*/

void  restore_menu_trace()
{
    /* variables */
    int  bit_position;	/* position of bit to restore (in saved data) */
    int  bit_offset;    /* offset (in bytes) of bit within saved row */

    int  x;		/* loop indices */
    int  y;



    /* loop, restoring the trace under the menu */
    for (y = MENU_UL_Y; y < (MENU_UL_Y + MENU_SIZE_Y); y++)  {

        /* starting a row - initialize bit position */
	bit_position = 0x80;	/* start at high-order bit in the byte */
	bit_offset = 0;		/* first byte of the row */

        for (x = MENU_UL_X; x < (MENU_UL_X + MENU_SIZE_X); x++)  {

	    /* check if this point is on or off (need to look at bits) */
	    if ((saved_menu[y - MENU_UL_Y][bit_offset] & bit_position) == 0)
	        /* saved pixel is off */
		plot_pixel(x, y, PIXEL_WHITE);
	    else
	        /* saved pixel is on */
		plot_pixel(x, y, PIXEL_BLACK);

	    /* move to the next bit position */
	    bit_position >>= 1;
	    /* check if moving to next byte */
	    if (bit_position == 0)  {
	        /* now on high bit of next byte */
		bit_position = 0x80;
		bit_offset++;
	    }
        }
    }


    /* restored menu area - return */
    return;

}




/*
   set_save_area

   Description:      This function sets the position and size of the area to
                     be saved when traces are drawn.  It also clears any data
		     currently saved.

   Arguments:        pos_x (int)  - x position of upper left corner of the
   				    saved area.
   		     pos_y (int)  - y position of upper left corner of the
		     		    saved area.
		     size_x (int) - horizontal size of the saved area.
		     size_y (int) - vertical size of the saved area.
   Return Value:     None.

   Input:            None.
   Output:           None.

   Error Handling:   None.

   Algorithms:       None.
   Data Structures:  None.

   Global Variables: saved_area  - cleared.
   		     saved_pos_x - set to passed value.
   		     saved_pos_y - set to passed value.
		     saved_end_x - computed from passed values.
		     saved_end_y - computed from passed values.

   Author:           Glen George
   Last Modified:    Mar. 8, 1994

*/

void  set_save_area(int pos_x, int pos_y, int size_x, int size_y)
{
    /* variables */
    int  x;		/* loop indices */
    int  y;



    /* just setup all the locally global variables from the passed values */
    saved_pos_x = pos_x;
    saved_pos_y = pos_y;
    saved_end_x = pos_x + size_x;
    saved_end_y = pos_y + size_y;


    /* clear the save area */
    for (y = 0; y < SAVE_SIZE_Y; y++)  {
        for (x = 0; x < (SAVE_SIZE_X / 8); x++)  {
	    saved_area[y][x] = 0;
        }
    }


    /* setup the saved area - return */
    return;

}




/*
   restore_trace

   Description:      This function restores the trace under the set saved
                     area.  (The area was previously set and the trace was
		     previously saved.)

   Arguments:        None.
   Return Value:     None.

   Input:            None.
   Output:           The trace under the saved ares is restored to the LCD.

   Error Handling:   None.

   Algorithms:       None.
   Data Structures:  None.

   Global Variables: saved_area  - used to restore trace data.
   		     saved_pos_x - gives starting x position of saved area.
   		     saved_pos_y - gives starting y position of saved area.
		     saved_end_x - gives ending x position of saved area.
		     saved_end_y - gives ending y position of saved area.

   Author:           Glen George
   Last Modified:    Mar. 13, 1994

*/

void  restore_trace()
{
    /* variables */
    int  bit_position;	/* position of bit to restore (in saved data) */
    int  bit_offset;    /* offset (in bytes) of bit within saved row */

    int  x;		/* loop indices */
    int  y;



    /* loop, restoring the saved trace */
    for (y = saved_pos_y; y < saved_end_y; y++)  {

        /* starting a row - initialize bit position */
	bit_position = 0x80;	/* start at high-order bit in the byte */
	bit_offset = 0;		/* first byte of the row */

        for (x = saved_pos_x; x < saved_end_x; x++)  {

	    /* check if this point is on or off (need to look at bits) */
	    if ((saved_area[y - saved_pos_y][bit_offset] & bit_position) == 0)
	        /* saved pixel is off */
		plot_pixel(x, y, PIXEL_WHITE);
	    else
	        /* saved pixel is on */
		plot_pixel(x, y, PIXEL_BLACK);

	    /* move to the next bit position */
	    bit_position >>= 1;
	    /* check if moving to next byte */
	    if (bit_position == 0)  {
	        /* now on high bit of next byte */
		bit_position = 0x80;
		bit_offset++;
	    }
        }
    }


    /* restored the saved area - return */
    return;

}




/*
   do_trace

   Description:      This function starts a trace.  It starts the hardware
                     sampling data (via a function call) and sets the trace
		     ready flag (trace_status) to FALSE and the sampling flag
		     (sampling) to TRUE.

   Arguments:        None.
   Return Value:     None.

   Input:            None.
   Output:           None.

   Error Handling:   None.

   Algorithms:       None.
   Data Structures:  None.

   Global Variables: trace_status - set to FALSE (not ready for another trace).
   		     sampling     - set to TRUE (doing a sample now).

   Author:           Glen George
   Last Modified:    Mar. 13, 1994

*/

void  do_trace()
{
    /* variables */
      /* none */



    /* start up the trace */
    /* indicate whether using automatic triggering or not */
    start_sample(get_trigger_mode() == AUTO_TRIGGER);

    /* now not ready for another trace (currently doing one) */
    trace_status = FALSE;

    /* and are currently sampling data */
    sampling = TRUE;


    /* trace is going, return */
    return;

}




/*
   plot_trace

   Description:      This function plots the passed trace.  The trace is
                     assumed to contain sample_size points of sampled data.
		     Any points falling within any of the save areas are also
		     saved by this routine.  The data is also scaled to be
		     within the range of the entire screen.

   Arguments:        sample (unsigned char far *) - sample to plot.
   Return Value:     None.

   Input:            None.
   Output:           The sample is plotted on the screen.

   Error Handling:   None.

   Algorithms:       If there are more sample points than screen width the
   		     sample is plotted with multiple points per horizontal
		     position.
   Data Structures:  None.

   Global Variables: cur_scale    - determines type of scale to plot.
		     sample_size  - determines size of passed sample.
		     saved_axis_x - stores trace under x-axis.
		     saved_axis_y - stores trace under y-axis.
		     saved_menu   - stores trace under the menu.
		     saved_area   - stores trace under the saved area.
		     saved_pos_x  - determines location of saved area.
		     saved_pos_y  - determines location of saved area.
		     saved_end_x  - determines location of saved area.
		     saved_end_y  - determines location of saved area.

   Author:           Glen George
   Last Modified:    May 9, 2006

*/

void  plot_trace(unsigned char far *sample)
{
    /* variables */
    int  x = 0;				/* current x position to plot */
    int  x_pos = (PLOT_SIZE_X / 2);	/* "fine" x position for multiple point plotting */

    int  y;				/* y position of point to plot */

    int  p;                             /* an x or y coordinate */

    int  i;				/* loop indices */
    int  j;



    /* first, clear the display to get rid of old plots */
    clear_display();

    /* clear the saved areas too */
    clear_saved_areas();

    /* re-display the menu (if it was on) */
    refresh_menu();


    /* plot the sample */
    for (i = 0; i < sample_size; i++)  {

        /* determine y position of point (note: screen coordinates invert) */
	y = (PLOT_SIZE_Y - 1) - ((sample[i] * (PLOT_SIZE_Y - 1)) / 255);

        /* plot this point */
	plot_pixel(x, y, PIXEL_BLACK);


	/* check if the point is in a save area */

	/* check if in the menu area */
	if ((x >= MENU_UL_X) && (x < (MENU_UL_X + MENU_SIZE_X)) &&
	    (y >= MENU_UL_Y) && (y < (MENU_UL_Y + MENU_SIZE_Y)))
	    /* point is in the menu area - save it */
	    saved_menu[y - MENU_UL_Y][(x - MENU_UL_X)/8] |= (0x80 >> ((x - MENU_UL_X) % 8));

	/* check if in the saved area */
	if ((x >= saved_pos_x) && (x <= saved_end_x) && (y >= saved_pos_y) && (y <= saved_end_y))
	    /* point is in the save area - save it */
	    saved_area[y - saved_pos_y][(x - saved_pos_x)/8] |= (0x80 >> ((x - saved_pos_x) % 8));

	/* check if on a grid line */
	/* go through all the horizontal lines */
	for (j = -Y_TICK_CNT; j <= Y_TICK_CNT; j++)  {

	    /* get y position of the line */
	    p = X_AXIS_POS + j * Y_TICK_SIZE;
	    /* make sure it is in range */
	    if (p >= PLOT_SIZE_Y)
	        p = PLOT_SIZE_Y - 1;
	    if (p < 0)
	        p = 0;

	    /* if the point is on this line, save it */
	    if (y == p)
		saved_axis_x[j + Y_TICK_CNT][x / 8] |= (0x80 >> (x % 8));
	}

	/* go through all the vertical lines */
	for (j = -X_TICK_CNT; j <= X_TICK_CNT; j++)  {

	    /* get x position of the line */
	    p = Y_AXIS_POS + j * X_TICK_SIZE;
	    /* make sure it is in range */
	    if (p >= PLOT_SIZE_X)
	        p = PLOT_SIZE_X - 1;
	    if (p < 0)
	        p = 0;

	    /* if the point is on this line, save it */
	    if (x == p)
		saved_axis_y[j + X_TICK_CNT][y / 8] |= (0x80 >> (y % 8));
	}


	/* update x position */
	x_pos += PLOT_SIZE_X;
	/* check if at next horizontal position */
	if (x_pos >= sample_size)  {
	    /* at next position - update positions */
	    x++;
	    x_pos -= sample_size;
	}
    }


    /* finally, output the scale if need be */
    set_display_scale(cur_scale);


    /* done with plot, return */
    return;

}
