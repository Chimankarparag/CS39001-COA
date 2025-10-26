`timescale 1ns / 1ps

// Group NO. = 2
// Name 1: Harshit Singhal 23CS10025
// Name 2: Parag Mahadeo Chimankar 23CS10049
// VerilogAssignment5

// 2x1 Multiplexer

module mux(
    input d_inp,      // when sel=1
    input seed_inp,      // when sel=0
    input sel,
    output out
);
    assign out = sel ? d_inp : seed_inp; 
endmodule
