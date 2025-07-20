//==============================================================================
// FILE: mac_unit.v
// DESCRIPTION: Core multiply unit. (No changes needed)
//==============================================================================
`timescale 1ns / 1ps

module mac_unit (
    input  wire       clk,
    input  wire       rst,
    input  wire       en,
    input  wire [7:0] a,
    input  wire [7:0] b,
    output reg [15:0] c
);
    // Registered multiplier
    always @(posedge clk) begin
        if (rst) begin
            c <= 16'd0;
        end else if (en) begin
            c <= a * b;
        end
    end
endmodule
