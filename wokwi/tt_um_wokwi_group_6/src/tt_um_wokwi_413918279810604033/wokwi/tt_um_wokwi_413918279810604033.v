/* Automatically generated from https://wokwi.com/projects/413918279810604033 */

`default_nettype none

// verilator lint_off UNUSEDSIGNAL
// verilator lint_off PINCONNECTEMPTY

module tt_um_wokwi_413918279810604033(
  input  wire [7:0] ui_in,    // Dedicated inputs
  output wire [7:0] uo_out,    // Dedicated outputs
  input  wire [7:0] uio_in,    // IOs: Input path
  output wire [7:0] uio_out,    // IOs: Output path
  output wire [7:0] uio_oe,    // IOs: Enable path (active high: 0=input, 1=output)
  input ena,
  input clk,
  input rst_n
);
  wire net1 = ui_in[4];
  wire net2 = ui_in[6];
  wire net3 = ui_in[7];
  wire net4;
  wire net5 = 1'b0;
  wire net6 = 1'b1;
  wire net7 = 1'b1;
  wire net8 = 1'b0;
  wire net9 = 1'b1;

  assign uo_out[0] = net4;
  assign uo_out[1] = net4;
  assign uo_out[2] = net4;
  assign uo_out[3] = net4;
  assign uo_out[4] = net4;
  assign uo_out[5] = net4;
  assign uo_out[6] = net4;
  assign uo_out[7] = net4;
  assign uio_out[0] = 0;
  assign uio_oe[0] = 0;
  assign uio_out[1] = 0;
  assign uio_oe[1] = 0;
  assign uio_out[2] = 0;
  assign uio_oe[2] = 0;
  assign uio_out[3] = 0;
  assign uio_oe[3] = 0;
  assign uio_out[4] = 0;
  assign uio_oe[4] = 0;
  assign uio_out[5] = 0;
  assign uio_oe[5] = 0;
  assign uio_out[6] = 0;
  assign uio_oe[6] = 0;
  assign uio_out[7] = 0;
  assign uio_oe[7] = 0;

  mux_cell mux1 (
    .a (net1),
    .b (net2),
    .sel (net3),
    .out (net4)
  );
endmodule
