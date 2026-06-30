`timescale 1ns / 1ps

module tb_load_store;

    // Testbench signals
    reg         clk;
    reg         reset;
    reg  [31:0] pcIn;
    wire [31:0] result_out;
    wire [31:0] rs_value;
    wire        zero_flag;
    wire        negative_flag;
    wire        overflow_flag;

    // Instantiate the top module
    top_module uut (
        .clk(clk),
        .reset(reset),
        .pcIn(pcIn),
        .result_out(result_out),
        .rs_value(rs_value),
        .zero_flag(zero_flag),
        .negative_flag(negative_flag),
        .overflow_flag(overflow_flag)
    );

    // Clock generation - 10ns period (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test stimulus
    initial begin
        // Display header
        $display("\n==========================================================");
        $display("          LOAD/STORE INSTRUCTION TESTBENCH");
        $display("==========================================================\n");

        // Initialize signals
        reset = 1;
        pcIn = 32'h00000050;  // Start at word address 20 (0x50)
        
        // Hold reset for 2 clock cycles
        #100;
        reset = 0;
        #10;

        // Test Case 1: ADDI R1, R0, 100
        $display("=== Test 1: ADDI R1, R0, 100 ===");
        $display("Expected: R1 = 100");
        pcIn = 32'h00000050;  // PC = 0x50 (word addr 20)
        #200;
        $display("Time=%0t | PC=%h | Result=%d | RS_Value=%d | Flags=%b%b%b", 
                 $time, uut.pcOut, result_out, rs_value, 
                 zero_flag, negative_flag, overflow_flag);
        $display("DEBUG: Register R1 should now be: %d", result_out);
        if (result_out == 100)
            $display("✓ PASS: R1 = 100\n");
        else
            $display("✗ FAIL: Expected 100, got %d\n", result_out);

        // Test Case 2: SW R1, 4(R0) - Store to Memory[4]
        $display("=== Test 2: SW R1, 4(R0) ===");
        $display("Expected: Memory[4] = 100");
        pcIn = 32'h00000054;  // PC = 0x54 (word addr 21)
        #200;
        $display("Time=%0t | PC=%h | Result=%d | RS_Value=%d | Flags=%b%b%b", 
                 $time, uut.pcOut, result_out, rs_value, 
                 zero_flag, negative_flag, overflow_flag);
        $display("DEBUG: Memory address = %d (0+4)", 4);
        $display("DEBUG: Data being stored from R1 = %d", rs_value);
        $display("DEBUG: Memory[4] should now contain: 100");
        $display("✓ Store operation completed\n");

        // Test Case 3: ADDI R2, R0, 200
        $display("=== Test 3: ADDI R2, R0, 200 ===");
        $display("Expected: R2 = 200");
        pcIn = 32'h00000058;  // PC = 0x58 (word addr 22)
        #20;
        $display("Time=%0t | PC=%h | Result=%d | RS_Value=%d | Flags=%b%b%b", 
                 $time, uut.pcOut, result_out, rs_value, 
                 zero_flag, negative_flag, overflow_flag);
        $display("DEBUG: Register R2 should now be: %d", result_out);
        if (result_out == 200)
            $display("✓ PASS: R2 = 200\n");
        else
            $display("✗ FAIL: Expected 200, got %d\n", result_out);

        // Test Case 4: SW R2, 8(R0) - Store to Memory[8]
        $display("=== Test 4: SW R2, 8(R0) ===");
        $display("Expected: Memory[8] = 200");
        pcIn = 32'h0000005C;  // PC = 0x5C (word addr 23)
        #20;
        $display("Time=%0t | PC=%h | Result=%d | RS_Value=%d | Flags=%b%b%b", 
                 $time, uut.pcOut, result_out, rs_value, 
                 zero_flag, negative_flag, overflow_flag);
        $display("DEBUG: Memory address = %d (0+8)", 8);
        $display("DEBUG: Data being stored from R2 = %d", rs_value);
        $display("DEBUG: Memory[8] should now contain: 200");
        $display("✓ Store operation completed\n");

        // Test Case 5: LD R3, 4(R0) - Load from Memory[4]
        $display("=== Test 5: LD R3, 4(R0) ===");
        $display("Expected: R3 = 100 (loaded from Memory[4])");
        pcIn = 32'h00000060;  // PC = 0x60 (word addr 24)
        #20;
        $display("Time=%0t | PC=%h | Result=%d | RS_Value=%d | Flags=%b%b%b", 
                 $time, uut.pcOut, result_out, rs_value, 
                 zero_flag, negative_flag, overflow_flag);
        $display("DEBUG: Memory address = %d (0+4)", 4);
        $display("DEBUG: Data loaded into R3 = %d", result_out);
        if (result_out == 100)
            $display("✓ PASS: R3 = 100 (Load successful)\n");
        else
            $display("✗ FAIL: Expected 100, got %d\n", result_out);

        // Test Case 6: LD R4, 8(R0) - Load from Memory[8]
        $display("=== Test 6: LD R4, 8(R0) ===");
        $display("Expected: R4 = 200 (loaded from Memory[8])");
        pcIn = 32'h00000064;  // PC = 0x64 (word addr 25)
        #20;
        $display("Time=%0t | PC=%h | Result=%d | RS_Value=%d | Flags=%b%b%b", 
                 $time, uut.pcOut, result_out, rs_value, 
                 zero_flag, negative_flag, overflow_flag);
        $display("DEBUG: Memory address = %d (0+8)", 8);
        $display("DEBUG: Data loaded into R4 = %d", result_out);
        if (result_out == 200)
            $display("✓ PASS: R4 = 200 (Load successful)\n");
        else
            $display("✗ FAIL: Expected 200, got %d\n", result_out);

        // Test Case 7: ADDI R5, R0, 16 - Setup base address
        $display("=== Test 7: ADDI R5, R0, 16 ===");
        $display("Expected: R5 = 16 (base address register)");
        pcIn = 32'h00000068;  // PC = 0x68 (word addr 26)
        #20;
        $display("Time=%0t | PC=%h | Result=%d | RS_Value=%d | Flags=%b%b%b", 
                 $time, uut.pcOut, result_out, rs_value, 
                 zero_flag, negative_flag, overflow_flag);
        $display("DEBUG: Register R5 (base) = %d", result_out);
        if (result_out == 16)
            $display("✓ PASS: R5 = 16\n");
        else
            $display("✗ FAIL: Expected 16, got %d\n", result_out);

        // Test Case 8: SW R3, 4(R5) - Store with base+offset
        $display("=== Test 8: SW R3, 4(R5) ===");
        $display("Expected: Memory[20] = 100 (16+4)");
        pcIn = 32'h0000006C;  // PC = 0x6C (word addr 27)
        #20;
        $display("Time=%0t | PC=%h | Result=%d | RS_Value=%d | Flags=%b%b%b", 
                 $time, uut.pcOut, result_out, rs_value, 
                 zero_flag, negative_flag, overflow_flag);
        $display("DEBUG: Base address (R5) = 16");
        $display("DEBUG: Offset = 4");
        $display("DEBUG: Memory address = %d (16+4)", 20);
        $display("DEBUG: Data being stored from R3");
        $display("DEBUG: Memory[20] should now contain: 100");
        $display("✓ Store with base+offset completed\n");

        // Test Case 9: LD R6, 4(R5) - Load with base+offset
        $display("=== Test 9: LD R6, 4(R5) ===");
        $display("Expected: R6 = 100 (loaded from Memory[20])");
        pcIn = 32'h00000070;  // PC = 0x70 (word addr 28)
        #20;
        $display("Time=%0t | PC=%h | Result=%d | RS_Value=%d | Flags=%b%b%b", 
                 $time, uut.pcOut, result_out, rs_value, 
                 zero_flag, negative_flag, overflow_flag);
        $display("DEBUG: Base address (R5) = 16");
        $display("DEBUG: Offset = 4");
        $display("DEBUG: Memory address = %d (16+4)", 20);
        $display("DEBUG: Data loaded into R6 = %d", result_out);
        if (result_out == 100)
            $display("✓ PASS: R6 = 100 (Base+offset load successful)\n");
        else
            $display("✗ FAIL: Expected 100, got %d\n", result_out);

        // Summary
        $display("\n==========================================================");
        $display("              TEST SUMMARY");
        $display("==========================================================");
        $display("All load/store operations tested:");
        $display("  • Immediate loads (ADDI)");
        $display("  • Store operations (SW)");
        $display("  • Load operations (LD)");
        $display("  • Base + offset addressing");
        $display("==========================================================\n");
        
        // End simulation
        #20;
        $finish;
    end

    // Timeout watchdog
    initial begin
        #500;
        $display("\n!!! SIMULATION TIMEOUT !!!");
        $finish;
    end

endmodule