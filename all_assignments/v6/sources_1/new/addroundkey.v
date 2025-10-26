// Assignment 6
// Group 2
// Name : Parag Mahadeo Chimankar
// Name : Harshit Singhal

module add_round_key (
    input  wire [15:0] state_in,
    input  wire [15:0] round_key_in,
    output wire [15:0] state_out
);

    assign state_out = state_in ^ round_key_in;

endmodule