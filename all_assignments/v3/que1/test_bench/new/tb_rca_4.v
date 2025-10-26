module tb_rca_4;
    reg [3:0] A, B;
    reg Cin;
    wire [3:0] SUM;
    wire Cout;

    rca_4 UUT (
        .A(A), .B(B), .Cin(Cin),
        .SUM(SUM), .Cout(Cout)
    );

    initial begin
        A = 4'd3; B = 4'd2; Cin = 0;
        #10 A = 4'd7; B = 4'd8; Cin = 1;
        #10 A = 4'd15; B = 4'd1; Cin = 0;
        #10 A = 4'd10; B = 4'd5; Cin = 1;
    end
endmodule
