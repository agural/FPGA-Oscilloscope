/****************************************************************************/
/*                                                                          */
/*                                MENUACT.H                                 */
/*                          Menu Action Functions                           */
/*                               Include File                               */
/*                       Digital Oscilloscope Project                       */
/*                                 EE/CS 52                                 */
/*                                                                          */
/****************************************************************************/

/*
   This file contains the constants and function prototypes for the functions
   which carry out menu actions and display and initialize menu settings for
   the Digital Oscilloscope project (the functions are defined in menuact.c).


   Revision History:
      3/8/94   Glen George       Initial revision.
      3/13/94  Glen George       Updated comments.
      3/13/94  Glen George       Changed definition of enum scale_type (was
      				 enum scale_status).
      3/10/95  Glen George       Changed MAX_TRG_LEVEL_SET (maximum trigger
      				 level) to 127 to match specification.
      3/17/97  Glen George       Updated comments.
      5/3/06   Glen George       Updated comments.
      5/9/06   Glen George       Added a new mode (AUTO_TRIGGER) and a new
                                 scale (SCALE_GRID).
      5/9/06   Glen George       Added menu functions for mode and scale to
                                 move up and down a list instead of just
				 toggling the selection.
      5/9/06   Glen George       Added declaration for the accessor to the
                                 current trigger mode (get_trigger_mode).
*/



#ifndef  __MENUACT_H__
    #define  __MENUACT_H__


/* library include files */
  /* none */

/* local include files */
#include  "interfac.h"
#include  "lcdout.h"




/* constants */

/* min and max trigger level settings */
#define  MIN_TRG_LEVEL_SET   0
#define  MAX_TRG_LEVEL_SET   127

/* number of different sweep rates */
#define  NO_SWEEP_RATES     (sizeof(sweep_rates) / sizeof(struct sweep_info))




/* structures, unions, and typedefs */

/* types of triggering modes */
enum trigger_type  {  NORMAL_TRIGGER,		/* normal triggering */
		      AUTO_TRIGGER,		/* automatic triggering */
		      ONESHOT_TRIGGER		/* one-shot triggering */
		   };

/* types of displayed scales */
enum scale_type    {  SCALE_NONE,		/* no scale is displayed */
		      SCALE_AXES,		/* scale is a set of axes */
		      SCALE_GRID		/* scale is a grid */
		   };

/* types of trigger slopes */
enum slope_type    {  SLOPE_POSITIVE,		/* positive trigger slope */
		      SLOPE_NEGATIVE		/* negative trigger slope */
		   };

/* sweep rate information */
struct sweep_info  {  long int     sample_rate;    /* sample rate */
		      const char  *s;		   /* sweep rate string */
		   };




/* function declarations */

/* menu option actions */
void  no_menu_action(void);    /* no action to perform */
void  mode_down(void);         /* change to the "next" trigger mode */
void  mode_up(void);           /* change to the "previous" trigger mode */
void  scale_down(void);        /* change to the "next" scale type */
void  scale_up(void);          /* change to the "previous" scale type */
void  sweep_down(void);        /* decrease the sweep rate */
void  sweep_up(void);          /* increase the sweep rate */
void  trg_level_down(void);    /* decrease the trigger level */
void  trg_level_up(void);      /* increase the trigger level */
void  trg_slope_toggle(void);  /* toggle the trigger slope */
void  trg_delay_down(void);    /* decrease the trigger delay */
void  trg_delay_up(void);      /* increase the trigger delay */

/* option accessor routines */
enum trigger_type  get_trigger_mode(void);  /* get the current trigger mode */

/* option initialization routines */
void  set_trigger_mode(enum trigger_type);  /* set the trigger mode */
void  set_scale(enum scale_type);           /* set the scale type */
void  set_sweep(int);         		    /* set the sweep rate */
void  set_trg_level(int);     		    /* set the trigger level */
void  set_trg_slope(enum slope_type);       /* set the trigger slope */
void  set_trg_delay(long int);     	    /* set the tigger delay */

/* option display routines */
void  no_display(int, int, int);	 /* no option setting to display */
void  display_mode(int, int, int);       /* display trigger mode */
void  display_scale(int, int, int);      /* display the scale type */
void  display_sweep(int, int, int);      /* display the sweep rate */
void  display_trg_level(int, int, int);  /* display the trigger level */
void  display_trg_slope(int, int, int);  /* display the trigger slope */
void  display_trg_delay(int, int, int);  /* display the tigger delay */


#endif
