//==============================================================================
// FILE: conv_engine.v
// DESCRIPTION: Performs the convolution calculation.
//==============================================================================
`timescale 1ns / 1ps

module conv_engine #(
    parameter DATA_WIDTH  = 8,
    parameter KERNEL_SIZE = 3
)(
    input  wire clk,
    input  wire rst,
    input  wire en,
    input  wire [DATA_WIDTH*KERNEL_SIZE*KERNEL_SIZE-1:0] fmap_in,
    input  wire [DATA_WIDTH*KERNEL_SIZE*KERNEL_SIZE-1:0] kernel_in,
    output reg  [19:0] result_out, // FIX: Widened to 20 bits
    output wire done_out
);

    localparam NUM_MACS = KERNEL_SIZE * KERNEL_SIZE;
    wire [15:0] mac_out [0:NUM_MACS-1];
    wire [19:0] total_sum; // FIX: Widened to 20 bits

    // Instantiate MAC units
    genvar i;
    generate
        for (i = 0; i < NUM_MACS; i = i + 1) begin: mac_gen
            mac_unit u_mac (
                .clk(clk),
                .rst(rst),
                .en(en),
                .a(fmap_in[ (i+1)*DATA_WIDTH-1 -: DATA_WIDTH ]),
                .b(kernel_in[ (i+1)*DATA_WIDTH-1 -: DATA_WIDTH ]),
                .c(mac_out[i])
            );
        end
    endgenerate

    // Combinational Adder Tree
    assign total_sum = mac_out[0] + mac_out[1] + mac_out[2] +
                       mac_out[3] + mac_out[4] + mac_out[5] +
                       mac_out[6] + mac_out[7] + mac_out[8];

    // Register the final result
    always @(posedge clk) begin
        if (rst) begin
            result_out <= 20'b0;
        end else if (en) begin
            result_out <= total_sum;
        end
    end

    // Done signal generation (2-cycle pipeline latency)
    reg [1:0] en_pipe;
    always @(posedge clk) begin
        if(rst) en_pipe <= 2'b0;
        else    en_pipe <= {en_pipe[0], en};
    end
    assign done_out = en_pipe[1];

endmodule

