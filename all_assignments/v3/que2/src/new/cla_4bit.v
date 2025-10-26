`timescale 1ns / 1ps

module cla_4bit (
    input  [3:0] A, B,
    input  C0,
    output [3:0] S,
    output C4,
    output P_block, G_block
);
    wire [3:0] P, G;
    wire C1, C2, C3;
    wire t1, t2, t3, t4, t5, t6, t7, t8;

//store thy P here , Where we compute P as  Pi = Ai ^ Bi
    xor (P[0], A[0], B[0]);
    xor (P[1], A[1], B[1]);
    xor (P[2], A[2], B[2]);
    xor (P[3], A[3], B[3]);
    
 //store thy G here , Where we compute G as  Gi = Ai & Bi

    and (G[0], A[0], B[0]);
    and (G[1], A[1], B[1]);
    and (G[2], A[2], B[2]);
    and (G[3], A[3], B[3]);

    // Carry equations
    // for any Ci+1 = Gi + Pi & Ci
    
    // C1 = G0 + P0&C0
    and (t1, P[0], C0);
    or  (C1, G[0], t1);

    // C2 = G1 + P1&G0 + P1&P0&C0
    and (t2, P[1], G[0]);
    and (t3, P[1], P[0], C0);
    or  (C2, G[1], t2, t3);

    // C3 = G2 + P2&G1 + P2&P1&G0 + P2&P1&P0&C0
    and (t4, P[2], G[1]);
    and (t5, P[2], P[1], G[0]);
    and (t6, P[2], P[1], P[0], C0);
    or  (C3, G[2], t4, t5, t6);

    // C4 = G3 + P3&G2 + P3&P2&G1 + P3&P2&P1&G0 + P3&P2&P1&P0&C0
    and (t7, P[3], G[2]);
    and (t8, P[3], P[2], G[1]);
    wire t9, t10;
    and (t9, P[3], P[2], P[1], G[0]);
    and (t10, P[3], P[2], P[1], P[0], C0);
    or  (C4, G[3], t7, t8, t9, t10);

    // Sum bits: S[i] = P[i] ^ C[i]
    
    xor (S[0], P[0], C0);
    xor (S[1], P[1], C1);
    xor (S[2], P[2], C2);
    xor (S[3], P[3], C3);

    // P_block = P3 & P2 & P1 & P0
    // we need this block when we lookahead for 16bit
   
    and (P_block, P[3], P[2], P[1], P[0]);

    //  G_block = G3 + P3&G2 + P3&P2&G1 + P3&P2&P1&G0
    wire t11, t12, t13;
    and (t11, P[3], G[2]);
    and (t12, P[3], P[2], G[1]);
    and (t13, P[3], P[2], P[1], G[0]);
    or  (G_block, G[3], t11, t12, t13);

endmodule
