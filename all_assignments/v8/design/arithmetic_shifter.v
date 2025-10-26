// Verilog Assignment 8: Sequential Booth Multiplier
// Name : Parag Mahadeo Chimankar 23CS10049
// Name : Harshit Singhal 23CS10035

module arithmetic_shifter(
    input [16:0] data_in,
    input shift_enable,
    output [16:0] data_out
);

    assign data_out = shift_enable ? 
                     {data_in[16], data_in[16:1]} : 
                     data_in;

endmodule