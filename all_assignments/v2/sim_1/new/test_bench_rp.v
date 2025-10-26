`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.08.2025 15:44:08
// Design Name: 
// Module Name: test_bench_rp
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


`timescale 1ns / 1ps

module test_bench_rp();

  
    reg  [4:0] A;
    reg  [3:0] B;
    wire [4:0] SUM;


    ripple_carry_adder dut (
        .A(A),
        .B(B),
        .SUM(SUM)
    );


    initial begin
        //  3 + 4 = 7
        A = 5'd3; B = 4'd4; #10;
        
        //  15 + 1 = 16
        A = 5'd15; B = 4'd1; #10;
        

    end

endmodule
