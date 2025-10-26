module tb_rca_16;
    reg [15:0] A, B;
    reg Cin;
    wire [15:0] SUM;
    wire Cout;

    rca_16 UUT (
        .A(A), .B(B), .Cin(Cin),
        .SUM(SUM), .Cout(Cout)
    );

    initial begin
        A = 16'd12345; B = 16'd5432; Cin = 0;
        #10 A = 16'd65535; B = 16'd1; Cin = 0;
        #10 A = 16'd30000; B = 16'd30000; Cin = 1;
        #10 A = 16'd10000; B = 16'd20000; Cin = 1;
    end
endmodule
