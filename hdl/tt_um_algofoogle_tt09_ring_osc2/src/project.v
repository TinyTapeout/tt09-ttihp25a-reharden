/*
 * Copyright (c) 2024 Anton Maurovic
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_algofoogle_tt09_ring_osc2 (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);


  // Ring of 125 inverters, output on uo_out[0] ~ 112MHz, if it makes it out?
  ring_osc #(.DEPTH(62)) ring_125 (.ena(ena), .osc_out(uo_out[0]));
  // Ring of 251 inverters, output on uo_out[1] ~ 56MHz?
  ring_osc #(.DEPTH(125)) ring_251 (.ena(ena), .osc_out(uo_out[1]));
  // Ring of 501 inverters, output on uo_out[2] ~ 28MHz?
  ring_osc #(.DEPTH(250)) ring_501 (.ena(ena), .osc_out(uo_out[2]));
  // Ring of 1001 inverters, output on uo_out[3] ~ 14MHz?
  ring_osc #(.DEPTH(500)) ring_1001 (.ena(ena), .osc_out(uo_out[3]));

  // Clocking a simple counter as a clock divider for ring_501...
  // Naive, unless I configure CTS and SDC?
  wire c0clock = uo_out[2]; // ~28MHz?
  reg [3:0] c0;
  always @(posedge c0clock) c0 <= c0 + 1;
  assign uo_out[4] = c0[3]; // ~3.5MHz?

  // Likewise, a simple clock divider on ring_125:
  wire c1clock = uo_out[0]; // ~112MHz?
  reg [3:0] c1;
  always @(posedge c1clock) c1 <= c1 + 1;
  assign uo_out[5] = c1[3]; // ~14MHz? Probably won't be exactly the same as uo_out[3].

  // Fast ring (25 inv) used for another counter experiment: ~570MHz?
  wire fast_osc;
  ring_osc #(.DEPTH(12)) ring_25 (.ena(ena), .osc_out(fast_osc));
  // Counter to divide down to (hopefully) ~9MHz:
  reg [5:0] c2;
  always @(posedge fast_osc) c2 <= c2 + 1;
  assign uo_out[6] = c2[5]; // ~9MHz?
  // PWM output ~137MHz, ui_in[1:0] compared with c2[1:0]
  assign uio_out[6] = c2[1:0] < ui_in[1:0]; // pwm2_out
  
  // VERY FAST ring (13 inv) for another counter and PWM experiment: ~1.1GHz:
  wire vfast_osc;
  ring_osc #(.DEPTH(6)) ring_13 (.osc_out(vfast_osc));
  // Counter to divide down to (hopefully) ~34MHz:
  reg [4:0] c3;
  always @(posedge vfast_osc) c3 <= c3 + 1;
  assign uo_out[7] = c3[4]; // ~34MHz?
  // PWM output ~275MHz, ui_in[3:2] compared with c3[1:0]
  assign uio_out[7] = c3[1:0] < ui_in[3:2]; // pwm3_out
  // PWM output ~137MHz, ui_in[7:5] compared with c3[2:0]
  assign uio_out[1] = c3[2:0] < ui_in[7:5]; // pwm3a_out

  // List all unused inputs to prevent warnings
  wire dummy = &{ui_in, uio_in, ena, rst_n};
  assign uio_out[0] = dummy;
  wire _unused = &{clk, 1'b0};

  assign uio_oe = 8'b1100_0011;
  assign uio_out[5:2] = 4'b0000;

endmodule
