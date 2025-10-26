`timescale 1ns / 1ps

// Group NO. = 2
// Name 1: Harshit Singhal 23CS10025
// Name 2: Parag Mahadeo Chimankar 23CS10049
// VerilogAssignment5
module lfsr(
    input clk,              // 100 MHz clock from FPGA
    input rst,              // async reset
    input sel,              // 0 = load seed, 1 = shift
    input [3:0] seed,       // initial seed (non-zero)
    output [3:0] state      // current LFSR state
);

    // slow clock for observation
    wire slow_clk;
    clock_divider clkdiv(.clk(clk), .rst(rst), .slow_clk(slow_clk));

    // Internal wires for DFF outputs
    wire w2, w3, w4, w5;  
    assign state = {w2, w3, w4, w5};

    // Feedback = XOR of last two bits
    wire feedback = w4 ^ w5;

    // MUX + DFF chain
    wire d0, d1, d2, d3;

    mux m0(.d_inp(feedback), .seed_inp(seed[3]), .sel(sel), .out(d0));
    dff dff0(.in(d0), .out(w2), .clk(slow_clk), .rst(rst));

    mux m1(.d_inp(w2), .seed_inp(seed[2]), .sel(sel), .out(d1));
    dff dff1(.in(d1), .out(w3), .clk(slow_clk), .rst(rst));

    mux m2(.d_inp(w3), .seed_inp(seed[1]), .sel(sel), .out(d2));
    dff dff2(.in(d2), .out(w4), .clk(slow_clk), .rst(rst));

    mux m3(.d_inp(w4), .seed_inp(seed[0]), .sel(sel), .out(d3));
    dff dff3(.in(d3), .out(w5), .clk(slow_clk), .rst(rst));

endmodule

