`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Group Number : 2
// Names : Parag Mahadeo Chimankar
//         Harshit Singhal
// Date: 06-08-2025
//////////////////////////////////////////////////////////////////////////////////


// Accumulator Module
module accumulator(
    input clk,
    input rst,
    input [3:0] In1,        // 4-bit input
    output [4:0] acc        // 5-bit accumulated output
);
    wire [4:0] dff_out;
    wire [4:0] add_out;

    // Instantiate 5-bit ripple carry adder
    ripple_carry_adder RCA(
        .A(dff_out),
        .B(In1),
        .SUM(add_out)
    );

    // Instantiate 5 D flip-flops
    genvar i;
    generate
        for (i = 0; i < 5; i = i + 1) begin : dff_gen
            dff d_inst(
                .in(add_out[i]),
                .out(dff_out[i]),
                .clk(clk),
                .rst(rst)
            );
        end
    endgenerate

    assign acc = dff_out;
endmodule
