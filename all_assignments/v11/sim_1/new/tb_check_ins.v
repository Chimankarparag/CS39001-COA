`timescale 1ns / 1ps

module tb_check_ins();

    // Clock and Reset
    reg clk;
    reg reset;

    // Inputs to DUT
    reg [31:0] pcOut;

    // Outputs from DUT
    wire [5:0] opcode;
    wire [5:0] funct;
    wire [3:0] rs;
    wire [3:0] rt;
    wire [3:0] rd;
    wire [31:0] imm_signed;
    wire [31:0] jmp_signed;

    // Instantiate DUT
    instruction_memory dut (
        .clk(clk),
        .reset(reset),
        .pcOut(pcOut),
        .opcode(opcode),
        .funct(funct),
        .rs(rs),
        .rt(rt),
        .rd(rd),
        .imm_signed(imm_signed),
        .jmp_signed(jmp_signed)
    );

    // Clock generation (10 ns period)
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        $display("------------------------------------------------------");
        $display("Starting Instruction Memory Testbench");
        $display("------------------------------------------------------");

        clk = 0;
        reset = 1;
        pcOut = 0;

        #200 reset = 0;

        // Test several addresses
        repeat (10) begin
            
            #10;
            $display("Time=%0t | PC=%h | Opcode=%h | Funct=%h | rs=%h | rt=%h | rd=%h | Imm=%h | Jmp=%h",
                     $time, pcOut, opcode, funct, rs, rt, rd, imm_signed, jmp_signed);
            #10 pcOut = pcOut + 1;  // assuming word-addressable memory
        end

        $display("------------------------------------------------------");
        $display("Simulation Completed");
        $display("------------------------------------------------------");
        $stop;
    end

endmodule
