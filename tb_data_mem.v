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

    // Clock generation - 10ns period (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test stimulus
    initial begin
        // Display header
        $display("\n==========================================================");
        $display("          DATA MEMORY (BRAM) TESTBENCH");
        $display("==========================================================\n");

        // Initialize signals
        reset = 1;
        addr = 32'h0;
        wrData = 32'h0;
        rdMem = 1'b0;
        wrMem = 1'b0;
        
        // Hold reset for 2 clock cycles
        #10;
        reset = 0;
        #10;

        // Test Case 1: Write data to address 0
        $display("=== Test 1: Write 0x12345678 to Address 0 ===");
        addr = 32'h00000000;
        wrData = 32'h12345678;
        wrMem = 1'b1;
        rdMem = 1'b0;
        #10;
        wrMem = 1'b0;
        $display("Time=%0t | Address=%h | Write Data=%h | wrMem=%b", 
                 $time, addr, wrData, wrMem);
        $display("✓ Write operation completed\n");
        #10;

        // Test Case 2: Read data from address 0
        $display("=== Test 2: Read from Address 0 ===");
        $display("Expected: 0x12345678");
        addr = 32'h00000000;
        rdMem = 1'b1;
        #10;  // Wait one clock cycle for BRAM to output data
        #10;  // Wait another cycle for rdData register to capture
        $display("Time=%0t | Address=%h | Read Data=%h | rdMem=%b", 
                 $time, addr, rdData, rdMem);
        if (rdData == 32'h12345678)
            $display("✓ PASS: Read data matches (0x%h)\n", rdData);
        else
            $display("✗ FAIL: Expected 0x12345678, got 0x%h\n", rdData);
        rdMem = 1'b0;
        #10;

        // Test Case 3: Write data to address 4
        $display("=== Test 3: Write 0xAABBCCDD to Address 4 ===");
        addr = 32'h00000004;
        wrData = 32'hAABBCCDD;
        wrMem = 1'b1;
        #10;
        wrMem = 1'b0;
        $display("Time=%0t | Address=%h | Write Data=%h | wrMem=%b", 
                 $time, addr, wrData, wrMem);
        $display("✓ Write operation completed\n");
        #10;

        // Test Case 4: Read data from address 4
        $display("=== Test 4: Read from Address 4 ===");
        $display("Expected: 0xAABBCCDD");
        addr = 32'h00000004;
        rdMem = 1'b1;
        #10;  // Wait for BRAM latency
        #10;  // Wait for capture in rdData register
        $display("Time=%0t | Address=%h | Read Data=%h | rdMem=%b", 
                 $time, addr, rdData, rdMem);
        if (rdData == 32'hAABBCCDD)
            $display("✓ PASS: Read data matches (0x%h)\n", rdData);
        else
            $display("✗ FAIL: Expected 0xAABBCCDD, got 0x%h\n", rdData);
        rdMem = 1'b0;
        #10;

        // Test Case 5: Verify address 0 still holds original data
        $display("=== Test 5: Re-read Address 0 (verify data persistence) ===");
        $display("Expected: 0x12345678");
        addr = 32'h00000000;
        rdMem = 1'b1;
        #10;  // Wait for BRAM latency
        #10;  // Wait for capture
        $display("Time=%0t | Address=%h | Read Data=%h | rdMem=%b", 
                 $time, addr, rdData, rdMem);
        if (rdData == 32'h12345678)
            $display("✓ PASS: Data persisted correctly (0x%h)\n", rdData);
        else
            $display("✗ FAIL: Expected 0x12345678, got 0x%h\n", rdData);
        rdMem = 1'b0;
        #10;

        // Test Case 6: Write multiple sequential addresses
        $display("=== Test 6: Write Sequential Data ===");
        for (integer i = 0; i < 8; i = i + 1) begin
            addr = i * 4;  // Word-aligned addresses: 0, 4, 8, 12, 16, 20, 24, 28
            wrData = 32'h00000100 + i;
            wrMem = 1'b1;
            #10;
            wrMem = 1'b0;
            $display("  Wrote 0x%h to Address %d", wrData, addr);
            #10;
        end
        $display("✓ Sequential write completed\n");

        // Test Case 7: Read back sequential data
        $display("=== Test 7: Read Sequential Data ===");
        for (integer i = 0; i < 8; i = i + 1) begin
            addr = i * 4;
            rdMem = 1'b1;
            #10;  // Wait for BRAM latency
            #10;  // Wait for capture
            $display("  Address %d: Read 0x%h (Expected: 0x%h)", 
                     addr, rdData, 32'h00000100 + i);
            if (rdData == (32'h00000100 + i))
                $display("    ✓ PASS");
            else
                $display("    ✗ FAIL");
            rdMem = 1'b0;
            #10;
        end
        $display("");

        // Test Case 8: Test write at higher address
        $display("=== Test 8: Write to Higher Address (0x100) ===");
        addr = 32'h00000100;
        wrData = 32'hDEADBEEF;
        wrMem = 1'b1;
        #10;
        wrMem = 1'b0;
        $display("Time=%0t | Address=%h | Write Data=%h", 
                 $time, addr, wrData);
        $display("✓ Write operation completed\n");
        #10;

        // Test Case 9: Read from higher address
        $display("=== Test 9: Read from Address 0x100 ===");
        $display("Expected: 0xDEADBEEF");
        addr = 32'h00000100;
        rdMem = 1'b1;
        #10;  // Wait for BRAM latency
        #10;  // Wait for capture
        $display("Time=%0t | Address=%h | Read Data=%h", 
                 $time, addr, rdData);
        if (rdData == 32'hDEADBEEF)
            $display("✓ PASS: Read data matches (0x%h)\n", rdData);
        else
            $display("✗ FAIL: Expected 0xDEADBEEF, got 0x%h\n", rdData);
        rdMem = 1'b0;
        #10;

        // Test Case 10: Test simultaneous read and write flags (write should take precedence)
        $display("=== Test 10: Simultaneous Read/Write Test ===");
        addr = 32'h00000020;
        wrData = 32'hCAFEBABE;
        wrMem = 1'b1;
        rdMem = 1'b1;  // Both flags set
        #10;
        $display("Time=%0t | Address=%h | Write Data=%h | wrMem=%b | rdMem=%b", 
                 $time, addr, wrData, wrMem, rdMem);
        wrMem = 1'b0;
        #10;  // Extra cycle for BRAM read latency
        #10;  // Extra cycle for capture
        $display("  Data written: 0x%h", wrData);
        $display("  Read back: 0x%h", rdData);
        if (rdData == 32'hCAFEBABE)
            $display("✓ PASS: Simultaneous operation handled correctly\n");
        else
            $display("✗ FAIL: Expected 0xCAFEBABE, got 0x%h\n", rdData);
        rdMem = 1'b0;
        #10;

        // Test Case 11: Test with rdMem=0 (should hold previous value)
        $display("=== Test 11: Test rdMem=0 (output should hold) ===");
        addr = 32'h00000020;
        rdMem = 1'b0;
        #20;
        $display("Time=%0t | rdMem=%b | rdData=%h (should hold previous)", 
                 $time, rdMem, rdData);
        $display("✓ Output holding test completed\n");

        // Test Case 12: Reset test
        $display("=== Test 12: Reset Test ===");
        reset = 1'b1;
        #10;
        $display("Time=%0t | Reset=%b | rdData=%h (should be 0)", 
                 $time, reset, rdData);
        if (rdData == 32'h0)
            $display("✓ PASS: Reset cleared output\n");
        else
            $display("✗ FAIL: Output not cleared on reset\n");
        reset = 1'b0;
        #10;

        // Summary
        $display("\n==========================================================");
        $display("              TEST SUMMARY");
        $display("==========================================================");
        $display("Memory operations tested:");
        $display("  • Single word write/read");
        $display("  • Multiple address writes");
        $display("  • Sequential read/write");
        $display("  • Data persistence");
        $display("  • Higher address access");
        $display("  • Simultaneous read/write");
        $display("  • Output holding behavior");
        $display("  • Reset functionality");
        $display("==========================================================\n");
        
        // End simulation
        #20;
        
    end

    // Monitor for real-time observation
    initial begin
        $monitor("Time=%0t | Addr=%h | wrData=%h | rdData=%h | wrMem=%b | rdMem=%b | Reset=%b", 
                 $time, addr, wrData, rdData, wrMem, rdMem, reset);
    end

    // Timeout watchdog
    initial begin
        #2000;
        $display("\n!!! SIMULATION TIMEOUT !!!");
        $finish;
    end

endmodule