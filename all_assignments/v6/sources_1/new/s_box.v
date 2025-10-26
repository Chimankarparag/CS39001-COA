// Assignment 6
// Group 2
// Name : Parag Mahadeo Chimankar
// Name : Harshit Singhal

module s_box (
    input  wire        clk,
    input  wire [15:0] state_in,
    output wire [15:0] state_out
);

    // Instantiate the S-Box ROM four times, one for each nibble.
    // Clock (clka) and enable (ena) ports are now connected.
    
    sbox_rom sbox_inst_3 (
        .clka(clk),
        .ena(1'b1),
        .addra(state_in[15:12]),
        .douta(state_out[15:12])
    );

    sbox_rom sbox_inst_2 (
        .clka(clk),
        .ena(1'b1),
        .addra(state_in[11:8]),
        .douta(state_out[11:8])
    );

    sbox_rom sbox_inst_1 (
        .clka(clk),
        .ena(1'b1),
        .addra(state_in[7:4]),
        .douta(state_out[7:4])
    );

    sbox_rom sbox_inst_0 (
        .clka(clk),
        .ena(1'b1),
        .addra(state_in[3:0]),
        .douta(state_out[3:0])
    );

endmodule