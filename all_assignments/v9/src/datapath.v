
`timescale 1ns / 1ps
module datapath (
    input  wire         clk,
    input  wire         reset,
    // register file interface
    input  wire [3:0]   rs_addr,
    input  wire [3:0]   rt_addr,
    input  wire [3:0]   rd_addr,
    input  wire         wrReg,            // write enable for register file
    input  wire         m_to_reg,         // 1 -> write data from memory, 0 -> ALU result
    input  wire [31:0]  mem_data_in,      // data loaded from data memory
    // ALU
    input  wire [3:0]   alu_control,      // 4-bit ALU control (mapped inside wrapper)
    input  wire         alu_src,          // 1 => pick rtOut, 0 => pick imm
    input  wire [31:0]  imm_ext,          // sign-extended immediate
    output wire [31:0]  alu_result_out,   // expose ALU result (for data memory addressing/debug)
    output wire [31:0]  rsOut_out,        // expose rsOut for branch decisions/debug
    output wire [31:0]  writeback_data    // actual data fed to regfile rd on write
);

    wire [31:0] rsOut, rtOut;
    wire [31:0] alu_operand_b;
    wire [31:0] alu_result;
    wire zero_flag, negative_flag, overflow_flag;

    // instantiate register bank
    reg_bank regs (
        .clk(clk),
        .reset(reset),
        .wrReg(wrReg),
        .rs(rs_addr),
        .rt(rt_addr),
        .rd(rd_addr),
        .rdIn(writeback_data),
        .rsOut(rsOut),
        .rtOut(rtOut)
    );

    // ALU operand B selection: alu_src = 1 selects rtOut, 0 selects immediate
    assign alu_operand_b = (alu_src) ? rtOut : imm_ext;

    alu_wrapper ALUinst (
        .operand_a(rsOut),
        .operand_b(alu_operand_b),
        .alu_control(alu_control),
        .result(alu_result),
        .zero_flag(zero_flag),
        .negative_flag(negative_flag),
        .overflow_flag(overflow_flag)
    );

    assign alu_result_out = alu_result;
    assign rsOut_out     = rsOut;

    assign writeback_data = (m_to_reg) ? mem_data_in : alu_result;

endmodule
