`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.08.2025 17:04:16
// Design Name: 
// Module Name: full_adder
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


//making modular full adder using half adder

module full_adder(input in1, input in2, input cin, output out , output cout );
    
    wire cout1,cout2;
    wire sum;
    
    half_adder HA1(in1, in2, sum, cout1);
    half_adder HA2(sum, cin, out, cout2);
    or g1( cout, cout1, cout2);
 
endmodule