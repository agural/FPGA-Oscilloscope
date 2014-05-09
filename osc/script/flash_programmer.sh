#!/bin/sh
#
# This file was automatically generated.
#
# It can be overwritten by nios2-flash-programmer-generate or nios2-flash-programmer-gui.
#

#
# Converting ELF File: E:\agural\osc\software\osc\osc.elf to: "..\flash/osc_ROM_ctrl.flash"
#
elf2flash --input="E:/agural/osc/software/osc/osc.elf" --output="../flash/osc_ROM_ctrl.flash" --boot="$SOPC_KIT_NIOS2/components/altera_nios2/boot_loader_cfi.srec" --base=0x30000 --end=0x3ffff --reset=0x30020 

#
# Programming File: "..\flash/osc_ROM_ctrl.flash" To Device: ROM_ctrl
#
nios2-flash-programmer "../flash/osc_ROM_ctrl.flash" --base=0x30000 --sidp=0x51008 --id=0xAAAAAAAA --timestamp=1399272638 --device=1 --instance=0 '--cable=ByteBlasterMV on localhost [LPT1]' --program --erase-all --go 

