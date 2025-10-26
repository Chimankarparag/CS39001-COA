`timescale 1ns / 1ps

module tb_sub_8bit;
    reg [7:0] A, B;
    reg Cin;
    wire [7:0] SUM;
    wire Cout;
    wire [7:0] subB;
    assign subB = B ^ 8'b11111111;

    rca_8 UUT (
        .A(A), .B(subB), .Cin(Cin),
        .SUM(SUM), .Cout(Cout)
    );

    initial begin
        A = 8'd100; B = 8'd28; Cin = 1;
        #10 A = 8'd255; B = 8'd1; Cin = 1;
        #10 A = 8'd50; B = 8'd100; Cin = 1;
        #10 A = 8'd200; B = 8'd55; Cin = 1;
    end
endmodule
