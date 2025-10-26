// Verilog Assignment 8: Sequential Booth Multiplier
// Name : Parag Mahadeo Chimankar 23CS10049
// Name : Harshit Singhal 23CS10035

module counter_4bit(
    input clk,
    input rst,
    input load,
    input [3:0] load_value,
    input decrement,
    output reg [3:0] count,
    output zero_flag
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            count <= 4'b0;
        else if (load)
            count <= load_value;
        else if (decrement && count > 0)
            count <= count - 1;
    end

    assign zero_flag = (count == 4'b0);

endmodule