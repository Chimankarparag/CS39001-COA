module incrementer (
    input [31:0] pc_in,
    output [31:0] npc
);
    assign npc = pc_in + 4;
endmodule