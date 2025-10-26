`timescale 1ns / 1ps

module master(
    input  wire        clk,
    input  wire [15:0] sw,
    input  wire        btn_exec,     // Execution trigger button
    input  wire        btn_reset,
    output wire [15:0] led
);

    // --- Signal Parsing from Switches (as per lab addendum) ---
    wire        dft_display_select;  // '0' for lower, '1' for upper 16 bits
    wire [2:0]  alu_op_select;       // Selects one of 8 ALU operations
    wire [3:0]  rd_addr;             // Destination Register (rd)
    wire [3:0]  rs_addr;             // Source Register 1 (rs)
    wire [3:0]  rt_addr;             // Source Register 2 (rt)

    assign dft_display_select = sw[15];
    assign alu_op_select      = sw[14:12];
    assign rd_addr            = sw[11:8];
    assign rs_addr            = sw[7:4];
    assign rt_addr            = sw[3:0];

    // --- Reset Generation State Machine ---
    localparam S_RESET = 2'b00;      // Hold reset for initialization
    localparam S_RUN   = 2'b01;      // Normal operation
    
    reg [1:0] state = S_RESET;
    reg [3:0] reset_counter = 4'd0;
    reg internal_reset;

    // --- State Machine for Initialization via Reset ---
    always @(posedge clk) begin
        case (state)
            S_RESET: begin
                internal_reset <= 1'b1;    // Assert reset
                if (reset_counter == 4'd10) begin
                    state <= S_RUN;
                    internal_reset <= 1'b0;
                end else begin
                    reset_counter <= reset_counter + 1;
                end
            end
            S_RUN: begin
                internal_reset <= 1'b0;    // Keep reset deasserted
                state <= S_RUN;
            end
            default: begin
                state <= S_RESET;
                internal_reset <= 1'b1;
            end
        endcase
    end
    
    // here we are adding async reset signal 
    wire reset_signal;
    assign reset_signal = btn_reset;
    
    // **** later update here to get both the sync and async signal
    
    // --- Button Edge Detection (Convert to Single-Cycle Pulse) ---
    reg btn_exec_d1, btn_exec_d2;
    wire btn_exec_pulse;
    
    always @(posedge clk) begin
        btn_exec_d1 <= btn_exec;
        btn_exec_d2 <= btn_exec_d1;
    end
    
    assign btn_exec_pulse = btn_exec_d1 & ~btn_exec_d2;

    // --- Write Enable Control ---
    // Only allow writes in RUN state when button is pressed
    wire wrReg_signal;
    assign wrReg_signal = (state == S_RUN) ? btn_exec_pulse : 1'b0;

    // --- ALU Control Mapping (3-bit switch to 4-bit datapath control) ---
    reg [3:0] alu_control_4bit;
    
    always @(*) begin
        case (alu_op_select)
            3'b000: alu_control_4bit = 4'b0000; // ADD
            3'b001: alu_control_4bit = 4'b0001; // SUB
            3'b010: alu_control_4bit = 4'b0010; // AND
            3'b011: alu_control_4bit = 4'b0011; // OR
            3'b100: alu_control_4bit = 4'b0100; // XOR
            3'b101: alu_control_4bit = 4'b0101; // SL
            3'b110: alu_control_4bit = 4'b0110; // SRL
            3'b111: alu_control_4bit = 4'b0111; // SLT
            default: alu_control_4bit = 4'b0000;
        endcase
    end

    // --- Datapath Output ---
    wire [31:0] alu_result;

    // --- Datapath Instantiation ---
    datapath datapath_inst (
        .clk(clk),
        .reset(reset_signal),
        .wrReg(wrReg_signal),
        .rs(rs_addr),              // rs reads from Ry
        .rt(rt_addr),              // rt reads from Rz
        .rd(rd_addr),              // rd writes to Rx
        .alu_control(alu_control_4bit),
        .out_data(alu_result)
    );

    // --- Multiplexed LED Output (DFT) ---
    assign led = dft_display_select ? alu_result[31:16] : alu_result[15:0];

endmodule