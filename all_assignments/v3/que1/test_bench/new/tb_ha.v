module tb_ha;
    reg in1, in2;
    wire out, cout;

    half_adder HA (
        .in1(in1),
        .in2(in2),
        .out(out),
        .cout(cout)
    );

    initial begin
        in1 = 0; in2 = 0;
        #10 in1 = 0; in2 = 1;
        #10 in1 = 1; in2 = 0;
        #10 in1 = 1; in2 = 1;
    end
endmodule
