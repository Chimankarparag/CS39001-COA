`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.08.2025 15:22:08
// Design Name: 
// Module Name: test_bench_adder
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


module test_bench_adder;

reg in1, in2, cin;  
wire out, cout;     

full_adder uut(in1, in2, cin, out,cout); // calling module

initial 
    begin
        // set the inputs
        in1<=1'd1;  //input 1 = 1
        in2<=1'd1;  //input 2 = 1
        cin<=1'd1;  // carry input = 0
    end
endmodule

