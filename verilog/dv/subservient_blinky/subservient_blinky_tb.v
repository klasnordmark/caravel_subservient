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

 `default_nettype none

 `timescale 1ns/1ps

 `include "uprj_netlists.v"
 `include "caravel_netlists.v"
 `include "spiflash.v"
 `include "tbuart.v"

 module subservient_blinky_tb;

    reg clock;
    reg RSTB;
    reg CSB;
    reg power1, power2;
    reg power3, power4;

    wire HIGH;
    wire LOW;
    wire TRI;
    assign HIGH = 1'b1;
    assign LOW = 1'b0;
    assign TRI = 1'bz;

    wire gpio;
    wire mprj_gpio;
    wire uart_tx;
    wire [37:0] mprj_io;
    wire [15:0] checkbits;

    wire flash_csb;
    wire flash_clk;
    wire flash_io0;
    wire flash_io1;

    wire VDD3V3 = power1;
    wire VDD1V8 = power2;
    wire VSS = 1'b0;

    assign checkbits = mprj_io[31:16];
    assign mprj_gpio = mprj_io[1];

    always #15 clock <= (clock == 1'b0);

    initial begin
        clock = 0;
    end

    initial begin
        $dumpfile("subservient_blinky.vcd");
        $dumpvars(0, subservient_blinky_tb);
        repeat (150) begin
            repeat (1000) @(posedge clock);
        end
        $display("%c[1;31m",27);
        $display ("Monitor: Timeout, Subservient blinky test failed");
        $display("%c[0m",27);
        $finish;
    end

    // Reset Operation
    initial begin
        RSTB <= 1'b0;
        CSB  <= 1'b1;       // Force CSB high
        #2000;
        RSTB <= 1'b1;       // Release reset
        #170000;
        CSB = 1'b0;         // CSB can be released
    end

    initial begin		// Power-up sequence
        power1 <= 1'b0;
        power2 <= 1'b0;
        #200;
        power1 <= 1'b1;
        #200;
        power2 <= 1'b1;
    end

    // Actual test - checking GPIO
    initial begin
        wait(checkbits == 16'hAB40);
        $display("Monitor: subservient blinky test started");
        // We need the blink IO to switch at least two times
        wait(mprj_gpio == 1);
        wait(mprj_gpio == 0);
        $display("Monitor: gpio switched once.");
        wait(mprj_gpio == 1);
        wait(mprj_gpio == 0);
        $display("Monitor: gpio switched twice.");
        $display("Monitor: subservient blinky test Passed");
        #10000;
        $finish;
    end
    
    caravel dut (
        .vddio	  (VDD3V3),
        .vssio	  (VSS),
        .vdda	  (VDD3V3),
        .vssa	  (VSS),
        .vccd	  (VDD1V8),
        .vssd	  (VSS),
        .vdda1    (VDD3V3),
        .vdda2    (VDD3V3),
        .vssa1	  (VSS),
        .vssa2	  (VSS),
        .vccd1	  (VDD1V8),
        .vccd2	  (VDD1V8),
        .vssd1	  (VSS),
        .vssd2	  (VSS),
        .clock	  (clock),
        .gpio     (gpio),
        .mprj_io  (mprj_io),
        .flash_csb(flash_csb),
        .flash_clk(flash_clk),
        .flash_io0(flash_io0),
        .flash_io1(flash_io1),
        .resetb	  (RSTB)
    );

    spiflash #(
        .FILENAME("subservient_blinky.hex")
    ) spiflash (
        .csb(flash_csb),
        .clk(flash_clk),
        .io0(flash_io0),
        .io1(flash_io1),
        .io2(),         // not used
        .io3()          // not used
    );

 endmodule