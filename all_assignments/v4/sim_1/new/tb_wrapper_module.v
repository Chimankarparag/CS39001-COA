`timescale 1ns / 1ps

module tb_wrapper_module;
    // Testbench signals
    reg clk;
    reg rst_btn;
    reg sw0;
    wire [3:0] led;

    // DUT instance
    wrapper_module dut (
        .clk(clk),
        .rst_btn(rst_btn),
        .sw0(sw0),
        .led(led)
    );

    // Clock generation (100 MHz -> 10 ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Stimulus
    initial begin
        // Initialize
        rst_btn = 1;
        sw0 = 1;   // start with count up
        #50;
        
        // Release reset
        rst_btn = 0;

        // Let it count up for a while
        #2000;

        // Switch to down count
        sw0 = 0;
        #2000;

        // Back to up count
        sw0 = 1;
        #2000;

        // Apply reset in middle
        rst_btn = 1; #50; rst_btn = 0;
        #2000;

     
    end
endmodule
