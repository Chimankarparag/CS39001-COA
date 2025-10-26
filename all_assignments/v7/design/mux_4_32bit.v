module mux_4_32bit(
    input [31:0] d0,
    input [31:0] d1,
    input [31:0] d2,
    input [31:0] d3,
    input [1:0] sel,
    output reg [31:0] out
);
    always @(*) begin
        case(sel)
            2'b00: out = d0; // ALU result
            2'b01: out = d1; // Memory output
            2'b10: out = d2; // JAL value
            2'b11: out = d3; // CMOV value
            default: out = d0;
        endcase
    end
endmodule
