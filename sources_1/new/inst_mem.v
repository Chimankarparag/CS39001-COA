module instruction_memory (
    input  wire [31:0] pcOut,              // Program counter (address)
    output wire  [5:0] opcode,
    output wire  [5:0] funct,
    output wire  [3:0]  rs,
    output wire  [3:0]  rt,
    output wire  [3:0]  rd,
    output wire  [31:0] imm_signed,
    output wire  [31:0] jmp_signed
          
    );
    reg [31:0] instruction;
        // Hardcoded test instructions from testbench
    always @(*) begin
        case (pcOut[7:2])  // Word-aligned addressing (divide by 4)
            6'd0:  instruction = 32'b000000_00001_00010_00011_00000_000001; // ADD R3, R1, R2
            6'd1:  instruction = 32'b000000_00100_00010_00101_00000_000010; // SUB R5, R4, R2
            6'd2:  instruction = 32'b000000_00011_00101_00110_00000_000011; // AND R6, R3, R5
            6'd3:  instruction = 32'b000000_00011_00100_00111_00000_000100; // OR R7, R3, R4
            6'd4:  instruction = 32'b000000_00111_00110_01000_00000_000101; // XOR R8, R7, R6
            6'd5:  instruction = 32'b000000_00001_00010_01001_00000_000110; // NOR R9, R1, R2
            6'd6:  instruction = 32'b000000_01000_00000_01010_00000_001100; // NOT R10, R8
            6'd7:  instruction = 32'b000000_00011_00001_01011_00000_000111; // SL R11, R3, R1
            6'd8:  instruction = 32'b000000_01000_00000_01100_00000_001101; // INC R12, R8
            6'd9:  instruction = 32'b000000_00111_00000_01101_00000_001110; // DEC R13, R7
            6'd10: instruction = 32'b000001_00001_01110_0000000000001010; // ADDI R14, R1, 10
            6'd11: instruction = 32'b000010_00111_01111_0000000000000011; // SUBI R15, R7, 3
            6'd12: instruction = 32'b000011_01110_00001_0000000000000111; // ANDI R1, R14, 0x0007
            6'd13: instruction = 32'b000100_00001_00010_0000000000000100; // ORI R2, R1, 0x0004
            6'd14: instruction = 32'b000101_00111_00011_0000000000000101; // XORI R3, R7, 0x0005
            6'd15: instruction = 32'b010000_00000_00100_0001001000110100; // LUI R4, 0x1234
            6'd16: instruction = 32'b001101_00011_00101_0000000000000000; // INCI R5, R3
            6'd17: instruction = 32'b001110_00111_00110_0000000000000000; // DECI R6, R7
            6'd18: instruction = 32'b000001_01000_00111_1111111111111011; // ADDI R7, R8, -5
            6'd19: instruction = 32'b000001_00001_00000_0000000001100100; // ADDI R0, R1, 100
            
            // LOAD/STORE TEST INSTRUCTIONS (Starting from address 20)
            6'd20: instruction = 32'b000001_00000_00001_0000000001100100; // ADDI R1, R0, 100
            6'd21: instruction = 32'b010010_00000_00001_0000000000000100; // SW R1, 4(R0) - Store R1 to Mem[4]
            6'd22: instruction = 32'b000001_00000_00010_0000000011001000; // ADDI R2, R0, 200
            6'd23: instruction = 32'b010010_00000_00010_0000000000001000; // SW R2, 8(R0) - Store R2 to Mem[8]
            6'd24: instruction = 32'b010001_00000_00011_0000000000000100; // LD R3, 4(R0) - Load Mem[4] into R3
            6'd25: instruction = 32'b010001_00000_00100_0000000000001000; // LD R4, 8(R0) - Load Mem[8] into R4
            6'd26: instruction = 32'b000001_00000_00101_0000000000010000; // ADDI R5, R0, 16 - Base address
            6'd27: instruction = 32'b010010_00101_00011_0000000000000100; // SW R3, 4(R5) - Store R3 to Mem[20]
            6'd28: instruction = 32'b010001_00101_00110_0000000000000100; // LD R6, 4(R5) - Load Mem[20] into R6
            default: instruction = 32'h00000000; // NOP
        endcase
    end
    
        // Instruction field extraction
    assign opcode = instruction[31:26];
    wire [4:0]  rs_5bit = instruction[25:21];
    wire [4:0]  rt_5bit = instruction[20:16];
    wire [4:0]  rd_5bit = instruction[15:11];
    // wire [4:0]  shamt = instruction[10:6];  // Unused for now
    assign funct = instruction[5:0];
    wire [15:0] imm = instruction[15:0];
    wire [25:0] jmp = instruction[25:0];
    
    assign imm_signed = {{16{imm[15]}}, imm};
    assign jmp_signed = {6'b0, jmp};
    
    assign rs = rs_5bit[3:0];
    assign rt = rt_5bit[3:0];
    assign rd = rd_5bit[3:0];
    
endmodule
