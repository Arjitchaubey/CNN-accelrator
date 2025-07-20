#=================================================================================
# XDC Constraints for cnn_accel_top
#
# Target FPGA: xc7k70tfbv676-1
#
# NOTE: These pin assignments are general-purpose examples. You must verify
#       these locations and I/O standards against your board's official
#       schematic or user guide for your design to work correctly.
#=================================================================================

## --------------------------------------------------------------------------------
## 1. System Clock Constraint (100 MHz Example)
##    - A common frequency for many boards is 100MHz (10.0 ns period).
##    - Assigned to a typical global clock capable (MRCC/SRCC) pin.
## --------------------------------------------------------------------------------
create_clock -period 10.000 -name sys_clk_pin [get_ports clk]
set_property PACKAGE_PIN J20 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]


## --------------------------------------------------------------------------------
## 2. Control and Status Signals
##    - Mapped to general-purpose pins suitable for buttons and LEDs.
##    - The I/O standard (LVCMOS33) is a common default.
## --------------------------------------------------------------------------------
# Reset signal (e.g., from a push button)
set_property PACKAGE_PIN G20 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]
set_property PULLUP true [get_ports rst]

# Start signal (e.g., from a switch)
set_property PACKAGE_PIN T20 [get_ports start]
set_property IOSTANDARD LVCMOS33 [get_ports start]
set_property PULLUP true [get_ports start]

# Done signal (e.g., to an LED)
set_property PACKAGE_PIN K21 [get_ports done]
set_property IOSTANDARD LVCMOS33 [get_ports done]


## --------------------------------------------------------------------------------
## 3. Data Output Bus (result_out[19:0])
##    - Mapped to a contiguous block of I/O pins, such as those that might
##      connect to an expansion header or test points.
## --------------------------------------------------------------------------------
set_property PACKAGE_PIN D25 [get_ports {result_out[0]}]
set_property PACKAGE_PIN D26 [get_ports {result_out[1]}]
set_property PACKAGE_PIN E25 [get_ports {result_out[2]}]
set_property PACKAGE_PIN E26 [get_ports {result_out[3]}]
set_property PACKAGE_PIN F23 [get_ports {result_out[4]}]
set_property PACKAGE_PIN F24 [get_ports {result_out[5]}]
set_property PACKAGE_PIN A20 [get_ports {result_out[6]}]
set_property PACKAGE_PIN G24 [get_ports {result_out[7]}]
set_property PACKAGE_PIN H22 [get_ports {result_out[8]}]
set_property PACKAGE_PIN H23 [get_ports {result_out[9]}]
set_property PACKAGE_PIN L18 [get_ports {result_out[10]}]
set_property PACKAGE_PIN J23 [get_ports {result_out[11]}]
set_property PACKAGE_PIN K22 [get_ports {result_out[12]}]
set_property PACKAGE_PIN L22 [get_ports {result_out[13]}]
set_property PACKAGE_PIN M21 [get_ports {result_out[14]}]
set_property PACKAGE_PIN M22 [get_ports {result_out[15]}]
set_property PACKAGE_PIN N21 [get_ports {result_out[16]}]
set_property PACKAGE_PIN N22 [get_ports {result_out[17]}]
set_property PACKAGE_PIN P21 [get_ports {result_out[18]}]
set_property PACKAGE_PIN P19 [get_ports {result_out[19]}]

# Set the I/O standard for the entire bus
set_property IOSTANDARD LVCMOS33 [get_ports {result_out[*]}]