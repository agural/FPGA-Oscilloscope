transcript on
vmap altera C:/Users/Albert/Documents/GitHub/FPGA-Oscilloscope/FPGA/msim_lib/vhdl_libs/altera
vmap lpm C:/Users/Albert/Documents/GitHub/FPGA-Oscilloscope/FPGA/msim_lib/vhdl_libs/lpm
vmap sgate C:/Users/Albert/Documents/GitHub/FPGA-Oscilloscope/FPGA/msim_lib/vhdl_libs/sgate
vmap altera_mf C:/Users/Albert/Documents/GitHub/FPGA-Oscilloscope/FPGA/msim_lib/vhdl_libs/altera_mf
vmap altera_lnsim C:/Users/Albert/Documents/GitHub/FPGA-Oscilloscope/FPGA/msim_lib/vhdl_libs/altera_lnsim
vmap cycloneiii C:/Users/Albert/Documents/GitHub/FPGA-Oscilloscope/FPGA/msim_lib/vhdl_libs/cycloneiii
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/Albert/Documents/GitHub/FPGA-Oscilloscope/FPGA/oscilloscope.vhd}
vcom -93 -work work {C:/Users/Albert/Documents/GitHub/FPGA-Oscilloscope/FPGA/vramstates.vhd}
vcom -93 -work work {C:/Users/Albert/Documents/GitHub/FPGA-Oscilloscope/FPGA/lpm_counter0.vhd}
vcom -93 -work work {C:/Users/Albert/Documents/GitHub/FPGA-Oscilloscope/FPGA/lpm_counter1.vhd}
vcom -93 -work work {C:/Users/Albert/Documents/GitHub/FPGA-Oscilloscope/FPGA/lpm_counter2.vhd}
vcom -93 -work work {C:/Users/Albert/Documents/GitHub/FPGA-Oscilloscope/FPGA/lpm_compare0.vhd}
vcom -93 -work work {C:/Users/Albert/Documents/GitHub/FPGA-Oscilloscope/FPGA/lpm_compare1.vhd}
vcom -93 -work work {C:/Users/Albert/Documents/GitHub/FPGA-Oscilloscope/FPGA/lpm_compare2.vhd}
vcom -93 -work work {C:/Users/Albert/Documents/GitHub/FPGA-Oscilloscope/FPGA/lpm_counter3.vhd}
vcom -93 -work work {C:/Users/Albert/Documents/GitHub/FPGA-Oscilloscope/FPGA/lpm_compare3.vhd}
vcom -93 -work work {C:/Users/Albert/Documents/GitHub/FPGA-Oscilloscope/FPGA/lpm_compare4.vhd}
vcom -93 -work work {C:/Users/Albert/Documents/GitHub/FPGA-Oscilloscope/FPGA/lpm_compare5.vhd}
vcom -93 -work work {C:/Users/Albert/Documents/GitHub/FPGA-Oscilloscope/FPGA/lpm_mux0.vhd}
vcom -93 -work work {C:/Users/Albert/Documents/GitHub/FPGA-Oscilloscope/FPGA/lpm_constant0.vhd}

vcom -93 -work work {C:/Users/Albert/Documents/GitHub/FPGA-Oscilloscope/FPGA/test_modelsim.vht}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneiii -L rtl_work -L work -voptargs="+acc"  a

add wave *
view structure
view signals
run -all
