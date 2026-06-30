`timescale 1ns / 1ps

module tb_pc;

    // Testbench signals
    reg clk;
    reg reset;
    reg [31:0] pcIn;
    wire [31:0] result_out;
    wire [31:0] rsOut_out;
    wire [31:0] ins;
    
    // Instantiate the DUT (Device Under Test)
    top_module uut (
        .clk(clk),
        .reset(reset),
        .pcIn(pcIn), //updated nextPc
        .result_out(result_out),
        .rsOut_out(rsOut_out),
        .ins(ins)
    );

    // Clock generation: 10ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;   // Toggle every 5ns
    end

    // Main simulation block
    initial begin
        // Initialize signals
        reset = 1;


        // Wait a few cycles with reset asserted
        #50;
        reset = 0;
        pcIn = 0;
        
        #50;

        $display("===========================================================");
        $display("Time\tPC\tInstruction\tResult\t\tRS_out");
        $display("===========================================================");

        // Provide PC values from 0 to 50
        repeat (20) begin
            @(posedge clk);
            $display("%0t\t%d\t%h\t%h\t%h", $time, pcIn, ins, result_out, rsOut_out);
            #50;
        end

        $display("===========================================================");
        $display("Simulation done at time %0t", $time);
        $display("===========================================================");
        $finish;
    end

    // Optional: monitor changes live
    initial begin
        $monitor("Time=%0t | PC=%d | ins=%h | result=%h | rsOut=%h",
                 $time, pcIn, ins, result_out, rsOut_out);
    end

endmodule
