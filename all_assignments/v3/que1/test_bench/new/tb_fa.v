module tb_fa;
    reg in1, in2, cin;
    wire out, cout;

    full_adder FA (
        .in1(in1),
        .in2(in2),
        .cin(cin),
        .out(out),
        .cout(cout)
    );

    initial begin
        in1 = 0; in2 = 0; cin = 0;
        #10 in1 = 0; in2 = 1; cin = 0;
        #10 in1 = 1; in2 = 0; cin = 0;
        #10 in1 = 1; in2 = 1; cin = 0;
        #10 in1 = 1; in2 = 1; cin = 1;
    end
endmodule
