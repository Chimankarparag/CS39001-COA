`timescale 1ns / 1ps

module program_counter(
    input  wire         clk,
    input  wire         reset,
    input  wire         updPc,
    input  wire [31:0]  pcIn,
    output reg [31:0]   pcOut
    );
    
    always @(posedge clk, posedge reset)
    begin
        if(reset) begin
            pcOut <= 0;
        end
        else if (updPc) begin
          // $display("UPDATING PC to %d", pcIn);
            pcOut <= pcIn;
        end
    end
endmodule
