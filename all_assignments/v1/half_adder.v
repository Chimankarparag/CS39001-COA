`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.08.2025 15:50:45
// Design Name: 
// Module Name: half_adder
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



// Group Number : 2
// Names : Parag Mahadeo Chimankar
//         Harshit Singhal
// Date: 05-08-2025


//////////////////////////////////////////////////////////////////////////////////


module half_adder(input in1, input in2,output out , output cout );

// Parameters : 
// input : in1, in2 
// output : out , cout



xor g1(out, in1, in2);     // Out = A ^ B
and g2(cout,in1, in2);        //  cout = A & B

 
endmodule
