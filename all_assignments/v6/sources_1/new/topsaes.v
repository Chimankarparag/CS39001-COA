// Assignment 6
// Group 2
// Name : Parag Mahadeo Chimankar
// Name : Harshit Singhal

module topsaes (
    input  wire        clk,
    input  wire        rst,
    input  wire [15:0] sw,
    output reg  [15:0] led
);

    localparam MASTER_KEY = 16'h2D65;

    localparam [4:0] IDLE           = 5'd0;
    localparam [4:0] PRE_ROUND      = 5'd1;
    localparam [4:0] R1_SUB         = 5'd2;
    localparam [4:0] R1_SUB_WAIT1   = 5'd3; // <-- Wait state 1
    localparam [4:0] R1_SUB_WAIT2   = 5'd4; // <-- Wait state 2
    localparam [4:0] R1_SHIFT       = 5'd5;
    localparam [4:0] R1_MIX         = 5'd6;
    localparam [4:0] R1_ADD_KEY     = 5'd7;
    localparam [4:0] R2_SUB         = 5'd8;
    localparam [4:0] R2_SUB_WAIT1   = 5'd9; // <-- Wait state 1
    localparam [4:0] R2_SUB_WAIT2   = 5'd10; // <-- Wait state 2
    localparam [4:0] R2_SHIFT       = 5'd11;
    localparam [4:0] R2_ADD_KEY     = 5'd12;
    localparam [4:0] DONE           = 5'd13;

    reg [4:0]  state, next_state;
    reg [15:0] state_reg, next_state_reg;
    reg [15:0] round_key_mux;

    wire [15:0] k0, k1, k2;

    wire [15:0] add_key_out;
    wire [15:0] s_box_out;
    wire [15:0] shift_rows_out;
    wire [15:0] mix_cols_out;

    keyexpansion key_exp_inst (
        .master_key_in(MASTER_KEY), .k0_out(k0), .k1_out(k1), .k2_out(k2)
    );

    s_box s_box_inst (
        .clk(clk), .state_in(state_reg), .state_out(s_box_out)
    );

    shift shift_rows_inst (
        .state_in(state_reg), .state_out(shift_rows_out)
    );
    
    mxcol mix_cols_inst (
        .state_in(state_reg), .state_out(mix_cols_out)
    );

    add_round_key add_key_inst (
        .state_in(state_reg), .round_key_in(round_key_mux), .state_out(add_key_out)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            state_reg <= 16'h0000;
        end else begin
            state <= next_state;
            state_reg <= next_state_reg;
        end
    end

    always @(*) begin
        case (state)
            PRE_ROUND:  round_key_mux = k0;
            R1_ADD_KEY: round_key_mux = k1;
            R2_ADD_KEY: round_key_mux = k2;
            default:      round_key_mux = 16'hXXXX;
        endcase
    end
    
    always @(*) begin
        next_state = state;
        next_state_reg = state_reg;

        case (state)
            IDLE: begin
                next_state_reg = sw;
                next_state = PRE_ROUND;
            end
            PRE_ROUND: begin
                next_state_reg = add_key_out;
                next_state = R1_SUB;
            end
            R1_SUB: begin
                // Provide address to S-Box, then begin waiting
                next_state = R1_SUB_WAIT1;
            end
            R1_SUB_WAIT1: begin // <-- NEW: First wait cycle
                next_state = R1_SUB_WAIT2;
            end
            R1_SUB_WAIT2: begin // <-- NEW: Second wait cycle
                // S-Box output is ready now, so latch it
                next_state_reg = s_box_out;
                next_state = R1_SHIFT;
            end
            R1_SHIFT: begin
                next_state_reg = shift_rows_out;
                next_state = R1_MIX;
            end
            R1_MIX: begin
                next_state_reg = mix_cols_out;
                next_state = R1_ADD_KEY;
            end
            R1_ADD_KEY: begin
                next_state_reg = add_key_out;
                next_state = R2_SUB;
            end
            R2_SUB: begin
                // Provide address to S-Box, then begin waiting
                next_state = R2_SUB_WAIT1;
            end
            R2_SUB_WAIT1: begin // <-- NEW: First wait cycle
                next_state = R2_SUB_WAIT2;
            end
            R2_SUB_WAIT2: begin // <-- NEW: Second wait cycle
                // S-Box output is ready now, so latch it
                next_state_reg = s_box_out;
                next_state = R2_SHIFT;
            end
            R2_SHIFT: begin
                next_state_reg = shift_rows_out;
                next_state = R2_ADD_KEY;
            end
            R2_ADD_KEY: begin
                next_state_reg = add_key_out;
                next_state = DONE;
            end
            DONE: begin
                next_state = DONE;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            led <= 16'h0000;
        end else if (state == DONE) begin
            led <= state_reg;
        end
    end

endmodule