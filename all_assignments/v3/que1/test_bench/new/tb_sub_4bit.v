`timescale 1ns / 1ps

module tb_sub_4bit;
    reg [3:0] A, B;
    reg Cin;
    wire [3:0] SUM;
    wire Cout;
    wire [3:0] subB;
    assign subB = B ^ 4'b1111;

    rca_4 UUT (
        .A(A), .B(subB), .Cin(Cin),
        .SUM(SUM), .Cout(Cout)
    );

    initial begin
        A = 4'd3; B = 4'd2; Cin = 1;
        #10 A = 4'd7; B = 4'd4; Cin = 1;
        #10 A = 4'd15; B = 4'd1; Cin = 1;
        #10 A = 4'd10; B = 4'd5; Cin = 1;
    end
endmodule
