/*
 * Copyright (c) 2024 Michael Bell
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_MichaelBell_rle_vga (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // Bidirs are used for SPI interface
  wire [3:0] qspi_data_in = ui_in[3] ? uio_in[5:2] : {uio_in[5:4], uio_in[2:1]};
  wire [3:0] qspi_data_out;
  wire [3:0] qspi_data_oe;
  wire       qspi_clk_out;
  wire       qspi_flash_select;
  wire       qspi_ram_a_select = 1'b1;
  wire       pwm_audio;
  assign uio_out = ui_in[3] ?
                   {pwm_audio, qspi_ram_a_select, qspi_data_out[3:0], 
                    qspi_clk_out, qspi_flash_select} :
                   {pwm_audio, qspi_ram_a_select, qspi_data_out[3:2], 
                    qspi_clk_out, qspi_data_out[1:0], qspi_flash_select};
  assign uio_oe = rst_n ? (ui_in[3] ? 
                   {2'b11, qspi_data_oe[3:0], 2'b11} :
                   {2'b11, qspi_data_oe[3:2], 1'b1, qspi_data_oe[1:0], 1'b1}) : 8'h00;  

  wire vga_blank;
  wire next_frame;
  wire next_row;

  vga i_vga (
    .clk        (clk),
    .reset_n    (rst_n),
    .hsync      (uo_out[7]),
    .vsync      (uo_out[3]),
    .blank      (vga_blank),
    .vsync_pulse(next_frame),
    .hsync_pulse(next_row)
  );

  wire [15:0] spi_data;
  wire spi_busy;
  wire spi_start_read;
  wire spi_stop_read;
  wire spi_continue_read;
  wire spi_buf_empty0;
  wire spi_buf_empty1;
  wire spi_buf_empty;

  spi_flash_controller #(
    .DATA_WIDTH_BYTES(2),
    .ADDR_BITS(24)
  ) i_spi (
    .clk        (clk),
    .rstn       (rst_n),
    .spi_data_in(qspi_data_in),
    .spi_data_out(qspi_data_out),
    .spi_data_oe(qspi_data_oe),
    .spi_select (qspi_flash_select),
    .spi_clk_out(qspi_clk_out),
    .latency    (ui_in[2:0]),
    .addr_in    (24'b0),
    .start_read (spi_start_read),
    .stop_read  (spi_stop_read),
    .continue_read(spi_continue_read || spi_buf_empty || spi_buf_empty0 || spi_buf_empty1),
    .data_out   (spi_data),
    .busy       (spi_busy)
  );

  wire [15:0] spi_buf_data0;

  spi_buffer #( 
    .DATA_WIDTH_BYTES(2) 
  ) i_spi_buf0 (
    .clk        (clk),
    .rstn       (rst_n),
    .start_read (spi_start_read),
    .continue_read(spi_continue_read || spi_buf_empty || spi_buf_empty1),
    .data_in    (spi_data),
    .spi_busy   (spi_busy),
    .prev_empty (1'b1),
    .data_out   (spi_buf_data0),
    .empty      (spi_buf_empty0)
  );

  wire [15:0] spi_buf_data1;

  spi_buffer #( 
    .DATA_WIDTH_BYTES(2) 
  ) i_spi_buf1 (
    .clk        (clk),
    .rstn       (rst_n),
    .start_read (spi_start_read),
    .continue_read(spi_continue_read || spi_buf_empty),
    .data_in    (spi_buf_data0),
    .spi_busy   (spi_busy),
    .prev_empty (spi_buf_empty0),
    .data_out   (spi_buf_data1),
    .empty      (spi_buf_empty1)
  );

  wire [15:0] spi_buf_data;

  spi_buffer #( 
    .DATA_WIDTH_BYTES(2) 
  ) i_spi_buf (
    .clk        (clk),
    .rstn       (rst_n),
    .start_read (spi_start_read),
    .continue_read(spi_continue_read),
    .data_in    (spi_buf_data1),
    .spi_busy   (spi_busy),
    .prev_empty (spi_buf_empty1),
    .data_out   (spi_buf_data),
    .empty      (spi_buf_empty)
  );

  reg spi_started;
  wire spi_data_ready = spi_started && (!spi_busy || !spi_buf_empty || !spi_buf_empty0 || !spi_buf_empty1) && !spi_start_read && !spi_continue_read;
  wire read_next;
  wire [5:0] video_colour;

  wire [7:0] pwm_sample;

  rle_video i_video (
    .clk        (clk),
    .rstn       (rst_n),
    .read_next  (read_next),
    .stop_data  (spi_stop_read),
    .data_ready (spi_data_ready),
    .data       (spi_buf_data),
    .next_frame (next_frame),
    .next_row   (next_row),
    .next_pixel (!vga_blank),
    .colour     (video_colour),
    .pwm_sample (pwm_sample)
  );

  pwm_ctrl i_pwm (
    .clk   (clk),
    .rstn  (rst_n),
    .pwm   (pwm_audio),
    .level (pwm_sample)
  );

  always @(posedge clk) begin
    if (!rst_n) begin
      spi_started <= 0;
    end else begin

      if (spi_stop_read) 
        spi_started <= 0;
      else if (read_next) begin
        spi_started <= 1;
      end
    end
  end

  assign spi_continue_read = read_next && spi_started;
  assign spi_start_read = read_next && !spi_started;

  assign uo_out[0] = vga_blank ? 1'b0 : video_colour[5];
  assign uo_out[1] = vga_blank ? 1'b0 : video_colour[3];
  assign uo_out[2] = vga_blank ? 1'b0 : video_colour[1];
  assign uo_out[4] = vga_blank ? 1'b0 : video_colour[4];
  assign uo_out[5] = vga_blank ? 1'b0 : video_colour[2];
  assign uo_out[6] = vga_blank ? 1'b0 : video_colour[0];


  // List all unused inputs to prevent warnings
  wire _unused = &{ena, ui_in[7:4], uio_in[7:6], uio_in[0], 1'b0};
endmodule
