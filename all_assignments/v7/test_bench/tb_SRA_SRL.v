`timescale 1ns / 1ps
module tb_SRA_SRL;
    reg  [31:0] A;
    reg  [31:0] B;
    wire [31:0] out_logical;
    wire [31:0] out_arithmetic;
    
    // DUT instances
    shift_right_logical uut_srl (
        .A(A), .B(B), .out(out_logical)
    );
    
    shift_right_arithmetic uut_sra (
        .A(A), .B(B), .out(out_arithmetic)
    );
    
    integer i;
    initial begin
        $display("Testing Positive Number (0x80000000 >> n):");
        $display("B\tLogical\t\tArithmetic");
        $display("----------------------------------------");
        A = 32'h80000000;  // Most negative number (-2147483648)
        
        for (i = 0; i <= 5; i = i+1) begin
            B = i;   
            #5;      
            $display("%d\t%h\t%h", i, out_logical, out_arithmetic);
        end
        
        $display("\nTesting Positive Number (0x0000FF00 >> n):");
        $display("B\tLogical\t\tArithmetic");
        $display("----------------------------------------");
        A = 32'h0000FF00;  // Positive number
        
        for (i = 0; i <= 8; i = i+1) begin
            B = i;   
            #5;      
            $display("%d\t%h\t%h", i, out_logical, out_arithmetic);
        end
        
        $display("\nTesting edge case (shift by 32):");
        A = 32'h80000000;
        B = 32;
        #5;
        $display("A=80000000, B=32: Logical=%h, Arithmetic=%h", out_logical, out_arithmetic);
        
        A = 32'h0000FF00;
        B = 32;
        #5;
        $display("A=0000FF00, B=32: Logical=%h, Arithmetic=%h", out_logical, out_arithmetic);
        
        $finish;
    end
endmodule