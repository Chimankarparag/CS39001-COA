`timescale 1ns / 1ps

module tb_top_module;

    //==========================================================================
    // TESTBENCH SIGNALS
    //==========================================================================
    reg clk;
    reg reset;
    reg [31:0] pcIn;

    wire [31:0] result_out;
    wire [31:0] rsOut_out;
    wire [31:0] ins;

    //==========================================================================
    // DEVICE UNDER TEST (DUT)
    //==========================================================================
    top_module uut (
        .clk(clk),
        .reset(reset),
        .pcIn(pcIn),
        .result_out(result_out),
        .rsOut_out(rsOut_out),
        .ins(ins)
    );

    //==========================================================================
    // CLOCK GENERATION (10ns period → 100 MHz)
    //==========================================================================
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    //==========================================================================
    // MAIN TEST SEQUENCE
    //==========================================================================
    initial begin
        // Initialize signals
        reset = 1;
        

        $display("\n===========================================================");
        $display("               RISC PROCESSOR TEST - SIMPLE RUN            ");
        $display("===========================================================");
        $display("Time(ns)\tPC\tInstruction\tResult\t\tRS_out");
        $display("-----------------------------------------------------------");

        // Apply reset
        #20;
        reset = 0;  // Release reset
        pcIn = 0;
        #100;
        // Drive PC from 0 → 50
        repeat (51) begin
            @(posedge clk);
            $display("--- %0t\t%0d\t%08h\t%08h\t%08h ---", 
                     $time, pcIn, ins, result_out, rsOut_out);
           // pcIn = pcIn + 1;  // Increment PC manually each cycle
            #10;               // Wait between steps
        end

        $display("-----------------------------------------------------------");
        $display("Simulation completed at %0t ns", $time);
        $display("===========================================================\n");

        $finish;
    end

    //==========================================================================
    // OPTIONAL: MONITOR FOR REAL-TIME VIEW
    //==========================================================================
    initial begin
        $monitor("Time=%0t | PC=%0d | ins=%08h | result=%08h | rsOut=%08h",
                 $time, pcIn, ins, result_out, rsOut_out);
    end

    //==========================================================================
    // WAVEFORM DUMP
    //==========================================================================
    initial begin
        $dumpfile("tb_top_module.vcd");
        $dumpvars(0, tb_top_module);
        $dumpvars(0, uut);
    end

endmodule
