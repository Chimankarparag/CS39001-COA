`timescale 1ns / 1ps

module wrapper_module(
    input clk,             // 100 MHz board clock
    input rst_btn,         // reset button (active-high)
    input sw0,             // slide switch for direction
    output [3:0] led,      // 4 LEDs show counter value
    output led_dir         // extra LED shows direction
);
    wire slow_clk;
    wire [3:0] count;

    // Clock divider to get ~2 Hz slow clock
    clock_divider clkdiv(
        .clk(clk),
        .rst(rst_btn),
        .slow_clk(slow_clk)
    );

    // Up/Down counter
    updown_counter counter(
        .clk(slow_clk),
        .rst(rst_btn),
        .direction(sw0),
        .count(count),
        .mode_led(led_dir)
    );

    // Map counter value to LEDs
    assign led = count;
endmodule
