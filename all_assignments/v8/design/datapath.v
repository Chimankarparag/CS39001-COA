// Verilog Assignment 8: Sequential Booth Multiplier
// Name : Parag Mahadeo Chimankar 23CS10049
// Name : Harshit Singhal 23CS10035

module datapath(
    input clk,
    input rst,
    input [7:0] multiplicand,
    input [7:0] multiplier,
    
    input load_registers,
    input load_counter,
    input add_operation,
    input sub_operation,
    input shift_enable,
    input decrement_counter,
    
    output counter_zero,
    output [1:0] booth_bits,
    output [15:0] product
);

    reg [7:0] reg_A, reg_Q, reg_M;
    reg q_minus_1;
    
    wire [7:0] adder_result, subtractor_result;
    wire [7:0] next_A;
    wire [16:0] shift_data;
    wire [3:0] counter_value;

    counter_4bit iteration_counter (
        .clk(clk),
        .rst(rst),
        .load(load_counter),
        .load_value(4'd8), 
        .decrement(decrement_counter),
        .count(counter_value),
        .zero_flag(counter_zero)
    );
    
    ripple_adder adder_unit (
        .a(reg_A),
        .b(reg_M),
        .cin(1'b0),
        .sum(adder_result),
        .cout()
    );
    
    ripple_subtractor subtractor_unit (
        .a(reg_A),
        .b(reg_M),
        .diff(subtractor_result),
        .bout()
    );
    
    assign next_A = add_operation ? adder_result :
                   sub_operation ? subtractor_result :
                   reg_A;
    
    assign shift_data = {next_A, reg_Q, q_minus_1};
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            reg_A <= 8'b0;
            reg_Q <= 8'b0;
            reg_M <= 8'b0;
            q_minus_1 <= 1'b0;
        end else begin
            if (load_registers) begin
                reg_A <= 8'b0;              
                reg_Q <= multiplier;        
                reg_M <= multiplicand;      
                q_minus_1 <= 1'b0;          
            end else if (shift_enable) begin
                reg_A <= {shift_data[16], shift_data[16:10]}; 
                reg_Q <= shift_data[9:2];                    
                q_minus_1 <= shift_data[1];                   
            end else if (add_operation || sub_operation) begin
                reg_A <= next_A;  
            end
        end
    end

    assign product = {reg_A, reg_Q};
    assign booth_bits = {reg_Q[0], q_minus_1}; 

endmodule