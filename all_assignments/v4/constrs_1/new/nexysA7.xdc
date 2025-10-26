## ========================================================================
## Nexys A7-100T Constraint File for 4-bit Up/Down Counter with Direction LED
## ========================================================================

## 100 MHz clock (system oscillator)
set_property -dict { PACKAGE_PIN E3   IOSTANDARD LVCMOS33 } [get_ports { clk }];
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { clk }];

## Reset button (Center push button, active-high)
set_property -dict { PACKAGE_PIN N17  IOSTANDARD LVCMOS33 } [get_ports { rst_btn }];

## Direction switch (SW0)
set_property -dict { PACKAGE_PIN J15  IOSTANDARD LVCMOS33 } [get_ports { sw0 }];

## LEDs for 4-bit counter value
set_property -dict { PACKAGE_PIN H17  IOSTANDARD LVCMOS33 } [get_ports { led[0] }];
set_property -dict { PACKAGE_PIN K15  IOSTANDARD LVCMOS33 } [get_ports { led[1] }];
set_property -dict { PACKAGE_PIN J13  IOSTANDARD LVCMOS33 } [get_ports { led[2] }];
set_property -dict { PACKAGE_PIN N14  IOSTANDARD LVCMOS33 } [get_ports { led[3] }];

## LED for direction indicator
set_property -dict { PACKAGE_PIN U17  IOSTANDARD LVCMOS33 } [get_ports { led_dir }];
