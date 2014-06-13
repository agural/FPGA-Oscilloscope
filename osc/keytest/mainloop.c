/****************************************************************************/
/*                                                                          */
/*                                 MAINLOOP                                 */
/*                             Main Program Loop                            */
/*                    Keypad Test for Digital Oscilloscope                  */
/*                                 EE/CS 52                                 */
/*                                                                          */
/****************************************************************************/

/*
   This file contains the main processing loop for testing the keypad
   functions for the Digital Oscilloscope project.  The only global function
   included is:
      main - background processing loop

   The local functions included are:
      key_lookup - get a key and look up its keycode

   The locally global variable definitions included are:
      key_buffer - buffer of key characters


   Revision History
      5/3/06   Glen George       Initial revision.
*/



/* library include files */
  /* none */

/* local include files */
#include  "interfac.h"
#include  "scopedef.h"




/* local function declarations */
char  key_lookup(void);      /* translate key values into keycodes */



/* buffer for keycodes */
#define   BUFFER_SIZE   256		/* size of the buffer */
static char  key_buffer[BUFFER_SIZE];	/* and the actual buffer */




/*
   main

   Description:      This procedure is the main program loop for testing the
                     keypad input on the Digital Oscilloscope.  It loops
                     forever getting keys from the keypad and stores those
                     keys in a buffer (key_buffer).  It also checks the
                     key_available function to be sure it returns false after
                     getting a key (if it doesn't a '?' is put in the buffer).

   Arguments:        None.
   Return Value:     (int) - return code, always 0 (never returns).

   Input:            Keys from the keypad.
   Output:           None.

   Error Handling:   Invalid input is ignored.

   Algorithms:       None.
   Data Structures:  Array (key_buffer) to store keys.

   Global Variables: None.

   Author:           Glen George
   Last Modified:    May 3, 2006

*/

int  main()
{
    /* variables */
    char  key;  		/* an input key */

    int   buffer_ptr = 0;	/* the buffer pointer */



    /* infinite loop processing input */
    while(TRUE)  {

        /* wait for a key to be ready */
	while (!key_available());


	/* have keypad input - get the key */
	key = key_lookup();
	/* and store the key */
	key_buffer[buffer_ptr++] = key;

	/* make sure buffer pointer stays in range */
	if (buffer_ptr >= BUFFER_SIZE)
	    buffer_ptr -= BUFFER_SIZE;


	/* check if there is still a key available (shouldn't be) */
	if (key_available())  {

	    /* if there is a key available now, it's an error */
	    /* put ? in the buffer and update the buffer pointer */
	    key_buffer[buffer_ptr++] = '?';
	    /* make sure pointer stays in range */
	    if (buffer_ptr >= BUFFER_SIZE)
	        buffer_ptr -= BUFFER_SIZE;
        }
    }


    /* done with main (never should get here), return 0 */
    return  0;

}




/*
   key_lookup

   Description:      This function gets a key from the keypad and translates
                     the raw keycode to a character for the main loop.

   Arguments:        None.
   Return Value:     (char) - character for the key input on keypad.

   Input:            Keys from the keypad.
   Output:           None.

   Error Handling:   Invalid keys are returned as 'X'.

   Algorithms:       The function uses an array to lookup the characters.
   Data Structures:  Array of key types versus characters.

   Global Variables: None.

   Author:           Glen George
   Last Modified:    May 3, 2006

*/

static  char  key_lookup()
{
    /* variables */

    const static char  keycodes[] = /* array of keycodes */
        {		            /* order must match keys array exactly */
           'M',      /* <Menu>     */   /* also need an extra element */
	   'U',      /* <Up>       */   /* for unknown key codes */
	   'D',      /* <Down>     */
	   'L',      /* <Left>     */
	   'R',      /* <Right>    */
	   'X'       /* other keys */
        }; 

    const static int  keys[] =   /* array of key values */
        {			 /* order must match keycodes array exactly */
           KEY_MENU,    /* <Menu>     */
	   KEY_UP,      /* <Up>       */
	   KEY_DOWN,    /* <Down>     */
	   KEY_LEFT,    /* <Left>     */
	   KEY_RIGHT,   /* <Right>    */
        }; 

    int  key; 		/* an input key */

    int  i;           	/* general loop index */



    /* get a key */
    key = getkey();


    /* lookup key in keys array */
    for (i = 0; ((i < (sizeof(keys)/sizeof(int))) && (key != keys[i])); i++);


    /* return the appropriate key type */
    return  keycodes[i];

}
