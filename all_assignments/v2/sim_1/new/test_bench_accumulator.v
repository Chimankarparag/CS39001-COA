`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Create Date: 06.08.2025 14:05:41

// Group Number : 2
// Names : Parag Mahadeo Chimankar
//         Harshit Singhal
// Date: 06-08-2025
//////////////////////////////////////////////////////////////////////////////////


module test_bench_accumulator();


    reg clk;
    reg rst;
    reg [3:0] In1;
    wire [4:0] acc;


    accumulator uut (
        .clk(clk),
        .rst(rst),
        .In1(In1),
        .acc(acc)
    );


    always #5 clk = ~clk;  //time period 10 ns
    

    initial begin

        clk = 0;
        rst = 1;         // Assert reset
        In1 = 4'd0;


        #12;
        rst = 0;         // Deassert reset
       
    end
 
 //CALLING BY LOOP
 
    //this always is for single bit input
    always @(posedge clk) begin
 

        if (!rst) begin
            In1 <= $random%2 + 5'b10000;
             // Keep adding 1 every clock cycle
            if (acc == 5'b11111) begin // Call it asyncronously , on the basis of condition when all bits are full
                In1<=4'b0000;
                rst=1;
                #12 rst=0; // after it is reset off the rst
            end
             
        end

    end
    
    
    //CALLED MANUALLAY
    
    /*
    
    initial begin
        // Input sequence
        #10 In1 = 4'd3;  // acc = 3
        #10 In1 = 4'd4;  // acc = 7
        #10 In1 = 4'd1;  // acc = 8
        #10 In1 = 4'd6;  // acc = 14
        #10 In1 = 4'd2;  // acc = 16
        #10 In1 = 4'd5;  // acc = 21

        // Reset accumulator
        #10 rst = 1;
        #10 rst = 0;
        In1 = 4'd0;

        // More accumulation
        #10 In1 = 4'd7;  // acc = 7
        #10 In1 = 4'd3;  // acc = 10
        #10 In1 = 4'd8;  // acc = 18
    
    end
*/

endmodule
