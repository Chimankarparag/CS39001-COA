`timescale 1ns / 1ps
module tb_SLA;
    reg  [31:0] A;
    reg  [31:0] B;
    wire [31:0] out;
    
    // DUT - using corrected module
    shift_left uut (
        .A(A),
        .B(B),
        .out(out)
    );
    
    integer i;
    initial begin
        A = 32'h0000_0002;  
        $display("Time\tB\t\tA\t\t\tOut\t\tExpected");
        $display("-----------------------------------------------------------------------");
        for (i = 0; i <= 33; i = i+1) begin
            B = i;   
            #5;      
            $display("%0t\t%d\t%h\t%h\t%h", $time, i, A, out, A << i);
        end
        $finish;
    end
endmodule