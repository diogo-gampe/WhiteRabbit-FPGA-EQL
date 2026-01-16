`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/26 11:37:12
// Design Name: 
// Module Name: uart_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_top(
//Differential system clocks
    sys_clk_p,//200M
    sys_clk_n,    
    //rst_n,  //S1
// UART Interface
    rs232_tx ,
    rs232_rx 

    );

input         sys_clk_p;
input         sys_clk_n;
//input         rst_n;    
output        rs232_tx;
input         rs232_rx;    
    
    
 wire [7:0]  rx_data;
 wire        po_flag;
 wire        sys_clk;
 wire        locked;
 wire        clk_50M;
 
IBUFDS sys_clk_ibufgds
(
	.O        (sys_clk  ),
	.I        (sys_clk_p),
	.IB       (sys_clk_n)
); 
 
  clk_wiz_0 instance_name
   (
    // Clock out ports
    .clk_out1(clk_50M),     // output clk_out1
    // Status and control signals
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1(sys_clk));      // input clk_in1 
 
   
uart_tx uart_tx_inst(
    . sclk      (clk_50M),
    . s_rst_n   (locked),
    // UART Interface
    . rs232_tx  (rs232_tx),
    // others
    . tx_trig   (po_flag),
    . tx_data   (rx_data)
    );    
    
uart_rx uart_rx_inst(
    . sclk      (clk_50M),
    . s_rst_n   (locked),
    // UART Interface
    . rs232_rx  (rs232_rx),
    // others
    . rx_data   (rx_data),
    . po_flag   (po_flag)
    ); 
    
ila_0 your_instance_name (
	.clk(sys_clk), // input wire clk


	.probe0(rs232_rx), // input wire [0:0]  probe0  
	.probe1(rs232_tx) // input wire [0:0]  probe1
);      
    
endmodule
