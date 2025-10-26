
module tb_alu;

    // Test bench signals
    reg [31:0] operand_a, operand_b;
    reg [4:0] alu_control;
    wire [31:0] result;
    wire zero_flag, negative_flag, overflow_flag;
    
    // Test tracking variables
    integer test_count = 0;
    integer pass_count = 0;
    integer fail_count = 0;
    
    // ALU operation codes
    parameter ADD  = 5'b00000;
    parameter SUB  = 5'b00001;
    parameter AND  = 5'b00010;
    parameter OR   = 5'b00011;
    parameter XOR  = 5'b00100;
    parameter NOR  = 5'b00101;
    parameter NOT  = 5'b00110;
    parameter SL   = 5'b00111;
    parameter SRL  = 5'b01000;
    parameter SRA  = 5'b01001;
    parameter INC  = 5'b01010;
    parameter DEC  = 5'b01011;
    parameter SLT  = 5'b01100;
    parameter SGT  = 5'b01101;
    parameter LUI  = 5'b01110;
    parameter HAM  = 5'b01111;
    
    // Instantiate the ALU
    ALU dut (
        .operand_a(operand_a),
        .operand_b(operand_b),
        .alu_control(alu_control),
        .result(result),
        .zero_flag(zero_flag),
        .negative_flag(negative_flag),
        .overflow_flag(overflow_flag)
    );
    
    // Test result checking task
    task check_result;
        input [31:0] expected;
        input [4:0] operation;
        input [31:0] a, b;
        begin
            test_count = test_count + 1;
            #1; // Small delay for result to propagate
            if (result === expected) begin
                $display("? Test %2d PASS: Op=%s A=%h B=%h Result=%h", 
                        test_count, get_op_name(operation), a, b, result);
                pass_count = pass_count + 1;
            end else begin
                $display("? Test %2d FAIL: Op=%s A=%h B=%h Expected=%h Got=%h", 
                        test_count, get_op_name(operation), a, b, expected, result);
                fail_count = fail_count + 1;
            end
        end
    endtask
    
    // Function to get operation name for display
    function [31:0] get_op_name;
        input [4:0] op;
        begin
            case (op)
                ADD: get_op_name = "ADD";
                SUB: get_op_name = "SUB";
                AND: get_op_name = "AND";
                OR:  get_op_name = "OR ";
                XOR: get_op_name = "XOR";
                NOR: get_op_name = "NOR";
                NOT: get_op_name = "NOT";
                SL:  get_op_name = "SL ";
                SRL: get_op_name = "SRL";
                SRA: get_op_name = "SRA";
                INC: get_op_name = "INC";
                DEC: get_op_name = "DEC";
                SLT: get_op_name = "SLT";
                SGT: get_op_name = "SGT";
                LUI: get_op_name = "LUI";
                HAM: get_op_name = "HAM";
                default: get_op_name = "UNK";
            endcase
        end
    endfunction
    
    // Main test sequence
    initial begin
        $display("=============================================================================");
        $display("Starting Comprehensive ALU Test");
        $display("=============================================================================");
        
        // Initialize
        operand_a = 0;
        operand_b = 0;
        alu_control = 0;
        #10;
        
        // =========================================================================
        // Test ADD Operation
        // =========================================================================
        $display("\n--- Testing ADD Operation ---");
        alu_control = ADD;
        
        operand_a = 32'h12345678; operand_b = 32'h87654321;
        check_result(32'h99999999, ADD, operand_a, operand_b);
        
        operand_a = 32'hFFFFFFFF; operand_b = 32'h00000001;
        check_result(32'h00000000, ADD, operand_a, operand_b);
        
        operand_a = 32'h00000000; operand_b = 32'h12345678;
        check_result(32'h12345678, ADD, operand_a, operand_b);
        
        // =========================================================================
        // Test SUB Operation
        // =========================================================================
        $display("\n--- Testing SUB Operation ---");
        alu_control = SUB;
        
        operand_a = 32'h87654321; operand_b = 32'h12345678;
        check_result(32'h7530ECA9, SUB, operand_a, operand_b);
        
        operand_a = 32'h12345678; operand_b = 32'h12345678;
        check_result(32'h00000000, SUB, operand_a, operand_b);
        
        operand_a = 32'h00000001; operand_b = 32'h00000002;
        check_result(32'hFFFFFFFF, SUB, operand_a, operand_b);
        
        // =========================================================================
        // Test AND Operation
        // =========================================================================
        $display("\n--- Testing AND Operation ---");
        alu_control = AND;
        
        operand_a = 32'hF0F0F0F0; operand_b = 32'h0F0F0F0F;
        check_result(32'h00000000, AND, operand_a, operand_b);
        
        operand_a = 32'hFFFFFFFF; operand_b = 32'h12345678;
        check_result(32'h12345678, AND, operand_a, operand_b);
        
        operand_a = 32'hAAAAAAAA; operand_b = 32'h55555555;
        check_result(32'h00000000, AND, operand_a, operand_b);
        
        // =========================================================================
        // Test OR Operation
        // =========================================================================
        $display("\n--- Testing OR Operation ---");
        alu_control = OR;
        
        operand_a = 32'hF0F0F0F0; operand_b = 32'h0F0F0F0F;
        check_result(32'hFFFFFFFF, OR, operand_a, operand_b);
        
        operand_a = 32'h00000000; operand_b = 32'h12345678;
        check_result(32'h12345678, OR, operand_a, operand_b);
        
        operand_a = 32'hAAAAAAAA; operand_b = 32'h55555555;
        check_result(32'hFFFFFFFF, OR, operand_a, operand_b);
        
        // =========================================================================
        // Test XOR Operation
        // =========================================================================
        $display("\n--- Testing XOR Operation ---");
        alu_control = XOR;
        
        operand_a = 32'hF0F0F0F0; operand_b = 32'h0F0F0F0F;
        check_result(32'hFFFFFFFF, XOR, operand_a, operand_b);
        
        operand_a = 32'h12345678; operand_b = 32'h12345678;
        check_result(32'h00000000, XOR, operand_a, operand_b);
        
        operand_a = 32'hAAAAAAAA; operand_b = 32'h55555555;
        check_result(32'hFFFFFFFF, XOR, operand_a, operand_b);
        
        // =========================================================================
        // Test NOR Operation
        // =========================================================================
        $display("\n--- Testing NOR Operation ---");
        alu_control = NOR;
        
        operand_a = 32'h00000000; operand_b = 32'h00000000;
        check_result(32'hFFFFFFFF, NOR, operand_a, operand_b);
        
        operand_a = 32'hF0F0F0F0; operand_b = 32'h0F0F0F0F;
        check_result(32'h00000000, NOR, operand_a, operand_b);
        
        operand_a = 32'h12345678; operand_b = 32'h00000000;
        check_result(32'hEDCBA987, NOR, operand_a, operand_b);
        
        // =========================================================================
        // Test NOT Operation
        // =========================================================================
        $display("\n--- Testing NOT Operation ---");
        alu_control = NOT;
        
        operand_a = 32'h00000000; operand_b = 32'h00000000; // operand_b ignored
        check_result(32'hFFFFFFFF, NOT, operand_a, operand_b);
        
        operand_a = 32'hFFFFFFFF; operand_b = 32'h00000000;
        check_result(32'h00000000, NOT, operand_a, operand_b);
        
        operand_a = 32'h12345678; operand_b = 32'h00000000;
        check_result(32'hEDCBA987, NOT, operand_a, operand_b);
        
        // =========================================================================
        // Test Shift Left (SL) Operation
        // =========================================================================
        $display("\n--- Testing Shift Left Operation ---");
        alu_control = SL;
        
        operand_a = 32'h12345678; operand_b = 32'h00000001;
        check_result(32'h2468ACF0, SL, operand_a, operand_b);
        
        operand_a = 32'h12345678; operand_b = 32'h00000004;
        check_result(32'h23456780, SL, operand_a, operand_b);
        
        operand_a = 32'h00000001; operand_b = 32'h0000001F;
        check_result(32'h80000000, SL, operand_a, operand_b);
        
        // =========================================================================
        // Test Shift Right Logical (SRL) Operation
        // =========================================================================
        $display("\n--- Testing Shift Right Logical Operation ---");
        alu_control = SRL;
        
        operand_a = 32'h12345678; operand_b = 32'h00000001;
        check_result(32'h091A2B3C, SRL, operand_a, operand_b);
        
        operand_a = 32'h12345678; operand_b = 32'h00000004;
        check_result(32'h01234567, SRL, operand_a, operand_b);
        
        operand_a = 32'h80000000; operand_b = 32'h0000001F;
        check_result(32'h00000001, SRL, operand_a, operand_b);
        
        // =========================================================================
        // Test Shift Right Arithmetic (SRA) Operation
        // =========================================================================
        $display("\n--- Testing Shift Right Arithmetic Operation ---");
        alu_control = SRA;
        
        operand_a = 32'h12345678; operand_b = 32'h00000001;
        check_result(32'h091A2B3C, SRA, operand_a, operand_b);
        
        operand_a = 32'h80000000; operand_b = 32'h00000001; // Negative number
        check_result(32'hC0000000, SRA, operand_a, operand_b);
        
        operand_a = 32'hF0000000; operand_b = 32'h00000004; // Negative number
        check_result(32'hFF000000, SRA, operand_a, operand_b);
        
        // =========================================================================
        // Test INC Operation
        // =========================================================================
        $display("\n--- Testing INC Operation ---");
        alu_control = INC;
        
        operand_a = 32'h12345678; operand_b = 32'h00000000; // operand_b ignored
        check_result(32'h12345679, INC, operand_a, operand_b);
        
        operand_a = 32'hFFFFFFFE; operand_b = 32'h00000000;
        check_result(32'hFFFFFFFF, INC, operand_a, operand_b);
        
        operand_a = 32'hFFFFFFFF; operand_b = 32'h00000000; // Overflow case
        check_result(32'h00000000, INC, operand_a, operand_b);
        
        // =========================================================================
        // Test DEC Operation
        // =========================================================================
        $display("\n--- Testing DEC Operation ---");
        alu_control = DEC;
        
        operand_a = 32'h12345678; operand_b = 32'h00000000; // operand_b ignored
        check_result(32'h12345677, DEC, operand_a, operand_b);
        
        operand_a = 32'h00000001; operand_b = 32'h00000000;
        check_result(32'h00000000, DEC, operand_a, operand_b);
        
        operand_a = 32'h00000000; operand_b = 32'h00000000; // Underflow case
        check_result(32'hFFFFFFFF, DEC, operand_a, operand_b);
        
        // =========================================================================
        // Test SLT (Set Less Than) Operation
        // =========================================================================
        $display("\n--- Testing SLT Operation ---");
        alu_control = SLT;
        
        operand_a = 32'h12345678; operand_b = 32'h87654321;
        check_result(32'h00000000, SLT, operand_a, operand_b); // positive < negative (unsigned)
        
        operand_a = 32'h00000001; operand_b = 32'h00000002;
        check_result(32'h00000001, SLT, operand_a, operand_b);
        
        operand_a = 32'hFFFFFFFF; operand_b = 32'h00000001; // -1 < 1 (signed)
        check_result(32'h00000001, SLT, operand_a, operand_b);
        
        // =========================================================================
        // Test SGT (Set Greater Than) Operation
        // =========================================================================
        $display("\n--- Testing SGT Operation ---");
        alu_control = SGT;
        
        operand_a = 32'h87654321; operand_b = 32'h12345678;
        check_result(32'h00000000, SGT, operand_a, operand_b); // negative > positive (signed)
        
        operand_a = 32'h00000002; operand_b = 32'h00000001;
        check_result(32'h00000001, SGT, operand_a, operand_b);
        
        operand_a = 32'h00000001; operand_b = 32'hFFFFFFFF; // 1 > -1 (signed)
        check_result(32'h00000001, SGT, operand_a, operand_b);
        
        // =========================================================================
        // Test LUI (Load Upper Immediate) Operation
        // =========================================================================
        $display("\n--- Testing LUI Operation ---");
        alu_control = LUI;
        
        operand_a = 32'h00000000; operand_b = 32'h00001234; // Load 0x1234 to upper 16 bits
        check_result(32'h12340000, LUI, operand_a, operand_b);
        
        operand_a = 32'h00000000; operand_b = 32'h0000ABCD;
        check_result(32'hABCD0000, LUI, operand_a, operand_b);
        
        operand_a = 32'h00000000; operand_b = 32'h0000FFFF;
        check_result(32'hFFFF0000, LUI, operand_a, operand_b);
        
        // =========================================================================
        // Test HAM (Hamming Weight) Operation
        // =========================================================================
        $display("\n--- Testing HAM Operation ---");
        alu_control = HAM;
        
        operand_a = 32'h00000000; operand_b = 32'h00000000; // 0 ones
        check_result(32'h00000000, HAM, operand_a, operand_b);
        
        operand_a = 32'hFFFFFFFF; operand_b = 32'h00000000; // 32 ones
        check_result(32'h00000020, HAM, operand_a, operand_b);
        
        operand_a = 32'h0000000F; operand_b = 32'h00000000; // 4 ones
        check_result(32'h00000004, HAM, operand_a, operand_b);
        
        operand_a = 32'hAAAAAAAA; operand_b = 32'h00000000; // 16 ones (alternating pattern)
        check_result(32'h00000010, HAM, operand_a, operand_b);
        
        // =========================================================================
        // Test Flags
        // =========================================================================
        $display("\n--- Testing Flags ---");
        
        // Test Zero Flag
        alu_control = SUB;
        operand_a = 32'h12345678; operand_b = 32'h12345678;
        #1;
        if (zero_flag == 1'b1) 
            $display("? Zero Flag Test PASS: Result=%h, Zero_Flag=%b", result, zero_flag);
        else 
            $display("? Zero Flag Test FAIL: Result=%h, Zero_Flag=%b", result, zero_flag);
        
        // Test Negative Flag
        alu_control = SUB;
        operand_a = 32'h12345678; operand_b = 32'h87654321;
        #1;
        if (negative_flag == 1'b1) 
            $display("? Negative Flag Test PASS: Result=%h, Negative_Flag=%b", result, negative_flag);
        else 
            $display("? Negative Flag Test FAIL: Result=%h, Negative_Flag=%b", result, negative_flag);
        
        // =========================================================================
        // Test Summary
        // =========================================================================
        $display("\n=============================================================================");
        $display("Test Summary:");
        $display("Total Tests: %d", test_count);
        $display("Passed:      %d", pass_count);
        $display("Failed:      %d", fail_count);
        $display("Success Rate: %0.1f%%", (pass_count * 100.0) / test_count);
        $display("=============================================================================");
        
        if (fail_count == 0) begin
            $display("? ALL TESTS PASSED! ALU is working correctly!");
        end else begin
            $display("??  Some tests failed. Please check your module implementations.");
        end
        
        $finish;
    end

endmodule