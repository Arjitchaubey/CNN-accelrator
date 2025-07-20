//==============================================================================
// FILE: mem_interface.v
// DESCRIPTION: Reads data from fmap.mem and kernel.mem. (No changes needed)
//==============================================================================
`timescale 1ns / 1ps

module mem_interface #(
    parameter DATA_WIDTH  = 8,
    parameter WINDOW_SIZE = 9,
    parameter ADDR_WIDTH  = 12
)(
    input  wire clk,
    input  wire rst,
    input  wire load,
    output reg [DATA_WIDTH*WINDOW_SIZE-1:0] fmap_window_out,
    output reg [DATA_WIDTH*WINDOW_SIZE-1:0] kernel_window_out,
    output reg data_ready
);

    reg [DATA_WIDTH-1:0] fmap_mem[0:(1<<ADDR_WIDTH)-1];
    reg [DATA_WIDTH-1:0] kernel_mem[0:(1<<ADDR_WIDTH)-1];
    integer i;

    initial begin
        #1; // Delay to prevent simulation race condition
        $readmemb("fmap.mem", fmap_mem);
        $readmemb("kernel.mem", kernel_mem);
    end

    always @(posedge clk) begin
        if (rst) begin
            data_ready <= 1'b0;
        end else if (load) begin
            for (i = 0; i < WINDOW_SIZE; i = i + 1) begin
                fmap_window_out[ (i+1)*DATA_WIDTH-1 -: DATA_WIDTH ] <= fmap_mem[i];
                kernel_window_out[ (i+1)*DATA_WIDTH-1 -: DATA_WIDTH ] <= kernel_mem[i];
            end
            data_ready <= 1'b1;
        end else begin
            data_ready <= 1'b0;
        end
    end

endmodule
