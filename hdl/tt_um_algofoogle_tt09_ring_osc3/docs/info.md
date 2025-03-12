<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## What is this?

See [tt09-ring-osc](https://github.com/algofoogle/tt09-ring-osc) and [tt09-ring-osc2](https://github.com/algofoogle/tt09-ring-osc2) for my other ring oscillator experiments on TT09.

This one has a configurable ring oscillator; the feedback can be tapped at different parts of the chain.

This uses Verilog to instantiate a ring of (an odd number of) `sky130_fd_sc_hd__inv_2` cells -- **UPDATE:** Actually, since this is targeting IHP instead, there is a polyfill that somebody else wrote to map sky130 cells to generic cells (that OpenLane will then map to IHP cells).
