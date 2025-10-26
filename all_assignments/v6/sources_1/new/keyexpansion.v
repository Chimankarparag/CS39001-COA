// Assignment 6
// Group 2
// Name : Parag Mahadeo Chimankar
// Name : Harshit Singhal

// Assignment 6
// Group 2
// Name : Parag Mahadeo Chimankar
// Name : Harshit Singhal
module keyexpansion (
    input  wire [15:0] master_key_in,
    output wire [15:0] k0_out,
    output wire [15:0] k1_out,
    output wire [15:0] k2_out
);

    localparam RCON1 = 8'h80;
    localparam RCON2 = 8'h30;
    
    wire [7:0] w0, w1, w2, w3, w4, w5;
    
    function [3:0] s_box_lookup;
        input [3:0] nibble_in;
        case (nibble_in)
            4'h0: s_box_lookup = 4'h9;
            4'h1: s_box_lookup = 4'h4;
            4'h2: s_box_lookup = 4'hA;
            4'h3: s_box_lookup = 4'hB;
            4'h4: s_box_lookup = 4'hD;
            4'h5: s_box_lookup = 4'h1;
            4'h6: s_box_lookup = 4'h8;
            4'h7: s_box_lookup = 4'h5;
            4'h8: s_box_lookup = 4'h6;
            4'h9: s_box_lookup = 4'h2;
            4'hA: s_box_lookup = 4'h0;
            4'hB: s_box_lookup = 4'h3;
            4'hC: s_box_lookup = 4'hC;
            4'hD: s_box_lookup = 4'hE;
            4'hE: s_box_lookup = 4'hF;
            4'hF: s_box_lookup = 4'h7;
            default: s_box_lookup = 4'h0;
        endcase
    endfunction
    
    function [7:0] g_function;
        input [7:0] word_in;
        input [7:0] rcon_in;
        reg [7:0] rotated_word;
        reg [7:0] sub_word;
        
        begin
            rotated_word = {word_in[3:0], word_in[7:4]};
            sub_word = {s_box_lookup(rotated_word[7:4]), s_box_lookup(rotated_word[3:0])};
            g_function = sub_word ^ rcon_in;
        end
    endfunction

    assign w0 = master_key_in[15:8];
    assign w1 = master_key_in[7:0];
    assign k0_out = master_key_in;
    
    assign w2 = w0 ^ g_function(w1, RCON1);
    assign w3 = w2 ^ w1;
    assign k1_out = {w2, w3};

    assign w4 = w2 ^ g_function(w3, RCON2);
    assign w5 = w4 ^ w3;
    assign k2_out = {w4, w5};

endmodule