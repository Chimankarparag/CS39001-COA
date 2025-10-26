// Verilog Assignment 8: Sequential Booth Multiplier
// Name : Parag Mahadeo Chimankar 23CS10049
// Name : Harshit Singhal 23CS10035

module booth_wrapper_for_fpga(
    input clk,                    // 100MHz system clock
    input rst,                    // Active-high reset (center button)
    input [7:0] multiplicand,     // SW7 down to SW0
    input [7:0] multiplier,       // SW15 down to SW8
    output [15:0] product         // LED15 down to LED0
);

    wire done_internal;

    booth booth_mult_inst (
        .clk(clk),
        .rst(rst),
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .product(product),
        .done(done_internal)
    );

endmodule