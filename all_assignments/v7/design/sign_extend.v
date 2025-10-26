module sign_extend (
    input [15:0] imm16,
    input [1:0] mode,        // Add this missing port
    output reg [31:0] imm32  // Change to 'reg' for always block
);
    always @(*) begin
        case (mode)
            2'b00: imm32 = {{16{imm16[15]}}, imm16};  // Sign extend
            2'b01: imm32 = {16'h0000, imm16};         // Zero extend  
            2'b10: imm32 = {imm16, 16'h0000};         // Load upper immediate
            2'b11: imm32 = {{16{imm16[15]}}, imm16};  // Default sign extend
            default: imm32 = {{16{imm16[15]}}, imm16};
        endcase
    end
endmodule