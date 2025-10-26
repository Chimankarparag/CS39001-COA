module tb_rca_64;
    reg [63:0] A, B;
    reg Cin;
    wire [63:0] SUM;
    wire Cout;

    rca_64 UUT (
        .A(A), .B(B), .Cin(Cin),
        .SUM(SUM), .Cout(Cout)
    );

    initial begin
        A = 64'd1234567890123456; B = 64'd9876543210123456; Cin = 0;
        #10 A = 64'hFFFFFFFFFFFFFFFF; B = 64'd1; Cin = 0;
        #10 A = 64'd10000000000000000; B = 64'd9999999999999999; Cin = 1;
        #10 A = 64'd0; B = 64'd18446744073709551615; Cin = 1;
    end
endmodule
