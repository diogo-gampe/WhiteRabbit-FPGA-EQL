############## NET - IOSTANDARD ##################
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

#############SPI Configurate Setting##################
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]

############## clock define##################
create_clock -period 5.000 [get_ports sys_clk_p]
set_property PACKAGE_PIN R4 [get_ports sys_clk_p]
set_property IOSTANDARD DIFF_SSTL15 [get_ports sys_clk_p]

############## reset define##################
set_property PACKAGE_PIN P17 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]

#TX TO USB 232 IC RX
set_property PACKAGE_PIN R18 [get_ports rs232_rx] 
#RX TO USB 232 IC TX
set_property PACKAGE_PIN T18 [get_ports rs232_tx] 

set_property IOSTANDARD LVCMOS33 [get_ports rs232_rx]
set_property IOSTANDARD LVCMOS33 [get_ports rs232_tx]