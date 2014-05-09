/****************************************************************************/
/*                                                                          */
/*                                 TESTCODE                                 */
/*                              Test Functions                              */
/*                       Digital Oscilloscope Project                       */
/*                                 EE/CS 52                                 */
/*                                                                          */
/****************************************************************************/

/*
   This file contains test functions for the Digital Oscilloscope project.
   These functions are just used to test various features of the system
   without necessarily needing all the hardware.  The functions included are:
      get_test_sample - get a test sample

   The local functions included are:
      none

   The locally global variable definitions included are:
      none


   Revision History
      3/13/94  Glen George       Initial revision.
      3/17/97  Glen George       Updated comments.
      5/3/06   Glen George       Added inclusion of scopedef.h to pick up
	                         definitions for portability.
      5/3/06   Glen George       Updated function to handle new, faster sweep
	                         rates.
*/



/* library include files */
  /* none */

/* local include files */
#include  "interfac.h"
#include  "scopedef.h"
#include  "testcode.h"




/* local definitions */
#define  NO_TEST_PTS	(sizeof(waveform) / sizeof(unsigned char))   /* size of test waveform */




/*
   get_test_sample

   Description:      This function simulates getting a sample of the passed
   		     size at the passed rate.  The sample is returned via the
		     passed pointer (3rd argument).  The sample rate is
		     assumed to be less than 10000000.  The waveform returned
		     is a ringing squarewave at approximately 521 Hz.

   Arguments:        sample_rate (long int)       - the number of samples per
   						    second to simulate.
   		     sample_size (int)            - the number of samples to
		     				    be returned.
		     sample (unsigned char far *) - pointer to the location to
		     				    which to return the
						    simulated samples.
   Return Value:     None.

   Input:            None.
   Output:           None.

   Error Handling:   None.

   Algorithms:       The sample point variable (sample_pt) is actually ten
		     times the sample point number to allow for fractional
		     sweep rate ratios without integer truncation problems.
   Data Structures:  None.

   Global Variables: None.

   Author:           Glen George
   Last Modified:    May 3, 2006

*/

void  get_test_sample(long int sample_rate, int sample_size, unsigned char far *sample)
{
    /* variables */

    /* a half-cycle of the ringing square wave */
    const static unsigned char  waveform[] =
        {  128, 127, 126, 125, 124, 122, 120, 118, 116, 113, 111, 108, 105,
	   102,  99,  96,  93,  90,  87,  83,  80,  77,  74,  70,  67,  64,
	    61,  58,  55,  52,  49,  47,  44,  42,  40,  37,  36,  34,  32,
	    31,  29,  28,  27,  26,  26,  25,  25,  25,  25,  25,  25,  26,
	    26,  27,  28,  29,  30,  31,  33,  34,  36,  37,  39,  41,  42,
	    44,  46,  48,  50,  52,  54,  56,  58,  60,  62,  64,  66,  68,
	    69,  71,  73,  74,  76,  77,  79,  80,  81,  82,  83,  84,  85,
	    86,  86,  87,  87,  88,  88,  88,  88,  88,  88,  88,  87,  87,
	    86,  86,  85,  85,  84,  83,  82,  81,  80,  79,  78,  77,  76,
	    75,  74,  72,  71,  70,  69,  68,  66,  65,  64,  63,  62,  61,
	    60,  59,  58,  57,  56,  55,  54,  54,  53,  52,  52,  51,  51,
	    50,  50,  50,  50,  50,  50,  50,  50,  50,  50,  50,  50,  51,
	    51,  51,  52,  52,  53,  54,  54,  55,  55,  56,  57,  57,  58,
	    59,  60,  60,  61,  62,  63,  63,  64,  65,  65,  66,  67,  67,
	    68,  68,  69,  69,  70,  70,  71,  71,  71,  72,  72,  72,  72,
	    73,  73,  73,  73,  73,  73,  73,  73,  72,  72,  72,  72,  72,
	    71,  71,  71,  70,  70,  70,  69,  69,  68,  68,  68,  67,  67,
	    66,  66,  65,  65,  64,  64,  64,  63,  63,  62,  62,  62,  61,
	    61,  61,  60,  60,  60,  60,  59,  59,  59,  59,  59,  59,  59,
	    59,  59,  59,  59,  59,  59,  59,  59,  59,  59,  59,  60,  60,
	    60,  60,  60,  61,  61,  61,  61,  62,  62,  62,  62,  63,  63,
	    63,  63,  64,  64,  64,  65,  65,  65,  65,  65,  66,  66,  66,
	    66,  66,  66,  67,  67,  67,  67,  67,  67,  67,  67,  67,  67,
	    67,  67,  67,  67,  67,  67,  67,  67,  67,  67,  67,  66,  66,
	    66,  66,  66,  66,  66,  65,  65,  65,  65,  65,  65,  64,  64,
	    64,  64,  64,  64,  64,  63,  63,  63,  63,  63,  63,  63,  63,
	    62,  62,  62,  62,  62,  62,  62,  62,  62,  62,  62,  62,  62,
	    62,  62,  62,  62,  62,  62,  62,  62,  62,  63,  63,  63,  63,
	    63,  63,  63,  63,  63,  63,  63,  64,  64,  64,  64,  64,  64,
	    64,  64,  64,  64,  64,  65,  65,  65,  65,  65,  65,  65,  65,
	    65,  65,  65,  65,  65,  65,  65,  65,  65,  65,  65,  65,  65,
	    65,  65,  65,  65,  65,  65,  65,  65,  65,  65,  65,  65,  65,
	    65,  65,  64,  64,  64,  64,  64,  64,  64,  64,  64,  64,  64,
	    64,  64,  64,  64,  64,  64,  64,  63,  63,  63,  63,  63,  63,
	    63,  63,  63,  63,  63,  63,  63,  63,  63,  63,  63,  63,  63,
	    63,  63,  63,  63,  63,  63,  64,  64,  64,  64,  64,  64,  64,
	    64,  64,  64,  64,  64,  64,  64,  64,  64,  64,  64,  64
	  };

    long int  sample_pt = 0;	/* current sample within the waveform */

    int       sample_sign = 1;	/* sample waveform sign */



    /* loop, getting sample points */
    while (sample_size-- > 0)  {

        /* get this sample point (value based on sign) */
	if (sample_sign > 0)
	    *sample++ = waveform[sample_pt/20] + 127;
	else
	    *sample++ = 128 - waveform[sample_pt/20];

	/* compute the time for the next sample point */
	sample_pt += (10000000L / sample_rate);
	/* keep sample_pt within the waveform (need to scale it) */
	while (sample_pt >= (20 * NO_TEST_PTS))  {
	    /* keep sample_pt within the test waveform */
	    sample_pt -= (20 * NO_TEST_PTS);
	    /* each time through the waveform, invert it */
	    sample_sign = -sample_sign;
        }
    }


    /* done getting the sample - return */
    return;

}
