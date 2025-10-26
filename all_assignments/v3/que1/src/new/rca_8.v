module rca_8(
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] SUM,
    output Cout
);
    wire carry_out_4;

    rca_4 lower(
        .A(A[3:0]),
        .B(B[3:0]),
        .Cin(Cin),
        .SUM(SUM[3:0]),
        .Cout(carry_out_4)
    );

    rca_4 upper(
        .A(A[7:4]),
        .B(B[7:4]),
        .Cin(carry_out_4),
        .SUM(SUM[7:4]),
        .Cout(Cout)
    );
endmodule
