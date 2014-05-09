/****************************************************************************/
/*                                                                          */
/*                                TRACUTIL.H                                */
/*                         Trace Utility Functions                          */
/*                               Include File                               */
/*                       Digital Oscilloscope Project                       */
/*                                 EE/CS 52                                 */
/*                                                                          */
/****************************************************************************/

/*
   This file contains the constants and function prototypes for the trace
   utility functions (defined in tracutil.c) for the Digital Oscilloscope
   project.


   Revision History:
      3/8/94   Glen George       Initial revision.
      3/13/94  Glen George       Updated comments.
      3/13/94  Glen George       Changed name of set_axes function to
      				 set_display_scale.
      5/9/06   Glen George       Added the constants for grids and tick marks.
      5/27/08  Glen George       Added is_sampling() function to be able to
	                         tell if the system is currently taking a
				 sample.
      6/3/08   Glen George       Removed Y_SCALE_FACTOR - no longer used to 
	                         fix problems with non-power of 2 display
				 sizes.
*/



#ifndef  __TRACUTIL_H__
    #define  __TRACUTIL_H__


/* library include files */
  /* none */

/* local include files */
#include  "interfac.h"
#include  "menuact.h"




/* constants */

/* plot size */
#define  PLOT_SIZE_X	SIZE_X		/* plot takes entire screen width */
#define  PLOT_SIZE_Y	SIZE_Y		/* plot takes entire screen height */

/* axes position and size */
#define  X_AXIS_START   0		   /* starting x position of x-axis */
#define  X_AXIS_END     (PLOT_SIZE_X - 1)  /* ending x position of x-axis */
#define  X_AXIS_POS	(PLOT_SIZE_Y / 2)  /* y position of x-axis */
#define  Y_AXIS_START   0		   /* starting y position of y-axis */
#define  Y_AXIS_END     (PLOT_SIZE_Y - 1)  /* ending y position of y-axis */
#define  Y_AXIS_POS	(PLOT_SIZE_X / 2)  /* x position of y-axis */

/* tick mark and grid constants */
#define  TICK_LEN       5    		/* length of axis tick mark */
/* tick mark counts are for a single quadrant, thus total number of tick */
/* marks or grids is twice this number */
#define  X_TICK_CNT     5		/* always 5 tick marks on x axis */
#define  X_TICK_SIZE    (PLOT_SIZE_X / (2 * X_TICK_CNT))   /* distance between tick marks */
#define  Y_TICK_SIZE    X_TICK_SIZE     /* same size as x */
#define  Y_TICK_CNT     (PLOT_SIZE_Y / (2 * Y_TICK_SIZE))  /* number of y tick marks */
#define  X_GRID_START   0		   /* starting x position of x grid */
#define  X_GRID_END     (PLOT_SIZE_X - 1)  /* ending x position of x grid */
#define  Y_GRID_START   0		   /* starting y position of y-axis */
#define  Y_GRID_END     (PLOT_SIZE_Y - 1)  /* ending y position of y-axis */

/* maximum size of the save area (in pixels) */
#define  SAVE_SIZE_X	120	/* maximum width */
#define  SAVE_SIZE_Y	16	/* maximum height */




/* structures, unions, and typedefs */
    /* none */




/* function declarations */

/* initialize the trace utility routines */
void  init_trace(void);

/* trace status functions */
void  set_mode(enum trigger_type);  /* set the triggering mode */
int   is_sampling(void);	    /* currently trying to take a sample */
int   trace_rdy(void);              /* determine if ready to start a trace */
void  trace_done(void);             /* signal a trace has been completed */
void  trace_rearm(void);            /* re-enable tracing */

/* trace save area functions */
void  clear_saved_areas(void);		  /* clears all saved areas */
void  restore_menu_trace(void);           /* restore the trace under menus */
void  set_save_area(int, int, int, int);  /* set an area of a trace to save */
void  restore_trace(void);                /* restore saved area of a trace */

/* set the scale type */
void  set_display_scale(enum scale_type);

/* setup and plot a trace */
void  set_trace_size(int);              /* set the number of samples in a trace */
void  do_trace(void);                   /* start a trace */
void  plot_trace(unsigned char far *);  /* plot a trace (sampled data) */


#endif
