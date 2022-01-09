//////////////////////////////////////////////////////////////////////
// File Downloaded from http://www.nandland.com
//////////////////////////////////////////////////////////////////////

// This testbench will exercise both the UART Tx and Rx.
// It sends out byte 0xAB over the transmitter
// It then exercises the receive by receiving byte 0x3F
`timescale 1ns/10ps

`include "src/main.v"
`include "src/uart_rx.v"

module main_tb ();
 
    parameter c_CLOCK_PERIOD_NS = 83; //approx
    parameter c_CLKS_PER_BIT = 1250;
    parameter c_BIT_PERIOD = 104167;

    reg r_Clock = 0;

    // Takes in input byte and serializes it 
    task UART_WRITE_BYTE;
        input [7:0] i_Data;
        integer     ii;
        begin
            // Send Start Bit
            r_Rx_Serial <= 1'b0;
            #(c_BIT_PERIOD);
            #1000;
            // Send Data Byte
            for (ii=0; ii<8; ii=ii+1) begin
                r_Rx_Serial <= i_Data[ii];
                #(c_BIT_PERIOD);
            end
            // Send Stop Bit
            r_Rx_Serial <= 1'b1;
            #(c_BIT_PERIOD);
        end
    endtask // UART_WRITE_BYTE
   
    always
        #(c_CLOCK_PERIOD_NS/2) r_Clock <= !r_Clock;

    reg r_Rx_Serial = 1;

    read_number READ_NUMBER_INST (
        .clk(r_Clock),
        .rx(r_Rx_Serial)
    );
 
    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, main_tb);
        @(posedge r_Clock)
        UART_WRITE_BYTE(8'h01);
        @(posedge r_Clock)
        UART_WRITE_BYTE(8'h02);
        @(posedge r_Clock)
        UART_WRITE_BYTE(8'h03);
        @(posedge r_Clock)
        UART_WRITE_BYTE(8'h04);
        @(posedge r_Clock)
        @(posedge r_Clock)
        @(posedge r_Clock)
        $display(READ_NUMBER_INST.received_int);
        $finish;
    end
endmodule
