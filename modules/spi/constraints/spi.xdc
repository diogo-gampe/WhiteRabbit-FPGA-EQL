
############## clock define##################
create_clock -period 5.000 [get_ports clock_p]
set_property PACKAGE_PIN R4 [get_ports clock_p]
set_property IOSTANDARD DIFF_SSTL15 [get_ports clock_p]

## ========== SPI + nRST no conector J15 (Bank 13 / 3.3V) ==========
# SCLK (FPGA -> STM32) V10 -> Pino 3
set_property -dict { PACKAGE_PIN V10 IOSTANDARD LVCMOS33 } [get_ports {sclk}]

# MOSI (FPGA -> STM32) U15 -> Pino 15
set_property -dict { PACKAGE_PIN U15 IOSTANDARD LVCMOS33 } [get_ports {mosi}]

# MISO (STM32 -> FPGA) Y11 -> Pino 7
set_property -dict { PACKAGE_PIN Y11 IOSTANDARD LVCMOS33 } [get_ports {miso}]

# CS / SS_n (FPGA -> STM32)  (ativo em 0) Y12 -> Pino 8
set_property -dict { PACKAGE_PIN Y12 IOSTANDARD LVCMOS33 PULLUP true SLEW FAST DRIVE 8 } [get_ports {ss_n}]

# nRST (FPGA -> STM32 NRST) W11 -> Pino 10
set_property -dict { PACKAGE_PIN P17 IOSTANDARD LVCMOS33 PULLUP true SLEW SLOW DRIVE 4 } [get_ports {reset_n}]
