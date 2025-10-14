`timescale 1ns / 1ps


// whole new
module data_mem(
    input wire reset,clk,
    input [31:0]  addr, // from ALU result
    input [31:0]  wrData, //take from register == rtOut
    input rdMem, //oontrol signal
    input wrMem, // control signal
    output reg [31:0] rdData // OUTPUT  passed to the mux
    );
    
    reg signed [31:0] mem [0:1023];  //1024 locations

    always @(posedge clk, posedge reset) begin
        if(reset) begin
           $readmemh("data_bram.mem", mem);   // reads hex file at simulation start
        end
        else begin
            if(wrMem) begin
                mem[addr[9:0]] <= wrData;
            end
            if(rdMem) begin
                rdData <= mem[addr[9:0]];
            end
        end
    end


    

endmodule