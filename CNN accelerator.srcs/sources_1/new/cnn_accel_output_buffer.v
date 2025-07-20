//==============================================================================
// FILE: output_buffer.v
// DESCRIPTION: A simple register to hold the final result.
//==============================================================================
`timescale 1ns / 1ps

module output_buffer (
    input  wire        clk,
    input  wire        rst,
    input  wire        write_en,
    input  wire [19:0] data_in,  // FIX: Widened to 20 bits
    output reg  [19:0] data_out  // FIX: Widened to 20 bits
);
    always @(posedge clk) begin
        if (rst) begin
            data_out <= 20'b0;
        end else if (write_en) begin
            data_out <= data_in;
        end
    end
endmodule