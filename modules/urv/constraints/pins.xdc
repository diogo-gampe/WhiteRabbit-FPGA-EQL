##  Entrada de Clock (200 MHz)
set_property PACKAGE_PIN R4 [get_ports sys_clk_p]
set_property IOSTANDARD DIFF_SSTL15 [get_ports sys_clk_p]
create_clock -period 5.000 -name sys_clk_pin -waveform {0.000 2.500} [get_ports sys_clk_p]

# LED0 (IO_B15_LN_5)
set_property PACKAGE_PIN H15 [get_ports {led_o[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_o[0]}]

# LED1 (IO_B15_LP_5)
set_property PACKAGE_PIN J15 [get_ports {led_o[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_o[1]}]