//==============================================================================
// FILE: cnn_accel_top_tb.v
// DESCRIPTION: Testbench for the CNN accelerator.
//==============================================================================
`timescale 1ns / 1ps

module cnn_accel_top_tb;

    reg clk;
    reg rst;
    reg start;
    wire done;
    wire [19:0] result_out; // FIX: Widened to 20 bits

    // Instantiate DUT
    cnn_accel_top dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .done(done),
        .result_out(result_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Test stimulus
    initial begin
        // Reset
        rst = 1;
        start = 0;
        #100;
        rst = 0;
        $display("[%0t] [TB] Reset deasserted.", $time);

        // Start the accelerator
        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;
        $display("[%0t] [TB] Start pulsed.", $time);

        // Wait for completion
        wait (done);
        $display("[%0t] [TB] Done received.", $time);

        // Check result
        @(posedge clk);
        #1; // Allow combinational logic to settle
        // FIX: Check against the true 20-bit golden reference
        if (result_out == 20'h33068) begin
            $display("[SUCCESS] Output matches expected value: %d (0x%h)", result_out, result_out);
        end else begin
            $display("[FAILURE] Output mismatch! Expected 209000, Got %d (0x%h)", result_out, result_out);
        end

        $finish;
    end

endmodule
