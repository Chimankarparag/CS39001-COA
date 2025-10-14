`timescale 1ns / 1ps

module top_module (
    input  wire         clk,
    input  wire         reset,
    input  wire [31:0]  pcIn,
    output wire [31:0]  result_out,       // result output
    output wire [31:0]  rs_value,         // rs register value
    output wire         zero_flag,
    output wire         negative_flag,
    output wire         overflow_flag
);
    
    wire [31:0] pcOut;
    
    // Instruction memory outputs
    wire [5:0]  opcode;
    wire [5:0]  funct;
    wire [3:0]  rs;
    wire [3:0]  rt;
    wire [3:0]  rd;
    wire [31:0] imm_signed;
    wire [31:0] jmp_signed;
    
    // Control signals
    wire [3:0]  alu_control;
    wire        alu_src;
    wire        wr_reg;
    wire        reg_dst;
    wire        immSel;
    wire        rdMem;
    wire        wrMem;
    wire        mToReg;
    wire        updPc;
    
    program_counter pc(
        .clk(clk),
        .reset(reset),
        .updPc(updPc),
        .pcIn(pcIn),
        .pcOut(pcOut)
    );
    
    // Instantiate instruction memory
    instruction_memory inst_mem (
        .pcOut(pcOut),
        .opcode(opcode),
        .funct(funct),
        .rs(rs),
        .rt(rt),
        .rd(rd),
        .imm_signed(imm_signed),
        .jmp_signed(jmp_signed)
    );
    
    // Instantiate control path
    controlpath ctrl (
        .opcode(opcode),
        .funct(funct),
        .alu_control(alu_control),
        .alu_src(alu_src),
        .immSel(immSel),
        .wr_reg(wr_reg),
        .reg_dst(reg_dst),
        .rdMem(rdMem),        // Read from data memory
        .wrMem(wrMem),         // Write to data memory
        .mToReg(mToReg),
        .updPc(updPc)
    );
    
    // Instantiate datapath
    datapath dp (
        .clk(clk),
        .reset(reset),
        .rs_addr(rs),
        .rt_addr(rt),
        .rd_addr(rd),
        .reg_dst(reg_dst),  // control signal rd or rt
        .wr_reg(wr_reg),
        
        .alu_control(alu_control),
        .alu_src(alu_src),
        .immSel(immSel),
        .imm_signed(imm_signed),
        .jmp_signed(jmp_signed),
        
        .rdMem(rdMem),        // Read from data memory
        .wrMem(wrMem),         // Write to data memory
        .mToReg(mToReg),
        
        .result_out(result_out),
        .rsOut_out(rs_value),
        
        .zero_flag(zero_flag),
        .negative_flag(negative_flag),
        .overflow_flag(overflow_flag)
    );
    
endmodule