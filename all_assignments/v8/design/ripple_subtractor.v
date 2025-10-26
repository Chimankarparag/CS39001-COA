// Verilog Assignment 8: Sequential Booth Multiplier
// Name : Parag Mahadeo Chimankar 23CS10049
// Name : Harshit Singhal 23CS10035

module ripple_subtractor(
    input [7:0] a,
    input [7:0] b,
    output [7:0] diff,
    output bout
);

    wire [7:0] b_complement;
    wire cout;

    // Two's complement: invert b and add 1
    assign b_complement = ~b;

    ripple_adder sub_adder (
        .a(a),
        .b(b_complement),
        .cin(1'b1),  // Add 1 for two's complement
        .sum(diff),
        .cout(cout)
    );

    assign bout = ~cout;  // Borrow is complement of carry

endmodule