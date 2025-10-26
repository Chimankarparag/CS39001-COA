`timescale 1ns / 1ps

module updown_counter(
    input clk,           // slow clock (~2 Hz)
    input rst,           // active-high reset
    input direction,     // 1 = up, 0 = down
    output reg [3:0] count, // 4-bit counter output
    output mode_led      // LED shows direction
);
    wire [3:0] sum;
    wire cout;
    reg  [3:0] B;

    // mode LED mirrors direction
    assign mode_led = direction;

    // Select operand based on direction
    always @(*) begin
        if (direction)
            B = 4'b0001; // increment by 1
        else
            B = 4'b1111; // decrement by 1 (two's complement -1)
    end

    // Ripple adder instance
    ripple_carry_adder RCA(
        .A(count),
        .B(B),
        .SUM(sum),
        .cout(cout)
    );

    // Sequential logic (state update)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 4'b0000;
        end else begin
            count <= sum;  // wrap-around handled automatically
        end
    end
endmodule
