/****************************************************************************/
/*                                                                          */
/*                                   MENU                                   */
/*                              Menu Functions                              */
/*                       Digital Oscilloscope Project                       */
/*                                 EE/CS 52                                 */
/*                                                                          */
/****************************************************************************/

/*
   This file contains the functions for processing menu entries for the
   Digital Oscilloscope project.  These functions take care of maintaining the
   menus and handling menu updates for the system.  The functions included
   are:
      clear_menu       - remove the menu from the display
      display_menu     - display the menu
      init_menu        - initialize menus
      menu_entry_left  - take care of <Left> key for a menu entry
      menu_entry_right - take care of <Right> key for a menu entry
      next_entry       - next menu entry
      previous_entry   - previous menu entry
      refresh_menu     - re-display the menu if currently being displayed
      reset_menu       - reset the current selection to the top of the menu

   The local functions included are:
      display_entry    - display a menu entry (including option setting)

   The locally global variable definitions included are:
      menu             - the menu
      menu_display     - whether or not the menu is currently displayed
      menu_entry       - the currently selected menu entry


   Revision History
      3/8/94   Glen George       Initial revision.
      3/9/94   Glen George       Changed position of const keyword in array
				 declarations involving pointers.
      3/13/94  Glen George       Updated comments.
      3/13/94  Glen George       Added display_entry function to output a menu
				 entry and option setting to the LCD (affects
				 many functions).
      3/13/94  Glen George       Changed calls to set_status due to changing
      				 enum scale_status definition.
      3/13/94  Glen George       No longer clear the menu area before
				 restoring the trace in clear_menu() (not
				 needed).
      3/17/97  Glen George       Updated comments.
      3/17/97  Glen George       Fixed minor bug in reset_menu().
      3/17/97  Glen George       When initializing the menu in init_menu(),
				 set the delay to MIN_DELAY instead of 0 and
				 trigger to a middle value instead of
				 MIN_TRG_LEVEL_SET.
      5/3/06   Glen George       Changed to a more appropriate constant in
                                 display_entry().
      5/3/06   Glen George       Updated comments.
      5/9/06   Glen George       Changed menus to handle a list for mode and
	                         scale (move up and down list), instead of
			         toggling values.
*/



/* library include files */
  /* none */

/* local include files */
#include  "scopedef.h"
#include  "lcdout.h"
#include  "menu.h"
#include  "menuact.h"
#include  "tracutil.h"




/* local function declarations */
void  display_entry(int, int);      /* display a menu entry and its setting */




/* locally global variables */
static int  menu_display;           /* TRUE if menu is currently displayed */

const static struct menu_item  menu[] =	    /* the menu */
    { { "Mode",    0, 4, display_mode      },
      { "Scale",   0, 5, display_scale     },
      { "Sweep",   0, 5, display_sweep     },
      { "Trigger", 0, 7, no_display        },
      { "Level",   2, 7, display_trg_level },
      { "Slope",   2, 7, display_trg_slope },
      { "Delay",   2, 7, display_trg_delay },
    };

static int  menu_entry;		    /* currently selected menu entry */




/*
   init_menu

   Description:      This function initializes the menu routines.  It sets
                     the current menu entry to the first entry, indicates the
		     display is off, and initializes the options (and
		     hardware) to normal trigger mode, scale displayed, the
		     fastest sweep rate, a middle trigger level, positive
		     trigger slope, and minimum delay.  Finally, it displays
		     the menu.

   Arguments:        None.
   Return Value:     None.

   Input:            None.
   Output:           The menu is displayed.

   Error Handling:   None.

   Algorithms:       None.
   Data Structures:  None.

   Global Variables: menu_display - reset to FALSE.
   		     menu_entry   - reset to first entry (0).

   Author:           Glen George
   Last Modified:    Mar. 17, 1997

*/

void  init_menu(void)
{
    /* variables */
      /* none */



    /* set the menu parameters */
    menu_entry = 0;		/* first menu entry */
    menu_display = FALSE;	/* menu is not currently displayed (but it will be shortly) */


    /* set the scope (option) parameters */
    set_trigger_mode(NORMAL_TRIGGER);	/* normal triggering */
    set_scale(SCALE_AXES);		/* scale is axes */
    set_sweep(0);			/* first sweep rate */
    set_trg_level((MIN_TRG_LEVEL_SET + MAX_TRG_LEVEL_SET) / 2);	/* middle trigger level */
    set_trg_slope(SLOPE_POSITIVE);	/* positive slope */
    set_trg_delay(MIN_DELAY);		/* minimum delay */


    /* now display the menu */
    display_menu();


    /* done initializing, return */
    return;

}




/*
   clear_menu

   Description:      This function removes the menu from the display.  The
                     trace under the menu is restored.  The flag menu_display,
		     is cleared, indicating the menu is no longer being
		     displayed.  Note: if the menu is not currently being
		     displayed this function does nothing.

   Arguments:        None.
   Return Value:     None.

   Input:            None.
   Output:           The menu if displayed, is removed and the trace under it
   		     is rewritten.

   Error Handling:   None.

   Algorithms:       None.
   Data Structures:  None.

   Global Variables: menu_display - checked and set to FALSE.

   Author:           Glen George
   Last Modified:    Mar. 13, 1994

*/

void  clear_menu(void)
{
    /* variables */
      /* none */



    /* check if the menu is currently being displayed */
    if (menu_display)  {

        /* menu is being displayed - turn it off and restore the trace in that area */
	restore_menu_trace();
    }


    /* no longer displaying the menu */
    menu_display = FALSE;


    /* all done, return */
    return;

}




/*
   display_menu

   Description:      This function displays the menu.  The trace under the
                     menu is overwritten (but it was saved).  The flag
		     menu_display, is also set, indicating the menu is
		     currently being displayed.  Note: if the menu is already
		     being displayed this function does not redisplay it.

   Arguments:        None.
   Return Value:     None.

   Input:            None.
   Output:           The menu is displayed.

   Error Handling:   None.

   Algorithms:       None.
   Data Structures:  None.

   Global Variables: menu_display - set to TRUE.
   		     menu_entry   - used to highlight currently selected entry.

   Author:           Glen George
   Last Modified:    Mar. 13, 1994

*/

void  display_menu(void)
{
    /* variables */
    int  i;		/* loop index */



    /* check if the menu is currently being displayed */
    if (!menu_display)  {

        /* menu is not being displayed - turn it on */
	/* display it entry by entry */
	for (i = 0; i < NO_MENU_ENTRIES; i++)  {

	    /* display this entry - check if it should be highlighted */
	    if (i == menu_entry)
	        /* currently selected entry - highlight it */
	        display_entry(i, TRUE);
	    else
	        /* not the currently selected entry - "normal video" */
	        display_entry(i, FALSE);
        }
    }


    /* now are displaying the menu */
    menu_display = TRUE;


    /* all done, return */
    return;

}




/*
   refresh_menu

   Description:      This function displays the menu if it is currently being
		     displayed.  The trace under the menu is overwritten (but
		     it was already saved).

   Arguments:        None.
   Return Value:     None.

   Input:            None.
   Output:           The menu is displayed.

   Error Handling:   None.

   Algorithms:       None.
   Data Structures:  None.

   Global Variables: menu_display - determines if menu should be displayed.

   Author:           Glen George
   Last Modified:    Mar. 8, 1994

*/

void  refresh_menu(void)
{
    /* variables */
      /* none */



    /* check if the menu is currently being displayed */
    if (menu_display)  {

    	/* menu is currently being displayed - need to refresh it */
	/* do this by turning off the display, then forcing it back on */
	menu_display = FALSE;
	display_menu();
    }


    /* refreshed the menu if it was displayed, now return */
    return;

}




/*
   reset_menu

   Description:      This function resets the current menu selection to the
                     first menu entry.  If the menu is currently being
		     displayed the display is updated.

   Arguments:        None.
   Return Value:     None.

   Input:            None.
   Output:           The menu display is updated if it is being displayed.

   Error Handling:   None.

   Algorithms:       None.
   Data Structures:  None.

   Global Variables: menu_display - checked to see if menu is displayed.
   		     menu_entry   - reset to 0 (first entry).

   Author:           Glen George
   Last Modified:    Mar. 17, 1997

*/

void  reset_menu(void)
{
    /* variables */
      /* none */



    /* check if the menu is currently being displayed */
    if (menu_display)  {

        /* menu is being displayed */
	/* remove highlight from currently selected entry */
	display_entry(menu_entry, FALSE);
    }


    /* reset the currently selected entry */
    menu_entry = 0;


    /* finally, highlight the first entry if the menu is being displayed */
    if (menu_display)
	display_entry(menu_entry, TRUE);



    /* all done, return */
    return;

}




/*
   next_entry

   Description:      This function changes the current menu selection to the
                     next menu entry.  If the current selection is the last
		     entry in the menu, it is not changed.  If the menu is
		     currently being displayed, the display is updated.

   Arguments:        None.
   Return Value:     None.

   Input:            None.
   Output:           The menu display is updated if it is being displayed and
   		     the entry selected changes.

   Error Handling:   None.

   Algorithms:       None.
   Data Structures:  None.

   Global Variables: menu_display - checked to see if menu is displayed.
   		     menu_entry   - updated to a new entry (if not at end).

   Author:           Glen George
   Last Modified:    Mar. 13, 1994

*/

void  next_entry(void)
{
    /* variables */
      /* none */



    /* only update if not at end of the menu */
    if (menu_entry < (NO_MENU_ENTRIES - 1))  {

        /* not at the end of the menu */

	/* turn off current entry if displaying */
	if (menu_display)
            /* displaying menu - turn off currently selected entry */
	    display_entry(menu_entry, FALSE);

	/* update the menu entry to the next one */
	menu_entry++;

	/* now highlight this entry if displaying the menu */
	if (menu_display)
            /* displaying menu - highlight newly selected entry */
	    display_entry(menu_entry, TRUE);
    }


    /* all done, return */
    return;

}




/*
   previous_entry

   Description:      This function changes the current menu selection to the
                     previous menu entry.  If the current selection is the 
		     first entry in the menu, it is not changed.  If the menu
		     is currently being displayed, the display is updated.

   Arguments:        None.
   Return Value:     None.

   Input:            None.
   Output:           The menu display is updated if it is being displayed and
   		     the currently selected entry changes.

   Error Handling:   None.

   Algorithms:       None.
   Data Structures:  None.

   Global Variables: menu_display - checked to see if menu is displayed.
   		     menu_entry   - updated to a new entry (if not at start).

   Author:           Glen George
   Last Modified:    Mar. 13, 1994

*/

void  previous_entry(void)
{
    /* variables */
      /* none */



    /* only update if not at the start of the menu */
    if (menu_entry > 0)  {

        /* not at the start of the menu */

	/* turn off current entry if displaying */
	if (menu_display)
            /* displaying menu - turn off currently selected entry */
	    display_entry(menu_entry, FALSE);

	/* update the menu entry to the previous one */
	menu_entry--;

	/* now highlight this entry if displaying the menu */
	if (menu_display)
            /* displaying menu - highlight newly selected entry */
	    display_entry(menu_entry, TRUE);

    }


    /* all done, return */
    return;

}




/*
   menu_entry_left

   Description:      This function handles the <Left> key for the current menu
                     selection.  It does this by doing a table lookup on the
		     current menu selection.

   Arguments:        None.
   Return Value:     None.

   Input:            None.
   Output:           The menu display is updated if it is being displayed and
   		     the <Left> key causes a change to the display.

   Error Handling:   None.

   Algorithms:       Table lookup is used to determine what to do for the
   		     input key.
   Data Structures:  An array holds the table of key processing routines.

   Global Variables: menu_entry - used to select the processing function.

   Author:           Glen George
   Last Modified:    May 9, 2006

*/

void  menu_entry_left(void)
{
    /* variables */

    /* key processing functions */
    static void  (* const process[])(void) =
       /*  Mode            Scale             Sweep           Trigger      */
        {  mode_down,      scale_down,       sweep_down,     trace_rearm,
           trg_level_down, trg_slope_toggle, trg_delay_down               };
       /*  Level           Slope             Delay                        */



    /* invoke the appropriate <Left> key function */
    process[menu_entry]();

    /* if displaying menu entries, display the new value */
    /* note: since it is being changed - know this option is selected */
    if (menu_display)  {
        menu[menu_entry].display((MENU_X + menu[menu_entry].opt_off),
    			         (MENU_Y + menu_entry), OPTION_SELECTED);
    }


    /* all done, return */
    return;

}




/*
   menu_entry_right

   Description:      This function handles the <Right> key for the current
                     menu selection.  It does this by doing a table lookup on
		     the current menu selection.

   Arguments:        None.
   Return Value:     None.

   Input:            None.
   Output:           The menu display is updated if it is being displayed and
   		     the <Right> key causes a change to the display.

   Error Handling:   None.

   Algorithms:       Table lookup is used to determine what to do for the
   		     input key.
   Data Structures:  An array holds the table of key processing routines.

   Global Variables: menu       - used to display the new menu value.
   		     menu_entry - used to select the processing function.

   Author:           Glen George
   Last Modified:    May 9, 2006

*/

void  menu_entry_right(void)
{
    /* variables */

    /* key processing functions */
    static void  (* const process[])(void) =
       /*  Mode          Scale             Sweep           Trigger      */
        {  mode_up    ,  scale_up,     sweep_up,       trace_rearm,
           trg_level_up, trg_slope_toggle, trg_delay_up                 };
       /*  Level         Slope             Delay                        */



    /* invoke the appropriate <Right> key function */
    process[menu_entry]();

    /* if displaying menu entries, display the new value */
    /* note: since it is being changed - know this option is selected */
    if (menu_display)  {
        menu[menu_entry].display((MENU_X + menu[menu_entry].opt_off),
    			         (MENU_Y + menu_entry), OPTION_SELECTED);
    }


    /* all done, return */
    return;

}




/*
   display_entry

   Description:      This function displays the passed menu entry and its
   		     current option setting.  If the second argument is TRUE
		     it displays them with color SELECTED and OPTION_SELECTED
		     respectively.  If the second argument is FALSE it
		     displays the menu entry with color NORMAL and the option
		     setting with color OPTION_NORMAL.

   Arguments:        entry (int)    - menu entry to be displayed.
   		     selected (int) - whether or not the menu entry is
		     		      currently selected (determines the color
				      with which the entry is output).
   Return Value:     None.

   Input:            None.
   Output:           The menu entry is output to the LCD.

   Error Handling:   None.

   Algorithms:       None.
   Data Structures:  None.

   Global Variables: menu - used to display the menu entry.

   Author:           Glen George
   Last Modified:    Aug. 13, 2004

*/

static void  display_entry(int entry, int selected)
{
    /* variables */
      /* none */



    /* output the menu entry with the appropriate color */
    plot_string((MENU_X + menu[entry].h_off), (MENU_Y + entry), menu[entry].s,
    		(selected ? SELECTED : NORMAL));
    /* also output the menu option with the appropriate color */
    menu[entry].display((MENU_X + menu[entry].opt_off), (MENU_Y + entry),
    			(selected ? OPTION_SELECTED : OPTION_NORMAL));


    /* all done outputting this menu entry - return */
    return;

}
