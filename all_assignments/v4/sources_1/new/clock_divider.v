`timescale 1ns / 1ps


module clock_divider(
    input clk,          // 100 MHz clock
    input rst,
    output reg slow_clk // ~2 Hz clock
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
