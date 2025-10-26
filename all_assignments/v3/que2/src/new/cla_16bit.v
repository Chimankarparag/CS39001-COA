module cla_16bit (
    input  [15:0] A, B,
    input  C0,
    output [15:0] S,
    output C16
);
    wire [3:0] P_block, G_block;
    wire [4:1] C_block;

    //  4-bit CLAs
    //this is our first level carry generator(c1,c2.c3.c4) generated in 4bit cla
    cla_4bit CLA0 (A[3:0],   B[3:0],   C0,       S[3:0],   , P_block[0], G_block[0]);
    cla_4bit CLA1 (A[7:4],   B[7:4],   C_block[1], S[7:4], , P_block[1], G_block[1]);
    cla_4bit CLA2 (A[11:8],  B[11:8],  C_block[2], S[11:8], , P_block[2], G_block[2]);
    cla_4bit CLA3 (A[15:12], B[15:12], C_block[3], S[15:12], C16, P_block[3], G_block[3]);

    // Lookahead Carry Unit
    //now we use it to second level to generate C4, C8 ,C12, C16 so we dont require time in rippling the carry
    lookahead_carry_unit LCU (P_block, G_block, C0, C_block);

endmodule
