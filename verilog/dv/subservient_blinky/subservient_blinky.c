/*
 * SPDX-FileCopyrightText: 2021 Klas Nordmark
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * SPDX-License-Identifier: Apache-2.0
 */

// This include is relative to $CARAVEL_PATH (see Makefile)
#include "verilog/dv/caravel/defs.h"

void main()
{

    uint32_t testval;

    reg_spimaster_config = 0xa002; // Enable, prescaler = 2

    // Only GPIO pin our design use is 1, which is the output of subservient
    reg_mprj_io_37 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_36 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_35 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_34 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_33 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_32 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_31 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_30 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_29 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_28 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_27 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_26 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_25 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_24 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_23 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_22 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_21 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_20 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_19 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_18 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_17 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_16 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_15 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_14 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_13 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_12 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_11 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_10 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_9 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_8 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_7 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_6 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_5 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_4 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_3 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_2 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_1 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_0 = GPIO_MODE_MGMT_STD_OUTPUT;

    // Set UART clock to 64 kbaud (enable before I/O configuration)
    reg_uart_clkdiv = 625;
    reg_uart_enable = 1;

    // Apply configuration
    reg_mprj_xfer = 1;
    while (reg_mprj_xfer == 1);

    // Configure LA probes [31:0] as inputs to Subservient
    reg_la0_oenb = reg_la0_iena = 0x00000000;
    reg_la1_oenb = reg_la1_iena = 0x00000000;    // [63:32]
	reg_la2_oenb = reg_la2_iena = 0x00000000;    // [95:64]
	reg_la3_oenb = reg_la3_iena = 0x00000000;    // [127:96]

    // Flag start of the test
    reg_mprj_datal = 0xAB400000;

    // Put Subservient in debug mode
    reg_la0_data = 0x00000000;

    // Write program to Subservient
    int blinky_length = 36;
    int blinky_start_addr = 0;
    uint8_t blinky_code[36] = {0x37, 0x05, 0x00, 0x40, 0x13, 0x03, 0x00, 0x01, 0x93, 0x02, 0x00, 0x00, 0x23, 0x00, 0x55, 0x00,
                               0x93, 0xC2, 0x12, 0x00, 0xB3, 0x73, 0x00, 0x00, 0x93, 0x83, 0x13, 0x00, 0xE3, 0x1E, 0x73, 0xFE,
                               0x6F, 0xF0, 0xDF, 0xFE};

    for (int i = 0; i < blinky_length; i+=4) {
        uint32_t word = blinky_code[i] | ((blinky_code[i+1]) << 8) | ((blinky_code[i+2]) << 16) | ((blinky_code[i+3]) << 24);
        volatile uint32_t* wr_addr = 0x30000000 + i + blinky_start_addr;
        *wr_addr = word;
    }

    // Put Subservient out of debug mode
    reg_la0_data = 0x00000001;

    // Idle
    while(true);
}