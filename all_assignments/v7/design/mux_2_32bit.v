module mux_2_32bit(
    input [31:0] d0,
    input [31:0] d1, 
    input sel,
    output [31:0] out
);
    assign out = sel ? d1 : d0;
endmodule