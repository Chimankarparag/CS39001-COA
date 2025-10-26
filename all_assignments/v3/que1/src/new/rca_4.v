module rca_4(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] SUM,
    output Cout
);
    wire [2:0] carry;

    full_adder FA0(A[0], B[0], Cin, SUM[0], carry[0]);
    full_adder FA1(A[1], B[1], carry[0], SUM[1], carry[1]);
    full_adder FA2(A[2], B[2], carry[1], SUM[2], carry[2]);
    full_adder FA3(A[3], B[3], carry[2], SUM[3], Cout);
endmodule
