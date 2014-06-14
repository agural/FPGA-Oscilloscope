#include "alt_types.h"

#define epcs_read    0x03
#define epcs_pp      0x02
#define epcs_wren    0x06
#define epcs_wrdi    0x04
#define epcs_rdsr    0x05
#define epcs_wrsr    0x01
#define epcs_se      0xD8
#define epcs_be      0xC7
#define epcs_dp      0xB9
#define epcs_res     0xAB
#define epcs_rdid    0x9F
#define epcs_en4b    0xB7    /* Enter 4-byte mode */
#define epcs_dis4b   0xE9    /* Exit 4-byte mode */

/* Private API */
alt_u32 epcs_read_device_id(alt_u32 base);
alt_u8 epcs_read_electronic_signature(alt_u32 base);
alt_u8 epcs_read_status_register(alt_u32 base);
void epcs_sector_erase(alt_u32 base, alt_u32 offset, alt_u32 four_bytes_mode);
alt_32 epcs_read_buffer(alt_u32 base, int offset, alt_u8 *dest_addr, int length,
                        alt_u32 four_bytes_mode);
void epcs_write_enable(alt_u32 base);
void epcs_write_status_register(alt_u32 base, alt_u8 value);
alt_32 epcs_write_buffer(alt_u32 base, int offset, const alt_u8* src_addr, 
                         int length, alt_u32 four_bytes_mode);
void epcs_enter_4_bytes_mode(alt_u32 base);
void epcs_exit_4_bytes_mode(alt_u32 base);
