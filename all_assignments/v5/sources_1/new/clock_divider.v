`timescale 1ns / 1ps

// Group NO. = 2
// Name 1: Harshit Singhal 23CS10025
// Name 2: Parag Mahadeo Chimankar 23CS10049
// VerilogAssignment5

module clock_divider(
    input clk,          // 100 MHz clock
    input rst,
    output reg slow_clk // ~1 Hz clock
);
    reg [25:0] counter; // needs log2(50e6) ? 26 bits

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            slow_clk <= 0;
        end else begin
            if (counter == 50_000_000 - 1) begin
                counter <= 0;
                slow_clk <= ~slow_clk;
            end else begin
                counter <= counter + 1;
            end
        end
    end
endmodule
