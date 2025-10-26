// Assignment 6
// Group 2
// Name : Parag Mahadeo Chimankar
// Name : Harshit Singhal

module shift (
    input  wire [15:0] state_in,
    output wire [15:0] state_out
);

    assign state_out = {state_in[15:12], state_in[11:8], state_in[3:0], state_in[7:4]};

endmodule