/*
 * Copyright (c) 2024 Anton Maurovic
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_algofoogle_tt09_ring_osc (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  ring_osc myring (
    .ena(ena),
    .osc_out(uo_out[0])
  );

  assign uo_out[7:2] = 6'b0000_00;

  // List all unused inputs to prevent warnings
  wire dummy = &{ui_in, uio_in, ena, rst_n};
  assign uo_out[1] = dummy;
  wire _unused = &{clk, 1'b0};

  assign uio_oe = 8'b0000_0000; // UIOs unused but make them inputs by default.
  assign uio_out = 8'b0000_0000;

endmodule
