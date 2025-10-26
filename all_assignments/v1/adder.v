`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.08.2025 15:21:18
// Design Name: 
// Module Name: adder
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


module full_adder(input in1, input in2, input cin,output out , output cout );

// Parameters : 
// input : in1, in2, cin 
// output : out , cout

wire g2_out, g3_out, g4_out;   //temporary variables

xor g1(out, in1, in2, cin);     // Out = A ^ B ^ Cin 
and g2(g2_out,in1, in2);        //  g2_out = A & B
xor g3(g3_out, in1,in2);        // g3_out = A ^ B 
and g4(g4_out,g3_out,cin);      // g4_out = (A^B) & (Cin)
or g5(cout, g2_out, g4_out);    //  Cout = (A & B) + ((A & B) & (Cin))
 
endmodule

