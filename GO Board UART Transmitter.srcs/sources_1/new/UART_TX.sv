`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: UART_TX
//////////////////////////////////////////////////////////////////////////////////


module UART_TX(
    input clk,                  // clock of the fpga board. in this project we use GO BOARD which has a clock in freq of 25MHz.
    input [7:0] tx_byte,        // the parallel data we are going to send to the cpu
    input tx_ready,
    output logic tx_serial,     // serial bit
    output logic tx_done        // signal that the data is valid
    );
    
    // Based on the freq of the clock on the Basys3 (100Mhz) divided by the freq of the baud rate (115200)
    // we will get 869 clocks per bit.    
    localparam CLKS_PER_BIT = 869;
    
    // We are going to use a state machine so we will specify the states.
    localparam IDLE = 2'b00;
    localparam TX_START_BIT = 2'b01;
    localparam TX_DATA_BITS = 2'b10;
    localparam TX_STOP_BIT = 2'b11;
    
    // The UART receiver will look for the falling edge in order to find the start bit.
    // we are sampling the middle of each bit -> there are 869 clocks per bit so it will count to 869/2
    logic [9:0] clock_count = 10'b0000000000; // in order to represent 869/2
    logic [2:0] bit_index = 3'b000;   // 8 bits in total -> 3 index bit
    logic bit_out = 1'b1;           // temp variable
    logic data_done = 1'b0;         // temp variable
    logic [7:0] tx_data = 8'b00000000;     // temp variable
    logic [2:0] uart_state = IDLE;
    
    always_ff @(posedge clk) begin
        case(uart_state) 
            IDLE: begin
                clock_count <= 10'b0000000000;
                bit_index <= 3'b000;
                data_done <= 1'b0;
                if(tx_ready) begin              // if button to transmit data is pressed
                    tx_data <= tx_byte;
                    uart_state <= TX_START_BIT;
                end
                else begin
                    uart_state <= IDLE;
                end            
            end
            TX_START_BIT: begin
                bit_out <= 1'b0;                // send a start bit
                if(clock_count < (CLKS_PER_BIT-1)) begin
                    clock_count <= clock_count + 1'b1;
                    uart_state <= TX_START_BIT;
                end
                else begin
                    clock_count <= 10'b0000000000;
                    uart_state <= TX_DATA_BITS;
                end
            end
            TX_DATA_BITS: begin
                bit_out <= tx_data[bit_index];  // serialize the data
                if(clock_count < (CLKS_PER_BIT-1)) begin
                    clock_count <= clock_count + 1'b1;
                    uart_state <= TX_DATA_BITS;
                end
                else begin   
                    if(bit_index <= 7) begin     // check if we send all bits
                        $display("Serial bit sent is %0d in time %t", tx_data[bit_index], $time);
                        bit_index <= bit_index + 1'b1;
                        clock_count <= 10'b0000000000;
                        uart_state <= TX_DATA_BITS;
                    end
                    else begin
                        clock_count <= 10'b0000000000;
                        uart_state <= TX_STOP_BIT;
                    end
                end
            end
            TX_STOP_BIT: begin
                bit_out <= 1'b1;
                if(clock_count < (CLKS_PER_BIT-1)) begin    // wait for stop bit to finish
                    clock_count <= clock_count + 1'b1;
                    uart_state <= TX_STOP_BIT;
                end
                else begin
                    $display("end of stop bit %0d", bit_out);
                    uart_state <= IDLE;
                    data_done <= 1'b1;
                end
            end
        endcase
    end
    
    assign tx_done = data_done;
    assign tx_serial = bit_out;
     
endmodule
