module rca_64(
    input [63:0] A,
    input [63:0] B,
    input Cin,
    output [63:0] SUM,
    output Cout
);
    wire carry_out_32;

    rca_32 lower(
        .A(A[31:0]),
        .B(B[31:0]),
        .Cin(Cin),
        .SUM(SUM[31:0]),
        .Cout(carry_out_32)
    );

    rca_32 upper(
        .A(A[63:32]),
        .B(B[63:32]),
        .Cin(carry_out_32),
        .SUM(SUM[63:32]),
        .Cout(Cout)
    );
endmodule
