`timescale 1ns/1ps

module tb_add_sub_and_or_not_xor_nor_32bit;

    // Test inputs
    reg  [31:0] A, B;
    reg  Cin, Bin;

    // Outputs
    wire [31:0] SUM, Diff;
    wire Cout, Bout;
    wire [31:0] AND_out, OR_out, XOR_out, NOR_out, NOT_out;

    // Instantiate 32-bit Adder
    full_adder_32bit U1 (
        .A(A),
        .B(B),
        .Cin(Cin),
        .SUM(SUM),
        .Cout(Cout)
    );

    // Instantiate 32-bit Subtractor
    full_subtractor_32bit U2 (
        .A(A),
        .B(B),
        .Bin(Bin),
        .Diff(Diff),
        .Bout(Bout)
    );

    // Instantiate Logic Gates
    and_gate_32_bit U3 (
        .n1(A),
        .n2(B),
        .out(AND_out)
    );

    or_gate_32_bit U4 (
        .n1(A),
        .n2(B),
        .out(OR_out)
    );

    xor_gate_32_bit U5 (
        .n1(A),
        .n2(B),
        .out(XOR_out)
    );

    nor_gate_32bit U6 (
        .n1(A),
        .n2(B),
        .out(NOR_out)
    );

    not_gate_32_bit U7 (
        .inp(A),
        .out(NOT_out)
    );

    // Test procedure
    initial begin
        $display("=== 32-bit ADD, SUB, AND, OR, XOR, NOR, NOT Testbench ===");
        $monitor("T=%0t | A=%h B=%h | Cin=%b Bin=%b | SUM=%h Cout=%b | Diff=%h Bout=%b | AND=%h OR=%h XOR=%h NOR=%h NOT(A)=%h",
                  $time, A, B, Cin, Bin, SUM, Cout, Diff, Bout, AND_out, OR_out, XOR_out, NOR_out, NOT_out);

        // Test case 1
        A = 32'h0000000F; B = 32'h00000001; Cin = 0; Bin = 0;
        #10;

        // Test case 2
        A = 32'hAAAAAAAA; B = 32'h55555555; Cin = 1; Bin = 1;
        #10;

        // Test case 3
        A = 32'hFFFFFFFF; B = 32'h00000001; Cin = 1; Bin = 0;
        #10;

        // Test case 4
        A = 32'h12345678; B = 32'h87654321; Cin = 0; Bin = 1;
        #10;

        // Test case 5 (random)
        A = $random; B = $random; Cin = 0; Bin = 0;
        #10;

        $display("=== Test Complete ===");
        $finish;
    end

endmodule
