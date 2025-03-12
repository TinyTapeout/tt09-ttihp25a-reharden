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

module ring_osc #(
    parameter DEPTH = 500 // Becomes DEPTH*2+1 inverters to ensure it is odd.
) (
    input wire ena,
    output osc_out
);

    wire [DEPTH*2:0] inv_in;
    wire [DEPTH*2:0] inv_out;
    assign inv_in[DEPTH*2:1] = inv_out[DEPTH*2-1:0]; // Chain.
    assign inv_in[0] = inv_out[DEPTH*2] & ena; // Loop back, unless disabled.
    // Generate an instance array of inverters, chained and looped back via the 2 assignments above:
    (* keep_hierarchy *) amm_inverter inv_array [DEPTH*2:0] ( .a(inv_in), .y(inv_out) );
    assign osc_out = inv_in[0];

endmodule
