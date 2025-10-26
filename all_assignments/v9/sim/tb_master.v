`timescale 1ns / 1ps

module tb_master;

    reg        clk;
    reg [15:0] sw;
    reg        btn_exec;
    reg     btn_reset;
    wire [15:0] led;

    master UUT (
        .clk(clk),
        .sw(sw),
        .btn_exec(btn_exec),
        .btn_reset(btn_reset),
        .led(led)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $display("=== Starting FPGA Top Module Test ===");
        
        sw = 16'h0000;
        btn_exec = 0;
        btn_reset = 0;
        
        #50;
        
        btn_reset = 1;
        #50;
        btn_reset = 0;
        #50;
                
        $display("\n--- Test 1: ADD R1 + R2 -> R4 (1 + 2 = 3) ---");
        // SW[15]=0 (lower bits), SW[14:12]=000 (ADD), 
        // SW[11:8]=0100 (R4), SW[7:4]=0001 (R1), SW[3:0]=0010 (R2)
        sw = 16'b0_000_0100_0001_0010;
        #50;
        btn_exec = 1;
        #20;
        btn_exec = 0;
        #50;
        $display("LED (lower 16): %h, Expected: 0003", led);
        
        // Check upper 16 bits
        sw[15] = 1;
        #20;
        $display("LED (upper 16): %h, Expected: 0000", led);
        
        $display("\n--- Test 2: SUB R11 - R10 -> R5 (11-10 = 1) ---");
        // SW[14:12]=001 (SUB), SW[11:8]=0101 (R5), 
        // SW[7:4]=1011 (R11), SW[3:0]=1010 (R10)
        sw = 16'b0_001_0101_1011_1010;
        #50;
        btn_exec = 1;
        #20;
        btn_exec = 0;
        #50;
        $display("LED (lower 16): %h, Expected: 0001 (1)", led);
        
        $display("\n--- Test 3: AND R5 & R4 -> R6 ---");
        // SW[14:12]=010 (AND), SW[11:8]=0110 (R6),
        // SW[7:4]=0101 (R5), SW[3:0]=0100 (R4)
        sw = 16'b0_010_0110_0101_0100;
        #50;
        btn_exec = 1;
        #20;
        btn_exec = 0;
        #50;
        $display("LED (lower 16): %h,Expected: 0001", led);
        
        $display("\n--- Test 4: OR R1 | R3 -> R7 (1 | 3 = 3) ---");
        // SW[14:12]=011 (OR), SW[11:8]=0111 (R7),
        // SW[7:4]=0001 (R1), SW[3:0]=0011 (R3)
        sw = 16'b0_011_0111_0001_0011;
        #50;
        btn_exec = 1;
        #20;
        btn_exec = 0;
        #50;
        $display("LED (lower 16): %h, Expected: 0003", led);
        sw[15] = 1;
        #20;
        $display("LED (upper 16): %h, Expected: 0000", led);
        
        $display("\n--- Test 5: XOR R8 ^ R9 -> R10 ---");
        // SW[14:12]=100 (XOR), SW[11:8]=1010 (R10),
        // SW[7:4]=1000 (R8), SW[3:0]=1001 (R9)
        sw = 16'b0_100_1010_1000_1001;
        #50;
        btn_exec = 1;
        #20;
        btn_exec = 0;
        #50;
        $display("LED (lower 16): %h, Expected: 0001", led);
        
        $display("\n--- Test 6: SL (Shift Left) R14 << R2 -> R11 (E << 2) ---");
        // SW[14:12]=101 (SL), SW[11:8]=1011 (R11),
        // SW[7:4]=1110 (R14), SW[3:0]=0010 (R2)
        sw = 16'b0_101_1011_1110_0010;
        #50;
        btn_exec = 1;
        #20;
        btn_exec = 0;
        #50;
        $display("LED (lower 16): %b, Expected: 0008", led);
        sw[15] = 1;
        #20;
        $display("LED (upper 16): %b, Expected: 0003", led);
        
        $display("\n--- Test 7: SRL (Shift Right Logical) R15 >> R2 -> R12 ---");
        // SW[14:12]=110 (SRL), SW[11:8]=1100 (R12),
        // SW[7:4]=1111 (R15), SW[3:0]=0010 (R2)
        sw = 16'b1_110_1100_1111_0010;
        #50;
        btn_exec = 1;
        #20;
        btn_exec = 0;
        #50;
        $display("LED (upper 16): %h, Expected: 0000", led);
        
        $display("\n--- Test 8: SLT (Set Less Than) R1 < R2 -> R13 (1 < 2 = 1) ---");
        // SW[14:12]=111 (SLT), SW[11:8]=1101 (R13),
        // SW[7:4]=0001 (R1), SW[3:0]=0010 (R2)
        sw = 16'b0_111_1101_0001_0010;
        #50;
        btn_exec = 1;
        #20;
        btn_exec = 0;
        #50;
        $display("LED (lower 16): %h, Expected: 0001", led);
        
        $display("\n--- Test 9: SLT R2 < R1 -> R14 (2 < 0 = 0) ---");
        sw = 16'b0_111_1110_0010_0001;
        #50;
        btn_exec = 1;
        #20;
        btn_exec = 0;
        #50;
        $display("LED (lower 16): %h, Expected: 0000", led);
        
        $display("\n--- Test 10: Verify R0 remains zero ---");
        // Try to write to R0 (should fail)
        sw = 16'b0_000_0000_0001_0010;  // ADD R1+R2 -> R0
        #50;
        btn_exec = 1;
        #20;
        btn_exec = 0;
        #50;
        // Now read R0
        sw = 16'b0_000_1111_0000_0000;  // ADD R0+R0 -> R15
        #50;
        btn_exec = 1;
        #20;
        btn_exec = 0;
        #50;
        $display("LED (lower 16): %h, Expected: 0000 (R0 should remain 0)", led);
        
        #100;
        $display("\n=== Test Complete ===");
        $finish;
    end

    // Monitor changes
    initial begin
        $monitor("Time=%0t | SW=%b | BTN=%b | LED=%h", 
                 $time, sw, btn_exec, led);
    end

endmodule