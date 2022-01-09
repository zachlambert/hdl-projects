//////////////////////////////////////////////////////////////////////
// File Downloaded from http://www.nandland.com
//////////////////////////////////////////////////////////////////////

// This testbench will exercise both the UART Tx and Rx.
// It sends out byte 0xAB over the transmitter
// It then exercises the receive by receiving byte 0x3F
`timescale 1ns/10ps

`include "src/main.v"
`include "src/uart_tx.v"
`include "src/pulse.v"

module main_tb ();

    parameter c_CLOCK_PERIOD_NS = 83; //approx
    reg r_Clock = 0;

    always
        #(c_CLOCK_PERIOD_NS/2) r_Clock <= !r_Clock;

    wire w_Rx_Serial = 1;
    wire [7:0] w_Rx_Byte;

    hello_world HELLO_WORLD_INST (
        .clk(r_Clock),
        .tx(w_Rx_Serial)
    );

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, main_tb);
        #(120000000);
        $display(w_Rx_Byte);
        $finish;
    end
endmodule
