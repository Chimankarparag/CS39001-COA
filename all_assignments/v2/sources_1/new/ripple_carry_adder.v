`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.08.2025 17:03:50
// Design Name: 
// Module Name: ripple_carry_adder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


// Ripple Carry Adder (5-bit) using 1-bit Full Adders

module ripple_carry_adder(
    input [4:0] A,       // Accumulator current value
    input [3:0] B,       // New input
    output [4:0] SUM     // Output sum
);
    wire [4:0] carry;
    wire [4:0] B_ext;

    // Extend B to 5 bits (pad MSB with 0)
    assign B_ext = {1'b0, B};

    // First full adder
    full_adder FA0(A[0], B_ext[0], 1'b0, SUM[0], carry[0]);
    full_adder FA1(A[1], B_ext[1], carry[0], SUM[1], carry[1]);
    full_adder FA2(A[2], B_ext[2], carry[1], SUM[2], carry[2]);
    full_adder FA3(A[3], B_ext[3], carry[2], SUM[3], carry[3]);
    full_adder FA4(A[4], B_ext[4], carry[3], SUM[4], carry[4]); // carry[4] not used
    
endmodule