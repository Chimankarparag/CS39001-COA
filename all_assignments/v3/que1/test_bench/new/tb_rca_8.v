module tb_rca_8;
    reg [7:0] A, B;
    reg Cin;
    wire [7:0] SUM;
    wire Cout;

    rca_8 UUT (
        .A(A), .B(B), .Cin(Cin),
        .SUM(SUM), .Cout(Cout)
    );

    initial begin
        A = 8'd100; B = 8'd28; Cin = 0;
        #10 A = 8'd255; B = 8'd1; Cin = 0;
        #10 A = 8'd50; B = 8'd100; Cin = 1;
        #10 A = 8'd200; B = 8'd55; Cin = 1;
    end
endmodule
