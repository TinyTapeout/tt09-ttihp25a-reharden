`default_nettype none

//NOTE: I determined this definition as follows:
// - Searched for "sky130_fd_sc_hd__" combined with "inv", e.g.
//      find $PDK_ROOT/$PDK -iname "*sky130_fd_sc_hd__*inv*"
// - Found various versions, checked to find ones which are NOT bad by
//      making sure they do NOT appear in:
//      https://github.com/RTimothyEdwards/open_pdks/blob/master/sky130/openlane/sky130_fd_sc_hd/no_synth.cells
// - Chose sky130_fd_sc_hd__inv_2
// - Had a look at it in:
//      - https://foss-eda-tools.googlesource.com/skywater-pdk/libs/sky130_fd_sc_hd/+/refs/heads/new-spice/cells/inv/sky130_fd_sc_hd__inv_2.v
//      - https://skywater-pdk.readthedocs.io/en/main/contents/libraries/sky130_fd_sc_hd/cells/inv/README.html
// - I was informed by my own former project:
//      https://repositories.efabless.com/amm_efabless/ci2409_counter_and_vga3/blob/main/f/verilog/rtl/antenna_breaker.v
//NOTE: Also need to make sure OpenLane RSZ_DONT_TOUCH_RX covers this?
// (* blackbox *) module sky130_fd_sc_hd__inv_2(
//     input A,
//     output Y // Inverted output.
// );
// endmodule

module amm_inverter (
    input   wire a,
    output  wire y
);

    (* keep_hierarchy *) sky130_fd_sc_hd__inv_2   sky_inverter (
        .A  (a),
        .Y  (y)
    );

endmodule

// A chain of inverters.
module inv_chain #(
    parameter N = 10 // SHOULD BE EVEN.
) (
    input a,
    output y
);

    wire [N-1:0] ins;
    wire [N-1:0] outs;
    assign ins[0] = a;
    assign ins[N-1:1] = outs[N-2:0];
    assign y = outs[N-1];
    (* keep_hierarchy *) amm_inverter inv_array [N-1:0] ( .a(ins), .y(outs) );

endmodule

module tapped_ring (
    input wire ena,
    input [2:0] tap,
    output y
);
    wire b0, b1, b11, b21, b31, b41, b51, b101, b301, b1001;
    (* keep_hierarchy *) amm_inverter      start ( .a(  b0), .y(     b1) ); // If all the counts below are even, this makes it odd.
    (* keep_hierarchy *) inv_chain #(.N(10))  c0 ( .a(  b1), .y(    b11) );
    (* keep_hierarchy *) inv_chain #(.N(10))  c1 ( .a( b11), .y(    b21) );
    (* keep_hierarchy *) inv_chain #(.N(10))  c2 ( .a( b21), .y(    b31) );
    (* keep_hierarchy *) inv_chain #(.N(10))  c3 ( .a( b31), .y(    b41) );
    (* keep_hierarchy *) inv_chain #(.N(10))  c4 ( .a( b41), .y(    b51) );
    (* keep_hierarchy *) inv_chain #(.N(50))  c5 ( .a( b51), .y(   b101) );
    (* keep_hierarchy *) inv_chain #(.N(200)) c6 ( .a(b101), .y(   b301) );
    (* keep_hierarchy *) inv_chain #(.N(700)) c7 ( .a(b301), .y(  b1001) );
    assign y =  tap == 0 ?   b11:
                tap == 1 ?   b21:
                tap == 2 ?   b31:
                tap == 3 ?   b41:
                tap == 4 ?   b51:
                tap == 5 ?  b101:
                tap == 6 ?  b301:
                /*tap==7*/ b1001;
    assign b0 = y & ena;
endmodule
