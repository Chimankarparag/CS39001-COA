module rca_32(
    input [31:0] A,
    input [31:0] B,
    input Cin,
    output [31:0] SUM,
    output Cout
);
    wire carry_out_16;

    rca_16 lower(
        .A(A[15:0]),
        .B(B[15:0]),
        .Cin(Cin),
        .SUM(SUM[15:0]),
        .Cout(carry_out_16)
    );

    rca_16 upper(
        .A(A[31:16]),
        .B(B[31:16]),
        .Cin(carry_out_16),
        .SUM(SUM[31:16]),
        .Cout(Cout)
    );
endmodule
