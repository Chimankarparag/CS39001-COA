module tb_rca_32;
    reg [31:0] A, B;
    reg Cin;
    wire [31:0] SUM;
    wire Cout;

    rca_32 UUT (
        .A(A), .B(B), .Cin(Cin),
        .SUM(SUM), .Cout(Cout)
    );

    initial begin
        A = 32'd100000; B = 32'd200000; Cin = 0;
        #10 A = 32'hFFFFFFFF; B = 32'd1; Cin = 0;
        #10 A = 32'd12345678; B = 32'd87654321; Cin = 1;
        #10 A = 32'd0; B = 32'd4294967295; Cin = 1;
    end
endmodule
