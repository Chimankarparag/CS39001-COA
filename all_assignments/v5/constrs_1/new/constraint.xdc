## Clock (100 MHz onboard oscillator)
set_property PACKAGE_PIN E3 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.0 -name sys_clk_pin -waveform {0 5} [get_ports clk]

## Reset Button (use BTN0, center pushbutton)
set_property PACKAGE_PIN N17 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

## Select (use BTN1, right pushbutton)
set_property PACKAGE_PIN V10 [get_ports sel]
set_property IOSTANDARD LVCMOS33 [get_ports sel]

## Seed Inputs (4 switches SW0-SW3)
set_property PACKAGE_PIN T13 [get_ports {seed[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seed[0]}]

set_property PACKAGE_PIN H6 [get_ports {seed[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seed[1]}]

set_property PACKAGE_PIN U12 [get_ports {seed[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seed[2]}]

set_property PACKAGE_PIN U11 [get_ports {seed[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seed[3]}]

## State Outputs (map to LEDs LD0-LD3)
set_property PACKAGE_PIN H17 [get_ports {state[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {state[0]}]

set_property PACKAGE_PIN K15 [get_ports {state[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {state[1]}]

set_property PACKAGE_PIN J13 [get_ports {state[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {state[2]}]

set_property PACKAGE_PIN N14 [get_ports {state[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {state[3]}]
