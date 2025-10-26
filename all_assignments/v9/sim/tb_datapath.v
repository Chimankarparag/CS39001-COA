`timescale 1ns / 1ps

// Testbench for Datapath Module
module tb_datapath;

    // Inputs
    reg clk;
    reg reset;
    reg wrReg;
    reg [3:0] rs;
    reg [3:0] rt;
    reg [3:0] rd;
    reg [3:0] alu_control;
    
    // Outputs
    wire [31:0] out_data;
    
    // Instantiate the datapath
    datapath uut (
        .clk(clk),
        .reset(reset),
        .wrReg(wrReg),
        .rs(rs),
        .rt(rt),
        .rd(rd),
        .alu_control(alu_control),
        .out_data(out_data)
    );
    
    // Clock generation (10ns period = 100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Test sequence
    initial begin
        // Initialize signals
        reset = 1;
        wrReg = 0;
        rs = 0;
        rt = 0;
        rd = 0;
        alu_control = 0;
        
        // Display header
        $display("=== Datapath Testbench ===");
        $display("Time\tOp\tRs\tRt\tRd\tResult");
        $display("----\t--\t--\t--\t--\t------");
        
        // Release reset after 20ns
        #20 reset = 0;
        #10;
        
        // Test 1: ADD R3 = R1 + R2 (0x1 + 0x2 = 0x3)
        rs = 4'd1;
        rt = 4'd2;
        rd = 4'd3;
        alu_control = 4'b0000;  // ADD
        wrReg = 1;
        #10 wrReg = 0;
        #10 $display("%0t\tADD\tR%0d\tR%0d\tR%0d\t0x%h", $time, rs, rt, rd, out_data);
        
        // Test 2: SUB R4 = R5 - R3 (0x5 - 0x3 = 0x2)
        rs = 4'd5;
        rt = 4'd3;
        rd = 4'd4;
        alu_control = 4'b0001;  // SUB
        wrReg = 1;
        #10 wrReg = 0;
        #10 $display("%0t\tSUB\tR%0d\tR%0d\tR%0d\t0x%h", $time, rs, rt, rd, out_data);
        
        // Test 3: AND R6 = R7 & R8 (0x7 & 0x8 = 0x0)
        rs = 4'd7;
        rt = 4'd8;
        rd = 4'd6;
        alu_control = 4'b0010;  // AND
        wrReg = 1;
        #10 wrReg = 0;
        #10 $display("%0t\tAND\tR%0d\tR%0d\tR%0d\t0x%h", $time, rs, rt, rd, out_data);
        
        // Test 4: OR R7 = R9 | R10 (0x9 | 0xA = 0xB)
        rs = 4'd9;
        rt = 4'd10;
        rd = 4'd7;
        alu_control = 4'b0011;  // OR
        wrReg = 1;
        #10 wrReg = 0;
        #10 $display("%0t\tOR\tR%0d\tR%0d\tR%0d\t0x%h", $time, rs, rt, rd, out_data);
        
        // Test 5: XOR R8 = R11 ^ R12 (0xB ^ 0xC = 0x7)
        rs = 4'd11;
        rt = 4'd12;
        rd = 4'd8;
        alu_control = 4'b0100;  // XOR
        wrReg = 1;
        #10 wrReg = 0;
        #10 $display("%0t\tXOR\tR%0d\tR%0d\tR%0d\t0x%h", $time, rs, rt, rd, out_data);
        
        // Test 6: SLL R9 = R13 << R2 (0xD << 2 = 0x34)
        rs = 4'd13;
        rt = 4'd2;
        rd = 4'd9;
        alu_control = 4'b0101;  // SLL
        wrReg = 1;
        #10 wrReg = 0;
        #10 $display("%0t\tSLL\tR%0d\tR%0d\tR%0d\t0x%h", $time, rs, rt, rd, out_data);
        
        // Test 7: SRL R10 = R14 >> R1 (0xE >> 1 = 0x7)
        rs = 4'd14;
        rt = 4'd1;
        rd = 4'd10;
        alu_control = 4'b0110;  // SRL
        wrReg = 1;
        #10 wrReg = 0;
        #10 $display("%0t\tSRL\tR%0d\tR%0d\tR%0d\t0x%h", $time, rs, rt, rd, out_data);
        
        // Test 8: SLT R11 = (R1 < R15) ? 1 : 0 (1 < 15 = 1)
        rs = 4'd1;
        rt = 4'd15;
        rd = 4'd11;
        alu_control = 4'b0111;  // SLT
        wrReg = 1;
        #10 wrReg = 0;
        #10 $display("%0t\tSLT\tR%0d\tR%0d\tR%0d\t0x%h", $time, rs, rt, rd, out_data);
        
        // Test 9: Verify R0 is always zero
        rs = 4'd0;
        rt = 4'd15;
        rd = 4'd12;
        alu_control = 4'b0000;  // ADD R0 + R15
        wrReg = 1;
        #10 wrReg = 0;
        #10 $display("%0t\tADD\tR%0d\tR%0d\tR%0d\t0x%h (R0 test)", $time, rs, rt, rd, out_data);
        
        // Test 10: Try writing to R0 (should remain 0)
        rs = 4'd15;
        rt = 4'd15;
        rd = 4'd0;  // Try to write to R0
        alu_control = 4'b0000;  // ADD
        wrReg = 1;
        #10 wrReg = 0;
        #10;
        // Read back R0
        rs = 4'd0;
        rt = 4'd1;
        alu_control = 4'b0000;
        #10 $display("%0t\tADD\tR%0d\tR%0d\t--\t0x%h (R0 write protection)", $time, rs, rt, out_data);
        
        #50;
        $display("\n=== Test Complete ===");
        $finish;
    end
    
    // Monitor for debugging
    initial begin
        $monitor("Time=%0t | Reset=%b WrReg=%b | Rs=R%0d Rt=R%0d Rd=R%0d | ALU_Ctrl=%b | Result=0x%h",
                 $time, reset, wrReg, rs, rt, rd, alu_control, out_data);
    end

endmodule
