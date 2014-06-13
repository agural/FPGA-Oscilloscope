/*
 * system.h - SOPC Builder system and BSP software package information
 *
 * Machine generated for CPU 'PROC' in SOPC Builder design 'proc'
 * SOPC Builder design path: C:/Users/Albert/Documents/GitHub/FPGA-Oscilloscope/osc/proc.sopcinfo
 *
 * Generated: Wed Jun 11 22:53:50 PDT 2014
 */

/*
 * DO NOT MODIFY THIS FILE
 *
 * Changing this file will have subtle consequences
 * which will almost certainly lead to a nonfunctioning
 * system. If you do modify this file, be aware that your
 * changes will be overwritten and lost when this file
 * is generated again.
 *
 * DO NOT MODIFY THIS FILE
 */

/*
 * License Agreement
 *
 * Copyright (c) 2008
 * Altera Corporation, San Jose, California, USA.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 * This agreement shall be governed in all respects by the laws of the State
 * of California and by the laws of the United States of America.
 */

#ifndef __SYSTEM_H_
#define __SYSTEM_H_

/* Include definitions from linker script generator */
#include "linker.h"


/*
 * ADC_ctrl configuration
 *
 */

#define ADC_CTRL_BASE 0x151100
#define ADC_CTRL_BIT_CLEARING_EDGE_REGISTER 0
#define ADC_CTRL_BIT_MODIFYING_OUTPUT_REGISTER 1
#define ADC_CTRL_CAPTURE 0
#define ADC_CTRL_DATA_WIDTH 8
#define ADC_CTRL_DO_TEST_BENCH_WIRING 0
#define ADC_CTRL_DRIVEN_SIM_VALUE 0
#define ADC_CTRL_EDGE_TYPE "NONE"
#define ADC_CTRL_FREQ 36000000
#define ADC_CTRL_HAS_IN 0
#define ADC_CTRL_HAS_OUT 1
#define ADC_CTRL_HAS_TRI 0
#define ADC_CTRL_IRQ -1
#define ADC_CTRL_IRQ_INTERRUPT_CONTROLLER_ID -1
#define ADC_CTRL_IRQ_TYPE "NONE"
#define ADC_CTRL_NAME "/dev/ADC_ctrl"
#define ADC_CTRL_RESET_VALUE 0
#define ADC_CTRL_SPAN 32
#define ADC_CTRL_TYPE "altera_avalon_pio"
#define ALT_MODULE_CLASS_ADC_ctrl altera_avalon_pio


/*
 * ADC_rate configuration
 *
 */

#define ADC_RATE_BASE 0x1511b0
#define ADC_RATE_BIT_CLEARING_EDGE_REGISTER 0
#define ADC_RATE_BIT_MODIFYING_OUTPUT_REGISTER 0
#define ADC_RATE_CAPTURE 0
#define ADC_RATE_DATA_WIDTH 32
#define ADC_RATE_DO_TEST_BENCH_WIRING 0
#define ADC_RATE_DRIVEN_SIM_VALUE 0
#define ADC_RATE_EDGE_TYPE "NONE"
#define ADC_RATE_FREQ 36000000
#define ADC_RATE_HAS_IN 0
#define ADC_RATE_HAS_OUT 1
#define ADC_RATE_HAS_TRI 0
#define ADC_RATE_IRQ -1
#define ADC_RATE_IRQ_INTERRUPT_CONTROLLER_ID -1
#define ADC_RATE_IRQ_TYPE "NONE"
#define ADC_RATE_NAME "/dev/ADC_rate"
#define ADC_RATE_RESET_VALUE 0
#define ADC_RATE_SPAN 16
#define ADC_RATE_TYPE "altera_avalon_pio"
#define ALT_MODULE_CLASS_ADC_rate altera_avalon_pio


/*
 * ADC_raw configuration
 *
 */

#define ADC_RAW_BASE 0x1511c0
#define ADC_RAW_BIT_CLEARING_EDGE_REGISTER 0
#define ADC_RAW_BIT_MODIFYING_OUTPUT_REGISTER 0
#define ADC_RAW_CAPTURE 0
#define ADC_RAW_DATA_WIDTH 24
#define ADC_RAW_DO_TEST_BENCH_WIRING 0
#define ADC_RAW_DRIVEN_SIM_VALUE 0
#define ADC_RAW_EDGE_TYPE "NONE"
#define ADC_RAW_FREQ 36000000
#define ADC_RAW_HAS_IN 1
#define ADC_RAW_HAS_OUT 0
#define ADC_RAW_HAS_TRI 0
#define ADC_RAW_IRQ -1
#define ADC_RAW_IRQ_INTERRUPT_CONTROLLER_ID -1
#define ADC_RAW_IRQ_TYPE "NONE"
#define ADC_RAW_NAME "/dev/ADC_raw"
#define ADC_RAW_RESET_VALUE 0
#define ADC_RAW_SPAN 16
#define ADC_RAW_TYPE "altera_avalon_pio"
#define ALT_MODULE_CLASS_ADC_raw altera_avalon_pio


/*
 * CPU configuration
 *
 */

#define ALT_CPU_ARCHITECTURE "altera_nios2_qsys"
#define ALT_CPU_BIG_ENDIAN 0
#define ALT_CPU_BREAK_ADDR 0x00150820
#define ALT_CPU_CPU_FREQ 36000000u
#define ALT_CPU_CPU_ID_SIZE 1
#define ALT_CPU_CPU_ID_VALUE 0x00000000
#define ALT_CPU_CPU_IMPLEMENTATION "tiny"
#define ALT_CPU_DATA_ADDR_WIDTH 0x15
#define ALT_CPU_DCACHE_LINE_SIZE 0
#define ALT_CPU_DCACHE_LINE_SIZE_LOG2 0
#define ALT_CPU_DCACHE_SIZE 0
#define ALT_CPU_EXCEPTION_ADDR 0x00148020
#define ALT_CPU_FLUSHDA_SUPPORTED
#define ALT_CPU_FREQ 36000000
#define ALT_CPU_HARDWARE_DIVIDE_PRESENT 0
#define ALT_CPU_HARDWARE_MULTIPLY_PRESENT 0
#define ALT_CPU_HARDWARE_MULX_PRESENT 0
#define ALT_CPU_HAS_DEBUG_CORE 1
#define ALT_CPU_HAS_DEBUG_STUB
#define ALT_CPU_HAS_JMPI_INSTRUCTION
#define ALT_CPU_ICACHE_LINE_SIZE 0
#define ALT_CPU_ICACHE_LINE_SIZE_LOG2 0
#define ALT_CPU_ICACHE_SIZE 0
#define ALT_CPU_INST_ADDR_WIDTH 0x15
#define ALT_CPU_NAME "PROC"
#define ALT_CPU_RESET_ADDR 0x00148000


/*
 * CPU configuration (with legacy prefix - don't use these anymore)
 *
 */

#define NIOS2_BIG_ENDIAN 0
#define NIOS2_BREAK_ADDR 0x00150820
#define NIOS2_CPU_FREQ 36000000u
#define NIOS2_CPU_ID_SIZE 1
#define NIOS2_CPU_ID_VALUE 0x00000000
#define NIOS2_CPU_IMPLEMENTATION "tiny"
#define NIOS2_DATA_ADDR_WIDTH 0x15
#define NIOS2_DCACHE_LINE_SIZE 0
#define NIOS2_DCACHE_LINE_SIZE_LOG2 0
#define NIOS2_DCACHE_SIZE 0
#define NIOS2_EXCEPTION_ADDR 0x00148020
#define NIOS2_FLUSHDA_SUPPORTED
#define NIOS2_HARDWARE_DIVIDE_PRESENT 0
#define NIOS2_HARDWARE_MULTIPLY_PRESENT 0
#define NIOS2_HARDWARE_MULX_PRESENT 0
#define NIOS2_HAS_DEBUG_CORE 1
#define NIOS2_HAS_DEBUG_STUB
#define NIOS2_HAS_JMPI_INSTRUCTION
#define NIOS2_ICACHE_LINE_SIZE 0
#define NIOS2_ICACHE_LINE_SIZE_LOG2 0
#define NIOS2_ICACHE_SIZE 0
#define NIOS2_INST_ADDR_WIDTH 0x15
#define NIOS2_RESET_ADDR 0x00148000


/*
 * Define for each module class mastered by the CPU
 *
 */

#define __ALTERA_AVALON_ONCHIP_MEMORY2
#define __ALTERA_AVALON_PIO
#define __ALTERA_AVALON_SYSID_QSYS
#define __ALTERA_GENERIC_TRISTATE_CONTROLLER
#define __ALTERA_NIOS2_QSYS


/*
 * ONCHIP_mem configuration
 *
 */

#define ALT_MODULE_CLASS_ONCHIP_mem altera_avalon_onchip_memory2
#define ONCHIP_MEM_ALLOW_IN_SYSTEM_MEMORY_CONTENT_EDITOR 0
#define ONCHIP_MEM_ALLOW_MRAM_SIM_CONTENTS_ONLY_FILE 0
#define ONCHIP_MEM_BASE 0x148000
#define ONCHIP_MEM_CONTENTS_INFO ""
#define ONCHIP_MEM_DUAL_PORT 0
#define ONCHIP_MEM_GUI_RAM_BLOCK_TYPE "AUTO"
#define ONCHIP_MEM_INIT_CONTENTS_FILE "proc_ONCHIP_mem"
#define ONCHIP_MEM_INIT_MEM_CONTENT 1
#define ONCHIP_MEM_INSTANCE_ID "NONE"
#define ONCHIP_MEM_IRQ -1
#define ONCHIP_MEM_IRQ_INTERRUPT_CONTROLLER_ID -1
#define ONCHIP_MEM_NAME "/dev/ONCHIP_mem"
#define ONCHIP_MEM_NON_DEFAULT_INIT_FILE_ENABLED 0
#define ONCHIP_MEM_RAM_BLOCK_TYPE "AUTO"
#define ONCHIP_MEM_READ_DURING_WRITE_MODE "DONT_CARE"
#define ONCHIP_MEM_SINGLE_CLOCK_OP 0
#define ONCHIP_MEM_SIZE_MULTIPLE 1
#define ONCHIP_MEM_SIZE_VALUE 32768
#define ONCHIP_MEM_SPAN 32768
#define ONCHIP_MEM_TYPE "altera_avalon_onchip_memory2"
#define ONCHIP_MEM_WRITABLE 1


/*
 * RAM_ctrl configuration
 *
 */

#define ALT_MODULE_CLASS_RAM_ctrl altera_generic_tristate_controller
#define RAM_CTRL_BASE 0x120000
#define RAM_CTRL_IRQ -1
#define RAM_CTRL_IRQ_INTERRUPT_CONTROLLER_ID -1
#define RAM_CTRL_NAME "/dev/RAM_ctrl"
#define RAM_CTRL_SIZE 65536
#define RAM_CTRL_SPAN 65536
#define RAM_CTRL_TYPE "altera_generic_tristate_controller"


/*
 * ROM_ctrl configuration
 *
 */

#define ALT_MODULE_CLASS_ROM_ctrl altera_generic_tristate_controller
#define ROM_CTRL_BASE 0x130000
#define ROM_CTRL_IRQ -1
#define ROM_CTRL_IRQ_INTERRUPT_CONTROLLER_ID -1
#define ROM_CTRL_NAME "/dev/ROM_ctrl"
#define ROM_CTRL_SIZE 65536
#define ROM_CTRL_SPAN 65536
#define ROM_CTRL_TYPE "altera_generic_tristate_controller"


/*
 * System configuration
 *
 */

#define ALT_DEVICE_FAMILY "Cyclone III"
#define ALT_ENHANCED_INTERRUPT_API_PRESENT
#define ALT_IRQ_BASE NULL
#define ALT_LOG_PORT "/dev/null"
#define ALT_LOG_PORT_BASE 0x0
#define ALT_LOG_PORT_DEV null
#define ALT_LOG_PORT_TYPE ""
#define ALT_NUM_EXTERNAL_INTERRUPT_CONTROLLERS 0
#define ALT_NUM_INTERNAL_INTERRUPT_CONTROLLERS 1
#define ALT_NUM_INTERRUPT_CONTROLLERS 1
#define ALT_STDERR "/dev/null"
#define ALT_STDERR_BASE 0x0
#define ALT_STDERR_DEV null
#define ALT_STDERR_TYPE ""
#define ALT_STDIN "/dev/null"
#define ALT_STDIN_BASE 0x0
#define ALT_STDIN_DEV null
#define ALT_STDIN_TYPE ""
#define ALT_STDOUT "/dev/null"
#define ALT_STDOUT_BASE 0x0
#define ALT_STDOUT_DEV null
#define ALT_STDOUT_TYPE ""
#define ALT_SYSTEM_NAME "proc"


/*
 * TRIG_ctrl configuration
 *
 */

#define ALT_MODULE_CLASS_TRIG_ctrl altera_avalon_pio
#define TRIG_CTRL_BASE 0x1510e0
#define TRIG_CTRL_BIT_CLEARING_EDGE_REGISTER 0
#define TRIG_CTRL_BIT_MODIFYING_OUTPUT_REGISTER 1
#define TRIG_CTRL_CAPTURE 0
#define TRIG_CTRL_DATA_WIDTH 8
#define TRIG_CTRL_DO_TEST_BENCH_WIRING 0
#define TRIG_CTRL_DRIVEN_SIM_VALUE 0
#define TRIG_CTRL_EDGE_TYPE "NONE"
#define TRIG_CTRL_FREQ 36000000
#define TRIG_CTRL_HAS_IN 0
#define TRIG_CTRL_HAS_OUT 1
#define TRIG_CTRL_HAS_TRI 0
#define TRIG_CTRL_IRQ -1
#define TRIG_CTRL_IRQ_INTERRUPT_CONTROLLER_ID -1
#define TRIG_CTRL_IRQ_TYPE "NONE"
#define TRIG_CTRL_NAME "/dev/TRIG_ctrl"
#define TRIG_CTRL_RESET_VALUE 0
#define TRIG_CTRL_SPAN 32
#define TRIG_CTRL_TYPE "altera_avalon_pio"


/*
 * TRIG_delay configuration
 *
 */

#define ALT_MODULE_CLASS_TRIG_delay altera_avalon_pio
#define TRIG_DELAY_BASE 0x1510a0
#define TRIG_DELAY_BIT_CLEARING_EDGE_REGISTER 0
#define TRIG_DELAY_BIT_MODIFYING_OUTPUT_REGISTER 1
#define TRIG_DELAY_CAPTURE 0
#define TRIG_DELAY_DATA_WIDTH 16
#define TRIG_DELAY_DO_TEST_BENCH_WIRING 0
#define TRIG_DELAY_DRIVEN_SIM_VALUE 0
#define TRIG_DELAY_EDGE_TYPE "NONE"
#define TRIG_DELAY_FREQ 36000000
#define TRIG_DELAY_HAS_IN 0
#define TRIG_DELAY_HAS_OUT 1
#define TRIG_DELAY_HAS_TRI 0
#define TRIG_DELAY_IRQ -1
#define TRIG_DELAY_IRQ_INTERRUPT_CONTROLLER_ID -1
#define TRIG_DELAY_IRQ_TYPE "NONE"
#define TRIG_DELAY_NAME "/dev/TRIG_delay"
#define TRIG_DELAY_RESET_VALUE 0
#define TRIG_DELAY_SPAN 32
#define TRIG_DELAY_TYPE "altera_avalon_pio"


/*
 * TRIG_error configuration
 *
 */

#define ALT_MODULE_CLASS_TRIG_error altera_avalon_pio
#define TRIG_ERROR_BASE 0x1511a0
#define TRIG_ERROR_BIT_CLEARING_EDGE_REGISTER 0
#define TRIG_ERROR_BIT_MODIFYING_OUTPUT_REGISTER 0
#define TRIG_ERROR_CAPTURE 0
#define TRIG_ERROR_DATA_WIDTH 8
#define TRIG_ERROR_DO_TEST_BENCH_WIRING 0
#define TRIG_ERROR_DRIVEN_SIM_VALUE 0
#define TRIG_ERROR_EDGE_TYPE "NONE"
#define TRIG_ERROR_FREQ 36000000
#define TRIG_ERROR_HAS_IN 0
#define TRIG_ERROR_HAS_OUT 1
#define TRIG_ERROR_HAS_TRI 0
#define TRIG_ERROR_IRQ -1
#define TRIG_ERROR_IRQ_INTERRUPT_CONTROLLER_ID -1
#define TRIG_ERROR_IRQ_TYPE "NONE"
#define TRIG_ERROR_NAME "/dev/TRIG_error"
#define TRIG_ERROR_RESET_VALUE 0
#define TRIG_ERROR_SPAN 16
#define TRIG_ERROR_TYPE "altera_avalon_pio"


/*
 * TRIG_int configuration
 *
 */

#define ALT_MODULE_CLASS_TRIG_int altera_avalon_pio
#define TRIG_INT_BASE 0x151120
#define TRIG_INT_BIT_CLEARING_EDGE_REGISTER 1
#define TRIG_INT_BIT_MODIFYING_OUTPUT_REGISTER 1
#define TRIG_INT_CAPTURE 1
#define TRIG_INT_DATA_WIDTH 8
#define TRIG_INT_DO_TEST_BENCH_WIRING 0
#define TRIG_INT_DRIVEN_SIM_VALUE 0
#define TRIG_INT_EDGE_TYPE "RISING"
#define TRIG_INT_FREQ 36000000
#define TRIG_INT_HAS_IN 1
#define TRIG_INT_HAS_OUT 0
#define TRIG_INT_HAS_TRI 0
#define TRIG_INT_IRQ 6
#define TRIG_INT_IRQ_INTERRUPT_CONTROLLER_ID 0
#define TRIG_INT_IRQ_TYPE "EDGE"
#define TRIG_INT_NAME "/dev/TRIG_int"
#define TRIG_INT_RESET_VALUE 0
#define TRIG_INT_SPAN 32
#define TRIG_INT_TYPE "altera_avalon_pio"


/*
 * TRIG_level configuration
 *
 */

#define ALT_MODULE_CLASS_TRIG_level altera_avalon_pio
#define TRIG_LEVEL_BASE 0x1510c0
#define TRIG_LEVEL_BIT_CLEARING_EDGE_REGISTER 0
#define TRIG_LEVEL_BIT_MODIFYING_OUTPUT_REGISTER 1
#define TRIG_LEVEL_CAPTURE 0
#define TRIG_LEVEL_DATA_WIDTH 8
#define TRIG_LEVEL_DO_TEST_BENCH_WIRING 0
#define TRIG_LEVEL_DRIVEN_SIM_VALUE 0
#define TRIG_LEVEL_EDGE_TYPE "NONE"
#define TRIG_LEVEL_FREQ 36000000
#define TRIG_LEVEL_HAS_IN 0
#define TRIG_LEVEL_HAS_OUT 1
#define TRIG_LEVEL_HAS_TRI 0
#define TRIG_LEVEL_IRQ -1
#define TRIG_LEVEL_IRQ_INTERRUPT_CONTROLLER_ID -1
#define TRIG_LEVEL_IRQ_TYPE "NONE"
#define TRIG_LEVEL_NAME "/dev/TRIG_level"
#define TRIG_LEVEL_RESET_VALUE 0
#define TRIG_LEVEL_SPAN 32
#define TRIG_LEVEL_TYPE "altera_avalon_pio"


/*
 * VRAM_ctrl configuration
 *
 */

#define ALT_MODULE_CLASS_VRAM_ctrl altera_generic_tristate_controller
#define VRAM_CTRL_BASE 0x80000
#define VRAM_CTRL_IRQ -1
#define VRAM_CTRL_IRQ_INTERRUPT_CONTROLLER_ID -1
#define VRAM_CTRL_NAME "/dev/VRAM_ctrl"
#define VRAM_CTRL_SPAN 524288
#define VRAM_CTRL_TYPE "altera_generic_tristate_controller"


/*
 * hal configuration
 *
 */

#define ALT_MAX_FD 32
#define ALT_SYS_CLK none
#define ALT_TIMESTAMP_CLK none


/*
 * key_input configuration
 *
 */

#define ALT_MODULE_CLASS_key_input altera_avalon_pio
#define KEY_INPUT_BASE 0x1511d0
#define KEY_INPUT_BIT_CLEARING_EDGE_REGISTER 1
#define KEY_INPUT_BIT_MODIFYING_OUTPUT_REGISTER 0
#define KEY_INPUT_CAPTURE 1
#define KEY_INPUT_DATA_WIDTH 20
#define KEY_INPUT_DO_TEST_BENCH_WIRING 0
#define KEY_INPUT_DRIVEN_SIM_VALUE 0
#define KEY_INPUT_EDGE_TYPE "RISING"
#define KEY_INPUT_FREQ 36000000
#define KEY_INPUT_HAS_IN 1
#define KEY_INPUT_HAS_OUT 0
#define KEY_INPUT_HAS_TRI 0
#define KEY_INPUT_IRQ 5
#define KEY_INPUT_IRQ_INTERRUPT_CONTROLLER_ID 0
#define KEY_INPUT_IRQ_TYPE "EDGE"
#define KEY_INPUT_NAME "/dev/key_input"
#define KEY_INPUT_RESET_VALUE 0
#define KEY_INPUT_SPAN 16
#define KEY_INPUT_TYPE "altera_avalon_pio"


/*
 * sysid_qsys_0 configuration
 *
 */

#define ALT_MODULE_CLASS_sysid_qsys_0 altera_avalon_sysid_qsys
#define SYSID_QSYS_0_BASE 0x1511e8
#define SYSID_QSYS_0_ID -1431655766
#define SYSID_QSYS_0_IRQ -1
#define SYSID_QSYS_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SYSID_QSYS_0_NAME "/dev/sysid_qsys_0"
#define SYSID_QSYS_0_SPAN 8
#define SYSID_QSYS_0_TIMESTAMP 1402552249
#define SYSID_QSYS_0_TYPE "altera_avalon_sysid_qsys"


/*
 * test_input configuration
 *
 */

#define ALT_MODULE_CLASS_test_input altera_avalon_pio
#define TEST_INPUT_BASE 0x151190
#define TEST_INPUT_BIT_CLEARING_EDGE_REGISTER 0
#define TEST_INPUT_BIT_MODIFYING_OUTPUT_REGISTER 0
#define TEST_INPUT_CAPTURE 0
#define TEST_INPUT_DATA_WIDTH 32
#define TEST_INPUT_DO_TEST_BENCH_WIRING 0
#define TEST_INPUT_DRIVEN_SIM_VALUE 0
#define TEST_INPUT_EDGE_TYPE "NONE"
#define TEST_INPUT_FREQ 36000000
#define TEST_INPUT_HAS_IN 1
#define TEST_INPUT_HAS_OUT 0
#define TEST_INPUT_HAS_TRI 0
#define TEST_INPUT_IRQ -1
#define TEST_INPUT_IRQ_INTERRUPT_CONTROLLER_ID -1
#define TEST_INPUT_IRQ_TYPE "NONE"
#define TEST_INPUT_NAME "/dev/test_input"
#define TEST_INPUT_RESET_VALUE 0
#define TEST_INPUT_SPAN 16
#define TEST_INPUT_TYPE "altera_avalon_pio"

#endif /* __SYSTEM_H_ */
