module mux_2_5bit(
    input [4:0] d0,
    input [4:0] d1,
    input sel,
    output [4:0] out
);
    assign out = sel ? d1 : d0;
endmodule
