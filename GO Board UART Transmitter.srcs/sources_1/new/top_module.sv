`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: top_module
//////////////////////////////////////////////////////////////////////////////////


module top_module(
    input clk,
    input [7:0] sw,
    input tx_ready,
    output [1:0] led
    );
    
    debounce L2(.clk(clk), .button_in(tx_ready));
    UART_TX L1(.clk(clk), .tx_byte(sw), .tx_ready(tx_ready), .tx_serial(led[0]), .tx_done(led[1]));
    
    
endmodule
