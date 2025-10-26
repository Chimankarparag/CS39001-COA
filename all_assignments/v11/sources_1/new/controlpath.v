module controlpath (
    input  wire [5:0] opcode,
    input  wire [5:0] funct,        // 5-bit function field from instr[4:0]
    output reg  [3:0] alu_control,  // 4-bit control to ALU wrapper
    output reg        alu_src,      // 1 => use rt, 0 => use immediate
    output reg        immSel,       // if 0 -> 16bit imm else 26bit jmp
    output reg        wr_reg,       // write register file
    output reg        reg_dst,       // 1 => rd (R-type), 0 => rt (I-type)
    output reg        rdMem,        // Read from data memory
    output reg        wrMem,         // Write to data memory
    output reg        mToReg,       //  if 1 => Meomry send to register else alu_result
    output reg  [2:0] brOp,         // which branch to choose in branch comparator
    output reg        updPc
);

    // ALU control encodings (4-bit for wrapper)
    localparam ALU_ADD  = 4'b0000;
    localparam ALU_SUB  = 4'b0001;
    localparam ALU_AND  = 4'b0010;
    localparam ALU_OR   = 4'b0011;
    localparam ALU_XOR  = 4'b0100;
    localparam ALU_SL   = 4'b0101;
    localparam ALU_SRL  = 4'b0110;
    localparam ALU_SLT  = 4'b0111;
    localparam ALU_NOT  = 4'b1000;
    localparam ALU_SRA  = 4'b1001;
    localparam ALU_INC  = 4'b1010;
    localparam ALU_DEC  = 4'b1011;
    localparam ALU_NOR  = 4'b1100;
    localparam ALU_SGT  = 4'b1101;
    localparam ALU_LUI  = 4'b1110;
    localparam ALU_HAM  = 4'b1111;

    // Opcode definitions
    // R-type: 000000
    // I-type: ADDI:000001, SUBI:000010, ANDI:000011, ORI:000100, XORI:000101
    //         NOTI:001100, INCI:001101, DECI:001110, HAMI:001111, LUI:010000

    always @(*) begin
        // Default values
        alu_control = ALU_ADD;
        alu_src     = 1'b1;    // default to rt (R-type)
        immSel      = 1'b0;
        wr_reg      = 1'b0;
        reg_dst     = 1'b0;
        rdMem       = 1'b0;
        wrMem       = 1'b0;
        mToReg      = 1'b0;
        updPc       = 1'b0;
        brOp        = 3'b100;

        case (opcode)
            6'b000000: begin // R-type instruction
                reg_dst  = 1'b1;   // write to rd
                wr_reg   = 1'b1;   // enable write
                alu_src  = 1'b1;   // use rt as operand_b
                updPc    = 1'b1;
                brOp     = 3'b100;
                case (funct)
                    6'b000001: alu_control = ALU_ADD;
                    6'b000010: alu_control = ALU_SUB;
                    6'b000011: alu_control = ALU_AND;
                    6'b000100: alu_control = ALU_OR;
                    6'b000101: alu_control = ALU_XOR;
                    6'b000110: alu_control = ALU_NOR;
                    6'b000111: alu_control = ALU_SL;
                    6'b001000: alu_control = ALU_SRL;
                    6'b001001: alu_control = ALU_SRA;
                    6'b001010: alu_control = ALU_SLT;
                    6'b001011: alu_control = ALU_SGT;
                    6'b001100: alu_control = ALU_NOT;
                    6'b001101: alu_control = ALU_INC;
                    6'b001110: alu_control = ALU_DEC;
                    6'b001111: alu_control = ALU_HAM;
                    default:  alu_control = ALU_ADD;
                endcase
            end

            // I-type instructions
            6'b000001: begin // ADDI
                alu_control = ALU_ADD;
                alu_src     = 1'b0;   // use immediate
                immSel      = 1'b0;
                wr_reg      = 1'b1;
                reg_dst     = 1'b0;   // write to rt
                brOp        = 3'b100;
                updPc    = 1'b1;
            end
            
            6'b000010: begin // SUBI
                alu_control = ALU_SUB;
                alu_src     = 1'b0;
                immSel      = 1'b0;
                wr_reg      = 1'b1;
                reg_dst     = 1'b0;
                brOp        = 3'b100;
                updPc    = 1'b1;
            end
            
            6'b000011: begin // ANDI
                alu_control = ALU_AND;
                alu_src     = 1'b0;
                immSel      = 1'b0;
                wr_reg      = 1'b1;
                reg_dst     = 1'b0;
                brOp        = 3'b100;
                updPc    = 1'b1;
            end
            
            6'b000100: begin // ORI
                alu_control = ALU_OR;
                alu_src     = 1'b0;
                immSel      = 1'b0;
                wr_reg      = 1'b1;
                reg_dst     = 1'b0;
                brOp        = 3'b100;
                updPc    = 1'b1;
            end
            
            6'b000101: begin // XORI
                alu_control = ALU_XOR;
                alu_src     = 1'b0;
                immSel      = 1'b0;
                wr_reg      = 1'b1;
                reg_dst     = 1'b0;
                brOp        = 3'b100;
                updPc    = 1'b1;
            end
            
            6'b001100: begin // NOTI
                alu_control = ALU_NOT;
                alu_src     = 1'b0;
                immSel      = 1'b0;
                wr_reg      = 1'b1;
                reg_dst     = 1'b0;
                brOp        = 3'b100;
                updPc    = 1'b1;
            end
            
            6'b001101: begin // INCI
                alu_control = ALU_INC;
                alu_src     = 1'b0;
                immSel      = 1'b0;
                wr_reg      = 1'b1;
                reg_dst     = 1'b0;
                brOp        = 3'b100;
                updPc    = 1'b1;
            end
            
            6'b001110: begin // DECI
                alu_control = ALU_DEC;
                alu_src     = 1'b0;
                immSel      = 1'b0;
                wr_reg      = 1'b1;
                reg_dst     = 1'b0;
                brOp        = 3'b100;
                updPc    = 1'b1;
            end
            
            6'b001111: begin // HAMI
                alu_control = ALU_HAM;
                alu_src     = 1'b0;
                immSel      = 1'b0;
                wr_reg      = 1'b1;
                reg_dst     = 1'b0;
                brOp        = 3'b100;
                updPc    = 1'b1;
            end
            
            6'b010000: begin // LUI
                alu_control = ALU_LUI;
                alu_src     = 1'b0;
                immSel      = 1'b0;
                wr_reg      = 1'b1;
                reg_dst     = 1'b0;
                brOp        = 3'b100;
                updPc    = 1'b1;
            end
            
            6'b010001: begin //LD
                alu_control = ALU_ADD;
                alu_src     = 1'b0;   // use immediate
                immSel      = 1'b0;
                wr_reg      = 1'b1;
                reg_dst     = 1'b0;   // write to rt
                rdMem       = 1'b1;
                wrMem       = 1'b0;
                mToReg      = 1'b1;
                brOp        = 3'b100;
                updPc    = 1'b1;
                
            end
            
            6'b010010: begin //SW
                alu_control = ALU_ADD;
                alu_src     = 1'b0;   // use immediate
                immSel      = 1'b0;
                wr_reg      = 1'b0;
                reg_dst     = 1'b0;   // write to rt
                rdMem       = 1'b0;
                wrMem       = 1'b1;
                mToReg      = 1'b0;
                brOp        = 3'b100;
                updPc    = 1'b1;
            end
            
            
            // BRANCH
            //immSel = 1 means jump
            
             6'b100000: begin //BR
                alu_control = ALU_ADD;
                alu_src     = 1'b0;   // use immediate
                brOp        = 3'b000;
                immSel      = 1'b1;
                wr_reg      = 1'b0;
                reg_dst     = 1'b0;   // write to rt
                rdMem       = 1'b0;
                wrMem       = 1'b0;
                mToReg      = 1'b0;
                updPc    = 1'b1;
            end
            
             6'b100001: begin //BMI
                alu_control = ALU_ADD;
                alu_src     = 1'b0;   // use immediate
                brOp        = 3'b001;
                immSel      = 1'b0;
                wr_reg      = 1'b0;
                reg_dst     = 1'b0;   // write to rt
                rdMem       = 1'b0;
                wrMem       = 1'b0;
                mToReg      = 1'b0;
                updPc    = 1'b1;
            end
            
            6'b100010: begin //BPL
                alu_control = ALU_ADD;
                alu_src     = 1'b0;   // use immediate
                brOp        = 3'b010;
                immSel      = 1'b0;
                wr_reg      = 1'b0;
                reg_dst     = 1'b0;   // write to rt
                rdMem       = 1'b0;
                wrMem       = 1'b0;
                mToReg      = 1'b0;
                updPc    = 1'b1;
                 
                $display("BPL Instruction is hit brop is %h",brOp);
                 
            end
            
             6'b100011: begin //BZ
                alu_control = ALU_ADD;
                alu_src     = 1'b0;   // use immediate
                brOp        = 3'b011;
                immSel      = 1'b0;
                wr_reg      = 1'b0;
                reg_dst     = 1'b0;   // write to rt
                rdMem       = 1'b0;
                wrMem       = 1'b0;
                mToReg      = 1'b0;
                updPc    = 1'b1;
            end
            
            // MOV CMOV NOP CALL  remaining
            
            //SYSCALLS
            
            6'b100100: begin //HALT
                alu_control = ALU_ADD;
                alu_src     = 1'b0;   // use immediate
                brOp        = 3'b100;
                immSel      = 1'b0;
                wr_reg      = 1'b0;
                reg_dst     = 1'b0;   // write to rt
                rdMem       = 1'b0;
                wrMem       = 1'b0;
                mToReg      = 1'b0;
                updPc    = 1'b0;
                $display("program halted");
            end

            default: begin
                // No operation - keep defaults
                alu_control = ALU_ADD;
                brOp        = 3'b100;
                alu_src     = 1'b0;
                wr_reg      = 1'b0;
                reg_dst     = 1'b0;
                updPc    = 1'b0;
            end
        endcase
    end
endmodule