`timescale 1ns / 1ps

module top_ls_module (
   input  wire        clk,
   input  wire        reset,         // BTNU - Reset button (synchronous)
   input  wire        execute,       // BTNC - Execute button (raw input)
   input  wire [15:0] switches,      // SW[15:0] - Instruction input
   output wire [15:0] leds        // LED[15:0] - Multiplexed output displa
);


   // Decode switches according to Table 1
   wire        dft_select;    // SW[15] - 0: lower 16 bits, 1: upper 16 bits
   wire        op_select;     // SW[14] - 0: LD, 1: ST
   wire [3:0]  rt_addr;       // SW[13:10] - Dst/Src register
   wire [3:0]  rs_addr;       // SW[9:6] - Base register
   wire [5:0]  imm_6bit;      // SW[5:0] - Signed immediate offset


   // Decode switch inputs
   assign dft_select = switches[15];
   assign op_select  = switches[14];
   assign rt_addr    = switches[13:10];
   assign rs_addr    = switches[9:6];
   assign imm_6bit   = switches[5:0];


   // Generate instruction fields
   wire [5:0]  opcode;
   wire [5:0]  funct;
   wire [3:0]  rd_addr;       // Not used for LD/ST
   wire [31:0] imm_signed;
   wire [31:0] jmp_signed;    // Not used


   // Opcode generation: 0 -> LD (010001), 1 -> ST (010010)
   assign opcode = op_select ? 6'b010010 : 6'b010001;
   assign funct  = 6'b000000;
   assign rd_addr = 4'b0000;   // Not used


   // Sign-extend 6-bit immediate to 32 bits
   assign imm_signed = {{26{imm_6bit[5]}}, imm_6bit};
   assign jmp_signed = 32'h00000000;


   // --- FSM for Execute Button ---
   wire execute_pulse; // This wire will be asserted for one cycle on button press


   // FSM state encoding
   localparam [1:0] IDLE = 2'b00;
   localparam [1:0] RUN  = 2'b01;
   localparam [1:0] NEXT = 2'b10;


   // FSM state registers
   reg [1:0] current_state;
   reg [1:0] next_state;


   // FSM Sequential Logic: State transitions on clock edge
   always @(posedge clk or posedge reset) begin
       if (reset) begin
           current_state <= IDLE;
       end else begin
           current_state <= next_state;
       end
   end


   // FSM Combinational Logic: Determines the next state
   always @(*) begin
       case (current_state)
           IDLE: begin
               if (execute) next_state = RUN;  // Button pressed, go to RUN
               else         next_state = IDLE; // Stay in IDLE
           end
           RUN: begin
               next_state = NEXT; // Always go to NEXT to wait for release
           end
           NEXT: begin
               if (!execute) next_state = IDLE; // Button released, go back to IDLE
               else          next_state = NEXT; // Wait here until button is released
           end
           default: begin
               next_state = IDLE;
           end
       endcase
   end


   // FSM Output Logic: Generate the single-cycle pulse
   assign execute_pulse = (current_state == RUN);
   // --- End of FSM for Execute Button ---




   // Control signals from the control path
   wire [3:0]  alu_control;
   wire        alu_src;
   wire        wr_reg;
   wire        reg_dst;
   wire        immSel;
   wire        rdMem;
   wire        wrMem;
   wire        mToReg;
   wire        updPc;


   // Datapath outputs
   wire [31:0] result_out;
   wire [31:0] rs_value;


   // Instantiate control path
   controlpath ctrl (
       .opcode(opcode),
       .funct(funct),
       .alu_control(alu_control),
       .alu_src(alu_src),
       .immSel(immSel),
       .wr_reg(wr_reg),
       .reg_dst(reg_dst),
       .rdMem(rdMem),
       .wrMem(wrMem),
       .mToReg(mToReg),
       .updPc(updPc)
   );


   wire gated_wr_reg;
   wire gated_rdMem;
   wire gated_wrMem;


   assign gated_wr_reg = wr_reg & execute_pulse;
   assign gated_rdMem  = rdMem  & execute_pulse;
   assign gated_wrMem  = wrMem  & execute_pulse;


   // Instantiate datapath, now controlled by the gated signals
   datapath_ls dp (
       .clk(clk),
       .reset(reset),
       // .execute(...) // This port is no longer needed in the datapath
       .rs_addr(rs_addr),
       .rt_addr(rt_addr),
       .rd_addr(rd_addr),
       .reg_dst(reg_dst),
       .wr_reg(gated_wr_reg),   // Use the gated signal


       .alu_control(alu_control),
       .alu_src(alu_src),
       .immSel(immSel),
       .imm_signed(imm_signed),
       .jmp_signed(jmp_signed),


       .rdMem(gated_rdMem),     // Use the gated signal
       .wrMem(gated_wrMem),     // Use the gated signal
       .mToReg(mToReg),


       .result_out(result_out),
       .rsOut_out(rs_value),


       .zero_flag(zero_flag),
       .negative_flag(negative_flag),
       .overflow_flag(overflow_flag)
   );


   // Multiplexed LED output
   assign leds = dft_select ? result_out[31:16] : result_out[15:0];


endmodule





