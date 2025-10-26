// Assignment 6
// Group 2
// Name : Parag Mahadeo Chimankar
// Name : Harshit Singhal

module mxcol (


    input  wire [15:0] state_in,
    output wire [15:0] state_out
);

    wire [3:0] n00 = state_in[15:12];
    wire [3:0] n01 = state_in[11:8];
    wire [3:0] n10 = state_in[7:4];
    wire [3:0] n11 = state_in[3:0];
    
    wire [3:0] one, two, three, four;

    function [3:0] mult_by_4;
        input [3:0] nibble_in;
        case (nibble_in)
        
            4'h0: mult_by_4 = 4'h0;
            4'h1: mult_by_4 = 4'h4;
            4'h2: mult_by_4 = 4'h8;
            4'h3: mult_by_4 = 4'hC;
            4'h4: mult_by_4 = 4'h3;
            4'h5: mult_by_4 = 4'h7;
            4'h6: mult_by_4 = 4'hB;
            4'h7: mult_by_4 = 4'hF;
            4'h8: mult_by_4 = 4'h6;
            4'h9: mult_by_4 = 4'h2;
            4'hA: mult_by_4 = 4'hE;
            4'hB: mult_by_4 = 4'hA;
            4'hC: mult_by_4 = 4'h5;
            4'hD: mult_by_4 = 4'h1;
            4'hE: mult_by_4 = 4'h9;
            4'hF: mult_by_4 = 4'hD;
            default: mult_by_4 = 4'h0;
        endcase
    endfunction

    assign one = n00 ^ mult_by_4(n10);
    assign two = mult_by_4(n00) ^ n10;
    
    assign three = n01 ^ mult_by_4(n11);
    assign four = mult_by_4(n01) ^ n11;
    
    assign state_out = {one, three, two, four};

endmodule