`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.08.2025 15:53:57
// Design Name: 
// Module Name: test_bench_half_adder
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


// Group Number : 2
// Names : Parag Mahadeo Chimankar
//         Harshit Singhal
// Date: 05-08-2025




module test_bench_half_adder;

reg in1, in2;  //here we declare the inputs
wire out, cout;     // temporary variables

half_adder uut(in1, in2, out,cout); // calling module

initial 
    begin
        // set the inputs
        in1<=1'd1;  //input 1 = 1
        in2<=1'd1;  //input 2 = 1
    end
endmodule

