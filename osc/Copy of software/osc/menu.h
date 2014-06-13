/****************************************************************************/
/*                                                                          */
/*                                  MENU.H                                  */
/*                              Menu Functions                              */
/*                               Include File                               */
/*                       Digital Oscilloscope Project                       */
/*                                 EE/CS 52                                 */
/*                                                                          */
/****************************************************************************/

/*
   This file contains the constants and function prototypes for the functions
   which deal with menus (defined in menu.c) for the Digital Oscilloscope
   project.


   Revision History:
      3/8/94   Glen George       Initial revision.
      3/13/94  Glen George       Updated comments.
      3/13/94  Glen George       Added definitions for SELECTED,
      				 OPTION_NORMAL, and OPTION_SELECTED.
*/



#ifndef  __MENU_H__
    #define  __MENU_H__


/* library include files */
  /* none */

/* local include files */
#include  "interfac.h"
#include  "scopedef.h"
#include  "lcdout.h"




/* constants */

/* menu size */
#define  MENU_WIDTH   16		/* menu width (in characters) */
#define  MENU_HEIGHT   7		/* menu height (in characters) */
#define  MENU_SIZE_X  (MENU_WIDTH * HORIZ_SIZE)  /* menu width (in pixels) */
#define  MENU_SIZE_Y  (MENU_HEIGHT * VERT_SIZE)  /* menu height (in pixels) */

/* menu position */
#define  MENU_X    (LCD_WIDTH - MENU_WIDTH - 1)  /* x position (in characters) */
#define  MENU_Y    0			         /* y position (in characters) */
#define  MENU_UL_X (MENU_X * HORIZ_SIZE)         /* x position (in pixels) */
#define  MENU_UL_Y (MENU_Y * VERT_SIZE)          /* y position (in pixels) */

/* menu colors */
#define  SELECTED         REVERSE	/* color for a selected menu entry */
#define  OPTION_SELECTED  NORMAL        /* color for a selected menu entry option */
#define  OPTION_NORMAL    NORMAL        /* color for an unselected menu entry option */

/* number of menu entries */
#define  NO_MENU_ENTRIES  (sizeof(menu) / sizeof(struct menu_item))




/* structures, unions, and typedefs */

/* data for an item in a menu */
struct menu_item  {  const char  *s;		/* string for menu entry */
		     int          h_off;	/* horizontal offset of entry */
		     int          opt_off;	/* horizontal offset of option setting */
		     void       (*display)(int, int, int);	/* option display function */
		  };




/* function declarations */

/* menu initialization function */
void  init_menu(void);

/* menu display functions */
void  clear_menu(void);		   /* clear the menu display */
void  display_menu(void);	   /* display the menu */
void  refresh_menu(void);	   /* refresh the menu */

/* menu update functions */
void  reset_menu(void);		   /* reset the menu to first entry */
void  next_entry(void);		   /* go to the next menu entry */
void  previous_entry(void);	   /* go to the previous menu entry */

/* menu entry functions */
void  menu_entry_left(void);	   /* do the <Left> key for the menu entry */
void  menu_entry_right(void);	   /* do the <Right> key for the menu entry */


#endif
