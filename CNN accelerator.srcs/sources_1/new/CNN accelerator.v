//==============================================================================
// FILE: cnn_accel_top.v
// DESCRIPTION: Top-level module for the CNN accelerator with BUFG added.
//==============================================================================

`timescale 1ns / 1ps

module cnn_accel_top #(
    parameter DATA_WIDTH  = 8,
    parameter KERNEL_SIZE = 3
)(
    input  wire clk,             
    input  wire rst,
    input  wire start,
    output wire done,
    output wire [19:0] result_out
);


    localparam WINDOW_SIZE = KERNEL_SIZE * KERNEL_SIZE;

    // Internal Control and Data Signals
    wire load_data;
    wire en_conv;
    wire write_result;
    wire data_ready;
    wire conv_done;
    wire [DATA_WIDTH*WINDOW_SIZE-1:0] fmap_window;
    wire [DATA_WIDTH*WINDOW_SIZE-1:0] kernel_window;
    wire [19:0] conv_result;

    // FSM Controller - The brain of the accelerator
    layer_fsm u_fsm (
        .clk(clk),               
        .rst(rst),
        .start(start),
        .data_ready(data_ready),
        .conv_done(conv_done),
        .load_data(load_data),
        .en_conv(en_conv),
        .write_result(write_result),
        .done(done)
    );

    // Memory Interface - Reads data for the convolution
    mem_interface #(
        .DATA_WIDTH(DATA_WIDTH),
        .WINDOW_SIZE(WINDOW_SIZE)
    ) u_mem_interface (
        .clk(clk),
        .rst(rst),
        .load(load_data),
        .fmap_window_out(fmap_window),
        .kernel_window_out(kernel_window),
        .data_ready(data_ready)
    );

    // Convolution Engine
    conv_engine #(
        .DATA_WIDTH(DATA_WIDTH),
        .KERNEL_SIZE(KERNEL_SIZE)
    ) u_conv_engine (
        .clk(clk),
        .rst(rst),
        .en(en_conv),
        .fmap_in(fmap_window),
        .kernel_in(kernel_window),
        .result_out(conv_result),
        .done_out(conv_done)
    );

    // Output Buffer
    output_buffer u_output_buffer (
        .clk(clk),
        .rst(rst),
        .write_en(write_result),
        .data_in(conv_result),
        .data_out(result_out)
    );

endmodule
