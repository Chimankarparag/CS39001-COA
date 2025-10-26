`timescale 1ns / 1ps

module datapath_ls (
    input  wire         clk,
    input  wire         reset,
    // Single-step execute signal
    // Register file interface
    input  wire [3:0]   rs_addr,
    input  wire [3:0]   rt_addr,
    input  wire [3:0]   rd_addr,
    input  wire         reg_dst,
    input  wire         wr_reg,
    // ALU interface
    input  wire [3:0]   alu_control,
    input  wire         alu_src,
    input  wire         immSel,
    input  wire [31:0]  imm_signed,
    input  wire [31:0]  jmp_signed,
    
    // Data Control Signals
    input  wire        rdMem,
    input  wire        wrMem,
    input  wire        mToReg,
    
    // Outputs
    output wire [31:0]  result_out,
    output wire [31:0]  rsOut_out,
    output wire         zero_flag,
    output wire         negative_flag,
    output wire         overflow_flag

);

    wire [31:0] rsOut, rtOut;
    wire [31:0] alu_operand_b;
    wire [31:0] alu_result;
    wire [31:0] imm_ext;
    wire [3:0]  dest_reg;
    wire [31:0] rdData;
    wire [31:0] write_data;

    // MUX for destination register
    assign dest_reg = (reg_dst) ? rd_addr : rt_addr;
    
    // MUX for write data: choose between memory data and ALU result
    assign write_data = (mToReg) ? rdData : alu_result;
    
    // Instantiate register bank with pre-loaded values
    reg_bank Registers (
        .clk(clk),
        .reset(reset),
        .wrReg(wr_reg),
        .rs(rs_addr),
        .rt(rt_addr),
        .rd(dest_reg),
        .rdIn(write_data),
        .rsOut(rsOut),
        .rtOut(rtOut)
    );
    
    // Data Memory with pre-loaded values (BRAM)
    data_mem Data_memory(
        .clk(clk),
        .reset(reset),
        .addr(alu_result),
        .wrData(rtOut),
        .rdMem(rdMem),
        .wrMem(wrMem),
        .rdData(rdData)
    );
    
    // MUX for immediate selection
    assign imm_ext = (immSel) ? jmp_signed : imm_signed;
    
    // ALU source MUX: select between rt and immediate
    assign alu_operand_b = (alu_src) ? rtOut : imm_ext;
    
    // Instantiate ALU wrapper
    alu_wrapper ALUinst (
        .operand_a(rsOut),
        .operand_b(alu_operand_b),
        .alu_control(alu_control),
        .result(alu_result),
        .zero_flag(zero_flag),
        .negative_flag(negative_flag),
        .overflow_flag(overflow_flag)
    );
    
    // Output assignments
    assign result_out = write_data;
    assign rsOut_out  = rsOut;
    
endmodule
