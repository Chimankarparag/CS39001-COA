`timescale 1ns / 1ps

module tb_data_mem;

    // Testbench signals
    reg         clk;
    reg         reset;
    reg  [31:0] addr;
    reg  [31:0] wrData;
    reg         rdMem;
    reg         wrMem;
    wire [31:0] rdData;

    // Instantiate the data memory module
    data_mem uut (
        .clk(clk),
        .reset(reset),
        .addr(addr),
        .wrData(wrData),
        .rdMem(rdMem),
        .wrMem(wrMem),
        .rdData(rdData)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test stimulus
    initial begin
        $display("\n==========================================================");
        $display("          DATA MEMORY (BRAM) TESTBENCH");
        $display("==========================================================\n");

        // Initialize signals
        reset = 1;
        addr = 32'h0;
        wrData = 32'h0;
        rdMem = 1'b0;
        wrMem = 1'b0;

        // Reset
        #10;
        reset = 0;
        #10;

        // --- Test 0: Check Memory Initialization ---
        $display("=== Test 0: Verify .mem Initialization ===");
        for (integer i = 0; i < 8; i = i + 1) begin
            addr = i * 4;
            rdMem = 1'b1;
            #10;
            $display("Addr=%h | Read Data=%h (Expected: Incremental pattern)", addr, rdData);
        end
        rdMem = 1'b0;
        #10;

        // --- Test 1: Write/Read Verification ---
        $display("=== Test 1: Write and Read 0x12345678 at Address 0 ===");
        addr = 32'h00000000;
        wrData = 32'h12345678;
        wrMem = 1;
        #10 wrMem = 0;
        rdMem = 1;
        #20;
        if (rdData == 32'h12345678)
            $display("✓ PASS: 0x12345678 written/read correctly at 0x0\n");
        else
            $display("✗ FAIL: Got 0x%h\n", rdData);
        rdMem = 0;

        // --- Test 2: Sequential Increment Test ---
        $display("=== Test 2: Write Sequential 0x01, 0x02, ... and Verify ===");
        for (integer i = 0; i < 8; i = i + 1) begin
            addr = i;
            wrData = {24'h0, (i + 1)};  // 0x00000001, 0x00000002, etc.
            wrMem = 1;
            #10 wrMem = 0;
        end

        // Read back sequential data
        for (integer i = 0; i < 8; i = i + 1) begin
            addr = i;
            rdMem = 1;
            #10;
            if (rdData == {24'h0, (i + 1)})
                $display("✓ Addr %0d: PASS (0x%h)", addr, rdData);
            else
                $display("✗ Addr %0d: FAIL (Got 0x%h)", addr, rdData);
            rdMem = 0;
            #10;
        end

        // --- Test 3: Higher Address Access ---
        $display("=== Test 3: Write/Read 0xDEADBEEF at Address 0x100 ===");
        addr = 32'h100;
        wrData = 32'hDEADBEEF;
        wrMem = 1;
        #10 wrMem = 0;
        rdMem = 1;
        #20;
        if (rdData == 32'hDEADBEEF)
            $display("✓ PASS: 0xDEADBEEF stored correctly at 0x100\n");
        else
            $display("✗ FAIL: Expected 0xDEADBEEF, got 0x%h\n", rdData);
        rdMem = 0;

        // --- Test 4: Reset Functionality ---
        $display("=== Test 4: Reset Test ===");
        reset = 1;
        #10;
        if (rdData == 0)
            $display("✓ PASS: Reset cleared rdData\n");
        else
            $display("✗ FAIL: rdData not cleared (0x%h)\n", rdData);
        reset = 0;

        // End of Tests
        $display("\n==========================================================");
        $display("                TESTS COMPLETED SUCCESSFULLY");
        $display("==========================================================\n");
        #20 $finish;
    end
 
    // Real-time monitor
    initial begin
        $monitor("Time=%0t | Addr=%h | wrData=%h | rdData=%h | wrMem=%b | rdMem=%b | Reset=%b",
                 $time, addr, wrData, rdData, wrMem, rdMem, reset);
    end

endmodule
