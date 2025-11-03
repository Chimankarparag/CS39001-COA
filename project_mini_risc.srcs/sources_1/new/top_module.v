`timescale 1ns / 1ps

module top_module (
    input  wire         clk,
    input  wire         reset,
    input  wire [31:0]  pcIn, //updated nextPc
    output wire [31:0]  result_out,       // result output
    output wire [31:0]  rsOut_out,          // rs register value
    output wire [31:0]  ins
);
    
    // Instruction memory outputs
    wire [5:0]  opcode;
    wire [5:0]  funct;

    wire         zero_flag;
    wire         negative_flag;
    wire         overflow_flag;
    
    // Control signals
    wire [3:0]  alu_control;
    wire        alu_src;
    wire        wr_reg;
    wire        reg_dst;
    wire        immSel;
    wire        rdMem;
    wire        wrMem;
    wire        mToReg;
    wire  [2:0] brOp;
    wire        updPc;
       
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
        .brOp(brOp),
        .updPc(updPc)
    );
    
    // Instantiate datapath
    datapath dp (
        .clk(clk),
        .reset(reset),
        .updPc(updPc),
        .pcIn(pcIn),  //updated nextPc //updated nextPc

        .reg_dst(reg_dst),  // control signal rd or rt
        .wr_reg(wr_reg),
        
        .alu_control(alu_control),
        .alu_src(alu_src),
        .immSel(immSel),
        
        .rdMem(rdMem),        // Read from data memory
        .wrMem(wrMem),         // Write to data memory
        .mToReg(mToReg),
        
        .brOp(brOp),
        .opcode(opcode),
        .funct(funct),
        .result_out(result_out),
        .rsOut_out(rsOut_out),
        
        .ins(ins),
        
        .zero_flag(zero_flag),
        .negative_flag(negative_flag),
        .overflow_flag(overflow_flag)
    );
    
endmodule