`timescale 1ns / 1ps

// Group NO. = 2
// Name 1: Harshit Singhal 23CS10025
// Name 2: Parag Mahadeo Chimankar 23CS10049
// VerilogAssignment5

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
