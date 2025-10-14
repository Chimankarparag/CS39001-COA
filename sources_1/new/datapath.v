module datapath (
    input  wire         clk,
    input  wire         reset,
    // Register file interface
    input  wire [3:0]   rs_addr,
    input  wire [3:0]   rt_addr,
    input  wire [3:0]   rd_addr,
    input  wire         reg_dst,          // which reg to store the value
    input  wire         wr_reg,           // write enable for register file
    // ALU interface
    input  wire [3:0]   alu_control,      // 4-bit ALU control
    input  wire         alu_src,          // 1 => pick rtOut, 0 => pick imm
    input  wire         immSel,
    input  wire [31:0]  imm_signed,          // sign-extended immediate
    input  wire [31:0]  jmp_signed,          // sign-extended immediate
    
    // Data Control Signals
    input  wire        rdMem,
    input  wire        wrMem,
    input  wire        mToReg,
    
    // Outputs
    output wire [31:0]  result_out,   // ALU result
    output wire [31:0]  rsOut_out,        // rs register value
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
    
    //Data Mem
    data_mem Data_memory(
        .clk(clk),
        .reset(reset),
        .addr(alu_result),
        .wrData(rtOut),
        .rdMem(rdMem),
        .wrMem(wrMem),
        .rdData(rdData)
    );
    
    // MUX
    assign dest_reg  = (reg_dst) ? rd_addr : rt_addr;
    
    // Instantiate register bank
    reg_bank regs (
        .clk(clk),
        .reset(reset),
        .wrReg(wr_reg),
        .rs(rs_addr),
        .rt(rt_addr),
        .rd(rd_addr),
        .rdIn(result_out),      // Write ALU result to register
        .rsOut(rsOut),
        .rtOut(rtOut)
    );
    
    // MUX 
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
    assign result_out = (mToReg) ? rdData : alu_result;
    // if memory to reg -> send the memory data
    
    assign rsOut_out      = rsOut;
    
endmodule
