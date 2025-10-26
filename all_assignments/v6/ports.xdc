# S-AES Project XDC Constraints for the Digilent Nexys A7

## Clock Signal
# 100MHz Clock
set_property -dict { PACKAGE_PIN E3   IOSTANDARD LVCMOS33 } [get_ports {clk}];
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} [get_ports {clk}];

## Reset Button
# CPU Reset Button (BTNC)
set_property -dict { PACKAGE_PIN N17  IOSTANDARD LVCMOS33 } [get_ports {rst}];

## Switches (Plaintext Input)
set_property -dict { PACKAGE_PIN J15  IOSTANDARD LVCMOS33 } [get_ports {sw[0]}];
set_property -dict { PACKAGE_PIN L16  IOSTANDARD LVCMOS33 } [get_ports {sw[1]}];
set_property -dict { PACKAGE_PIN M13  IOSTANDARD LVCMOS33 } [get_ports {sw[2]}];
set_property -dict { PACKAGE_PIN R15  IOSTANDARD LVCMOS33 } [get_ports {sw[3]}];
set_property -dict { PACKAGE_PIN R17  IOSTANDARD LVCMOS33 } [get_ports {sw[4]}];
set_property -dict { PACKAGE_PIN T18  IOSTANDARD LVCMOS33 } [get_ports {sw[5]}];
set_property -dict { PACKAGE_PIN U18  IOSTANDARD LVCMOS33 } [get_ports {sw[6]}];
set_property -dict { PACKAGE_PIN R13  IOSTANDARD LVCMOS33 } [get_ports {sw[7]}];
set_property -dict { PACKAGE_PIN T8  IOSTANDARD LVCMOS33 } [get_ports {sw[8]}];
set_property -dict { PACKAGE_PIN U8  IOSTANDARD LVCMOS33 } [get_ports {sw[9]}];
set_property -dict { PACKAGE_PIN R16  IOSTANDARD LVCMOS33 } [get_ports {sw[10]}];
set_property -dict { PACKAGE_PIN T13  IOSTANDARD LVCMOS33 } [get_ports {sw[11]}];
set_property -dict { PACKAGE_PIN H6  IOSTANDARD LVCMOS33 } [get_ports {sw[12]}];
set_property -dict { PACKAGE_PIN U12  IOSTANDARD LVCMOS33 } [get_ports {sw[13]}];
set_property -dict { PACKAGE_PIN U11  IOSTANDARD LVCMOS33 } [get_ports {sw[14]}];
set_property -dict { PACKAGE_PIN V10  IOSTANDARD LVCMOS33 } [get_ports {sw[15]}];

## LEDs (Ciphertext Output)
set_property -dict { PACKAGE_PIN H17  IOSTANDARD LVCMOS33 } [get_ports {led[0]}];
set_property -dict { PACKAGE_PIN K15  IOSTANDARD LVCMOS33 } [get_ports {led[1]}];
set_property -dict { PACKAGE_PIN J13  IOSTANDARD LVCMOS33 } [get_ports {led[2]}];
set_property -dict { PACKAGE_PIN N14  IOSTANDARD LVCMOS33 } [get_ports {led[3]}];
set_property -dict { PACKAGE_PIN R18  IOSTANDARD LVCMOS33 } [get_ports {led[4]}];
set_property -dict { PACKAGE_PIN V17  IOSTANDARD LVCMOS33 } [get_ports {led[5]}];
set_property -dict { PACKAGE_PIN U17  IOSTANDARD LVCMOS33 } [get_ports {led[6]}];
set_property -dict { PACKAGE_PIN U16  IOSTANDARD LVCMOS33 } [get_ports {led[7]}];
set_property -dict { PACKAGE_PIN V16  IOSTANDARD LVCMOS33 } [get_ports {led[8]}];
set_property -dict { PACKAGE_PIN T15  IOSTANDARD LVCMOS33 } [get_ports {led[9]}];
set_property -dict { PACKAGE_PIN U14  IOSTANDARD LVCMOS33 } [get_ports {led[10]}];
set_property -dict { PACKAGE_PIN T16  IOSTANDARD LVCMOS33 } [get_ports {led[11]}];
set_property -dict { PACKAGE_PIN V15  IOSTANDARD LVCMOS33 } [get_ports {led[12]}];
set_property -dict { PACKAGE_PIN V14  IOSTANDARD LVCMOS33 } [get_ports {led[13]}];
set_property -dict { PACKAGE_PIN V12  IOSTANDARD LVCMOS33 } [get_ports {led[14]}];
set_property -dict { PACKAGE_PIN V11  IOSTANDARD LVCMOS33 } [get_ports {led[15]}];