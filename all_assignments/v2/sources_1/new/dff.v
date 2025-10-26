`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.08.2025 17:04:35
// Design Name: 
// Module Name: dff
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

// D flip flop

module dff(in,out,clk,rst);
    input in,clk,rst;
    output out;
    reg out;
    
    always@(posedge clk or posedge rst)
    begin
        if(rst) out <= 1'b0;
        else    
            out <=in;
    end
    
endmodule
