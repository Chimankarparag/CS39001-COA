module rca_16(
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] SUM,
    output Cout
);
    wire carry_out_8;

    rca_8 lower(
        .A(A[7:0]),
        .B(B[7:0]),
        .Cin(Cin),
        .SUM(SUM[7:0]),
        .Cout(carry_out_8)
    );

    rca_8 upper(
        .A(A[15:8]),
        .B(B[15:8]),
        .Cin(carry_out_8),
        .SUM(SUM[15:8]),
        .Cout(Cout)
    );
endmodule
