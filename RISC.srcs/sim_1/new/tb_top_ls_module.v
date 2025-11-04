`timescale 1ns / 1ps

module tb_top_ls_module;

    // Testbench signals
    reg         clk;
    reg         reset;
    reg         execute;
    reg  [15:0] switches;
    wire [15:0] leds;
    wire        zero_flag;
    wire        negative_flag;
    wire        overflow_flag;

    // Instantiate the top module
    top_module uut (
        .clk(clk),
        .reset(reset),
        .execute(execute),
        .switches(switches),
        .leds(leds),
        .zero_flag(zero_flag),
        .negative_flag(negative_flag),
        .overflow_flag(overflow_flag)
    );

    // Clock generation - 10ns period (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Helper task to press execute button
    task press_execute;
        begin
            @(posedge clk);
            execute = 1'b1;
            @(posedge clk);
            @(posedge clk);
            execute = 1'b0;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);  // Extra cycles for memory read latency
        end
    endtask
    
    // Helper task to display 32-bit result
    task display_result;
        input [31:0] expected;
        input [255:0] reg_name;
        reg [31:0] actual_value;
        begin
            // Display lower 16 bits
            switches[15] = 1'b0;
            #20;
            actual_value[15:0] = leds;
            $display("  %s[15:0]  = 0x%04h", reg_name, leds);
            
            // Display upper 16 bits
            switches[15] = 1'b1;
            #20;
            actual_value[31:16] = leds;
            $display("  %s[31:16] = 0x%04h", reg_name, leds);
            $display("  Full 32-bit value: 0x%08h (Expected: 0x%08h)", actual_value, expected);
            
            if (actual_value == expected)
                $display("  ? PASS\n");
            else
                $display("  ? FAIL\n");
        end
    endtask

    // Test stimulus
    initial begin
        // Display header
        $display("\n==================================================================");
        $display("          FPGA LOAD/STORE DEMONSTRATION TESTBENCH");
        $display("==================================================================\n");

        // Initialize signals
        #200;
        reset = 1;
        execute = 0;
        switches = 16'h0000;
        
        // Hold reset for multiple clock cycles
        repeat(5) @(posedge clk);
        reset = 0;
        repeat(3) @(posedge clk);

        $display("Initial State After Reset:");
        $display("  Register R0 = 0x00000000 (always zero)");
        $display("  Register R1 = 0x00000001");
        $display("  Register R2 = 0x00000002");
        $display("  Register R3 = 0x00000003");
        $display("  Register R4 = 0x00000004");
        $display("  Register R5 = 0x00000005");
        $display("  ...");
        $display("  Register R15 = 0x0000000F\n");

        // ========================================
        // PART 1: DEMONSTRATING LD INSTRUCTION
        // ========================================
        $display("==================================================================");
        $display("PART 1: DEMONSTRATING LD INSTRUCTION");
        $display("==================================================================\n");

        // Test 1: Store a value first, then load it
        $display("Test 1a: ST R2, 4(R0) - Store R2 to memory[4]");
        $display("  Operation: Mem[0 + 4] = R2 = 0x00000002\n");
        
        // Configure switches: ST R2, 4(R0)
        // SW[15]=0 (display lower), SW[14]=1 (ST), SW[13:10]=2 (R2), SW[9:6]=0 (R0), SW[5:0]=4
        switches = 16'b0_1_0010_0000_000100;
        press_execute();
        $display("  Store completed\n");

        // Test 1b: LD R10, 4(R0) - Load back the value
        $display("Test 1b: LD R10, 4(R0) - Load from memory[4]");
        $display("  Operation: R10 = Mem[0 + 4] = 0x00000002");
        $display("  Expected: R10 = 0x00000002\n");
        
        // Configure switches: LD R10, 4(R0)
        // SW[14]=0 (LD), SW[13:10]=10 (R10), SW[9:6]=0 (R0), SW[5:0]=4
        switches = 16'b0_0_1010_0000_000100;
        press_execute();
        
        display_result(32'h00000002, "R10");

        // Test 2: Store R5 and load it back
        $display("Test 2a: ST R5, 8(R0) - Store R5 to memory[8]");
        $display("  Operation: Mem[0 + 8] = R5 = 0x00000005\n");
        
        switches = 16'b0_1_0101_0000_001000;  // ST R5, 8(R0)
        press_execute();
        $display("  Store completed\n");

        $display("Test 2b: LD R11, 8(R0) - Load from memory[8]");
        $display("  Expected: R11 = 0x00000005\n");
        
        switches = 16'b0_0_1011_0000_001000;  // LD R11, 8(R0)
        press_execute();
        
        display_result(32'h00000005, "R11");

        // Test 3: Using base register with offset
        $display("Test 3a: ST R7, 0(R4) - Store R7 using R4 as base");
        $display("  Operation: Mem[R4 + 0] = Mem[4 + 0] = R7 = 0x00000007\n");
        
        switches = 16'b0_1_0111_0100_000000;  // ST R7, 0(R4)
        press_execute();
        $display("  Store completed\n");

        $display("Test 3b: LD R12, 0(R4) - Load using R4 as base");
        $display("  Expected: R12 = 0x00000007\n");
        
        switches = 16'b0_0_1100_0100_000000;  // LD R12, 0(R4)
        press_execute();
        
        display_result(32'h00000007, "R12");

        // Test 4: Positive offset with base register
        $display("Test 4a: ST R9, 4(R3) - Store with base + offset");
        $display("  Operation: Mem[R3 + 4] = Mem[3 + 4] = Mem[7] = R9 = 0x00000009\n");
        
        switches = 16'b0_1_1001_0011_000100;  // ST R9, 4(R3)
        press_execute();
        $display("  Store completed\n");

        $display("Test 4b: LD R13, 4(R3) - Load with base + offset");
        $display("  Expected: R13 = 0x00000009\n");
        
        switches = 16'b0_0_1101_0011_000100;  // LD R13, 4(R3)
        press_execute();
        
        display_result(32'h00000009, "R13");

        // ========================================
        // PART 2: NEGATIVE OFFSET TESTS
        // ========================================
        $display("==================================================================");
        $display("PART 2: NEGATIVE OFFSET TESTS");
        $display("==================================================================\n");

        // Test 5: Store at a higher address first
        $display("Test 5a: ST R8, 16(R0) - Store at address 16");
        $display("  Operation: Mem[16] = R8 = 0x00000008\n");
        
        switches = 16'b0_1_1000_0000_010000;  // ST R8, 16(R0)
        press_execute();
        $display("  Store completed\n");

        // Now use negative offset from a base register
        $display("Test 5b: LD R14, -4(R5) - Load with negative offset");
        $display("  R5 = 0x00000005, so Mem[5 - 4] = Mem[1]");
        $display("  Expected: R14 = value at Mem[1] (initially 0)\n");
        
        // -4 in 6-bit two's complement = 111100
        switches = 16'b0_0_1110_0101_111100;  // LD R14, -4(R5)
        press_execute();
        
        display_result(32'h00000000, "R14");

        // ========================================
        // PART 3: COMPLEX OPERATIONS
        // ========================================
        $display("==================================================================");
        $display("PART 3: COMPLEX LOAD/STORE PATTERNS");
        $display("==================================================================\n");

        // Test 6: Store multiple values and verify
        $display("Test 6: Store and Load Pattern Test");
        
        // Store R1 at Mem[12]
        $display("  6a: ST R1, 12(R0) -> Mem[12] = 0x00000001");
        switches = 16'b0_1_0001_0000_001100;
        press_execute();
        
        // Store R2 at Mem[16]
        $display("  6b: ST R2, 16(R0) -> Mem[16] = 0x00000002");
        switches = 16'b0_1_0010_0000_010000;
        press_execute();
        
        // Store R3 at Mem[20]
        $display("  6c: ST R3, 20(R0) -> Mem[20] = 0x00000003");
        switches = 16'b0_1_0011_0000_010100;
        press_execute();
        
        $display("\n  Now loading back...\n");
        
        // Load from Mem[12] to R6
        $display("  6d: LD R6, 12(R0)");
        switches = 16'b0_0_0110_0000_001100;
        press_execute();
        display_result(32'h00000001, "R6");
        
        // Load from Mem[16] to R7
        $display("  6e: LD R7, 16(R0)");
        switches = 16'b0_0_0111_0000_010000;
        press_execute();
        display_result(32'h00000002, "R7");
        
        // Load from Mem[20] to R8
        $display("  6f: LD R8, 20(R0)");
        switches = 16'b0_0_1000_0000_010100;
        press_execute();
        display_result(32'h00000003, "R8");

        // ========================================
        // PART 4: EDGE CASES
        // ========================================
        $display("==================================================================");
        $display("PART 4: EDGE CASES");
        $display("==================================================================\n");

        // Test 7: Maximum positive offset (+31)
        $display("Test 7: Store/Load with maximum positive offset (+31)");
        $display("  7a: ST R15, 31(R0) -> Mem[31] = 0x0000000F");
        switches = 16'b0_1_1111_0000_011111;  // +31 = 011111
        press_execute();
        
        $display("  7b: LD R9, 31(R0)");
        switches = 16'b0_0_1001_0000_011111;
        press_execute();
        display_result(32'h0000000F, "R9");

        // Test 8: R0 always remains zero
        $display("Test 8: Verify R0 remains zero (read-only)");
        $display("  8a: Attempt ST R5, 0(R0) and then LD R0, 4(R0)");
        switches = 16'b0_1_0101_0000_000000;
        press_execute();
        
        $display("  8b: LD R0, 0(R0) - R0 should still be 0");
        switches = 16'b0_0_0000_0000_000000;
        press_execute();
        display_result(32'h00000000, "R0 (should remain 0)");

        // ========================================
        // PART 5: RESET TEST
        // ========================================
        $display("==================================================================");
        $display("PART 5: RESET FUNCTIONALITY TEST");
        $display("==================================================================\n");

        $display("Test 9: Verify reset restores initial values");
        $display("  Pressing reset button...\n");
        
        reset = 1;
        repeat(5) @(posedge clk);
        reset = 0;
        repeat(3) @(posedge clk);
        
        $display("  After reset, R2 should be restored to 0x00000002");
        $display("  Storing R2 to Mem[100] and loading back...\n");
        
        switches = 16'b0_1_0010_0000_011001;  // ST R2, 25(R0) -> Mem[25]
        press_execute();
        
        switches = 16'b0_0_1111_0000_011001;  // LD R15, 25(R0)
        press_execute();
        display_result(32'h00000002, "R15 (from R2 after reset)");

        // Summary
        $display("==================================================================");
        $display("                    TEST SUMMARY");
        $display("==================================================================");
        $display("Tested operations:");
        $display("  ? LD with zero offset");
        $display("  ? LD with positive offset");
        $display("  ? LD with negative offset");
        $display("  ? ST with various offsets");
        $display("  ? Base register + offset addressing");
        $display("  ? Store-Load verification");
        $display("  ? Multiple sequential operations");
        $display("  ? Edge cases (max offset, R0 protection)");
        $display("  ? Reset functionality");
        $display("==================================================================\n");
        
        // End simulation
        #100;
        $finish;
    end

    // Optional: Monitor critical signals
    initial begin
        $display("Time | Switches | Operation | Rt | Rs | Offset | LEDs");
        $display("-----|----------|-----------|----|----|--------|------");
    end
    
    always @(posedge execute) begin
        $display("%4t | %b | %s | R%0d | R%0d | %2d | %h", 
                 $time, 
                 switches,
                 switches[14] ? "ST" : "LD",
                 switches[13:10],
                 switches[9:6],
                 $signed({{26{switches[5]}}, switches[5:0]}),
                 leds);
    end

endmodule