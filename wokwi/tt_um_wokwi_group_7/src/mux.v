`default_nettype none

// verilator lint_off UNUSEDSIGNAL
// verilator lint_off PINCONNECTEMPTY

module tt_um_wokwi_group_7(
  input  wire [7:0] ui_in,    // Dedicated inputs
  output wire [7:0] uo_out,    // Dedicated outputs
  input  wire [7:0] uio_in,    // IOs: Input path
  output wire [7:0] uio_out,    // IOs: Output path
  output wire [7:0] uio_oe,    // IOs: Enable path (active high: 0=input, 1=output)
  input ena,
  input clk,
  input rst_n
);

  wire [3:0] sel = uio_in[3:0];
  wire [7:0] proj_out[15:0];

  tt_um_wokwi_413387009513254913 proj__0 (.ui_in, .uo_out(proj_out[ 0]), .uio_in(0), .uio_out(), .uio_oe());
  tt_um_wokwi_413387186248679425 proj__1 (.ui_in, .uo_out(proj_out[ 1]), .uio_in(0), .uio_out(), .uio_oe());
  tt_um_wokwi_413918244906651649 proj__2 (.ui_in, .uo_out(proj_out[ 2]), .uio_in(0), .uio_out(), .uio_oe());
  tt_um_wokwi_413919454053401601 proj__3 (.ui_in, .uo_out(proj_out[ 3]), .uio_in(0), .uio_out(), .uio_oe());
  tt_um_wokwi_413919458626244609 proj__4 (.ui_in, .uo_out(proj_out[ 4]), .uio_in(0), .uio_out(), .uio_oe());
  tt_um_wokwi_413919565287453697 proj__5 (.ui_in, .uo_out(proj_out[ 5]), .uio_in(0), .uio_out(), .uio_oe());
  tt_um_wokwi_413919752282163201 proj__6 (.ui_in, .uo_out(proj_out[ 6]), .uio_in(0), .uio_out(), .uio_oe());
  tt_um_wokwi_413919794360480769 proj__7 (.ui_in, .uo_out(proj_out[ 7]), .uio_in(0), .uio_out(), .uio_oe());
  tt_um_wokwi_413921849611724801 proj__8 (.ui_in, .uo_out(proj_out[ 8]), .uio_in(0), .uio_out(), .uio_oe());
  tt_um_wokwi_413929752291913729 proj__9 (.ui_in, .uo_out(proj_out[ 9]), .uio_in(0), .uio_out(), .uio_oe());
  tt_um_wokwi_414120379026893825 proj_10 (.ui_in, .uo_out(proj_out[10]), .uio_in(0), .uio_out(), .uio_oe());
  tt_um_wokwi_414120414884012033 proj_11 (.ui_in, .uo_out(proj_out[11]), .uio_in(0), .uio_out(), .uio_oe());
  tt_um_wokwi_414120432405727233 proj_12 (.ui_in, .uo_out(proj_out[12]), .uio_in(0), .uio_out(), .uio_oe());
  tt_um_wokwi_414120800422397953 proj_13 (.ui_in, .uo_out(proj_out[13]), .uio_in(0), .uio_out(), .uio_oe());
  tt_um_wokwi_414124471705253889 proj_14 (.ui_in, .uo_out(proj_out[14]), .uio_in(0), .uio_out(), .uio_oe());
  assign proj_out[15] = 0;

  assign uo_out = proj_out[sel];
  assign uio_out = 8'b0;
  assign uio_oe = 8'b0;

endmodule
