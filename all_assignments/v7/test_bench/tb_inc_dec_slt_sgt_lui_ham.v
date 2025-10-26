
`timescale 1ns / 1ps
module tb_inc_dec_slt_sgt_lui_ham;
    reg [31:0] A, B;
    reg [15:0] immediate;
    
    // Output wires for all modules
    wire [31:0] inc_result;
    wire inc_cout;
    wire [31:0] dec_result;
    wire dec_bout;
    wire [31:0] slt_result;
    wire [31:0] sgt_result;
    wire [31:0] lui_result;
    wire [31:0] ham_result;
    
    // Module instances
    inc inc_inst(.A(A), .OUT(inc_result), .Cout(inc_cout));
    dec dec_inst(.A(A), .OUT(dec_result), .Bout(dec_bout));
    slt slt_inst(.A(A), .B(B), .C(slt_result));
    sgt sgt_inst(.A(A), .B(B), .C(sgt_result));
    lui lui_inst(.immediate(immediate), .result(lui_result));
    ham ham_inst(.src(A), .result(ham_result));
    
    initial begin
        $display("=== ALL OPERATIONS TESTBENCH ===");
        $display("Time\tA\t\tB\t\tImm\tINC\t\tCout\tDEC\t\tBout\tSLT\tSGT\tLUI\t\tHAM");
        $display("============================================================================================================");
        
        // Test Case 1: Basic positive numbers
        A = 32'h00000005; B = 32'h0000000A; immediate = 16'hABCD;
        #5;
        $display("%0t\t%h\t%h\t%h\t%h\t%d\t%h\t%d\t%d\t%d\t%h\t%d", 
                 $time, A, B, immediate, inc_result, inc_cout, dec_result, dec_bout, slt_result[0], sgt_result[0], lui_result, ham_result);
        
        // Test Case 2: A > B
        A = 32'h0000000F; B = 32'h00000008; immediate = 16'h1234;
        #5;
        $display("%0t\t%h\t%h\t%h\t%h\t%d\t%h\t%d\t%d\t%d\t%h\t%d", 
                 $time, A, B, immediate, inc_result, inc_cout, dec_result, dec_bout, slt_result[0], sgt_result[0], lui_result, ham_result);
        
        // Test Case 3: Negative number (A)
        A = 32'hFFFFFFEC; B = 32'h00000005; immediate = 16'hFFFF; // A = -20, B = 5
        #5;
        $display("%0t\t%h\t%h\t%h\t%h\t%d\t%h\t%d\t%d\t%d\t%h\t%d", 
                 $time, A, B, immediate, inc_result, inc_cout, dec_result, dec_bout, slt_result[0], sgt_result[0], lui_result, ham_result);
        
        // Test Case 4: Zero (important for underflow)
        A = 32'h00000000; B = 32'h00000001; immediate = 16'h0001;
        #5;
        $display("%0t\t%h\t%h\t%h\t%h\t%d\t%h\t%d\t%d\t%d\t%h\t%d", 
                 $time, A, B, immediate, inc_result, inc_cout, dec_result, dec_bout, slt_result[0], sgt_result[0], lui_result, ham_result);
        
        // Test Case 5: Maximum positive (overflow test)
        A = 32'h7FFFFFFF; B = 32'h80000000; immediate = 16'hFACE;
        #5;
        $display("%0t\t%h\t%h\t%h\t%h\t%d\t%h\t%d\t%d\t%d\t%h\t%d", 
                 $time, A, B, immediate, inc_result, inc_cout, dec_result, dec_bout, slt_result[0], sgt_result[0], lui_result, ham_result);
        
        // Test Case 6: All 1s (overflow test)
        A = 32'hFFFFFFFF; B = 32'h7FFFFFFF; immediate = 16'hDEAD;
        #5;
        $display("%0t\t%h\t%h\t%h\t%h\t%d\t%h\t%d\t%d\t%d\t%h\t%d", 
                 $time, A, B, immediate, inc_result, inc_cout, dec_result, dec_bout, slt_result[0], sgt_result[0], lui_result, ham_result);
        
        // Test Case 7: Alternating pattern (HAM test)
        A = 32'hAAAAAAAA; B = 32'h55555555; immediate = 16'hBEEF;
        #5;
        $display("%0t\t%h\t%h\t%h\t%h\t%d\t%h\t%d\t%d\t%d\t%h\t%d", 
                 $time, A, B, immediate, inc_result, inc_cout, dec_result, dec_bout, slt_result[0], sgt_result[0], lui_result, ham_result);
        
        // Test Case 8: Power of 2
        A = 32'h00000080; B = 32'h00000040; immediate = 16'hCAFE;
        #5;
        $display("%0t\t%h\t%h\t%h\t%h\t%d\t%h\t%d\t%d\t%d\t%h\t%d", 
                 $time, A, B, immediate, inc_result, inc_cout, dec_result, dec_bout, slt_result[0], sgt_result[0], lui_result, ham_result);
        
        // Test Case 9: Equal values
        A = 32'h00000064; B = 32'h00000064; immediate = 16'h8000; // A = B = 100
        #5;
        $display("%0t\t%h\t%h\t%h\t%h\t%d\t%h\t%d\t%d\t%d\t%h\t%d", 
                 $time, A, B, immediate, inc_result, inc_cout, dec_result, dec_bout, slt_result[0], sgt_result[0], lui_result, ham_result);
        
        // Test Case 10: Minimum negative (underflow test)
        A = 32'h80000000; B = 32'h7FFFFFFF; immediate = 16'h0000;
        #5;
        $display("%0t\t%h\t%h\t%h\t%h\t%d\t%h\t%d\t%d\t%d\t%h\t%d", 
                 $time, A, B, immediate, inc_result, inc_cout, dec_result, dec_bout, slt_result[0], sgt_result[0], lui_result, ham_result);
        
        $display("\n=== Detailed Analysis ===");
        
        // Focus on overflow/underflow cases
        $display("\n--- Overflow/Underflow Analysis ---");
        
        A = 32'hFFFFFFFF; #1;
        $display("INC Overflow: %h + 1 = %h, Cout = %d %s", 
                 A, inc_result, inc_cout, inc_cout ? "(OVERFLOW DETECTED)" : "");
        
        A = 32'h7FFFFFFF; #1;
        $display("INC Overflow: %h + 1 = %h, Cout = %d %s", 
                 A, inc_result, inc_cout, inc_cout ? "(OVERFLOW DETECTED)" : "");
        
        A = 32'h00000000; #1;
        $display("DEC Underflow: %h - 1 = %h, Bout = %d %s", 
                 A, dec_result, dec_bout, dec_bout ? "(UNDERFLOW DETECTED)" : "");
        
        A = 32'h80000000; #1;
        $display("DEC Underflow: %h - 1 = %h, Bout = %d %s", 
                 A, dec_result, dec_bout, dec_bout ? "(UNDERFLOW DETECTED)" : "");
        
        $display("\n--- Comparison Examples ---");
        A = 32'h7FFFFFFF; B = 32'h80000000; #1;
        $display("Max Positive vs Min Negative:");
        $display("  SLT: %h < %h = %d", A, B, slt_result[0]);
        $display("  SGT: %h > %h = %d", A, B, sgt_result[0]);
        
        A = 32'hFFFFFFFF; B = 32'h00000001; #1;
        $display("Signed -1 vs +1:");
        $display("  SLT: %h < %h = %d", A, B, slt_result[0]);
        $display("  SGT: %h > %h = %d", A, B, sgt_result[0]);
        
        $display("\n--- LUI Examples ---");
        immediate = 16'h0000; #1;
        $display("LUI %h -> %h", immediate, lui_result);
        immediate = 16'hFFFF; #1;
        $display("LUI %h -> %h", immediate, lui_result);
        immediate = 16'h8000; #1;
        $display("LUI %h -> %h", immediate, lui_result);
        
        $display("\n--- HAM (Hamming Weight) Examples ---");
        A = 32'h00000001; #1;
        $display("HAM: %h has %d bits set", A, ham_result);
        A = 32'h00000003; #1;
        $display("HAM: %h has %d bits set", A, ham_result);
        A = 32'h0000000F; #1;
        $display("HAM: %h has %d bits set", A, ham_result);
        A = 32'h000000FF; #1;
        $display("HAM: %h has %d bits set", A, ham_result);
        A = 32'hFFFFFFFF; #1;
        $display("HAM: %h has %d bits set", A, ham_result);
        
        $finish;
    end
endmodule
