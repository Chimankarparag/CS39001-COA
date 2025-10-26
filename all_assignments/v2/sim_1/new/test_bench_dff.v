`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// 
//////////////////////////////////////////////////////////////////////////////////


module test_bench_dff();


    reg clk;
    reg rst;
    reg in;
    wire out;


    dff uut (
        .in(in),
        .out(out),
        .clk(clk),
        .rst(rst)
    );


    always #5 clk = ~clk;


    initial begin
        clk = 0;
        rst = 1;    // Start with reset
        in = 0;

    
        #12 rst = 0;    

       
        #8  in = 1;     // Apply input just before rising edge
        #10 in = 0;    
        #10 in = 1;     
        #10 in = 1;

      
        #5  rst = 1;    // Asynchronous reset
        #10 rst = 0;   

       
        #10 in = 0;
        #10 in = 1;

        
    end

endmodule



