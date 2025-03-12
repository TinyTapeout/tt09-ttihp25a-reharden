/*
 * Copyright (c) 2024 Anton Maurovic
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_algofoogle_tt09_ring_osc3 (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  wire osc;
  tapped_ring tapped_ring ( .ena(ena), .tap(ui_in[2:0]), .y(osc) );
  assign uo_out[0] = osc;
  reg [6:0] count;
  always @(posedge osc) count <= count + 1;
  assign uo_out[7:1] = count;

  // List all unused inputs to prevent warnings
  wire dummy = &{ui_in, uio_in, ena, rst_n};
  assign uio_out[0] = dummy;
  wire _unused = &{clk, 1'b0};

  assign uio_oe = 8'b0000_0001;
  assign uio_out[7:1] = 7'b0000000;

endmodule
