#!/bin/sh
#
# This file was automatically generated.
#
# It can be overwritten by nios2-flash-programmer-generate or nios2-flash-programmer-gui.
#

#
# Converting ELF File: C:\Users\Albert\Documents\GitHub\FPGA-Oscilloscope\osc\software\osc\osc.elf to: "..\flash/osc_ROM_ctrl.flash"
#
elf2flash --input="C:/Users/Albert/Documents/GitHub/FPGA-Oscilloscope/osc/software/osc/osc.elf" --output="../flash/osc_ROM_ctrl.flash" --boot="$SOPC_KIT_NIOS2/components/altera_nios2/boot_loader_cfi.srec" --base=0x30000 --end=0x40000 --reset=0x30000 

#
# Programming File: "..\flash/osc_ROM_ctrl.flash" To Device: ROM_ctrl
#
nios2-flash-programmer "../flash/osc_ROM_ctrl.flash" --base=0x30000 --sidp=0x51008 --id=0xAAAAAAAA --timestamp=1399429763 --device=1 --instance=0 '--cable=ByteBlasterMV on localhost [LPT1]' --program 

