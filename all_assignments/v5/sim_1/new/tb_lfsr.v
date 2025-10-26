module tb_lfsr;
    reg clk, rst, sel;
    reg [3:0] seed;
    wire [3:0] state;
    
    // Instantiate DUT
    lfsr dut(.clk(clk), .rst(rst), .sel(sel), .seed(seed), .state(state));
    
    // Clock gen (10ns period = 100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end
    

    
    initial begin
        // Initialize signals
        rst = 1; 
        sel = 0;  // Load mode
        seed = 4'b1111;
        
        
        // Hold reset for sufficient time
        #10;
        rst = 0;  // Release reset
       
        #20;
        
        sel = 1;
      
        
       
    end
endmodule