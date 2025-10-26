`timescale 1ns / 1ps

// Verilog Assignment 8: Sequential Booth Multiplier Testbench
// Name : Parag Mahadeo Chimankar 23CS10049
// Name : Harshit Singhal 23CS10035

module tb_booth();

    reg clk;
    reg rst;
    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    wire [15:0] product;
    wire done;

    wire signed [15:0] expected_product;
    assign expected_product = $signed(multiplicand) * $signed(multiplier);
    booth uut (
        .clk(clk),
        .rst(rst),
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .product(product),
        .done(done)
    );
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  
    end


    initial begin

        rst = 1;
        multiplicand = 0;
        multiplier = 0;

        #20;
        rst = 0;
        multiplicand = 8'd5;    // 5
        multiplier = 8'd3;      // 3
        
        $display("Test 1: 5 * 3 = %d", expected_product);
        $display("Time = %t, Starting multiplication: %d * %d", $time, $signed(multiplicand), $signed(multiplier));
        
        
        wait(done);
        #10;
        
        $display("Time = %t, Result: %d, Expected: %d", $time, $signed(product), expected_product);
        if (product == expected_product)
            $display("Test 1: PASSED");
        else
            $display("Test 1: FAILED");
        
        #20
        
        
        rst = 1;
        #10;
        rst = 0;
        multiplicand = -8'd7;   // -7
        multiplier = 8'd4;      // 4
        
        $display("\nTest 2: -7 * 4 = %d", expected_product);
        $display("Time = %t, Starting multiplication: %d * %d", $time, $signed(multiplicand), $signed(multiplier));
        
        wait(done);
        #10;
        
        $display("Time = %t, Result: %d, Expected: %d", $time, $signed(product), expected_product);
        if (product == expected_product)
            $display("Test 2: PASSED");
        else
            $display("Test 2: FAILED");
        
        #20;
        
        
        rst = 1;
        #10;
        rst = 0;
        multiplicand = 8'd6;    // 6
        multiplier = -8'd5;     // -5
        
        $display("\nTest 3: 6 * (-5) = %d", expected_product);
        $display("Time = %t, Starting multiplication: %d * %d", $time, $signed(multiplicand), $signed(multiplier));
        
        wait(done);
        #10;
        
        $display("Time = %t, Result: %d, Expected: %d", $time, $signed(product), expected_product);
        if (product == expected_product)
            $display("Test 3: PASSED");
        else
            $display("Test 3: FAILED");
        
        #20;
        
        
        rst = 1;
        #10;
        rst = 0;
        multiplicand = -8'd8;   // -8
        multiplier = -8'd3;     // -3
        
        $display("\nTest 4: (-8) * (-3) = %d", expected_product);
        $display("Time = %t, Starting multiplication: %d * %d", $time, $signed(multiplicand), $signed(multiplier));
        
        wait(done);
        #10;
        
        $display("Time = %t, Result: %d, Expected: %d", $time, $signed(product), expected_product);
        if (product == expected_product)
            $display("Test 4: PASSED");
        else
            $display("Test 4: FAILED");
        
        #20;
        
        
        rst = 1;
        #10;
        rst = 0;
        multiplicand = 8'd15;   // 15
        multiplier = 8'd0;      // 0
        
        $display("\nTest 5: 15 * 0 = %d", expected_product);
        $display("Time = %t, Starting multiplication: %d * %d", $time, $signed(multiplicand), $signed(multiplier));
        
        wait(done);
        #10;
        
        $display("Time = %t, Result: %d, Expected: %d", $time, $signed(product), expected_product);
        if (product == expected_product)
            $display("Test 5: PASSED");
        else
            $display("Test 5: FAILED");
        
        #20;
        
        
        rst = 1;
        #10;
        rst = 0;
        multiplicand = 8'd127;  // 127 (max positive 8-bit)
        multiplier = 8'd1;      // 1
        
        $display("\nTest 6: 127 * 1 = %d", expected_product);
        $display("Time = %t, Starting multiplication: %d * %d", $time, $signed(multiplicand), $signed(multiplier));
        
        wait(done);
        #10;
        
        $display("Time = %t, Result: %d, Expected: %d", $time, $signed(product), expected_product);
        if (product == expected_product)
            $display("Test 6: PASSED");
        else
            $display("Test 6: FAILED");
        
        #50;
        
        $display("\n=== All tests completed ===");
        $finish;
    end

    
    initial begin
        $monitor("Time = %t, Counter = %d, A = %d, Q = %d, Q-1 = %b, Booth = %b, Product = %d, Done = %b", 
                 $time, 
                 uut.datapath_unit.counter_value,
                 $signed(uut.datapath_unit.reg_A), 
                 $signed(uut.datapath_unit.reg_Q), 
                 uut.datapath_unit.q_minus_1,
                 uut.datapath_unit.booth_bits,
                 $signed(product), 
                 done);
    end

    
    initial begin
        #10000;
        $display("Timeout reached!");
        $finish;
    end

endmodule