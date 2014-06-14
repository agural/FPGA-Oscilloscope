/******************************************************************************
*                                                                             *
* License Agreement                                                           *
*                                                                             *
* Copyright (c) 2008 Altera Corporation, San Jose, California, USA.           *
* All rights reserved.                                                        *
*                                                                             *
* Permission is hereby granted, free of charge, to any person obtaining a     *
* copy of this software and associated documentation files (the "Software"),  *
* to deal in the Software without restriction, including without limitation   *
* the rights to use, copy, modify, merge, publish, distribute, sublicense,    *
* and/or sell copies of the Software, and to permit persons to whom the       *
* Software is furnished to do so, subject to the following conditions:        *
*                                                                             *
* The above copyright notice and this permission notice shall be included in  *
* all copies or substantial portions of the Software.                         *
*                                                                             *
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  *
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,    *
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE *
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      *
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING     *
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER         *
* DEALINGS IN THE SOFTWARE.                                                   *
*                                                                             *
* This agreement shall be governed in all respects by the laws of the State   *
* of California and by the laws of the United States of America.              *
*                                                                             *
* altera_avalon_epcs_flash_controller.c                                       *
*                                                                             *
* API for programming CFI compliant devices  - This interface is basically    *
* A POSIX device driver interface                                             *
*                                                                             *
* Author Aaron Ferrucci, adapted from code originally written by PRR.         *
*                                                                             *
******************************************************************************/
#include <errno.h>
#include <io.h>
#include <string.h>
#include "sys/param.h"
#include "alt_types.h"
#include "sys/alt_cache.h"
#include "altera_avalon_epcs_flash_controller.h"
#include "altera_avalon_spi.h"
#include "epcs_commands.h"

static int alt_epcs_flash_query(alt_flash_epcs_dev* flash);

/*
 * alt_epcs_flash_init
 *
 */
int alt_epcs_flash_init(alt_flash_epcs_dev* flash)
{
  int ret_code = 0;

  /* Set up function pointers and/or data structures as needed. */
  ret_code = alt_epcs_flash_query(flash);

  /* The following function pointers:
   *
   * alt_epcs_flash_write
   * alt_epcs_flash_read
   * alt_epcs_flash_get_info
   *
   * are already filled in in the device struct.
   * Fill in any other function pointers here, if necessary.
  */

  /*
  *  Register this device as a valid flash device type
  */
  if (!ret_code)
    ret_code = alt_flash_device_register(&(flash->dev));

  return ret_code;
}


static int alt_epcs_flash_query(alt_flash_epcs_dev* flash)
{
  int ret_code = 0;

  /* Decide if an epcs flash device is attached.
   *  
   * ret_code = -ENODEV = No device found!
   */

  /* It may be necessary to unlock or lock sectors,
   * reset the device, or whatever, to ensure that
   * it's in a known working state.
  */
  
  /* Disable 4-bytes address mode. */
  flash->four_bytes_mode = 0;
  
  /* Send the RES command sequence */
  flash->silicon_id =
    epcs_read_electronic_signature(flash->register_base);

  /* Fill in all device-specific parameters. */
  if (flash->silicon_id == 0x16) /* EPCS64 */
  {
    flash->dev.region_info[0].region_size = 64 * 1024 * 1024 / 8;
    flash->dev.region_info[0].number_of_blocks = 128;
    flash->dev.region_info[0].block_size = 65536;
  }
  else if (flash->silicon_id == 0x14) /* EPCS16 */
  {
    flash->dev.region_info[0].region_size = 16 * 1024 * 1024 / 8;
    flash->dev.region_info[0].number_of_blocks = 32;
    flash->dev.region_info[0].block_size = 65536;
  }
  else if (flash->silicon_id == 0x13) /* EPCS8 */
  {
    flash->dev.region_info[0].region_size = 8 * 1024 * 1024 / 8;
    flash->dev.region_info[0].number_of_blocks = 16;
    flash->dev.region_info[0].block_size = 65536;
  }
  else if (flash->silicon_id == 0x12) /* EPCS4 */
  {
    flash->dev.region_info[0].region_size = 4 * 1024 * 1024 / 8;
    flash->dev.region_info[0].number_of_blocks = 8;
    flash->dev.region_info[0].block_size = 65536;
  }
  else if (flash->silicon_id == 0x10) /* EPCS1 */
  {
    flash->dev.region_info[0].region_size = 1 * 1024 * 1024 / 8;
    flash->dev.region_info[0].number_of_blocks = 4;
    flash->dev.region_info[0].block_size = 32768;
  }
  else
  {
    /* 
     * Read electronic signature doesn't work for the EPCS128; try 
     * the "Read Device ID" command" before giving up.
     */
    flash->silicon_id = epcs_read_device_id(flash->register_base);
    
    /*
     * Last byte is the density ID. Note the difference between
     * EPCS128 and EPCQ128 -- arranged differently, though the 
     * least significant byte of each is '0x18'.
     */
    if((flash->silicon_id & 0xFFFFFF) == 0x20BA18) /* EPCQ128 */
    {
      flash->dev.region_info[0].region_size = 128 * 1024 * 1024 / 8;
      flash->dev.region_info[0].number_of_blocks = 256; /* number of sectors */
      flash->dev.region_info[0].block_size = 65536;  /* sector size */
    }
    else if((flash->silicon_id & 0xFF) == 0x18) /* EPCS128 */
    {
      flash->dev.region_info[0].region_size = 128 * 1024 * 1024 / 8;
      flash->dev.region_info[0].number_of_blocks = 64;
      flash->dev.region_info[0].block_size = 262144;
    }
    else if((flash->silicon_id & 0xFF ) == 0x19) /* EPCQ256 */
    {
      flash->dev.region_info[0].region_size = 256 * 1024 * 1024 / 8;
      flash->dev.region_info[0].number_of_blocks = 512; /* number of sectors */
      flash->dev.region_info[0].block_size = 65536;  /* sector size */

      /* Enable 4-bytes address mode if the device density is greater than 256Mbit. 
       * Last byte of device ID is density ID.
       *
       * The whole 4-bytes thing extends commands that send a memory address to
       * the chip (read, write, erase) from 3 bytes to 4. The 4-byte address mode
       * must first be programmed into the device, though. To complicate things, 
       * other Altera IP expects the chip to be in 3 byte address mode when they 
       * start using it. To be nice, we'll place the device into 4-byte address mode
       * when we need to, and take it back out when we're done.
       */
      flash->four_bytes_mode = 1;
    }
    else 
    {
      ret_code = -ENODEV; /* No known device found! */
    }
  }
  
  flash->size_in_bytes = flash->dev.region_info[0].region_size;
  flash->dev.number_of_regions = 1;
  flash->dev.region_info[0].offset = 0;
  flash->page_size = 256;

  /* Consider clearing all BP bits here. */
  return ret_code;
}

static int alt_epcs_flash_memcmp(
  alt_flash_dev* flash_info,
  const void* src_buffer,
  int offset,
  size_t n
)
{
  /*
   * Compare chunks of memory at a time, for better serial-flash
   * read efficiency.
   */
  alt_u8 chunk_buffer[32];
  const int chunk_size = sizeof(chunk_buffer) / sizeof(*chunk_buffer);
  int current_offset = 0;

  while (n > 0)
  {
    int this_chunk_size = n > chunk_size ? chunk_size : n;
    int this_chunk_cmp;

    if (
      alt_epcs_flash_read(
        flash_info,
        offset + current_offset,
        chunk_buffer,
        this_chunk_size
      ) < 0
    )
    {
      /*
      * If the read fails, I'm not sure what the appropriate action is.
      * Compare success seems wrong, so make it compare fail.
      */
      return -1;
    }

    /* Compare this chunk against the source memory buffer. */
    this_chunk_cmp = memcmp(&((unsigned char*)(src_buffer))[current_offset], chunk_buffer, this_chunk_size);
    if (this_chunk_cmp)
    {
      return this_chunk_cmp;
    }

    n -= this_chunk_size;
    current_offset += this_chunk_size;
  }

  /*
   * If execution made it to this point, compare is successful.
   */
  return 0;
}

/*
 * alt_epcs_flash_write
 *
 * Program the data into the flash at the selected address.
 *
 * Restrictions - For now this function will program the sectors it needs,
 * if it needs to erase a sector it will. If you wish to have all the contents
 * of the sector preserved you the user need to be aware of this and read out
 * the contents of that sector and add it to the data you wish to program.
 * The reasoning here is that sectors can be very large eg. 64k which is a
 * large buffer to tie up in our programming library, when not all users will
 * want that functionality.
 */
int alt_epcs_flash_write(alt_flash_dev* flash_info, int offset,
                          const void* src_addr, int length)
{
  int         ret_code = 0;
  int         i,j;
  int         data_to_write;
  int         current_offset;

  /*
   * First and foremost which sectors are affected?
   */
  for(i = 0; i < flash_info->number_of_regions; i++)
  {
    /* Is it in this erase block region?*/
    if((offset >= flash_info->region_info[i].offset) &&
      (offset < (flash_info->region_info[i].offset +
      flash_info->region_info[i].region_size)))
    {
      current_offset = flash_info->region_info[i].offset;

      for(j=0;j<flash_info->region_info[i].number_of_blocks;j++)
      {
        if ((offset >= current_offset ) &&
            (offset < (current_offset +
            flash_info->region_info[i].block_size)))
        {
          /*
           * Check if the contents of the block are different
           * from the data we wish to put there
           */
          data_to_write = ( current_offset + flash_info->region_info[i].block_size
                            - offset);
          data_to_write = MIN(data_to_write, length);

          if(alt_epcs_flash_memcmp(flash_info, src_addr, offset, data_to_write))
          {
            ret_code = (*flash_info->erase_block)(flash_info, current_offset);

            if (!ret_code)
            {
              ret_code = (*flash_info->write_block)(
                                                  flash_info,
                                                  current_offset,
                                                  offset,
                                                  src_addr,
                                                  data_to_write);
            }
          }

          /* Was this the last block? */
          if ((length == data_to_write) || ret_code)
          {
            goto finished;
          }

          length -= data_to_write;
          offset = current_offset + flash_info->region_info[i].block_size;
          src_addr = (alt_u8*)src_addr + data_to_write;
        }
        current_offset += flash_info->region_info[i].block_size;
      }
    }
  }

finished:
  return ret_code;
}

/*
 *  alt_epcs_flash_get_info
 *
 *  Pass the table of erase blocks to the user
 */
int alt_epcs_flash_get_info(alt_flash_fd* fd, flash_region** info,
                            int* number_of_regions)
{
  int ret_code = 0;

  alt_flash_dev* flash = (alt_flash_dev*)fd;

  *number_of_regions = flash->number_of_regions;

  if (!flash->number_of_regions)
  {
    ret_code = -EIO;
  }
  else if (flash->number_of_regions > ALT_MAX_NUMBER_OF_FLASH_REGIONS)
  {
    ret_code = -ENOMEM;
  }
  else
  {
    *info = &flash->region_info[0];
  }

  return ret_code;
}


/* This might be a candidate for optimization.  Precompute the last-address? */
static ALT_INLINE int alt_epcs_test_address(alt_flash_dev* flash_info, int offset)
{
  int ret_code = 0;
  /* Error checking:
   * if the block offset is outside of the memory, return -EIO.
   */
  alt_flash_epcs_dev *f = (alt_flash_epcs_dev*)flash_info;

  const alt_u32 last_region_index = f->dev.number_of_regions - 1;
  alt_u32 last_device_address =
    -1 +
    f->dev.region_info[last_region_index].offset +
    f->dev.region_info[last_region_index].region_size;

  if (offset > last_device_address)
  {
    /* Someone tried to erase a block outside of this device's range. */
    ret_code = -EIO;
  }
  return ret_code;
}


/*
 *
 * Erase the selected erase block ("sector erase", from the POV
 * of the EPCS data sheet).
 */
int alt_epcs_flash_erase_block(alt_flash_dev* flash_info, int block_offset)
{
  int ret_code = 0;
  alt_flash_epcs_dev *f = (alt_flash_epcs_dev*)flash_info;

  ret_code = alt_epcs_test_address(flash_info, block_offset);

  if (ret_code >= 0)
  {
    /* Send the Sector Erase command, whose 3 address bytes are anywhere
     * within the chosen sector.
     */
    epcs_sector_erase(f->register_base, block_offset, f->four_bytes_mode);
  }
  return ret_code;
}

/* Write, assuming that someone has kindly erased the appropriate
 * sector(s).
 * Note: "block_offset" is the base of the current erase block.
 * "data_offset" is the absolute address (from the 0-base of this
 * device's memory) of the beginning of the write-destination.
 * This device has no need for "block_offset", but it's included for
 * function type compatibility.
 */
int alt_epcs_flash_write_block(alt_flash_dev* flash_info, int block_offset,
                                      int data_offset, const void* data,
                                      int length)
{
  int ret_code;
  alt_flash_epcs_dev *f = (alt_flash_epcs_dev*)flash_info;

  int buffer_offset = 0;
  int length_of_current_write;
  ret_code = alt_epcs_test_address(flash_info, data_offset);

  if (ret_code >= 0)
  {

    /* "Block" writes must be broken up into the page writes that
     * the device understands.  Partial page writes are allowed.
     */
    while (length)
    {
      int next_page_start = (data_offset + f->page_size) & ~(f->page_size - 1);
      length_of_current_write = MIN(length, next_page_start - data_offset);

      epcs_write_buffer(f->register_base, data_offset, &((const alt_u8*)data)[buffer_offset], length_of_current_write,
          f->four_bytes_mode);

      length -= length_of_current_write;
      buffer_offset += length_of_current_write;
      data_offset = next_page_start;
    }
  }
  return ret_code;
}

/*
 *  If you try to read beyond the end of the memory, you'll wrap around
 *  to the beginning.  Reads that start beyond the end of the memory are
 *  flagged as errors with EIO (is there a better error code?).
 */
int alt_epcs_flash_read(alt_flash_dev* flash_info, int offset,
                        void* dest_addr, int length)
{
  int ret_code = 0;

  alt_flash_epcs_dev *f = (alt_flash_epcs_dev*)flash_info;

  ret_code = alt_epcs_test_address(flash_info, offset);

  if (ret_code >= 0)
  {
    ret_code = epcs_read_buffer(f->register_base, offset, dest_addr, length,
                                f->four_bytes_mode);

    /* epcs_read_buffer returns the number of buffers read, but
     * alt_epcs_flash_read returns 0 on success, <0 on failure.
     */
    if (ret_code == length)
    {
      ret_code = 0;
    }
  }
  return ret_code;
}

