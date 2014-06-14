#!/bin/sh
#
# This file was automatically generated.
#
# It can be overwritten by nios2-flash-programmer-generate or nios2-flash-programmer-gui.
#

#
# Converting SOF File: E:\agural\osc\output_files\osc.sof to: "..\flash/osc_FLASH_ctrl.flash"
#
sof2flash --input="E:/agural/osc/output_files/osc.sof" --output="../flash/osc_FLASH_ctrl.flash" --offset=0x0 

#
# Programming File: "..\flash/osc_FLASH_ctrl.flash" To Device: FLASH_ctrl
#
nios2-flash-programmer "../flash/osc_FLASH_ctrl.flash" --base=0x130000 --sidp=0x162208 --id=0xAAAAAAAA --timestamp=1402737926 --device=1 --instance=0 '--cable=ByteBlasterMV on localhost [LPT1]' --program --erase-all --go 

#
# Converting SOF File: E:\agural\osc\output_files\osc.sof to: "..\flash/osc_EPCS_ctrl.flash"
#
sof2flash --input="E:/agural/osc/output_files/osc.sof" --output="../flash/osc_EPCS_ctrl.flash" --epcs 

#
# Programming File: "..\flash/osc_EPCS_ctrl.flash" To Device: EPCS_ctrl
#
nios2-flash-programmer "../flash/osc_EPCS_ctrl.flash" --base=0x161000 --epcs --sidp=0x162208 --id=0xAAAAAAAA --timestamp=1402737926 --device=1 --instance=0 '--cable=ByteBlasterMV on localhost [LPT1]' --program --erase-all 

#
# Converting ELF File: E:\agural\osc\software\osc\osc.elf to: "..\flash/osc_EPCS_ctrl_1_.flash"
#
elf2flash --input="E:/agural/osc/software/osc/osc.elf" --output="../flash/osc_EPCS_ctrl_1_.flash" --epcs --after="../flash/osc_EPCS_ctrl.flash" 

#
# Programming File: "..\flash/osc_EPCS_ctrl_1_.flash" To Device: EPCS_ctrl
#
nios2-flash-programmer "../flash/osc_EPCS_ctrl_1_.flash" --base=0x161000 --epcs --sidp=0x162208 --id=0xAAAAAAAA --timestamp=1402737926 --device=1 --instance=0 '--cable=ByteBlasterMV on localhost [LPT1]' --program --go 

