module alu_wrapper (
    input [31:0] operand_a,
    input [31:0] operand_b,
    input [3:0] alu_control,
    output [31:0] result,
    output zero_flag,
    output negative_flag,
    output overflow_flag
);

    // Map 4-bit control to 5-bit for your existing ALU
    wire [4:0] extended_control = {1'b0, alu_control};
    
    // Instantiate your existing ALU
    ALU main_alu (
        .operand_a(operand_a),
        .operand_b(operand_b),
        .alu_control(extended_control),
        .result(result),
        .zero_flag(zero_flag),
        .negative_flag(negative_flag),
        .overflow_flag(overflow_flag)
    );

endmodule