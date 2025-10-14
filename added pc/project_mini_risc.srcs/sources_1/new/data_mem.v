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

    initial begin
        $readmemh("data_mem.mem", mem);   // reads hex file at simulation start
    end
    always @(posedge clk, posedge reset) begin
        if(reset) begin
 
            mem[0] <= 32'd44;
            mem[1] <= 32'b11111111111111111111111111110100; // -12
            mem[2] <= 32'b11111111111111111111111111110100; // -12
            mem[3] <= 32'd0;
            mem[4] <= 32'd1;
            mem[5] <= 32'd1;
            mem[6] <= 32'd999;
            mem[7] <= 32'd8;
            mem[8] <= 32'd101;
            mem[9] <= 32'd540;

           
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
