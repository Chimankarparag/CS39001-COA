// Verilog Assignment 8: Sequential Booth Multiplier
// Name : Parag Mahadeo Chimankar 23CS10049
// Name : Harshit Singhal 23CS10035

module controlpath(
    input clk,
    input rst,
    
    // Status signals from datapath
    input counter_zero,
    input [1:0] booth_bits,
    
    // Control signals to datapath
    output reg load_registers,
    output reg load_counter,
    output reg add_operation,
    output reg sub_operation,
    output reg shift_enable,
    output reg decrement_counter,
    
    // Status output
    output reg done
);

    // FSM states
    parameter IDLE       = 3'b000,
              INIT       = 3'b001,
              EVALUATE   = 3'b010,
              ADD        = 3'b011,
              SUBTRACT   = 3'b100,
              SHIFT      = 3'b101,
              DONE       = 3'b110;

    reg [2:0] current_state, next_state;

    // State register
    always @(posedge clk or posedge rst) begin
        if (rst)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: 
                next_state = INIT;
                
            INIT:
                next_state = EVALUATE;
                
            EVALUATE: begin
                if (counter_zero)
                    next_state = DONE;
                else begin
                    case (booth_bits)
                        2'b01: next_state = ADD;      // Q0=0, Q-1=1: Add M
                        2'b10: next_state = SUBTRACT; // Q0=1, Q-1=0: Sub M
                        default: next_state = SHIFT;  // Q0Q-1 = 00 or 11: No op
                    endcase
                end
            end
            
            ADD:
                next_state = SHIFT;
                
            SUBTRACT:
                next_state = SHIFT;
                
            SHIFT:
                next_state = EVALUATE;
                
            DONE:
                next_state = DONE;
                
            default:
                next_state = IDLE;
        endcase
    end

    // Output logic
    always @(*) begin
        // Default values
        load_registers = 1'b0;
        load_counter = 1'b0;
        add_operation = 1'b0;
        sub_operation = 1'b0;
        shift_enable = 1'b0;
        decrement_counter = 1'b0;
        done = 1'b0;

        case (current_state)
            INIT: begin
                load_registers = 1'b1;
                load_counter = 1'b1;
            end
            
            ADD: begin
                add_operation = 1'b1;
            end
            
            SUBTRACT: begin
                sub_operation = 1'b1;
            end
            
            SHIFT: begin
                shift_enable = 1'b1;
                decrement_counter = 1'b1;
            end
            
            DONE: begin
                done = 1'b1;
            end
        endcase
    end

endmodule