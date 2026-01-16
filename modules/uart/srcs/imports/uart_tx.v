`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/26 11:31:11
// Design Name: 
// Module Name: uart_tx
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


module uart_tx(
// system signals
input sclk ,
input s_rst_n ,
// UART Interface
output reg rs232_tx ,
// others
input tx_trig ,
input [ 7:0] tx_data
);
//====================================================================\
// ********** Define Parameter and Internal Signals *************
//====================================================================/

localparam BAUD_END = 433 ;

localparam BAUD_M = BAUD_END/2 - 1 ;
localparam BIT_END = 8 ;
reg [ 7:0] tx_data_r ;
reg tx_flag ;
reg [12:0] baud_cnt ;
reg bit_flag ;
reg [ 3:0] bit_cnt ;
//=================================================================================
// *************** Main Code ****************
//=================================================================================
// tx_data_r
always @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
            tx_data_r <= 'd0;
        else if(tx_trig == 1'b1 && tx_flag == 1'b0)
            tx_data_r <= tx_data;
end
// tx_flag
always @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
            tx_flag <= 1'b0;
        else if(tx_trig == 1'b1)
            tx_flag <= 1'b1;
        else if(bit_cnt == BIT_END && bit_flag == 1'b1)
            tx_flag <= 1'b0;
end
//baud_cnt
always @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
            baud_cnt <= 'd0;
        else if(baud_cnt == BAUD_END)
            baud_cnt <= 'd0;
        else if(tx_flag == 1'b1)
            baud_cnt <= baud_cnt + 1'b1;
        else
            baud_cnt <= 'd0;
end
// bit_flag
always @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
            bit_flag <= 1'b0;
        else if(baud_cnt == BAUD_END)
            bit_flag <= 1'b1;
        else
            bit_flag <= 1'b0;
end
//bit_cnt
always @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
            bit_cnt <= 'd0;
        else if(bit_flag == 1'b1 && bit_cnt == BIT_END)
            bit_cnt <= 'd0;
        else if(bit_flag == 1'b1)
            bit_cnt <= bit_cnt + 1'b1;
end
// rs232_tx
always @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
            rs232_tx <= 1'b1;
        else if(tx_flag == 1'b1)
            case(bit_cnt)
                    0: rs232_tx <= 1'b0; // start bit
                    1: rs232_tx <= tx_data_r[0];
                    2: rs232_tx <= tx_data_r[1];
                    3: rs232_tx <= tx_data_r[2];
                    4: rs232_tx <= tx_data_r[3];
                    5: rs232_tx <= tx_data_r[4];
                    6: rs232_tx <= tx_data_r[5];
                    7: rs232_tx <= tx_data_r[6];
                    8: rs232_tx <= tx_data_r[7];
                    default:rs232_tx <= 1'b1;
            endcase
        else
            rs232_tx <= 1'b1;
end


endmodule
