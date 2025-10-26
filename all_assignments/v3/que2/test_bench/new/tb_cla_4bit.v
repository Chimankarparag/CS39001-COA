`timescale 1ns / 1ps

module tb_cla_4bit;
    reg  [3:0] A, B;
    reg  C0;
    wire [3:0] S;
    wire C4;
    wire P_block, G_block;

    // Instantiate 4-bit CLA
    cla_4bit uut (
        .A(A), 
        .B(B), 
        .C0(C0), 
        .S(S), 
        .C4(C4),
        .P_block(P_block),
        .G_block(G_block)
    );

    initial begin
        

        // Test patterns
        C0 = 0; A = 4'd3;  B = 4'd5;  #10;  // 3 + 5 = 8
        C0 = 0; A = 4'd7;  B = 4'd9;  #10;  // 7 + 9 = 16
        C0 = 1; A = 4'd4;  B = 4'd6;  #10;  // 4 + 6 + carry = 11
        C0 = 0; A = 4'd15; B = 4'd1;  #10;  // 15 + 1 = 16
        C0 = 1; A = 4'd8;  B = 4'd8;  #10;  // 8 + 8 + carry = 17

    end
endmodule
