`timescale 1ns / 1ps
module tb_cla_16bit;
    reg [15:0] A, B;
    reg C0;
    wire [15:0] S;
    wire C16;

    cla_16bit uut (A, B, C0, S, C16);
    

    initial begin
        
        A = 16'h1234; B = 16'h4321; C0 = 0; #10;
        A = 16'hAAAA; B = 16'h5555; C0 = 1; #10;
        A = 16'hFFFF; B = 16'h0001; C0 = 0; #10;
        A = 16'd12345; B = 16'd5432; C0 = 0;
        #10 A = 16'd65535; B = 16'd1; C0 = 0;
        #10 A = 16'd30000; B = 16'd30000; C0 = 1;
        #10 A = 16'd10000; B = 16'd20000; C0 = 1;
       
    end
endmodule
