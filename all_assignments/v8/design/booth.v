// Verilog Assignment 8: Sequential Booth Multiplier
// Name : Parag Mahadeo Chimankar 23CS10049
// Name : Harshit Singhal 23CS10035

module booth(
    input clk,
    input rst,
    input [7:0] multiplicand,
    input [7:0] multiplier,
    output [15:0] product,
    output done
);

    wire load_registers;
    wire load_counter;
    wire add_operation;
    wire sub_operation;
    wire shift_enable;
    wire decrement_counter;
    wire counter_zero;
    wire [1:0] booth_bits;

    controlpath control_unit (
        .clk(clk),
        .rst(rst),
        .counter_zero(counter_zero),
        .booth_bits(booth_bits),
        .load_registers(load_registers),
        .load_counter(load_counter),
        .add_operation(add_operation),
        .sub_operation(sub_operation),
        .shift_enable(shift_enable),
        .decrement_counter(decrement_counter),
        .done(done)
    );

    datapath datapath_unit (
        .clk(clk),
        .rst(rst),
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .load_registers(load_registers),
        .load_counter(load_counter),
        .add_operation(add_operation),
        .sub_operation(sub_operation),
        .shift_enable(shift_enable),
        .decrement_counter(decrement_counter),
        .counter_zero(counter_zero),
        .booth_bits(booth_bits),
        .product(product)
    );

endmodule