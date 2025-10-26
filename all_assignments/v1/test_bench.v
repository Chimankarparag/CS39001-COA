`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.08.2025 15:23:38
// Design Name: Full Adder_Group 2
// Module Name: test_bench
// Project Name: Assignment
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

// Group Number : 2
// Names : Parag Mahadeo Chimankar
//         Harshit Singhal
// Date: 05-08-2025



//////////////////////////////////////////////////////////////////////////////////


module test_bench;

reg in1, in2, cin;  //here we declare the inputs
wire out, cout;     // temporary variables

full_adder uut(in1, in2, cin, out,cout); // calling module

initial 
    begin
        // set the inputs
        in1<=1'd1;  //input 1 = 1
        in2<=1'd1;  //input 2 = 1
        cin<=1'd0;  // carry input = 0
    end
endmodule
