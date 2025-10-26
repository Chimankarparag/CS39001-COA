`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Ripple Carry Adder (5-bit) using 1-bit Full Adders

module ripple_carry_adder(
    input [3:0] A,       // Accumulator current value
    input [3:0] B,       // New input
    output [3:0] SUM,     // Output sum
    output cout
);
    wire [3:0] carry;

    // First full adder
    full_adder FA0(A[0], B[0], 1'b0, SUM[0], carry[0]);
    full_adder FA1(A[1], B[1], carry[0], SUM[1], carry[1]);
    full_adder FA2(A[2], B[2], carry[1], SUM[2], carry[2]);
    full_adder FA3(A[3], B[3], carry[2], SUM[3], carry[3]);
   
    assign cout = carry[3];

endmodule