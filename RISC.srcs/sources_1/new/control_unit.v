`timescale 1ns / 1ps

module control_unit (
    input  wire [5:0] opcode,
    input  wire [5:0] funct,
    input  wire       clk, INT, rst,

    output reg  [3:0] alu_control,
    output reg  [2:0] brOp,
    output reg        alu_src, reg_dst,
    output reg        rdMem, wrMem,
    output reg        wr_reg, mToReg,
    output reg        immSel, updPc
);

    reg [2:0] state, ins_state;

    // Opcode parameters
    parameter
        R_TYPE = 6'b000000,
        ADDI = 6'b000001,
        SUBI = 6'b000010,
        ANDI = 6'b000011,
        ORI  = 6'b000100,
        XORI = 6'b000101,
        NORI = 6'b000110,
        SLI  = 6'b000111,
        SRLI = 6'b001000,
        SRAI = 6'b001001,
        SLTI = 6'b001010,
        SGTI = 6'b001011,
        NOTI = 6'b001100,
        INCI = 6'b001101,
        DECI = 6'b001110,
        HAMI = 6'b001111,
        LUI  = 6'b010000,
        LD   = 6'b010001,
        ST   = 6'b010010,
        BR   = 6'b100000,
        BMI  = 6'b100001,
        BPL  = 6'b100010,
        BZ   = 6'b100011,
        HALT = 6'b100100,
        NOP  = 6'b100101;

    //-----------------------------------------------------------------------
    // Sequential FSM for Multi-Cycle Control
    //-----------------------------------------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state      <= 0;
            ins_state  <= 0;
            updPc      <= 0;
            wr_reg     <= 0;
            wrMem      <= 0;
            rdMem      <= 0;
        end
        else begin
            case (state)
                // -----------------------------------------------------------
                0: begin
                    updPc <= 0;
                    state <= 1;
                end

                // -----------------------------------------------------------
                1: begin
                    case (opcode)

                        // ==================== R-TYPE ====================
                        R_TYPE: begin
                            case (ins_state)
                                0: begin
                                    alu_control <= funct[3:0] - 1;
                                    brOp <= 3'b100;
                                    alu_src <= 1;
                                    reg_dst <= 1;
                                    rdMem <= 0;
                                    wrMem <= 0;
                                    wr_reg <= 0;
                                    mToReg <= 0;
                                    ins_state <= 1;
                                end
                                1: begin
                                    wr_reg <= 1;
                                    ins_state <= 2;
                                end
                                2: begin
                                    wr_reg <= 0;
                                    updPc <= 1;
                                    state <= 0;
                                    ins_state <= 0;
                                end
                            endcase
                        end

                        // ==================== LUI ====================
                        LUI: begin
                            case (ins_state)
                                0: begin
                                    alu_control <= 4'b1111;
                                    brOp <= 3'b100;
                                    alu_src <= 0;
                                    reg_dst <= 0;
                                    rdMem <= 0;
                                    wrMem <= 0;
                                    wr_reg <= 0;
                                    mToReg <= 0;
                                    immSel <= 0;
                                    ins_state <= 1;
                                end
                                1: begin
                                    wr_reg <= 1;
                                    ins_state <= 2;
                                end
                                2: begin
                                    wr_reg <= 0;
                                    updPc <= 1;
                                    state <= 0;
                                    ins_state <= 0;
                                end
                            endcase
                        end

                        // ==================== LOAD ====================
                        LD: begin
                            case (ins_state)
                                0: begin
                                    alu_control <= 4'b0000;
                                    brOp <= 3'b100;
                                    alu_src <= 0;
                                    reg_dst <= 0;
                                    wrMem <= 0;
                                    wr_reg <= 0;
                                    immSel <= 0;
                                    ins_state <= 1;
                                end
                                1: begin
                                    rdMem <= 1;
                                    ins_state <= 2;
                                end
                                2: ins_state <= 3;
                                3: begin
                                    rdMem <= 0;
                                    mToReg <= 1;
                                    wr_reg <= 1;
                                    ins_state <= 4;
                                end
                                4: begin
                                    mToReg <= 0;
                                    wr_reg <= 0;
                                    updPc <= 1;
                                    state <= 0;
                                    ins_state <= 0;
                                end
                            endcase
                        end

                        // ==================== STORE ====================
                        ST: begin
                            case (ins_state)
                                0: begin
                                    alu_control <= 4'b0000;
                                    brOp <= 3'b100;
                                    alu_src <= 0;
                                    reg_dst <= 0;
                                    rdMem <= 0;
                                    mToReg <= 0;
                                    wr_reg <= 0;
                                    immSel <= 0;
                                    ins_state <= 1;
                                end
                                1: ins_state <= 2;
                                2: begin
                                    wrMem <= 1;
                                    ins_state <= 3;
                                end
                                3: begin
                                    wrMem <= 0;
                                    updPc <= 1;
                                    state <= 0;
                                    ins_state <= 0;
                                end
                            endcase
                        end

                        // ==================== BRANCHES ====================
                        BR:  begin brOp <= 3'b000; immSel <= 1; state <= 0; updPc <= 1; ins_state <= 0; end
                        BMI: begin brOp <= 3'b001; immSel <= 1; state <= 0; updPc <= 1; ins_state <= 0; end
                        BPL: begin brOp <= 3'b010; immSel <= 1; state <= 0; updPc <= 1; ins_state <= 0; end
                        BZ:  begin brOp <= 3'b011; immSel <= 1; state <= 0; updPc <= 1; ins_state <= 0; end

                        // ==================== HALT ====================
                        HALT: begin
                            case (ins_state)
                                0: begin
                                    brOp <= 3'b100;
                                    alu_src <= 0;
                                    rdMem <= 0;
                                    wrMem <= 0;
                                    wr_reg <= 0;
                                    mToReg <= 0;
                                    if (INT)
                                        ins_state <= 1;
                                    else
                                        ins_state <= 0;
                                end
                                1: begin
                                    updPc <= 1;
                                    state <= 0;
                                    ins_state <= 0;
                                end
                            endcase
                        end

                        // ==================== NOP ====================
                        NOP: begin
                            case (ins_state)
                                0: begin
                                    brOp <= 3'b100;
                                    alu_src <= 0;
                                    rdMem <= 0;
                                    wrMem <= 0;
                                    wr_reg <= 0;
                                    mToReg <= 0;
                                    ins_state <= 1;
                                end
                                1: begin
                                    updPc <= 1;
                                    state <= 0;
                                    ins_state <= 0;
                                end
                            endcase
                        end

                        // ==================== DEFAULT: IMM-type ====================
                        default: begin
                            case (ins_state)
                                0: begin
                                    alu_control <= opcode[3:0] - 1;
                                    brOp <= 3'b100;
                                    alu_src <= 0;
                                    reg_dst <= 0;
                                    rdMem <= 0;
                                    wrMem <= 0;
                                    mToReg <= 0;
                                    immSel <= 0;
                                    ins_state <= 1;
                                end
                                1: begin
                                    wr_reg <= 1;
                                    ins_state <= 2;
                                end
                                2: begin
                                    wr_reg <= 0;
                                    updPc <= 1;
                                    state <= 0;
                                    ins_state <= 0;
                                end
                            endcase
                        end
                    endcase
                end
            endcase
        end
    end
endmodule
