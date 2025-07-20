//==============================================================================
// FILE: layer_fsm.v
// DESCRIPTION: Main controller FSM. (No changes needed)
//==============================================================================
`timescale 1ns / 1ps

module layer_fsm (
    input  wire clk,
    input  wire rst,
    input  wire start,
    input  wire data_ready,
    input  wire conv_done,
    output reg  load_data,
    output reg  en_conv,
    output reg  write_result,
    output reg  done
);

    localparam S_IDLE  = 3'b000;
    localparam S_LOAD  = 3'b001;
    localparam S_CONV  = 3'b010;
    localparam S_WRITE = 3'b011;
    localparam S_DONE  = 3'b100;

    reg [2:0] state, next_state;

    // State Register
    always @(posedge clk) begin
        if (rst) state <= S_IDLE;
        else     state <= next_state;
    end

    // Next State Logic & Output Logic
    always @(*) begin
        // Default outputs
        load_data    = 1'b0;
        en_conv      = 1'b0;
        write_result = 1'b0;
        done         = 1'b0;
        next_state   = state;

        case (state)
            S_IDLE: begin
                if (start) next_state = S_LOAD;
            end
            S_LOAD: begin
                load_data = 1'b1;
                if (data_ready) next_state = S_CONV;
            end
            S_CONV: begin
                en_conv = 1'b1;
                if (conv_done) next_state = S_WRITE;
            end
            S_WRITE: begin
                write_result = 1'b1;
                next_state = S_DONE;
            end
            S_DONE: begin
                done = 1'b1;
                next_state = S_IDLE;
            end
        endcase
    end

endmodule