`timescale 1ns / 1ps
module lookahead_carry_unit (
    input  [3:0] P_block, G_block,
    input  C0,
    output [4:1] C
);

// actually here the C arrey is for the computed c4,c8,c12,c16 which this second level generates
//same procedure

    // For C1 = G0 + P0&C0
    wire t1;
    and (t1, P_block[0], C0);
    or  (C[1], G_block[0], t1);

    // For C2 = G1 + P1&G0 + P1&P0&C0
    wire t2, t3;
    and (t2, P_block[1], G_block[0]);
    and (t3, P_block[1], P_block[0], C0);
    or  (C[2], G_block[1], t2, t3);

    // For C3 = G2 + P2&G1 + P2&P1&G0 + P2&P1&P0&C0
    wire t4, t5, t6;
    and (t4, P_block[2], G_block[1]);
    and (t5, P_block[2], P_block[1], G_block[0]);
    and (t6, P_block[2], P_block[1], P_block[0], C0);
    or  (C[3], G_block[2], t4, t5, t6);

    // For C4 = G3 + P3&G2 + P3&P2&G1 + P3&P2&P1&G0 + P3&P2&P1&P0&C0
    wire t7, t8, t9, t10;
    and (t7, P_block[3], G_block[2]);
    and (t8, P_block[3], P_block[2], G_block[1]);
    and (t9, P_block[3], P_block[2], P_block[1], G_block[0]);
    and (t10, P_block[3], P_block[2], P_block[1], P_block[0], C0);
    or  (C[4], G_block[3], t7, t8, t9, t10);

endmodule
