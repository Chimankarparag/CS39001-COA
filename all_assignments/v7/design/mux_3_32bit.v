module mux_3_32bit(
    input [31:0] d0,
    input [31:0] d1,
    input [31:0] d2,
    input [1:0] sel,          // 2-bit select (values: 00, 01, 10)
    output reg [31:0] out
);
    always @(*) begin
        case(sel)
            2'b00: out = d0;
            2'b01: out = d1;
            2'b10: out = d2;
            default: out = 32'h0; // unused case (sel=11)
        endcase
    end
endmodule

