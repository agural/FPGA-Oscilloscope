/****************************************************************************/
/*                                                                          */
/*                                KEYPROC.H                                 */
/*                         Key Processing Functions                         */
/*                               Include File                               */
/*                       Digital Oscilloscope Project                       */
/*                                 EE/CS 52                                 */
/*                                                                          */
/****************************************************************************/

/*
   This file contains the constants and function prototypes for the key
   processing functions (defined in keyproc.c) for the Digital Oscilloscope
   project.


   Revision History:
      3/8/94   Glen George       Initial revision.
      3/13/94  Glen George       Updated comments.
*/



#ifndef  __KEYPROC_H__
    #define  __KEYPROC_H__


/* library include files */
  /* none */

/* local include files */
#include  "scopedef.h"




/* constants */
    /* none */




/* structures, unions, and typedefs */
    /* none */




/* function declarations */

enum status  no_action(enum status);      /* nothing to do */

enum status  menu_key(enum status);	  /* process the <Menu> key */

enum status  menu_up(enum status);	  /* <Up> key in a menu */
enum status  menu_down(enum status);	  /* <Down> key in a menu */
enum status  menu_left(enum status);	  /* <Left> key in a menu */
enum status  menu_right(enum status);	  /* <Right> key in a menu */


#endif
