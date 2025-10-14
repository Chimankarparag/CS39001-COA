`timescale 1ns / 1ps

module tb_top_module();
    // Testbench signals
    reg         clk;
    reg         reset;
    reg  [31:0] pcIn;
    wire [31:0] alu_result;
    wire [31:0] rs_value;
    wire        zero_flag;
    wire        negative_flag;
    wire        overflow_flag;
    
    // Instantiate the top module
    top_module uut (
        .clk(clk),
        .reset(reset),
        .pcIn(pcIn),
        .alu_result(alu_result),
        .rs_value(rs_value),
        .zero_flag(zero_flag),
        .negative_flag(negative_flag),
        .overflow_flag(overflow_flag)
    );
    
    // Clock generation: 10ns period (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Test sequence
    integer test_num;
    initial begin
        // Initialize signals
        reset = 1;
        pcIn = 0;
        test_num = 0;
        
        // Display header
        $display("==================================================");
        $display("  Simple MIPS Processor Testbench");
        $display("  Testing with PC Control");
        $display("==================================================\n");
        
        // Apply reset
        @(posedge clk);
        #2;
        reset = 0;
        
        // Wait one clock cycle after reset
        @(posedge clk);
        #2;
        
        $display("--- Starting Instruction Execution ---\n");
        
        // ===== R-Type Instructions =====
        $display("========== R-TYPE INSTRUCTIONS ==========\n");
        
        // Test 1: ADD R3, R1, R2 (PC = 0)
        test_num = 1;
        pcIn = 32'd0;
        @(posedge clk);
        #2;
        $display("Test %0d: ADD R3, R1, R2 [PC=%0d]", test_num, pcIn);
        $display("  R1 (rs): %h (%0d)", rs_value, rs_value);
        $display("  Result:  %h (%0d)", alu_result, alu_result);
        $display("  Expected: 0x00000003 (1 + 2 = 3)");
        $display("  Flags - Z:%b N:%b O:%b\n", zero_flag, negative_flag, overflow_flag);
        
        // Test 2: SUB R5, R4, R2 (PC = 4)
        test_num = 2;
        pcIn = 32'd4;
        @(posedge clk);
        #2;
        $display("Test %0d: SUB R5, R4, R2 [PC=%0d]", test_num, pcIn);
        $display("  R4 (rs): %h (%0d)", rs_value, rs_value);
        $display("  Result:  %h (%0d)", alu_result, alu_result);
        $display("  Expected: 0x00000002 (4 - 2 = 2)");
        $display("  Flags - Z:%b N:%b O:%b\n", zero_flag, negative_flag, overflow_flag);
        
        // Test 3: AND R6, R3, R5 (PC = 8)
        test_num = 3;
        pcIn = 32'd8;
        @(posedge clk);
        #2;
        $display("Test %0d: AND R6, R3, R5 [PC=%0d]", test_num, pcIn);
        $display("  R3 (rs): %h (%0d)", rs_value, rs_value);
        $display("  Result:  %h (%0d)", alu_result, alu_result);
        $display("  Expected: 0x00000002 (3 AND 2 = 2)");
        $display("  Flags - Z:%b N:%b O:%b\n", zero_flag, negative_flag, overflow_flag);
        
        // Test 4: OR R7, R3, R4 (PC = 12)
        test_num = 4;
        pcIn = 32'd12;
        @(posedge clk);
        #2;
        $display("Test %0d: OR R7, R3, R4 [PC=%0d]", test_num, pcIn);
        $display("  R3 (rs): %h (%0d)", rs_value, rs_value);
        $display("  Result:  %h (%0d)", alu_result, alu_result);
        $display("  Expected: 0x00000007 (3 OR 4 = 7)");
        $display("  Flags - Z:%b N:%b O:%b\n", zero_flag, negative_flag, overflow_flag);
        
        // Test 5: XOR R8, R7, R6 (PC = 16)
        test_num = 5;
        pcIn = 32'd16;
        @(posedge clk);
        #2;
        $display("Test %0d: XOR R8, R7, R6 [PC=%0d]", test_num, pcIn);
        $display("  R7 (rs): %h (%0d)", rs_value, rs_value);
        $display("  Result:  %h (%0d)", alu_result, alu_result);
        $display("  Expected: 0x00000005 (7 XOR 2 = 5)");
        $display("  Flags - Z:%b N:%b O:%b\n", zero_flag, negative_flag, overflow_flag);
        
        // Test 6: NOR R9, R1, R2 (PC = 20) - RANDOM JUMP!
        test_num = 6;
        pcIn = 32'd20;
        @(posedge clk);
        #2;
        $display("Test %0d: NOR R9, R1, R2 [PC=%0d] ** RANDOM JUMP **", test_num, pcIn);
        $display("  R1 (rs): %h (%0d)", rs_value, rs_value);
        $display("  Result:  %h", alu_result);
        $display("  Expected: 0xFFFFFFFC (NOT(1 OR 2))");
        $display("  Flags - Z:%b N:%b O:%b\n", zero_flag, negative_flag, overflow_flag);
        
        // Test 7: NOT R10, R8 (PC = 24)
        test_num = 7;
        pcIn = 32'd24;
        @(posedge clk);
        #2;
        $display("Test %0d: NOT R10, R8 [PC=%0d]", test_num, pcIn);
        $display("  R8 (rs): %h (%0d)", rs_value, rs_value);
        $display("  Result:  %h", alu_result);
        $display("  Expected: 0xFFFFFFFA (NOT 5)");
        $display("  Flags - Z:%b N:%b O:%b\n", zero_flag, negative_flag, overflow_flag);
        
        // Random jump to PC = 32 (skip instruction at 28)
        test_num = 8;
        pcIn = 32'd32;
        @(posedge clk);
        #2;
        $display("Test %0d: INC R12, R8 [PC=%0d] ** SKIPPED PC=28 **", test_num, pcIn);
        $display("  R8 (rs): %h (%0d)", rs_value, rs_value);
        $display("  Result:  %h (%0d)", alu_result, alu_result);
        $display("  Expected: 0x00000006 (5 + 1 = 6)");
        $display("  Flags - Z:%b N:%b O:%b\n", zero_flag, negative_flag, overflow_flag);
        
        // Go back to PC = 28 (SL instruction)
        test_num = 9;
        pcIn = 32'd28;
        @(posedge clk);
        #2;
        $display("Test %0d: SL R11, R3, R1 [PC=%0d] ** JUMPED BACK **", test_num, pcIn);
        $display("  R3 (rs): %h (%0d)", rs_value, rs_value);
        $display("  Result:  %h (%0d)", alu_result, alu_result);
        $display("  Expected: 0x00000006 (3 << 1 = 6)");
        $display("  Flags - Z:%b N:%b O:%b\n", zero_flag, negative_flag, overflow_flag);
        
        // Test 10: DEC R13, R7 (PC = 36)
        test_num = 10;
        pcIn = 32'd36;
        @(posedge clk);
        #2;
        $display("Test %0d: DEC R13, R7 [PC=%0d]", test_num, pcIn);
        $display("  R7 (rs): %h (%0d)", rs_value, rs_value);
        $display("  Result:  %h (%0d)", alu_result, alu_result);
        $display("  Expected: 0x00000006 (7 - 1 = 6)");
        $display("  Flags - Z:%b N:%b O:%b\n", zero_flag, negative_flag, overflow_flag);
        
        // ===== I-Type Instructions =====
        $display("\n========== I-TYPE INSTRUCTIONS ==========\n");
        
        // Test 11: ADDI R14, R1, 10 (PC = 40)
        test_num = 11;
        pcIn = 32'd40;
        @(posedge clk);
        #2;
        $display("Test %0d: ADDI R14, R1, 10 [PC=%0d]", test_num, pcIn);
        $display("  R1 (rs): %h (%0d)", rs_value, rs_value);
        $display("  Result:  %h (%0d)", alu_result, alu_result);
        $display("  Expected: 0x0000000B (1 + 10 = 11)");
        $display("  Flags - Z:%b N:%b O:%b\n", zero_flag, negative_flag, overflow_flag);
        
        // Random jump to PC = 60 (LUI)
        test_num = 12;
        pcIn = 32'd60;
        @(posedge clk);
        #2;
        $display("Test %0d: LUI R4, 0x1234 [PC=%0d] ** RANDOM JUMP **", test_num, pcIn);
        $display("  Result:  %h", alu_result);
        $display("  Expected: 0x12340000");
        $display("  Flags - Z:%b N:%b O:%b\n", zero_flag, negative_flag, overflow_flag);
        
        // Test 13: SUBI R15, R7, 3 (PC = 44)
        test_num = 13;
        pcIn = 32'd44;
        @(posedge clk);
        #2;
        $display("Test %0d: SUBI R15, R7, 3 [PC=%0d]", test_num, pcIn);
        $display("  R7 (rs): %h (%0d)", rs_value, rs_value);
        $display("  Result:  %h (%0d)", alu_result, alu_result);
        $display("  Expected: 0x00000004 (7 - 3 = 4)");
        $display("  Flags - Z:%b N:%b O:%b\n", zero_flag, negative_flag, overflow_flag);
        
        // Test 14: ANDI R1, R14, 0x0007 (PC = 48)
        test_num = 14;
        pcIn = 32'd48;
        @(posedge clk);
        #2;
        $display("Test %0d: ANDI R1, R14, 0x0007 [PC=%0d]", test_num, pcIn);
        $display("  R14 (rs): %h (%0d)", rs_value, rs_value);
        $display("  Result:   %h (%0d)", alu_result, alu_result);
        $display("  Expected: 0x00000003 (11 AND 7 = 3)");
        $display("  Flags - Z:%b N:%b O:%b\n", zero_flag, negative_flag, overflow_flag);
        
        // Test 15: ORI R2, R1, 0x0004 (PC = 52)
        test_num = 15;
        pcIn = 32'd52;
        @(posedge clk);
        #2;
        $display("Test %0d: ORI R2, R1, 0x0004 [PC=%0d]", test_num, pcIn);
        $display("  R1 (rs): %h (%0d)", rs_value, rs_value);
        $display("  Result:  %h (%0d)", alu_result, alu_result);
        $display("  Expected: 0x00000007 (3 OR 4 = 7)");
        $display("  Flags - Z:%b N:%b O:%b\n", zero_flag, negative_flag, overflow_flag);
        
        // Test 16: XORI R3, R7, 0x0005 (PC = 56)
        test_num = 16;
        pcIn = 32'd56;
        @(posedge clk);
        #2;
        $display("Test %0d: XORI R3, R7, 0x0005 [PC=%0d]", test_num, pcIn);
        $display("  R7 (rs): %h (%0d)", rs_value, rs_value);
        $display("  Result:  %h (%0d)", alu_result, alu_result);
        $display("  Expected: 0x00000002 (7 XOR 5 = 2)");
        $display("  Flags - Z:%b N:%b O:%b\n", zero_flag, negative_flag, overflow_flag);
        
        // Random jump back to PC = 64 (INCI)
        test_num = 17;
        pcIn = 32'd64;
        @(posedge clk);
        #2;
        $display("Test %0d: INCI R5, R3 [PC=%0d] ** RANDOM JUMP **", test_num, pcIn);
        $display("  R3 (rs): %h (%0d)", rs_value, rs_value);
        $display("  Result:  %h (%0d)", alu_result, alu_result);
        $display("  Expected: 0x00000003 (2 + 1 = 3)");
        $display("  Flags - Z:%b N:%b O:%b\n", zero_flag, negative_flag, overflow_flag);
        
        // Test 18: DECI R6, R7 (PC = 68)
        test_num = 18;
        pcIn = 32'd68;
        @(posedge clk);
        #2;
        $display("Test %0d: DECI R6, R7 [PC=%0d]", test_num, pcIn);
        $display("  R7 (rs): %h (%0d)", rs_value, rs_value);
        $display("  Result:  %h (%0d)", alu_result, alu_result);
        $display("  Expected: 0x00000006 (7 - 1 = 6)");
        $display("  Flags - Z:%b N:%b O:%b\n", zero_flag, negative_flag, overflow_flag);
        
        // Test 19: ADDI R7, R8, -5 (PC = 72)
        test_num = 19;
        pcIn = 32'd72;
        @(posedge clk);
        #2;
        $display("Test %0d: ADDI R7, R8, -5 [PC=%0d]", test_num, pcIn);
        $display("  R8 (rs): %h (%0d)", rs_value, rs_value);
        $display("  Result:  %h (%0d)", alu_result, $signed(alu_result));
        $display("  Expected: 0x00000000 (5 + (-5) = 0)");
        $display("  Flags - Z:%b N:%b O:%b\n", zero_flag, negative_flag, overflow_flag);
        
        // Test 20: ADDI R0, R1, 100 (PC = 76) - R0 should stay 0
        test_num = 20;
        pcIn = 32'd76;
        @(posedge clk);
        #2;
        $display("Test %0d: ADDI R0, R1, 100 (R0 stays 0) [PC=%0d]", test_num, pcIn);
        $display("  R1 (rs): %h (%0d)", rs_value, rs_value);
        $display("  Result:  %h (%0d)", alu_result, alu_result);
        $display("  Expected: ALU computes but R0 should remain 0");
        $display("  Flags - Z:%b N:%b O:%b\n", zero_flag, negative_flag, overflow_flag);
        
        // Demonstrate random PC jumps
        $display("\n========== RANDOM PC JUMP TEST ==========\n");
        
        // Jump to PC = 4 (SUB again)
        test_num = 21;
        pcIn = 32'd4;
        @(posedge clk);
        #2;
        $display("Test %0d: SUB R5, R4, R2 [PC=%0d] ** RE-EXECUTE **", test_num, pcIn);
        $display("  R4 (rs): %h (%0d)", rs_value, rs_value);
        $display("  Result:  %h (%0d)", alu_result, alu_result);
        $display("  Flags - Z:%b N:%b O:%b\n", zero_flag, negative_flag, overflow_flag);
        
        // Jump to PC = 20 (NOR)
        test_num = 22;
        pcIn = 32'd20;
        @(posedge clk);
        #2;
        $display("Test %0d: NOR R9, R1, R2 [PC=%0d] ** RE-EXECUTE **", test_num, pcIn);
        $display("  R1 (rs): %h (%0d)", rs_value, rs_value);
        $display("  Result:  %h", alu_result);
        $display("  Flags - Z:%b N:%b O:%b\n", zero_flag, negative_flag, overflow_flag);
        
        // Jump to PC = 8 (AND)
        test_num = 23;
        pcIn = 32'd8;
        @(posedge clk);
        #2;
        $display("Test %0d: AND R6, R3, R5 [PC=%0d] ** RE-EXECUTE **", test_num, pcIn);
        $display("  R3 (rs): %h (%0d)", rs_value, rs_value);
        $display("  Result:  %h (%0d)", alu_result, alu_result);
        $display("  Flags - Z:%b N:%b O:%b\n", zero_flag, negative_flag, overflow_flag);
        
        // Summary
        $display("\n==================================================");
        $display("  Test Execution Complete!");
        $display("  Total Instructions Executed: %0d", test_num);
        $display("  Demonstrated random PC jumps and re-execution");
        $display("==================================================\n");
        
        // Wait a few more clock cycles
        repeat(5) @(posedge clk);
        $finish;
    end
    
    // Optional: Waveform dump for viewing in simulator
    initial begin
        $dumpfile("tb_top_module.vcd");
        $dumpvars(0, tb_top_module);
    end
    
endmodule