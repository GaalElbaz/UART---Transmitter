`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: UART_TB
//////////////////////////////////////////////////////////////////////////////////


module UART_TB();
    
    localparam c_duty_cycle = 10;       // for a clock with freq of 100MHz.
    localparam c_clk_per_bit = 869;     // for a desired baud rate of 115200 -> 100*10^9 / 115200  ~ 869
                                        // when we divide the freq of a clock sigal by the baud rate, we get the number of clock cycles per second.
                                        // Clock signal freq -> represents the number of clock cycles per second
                                        // Baud rate -> represents the number of symbols per second
    localparam c_bit_period = 8690;     // bit period is the duration of one bit period for UART communication. 
    
    logic clk, tx_ready, tx_serial, tx_done;
    logic [7:0] tx_byte;
    
    UART_TX T0 (.clk(clk), .tx_ready(tx_ready), .tx_byte(tx_byte), .tx_serial(tx_serial), .tx_done(tx_done));
    
    always #(c_duty_cycle / 2) clk = ~clk;
    
    initial begin
        clk = 1'b0;
        tx_ready = 1'b1;
        tx_byte = 8'h23;
        #c_bit_period;
        #(8 * c_bit_period);
        #(c_bit_period);
        $finish;
       
    end
    
endmodule
