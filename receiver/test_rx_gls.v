//==============================================================================
// Module Name : test_rx_gls
// Project     : UART Receiver
// Author      : Ansh Shinde
//
// Description :
// Gate-Level Simulation Testbench for UART Receiver
//
// Features Tested:
// - UART frame reception
// - Start-bit detection
// - UART deserialization
// - FIFO buffering
// - Odd parity checking
// - Framing error detection
// - Multiple frame reception
// - Back-to-back UART frames
//
// Notes:
// - Same functional stimulus as RTL testbench
// - Timing differences expected due to gate delays
//
//==============================================================================

`timescale 1ns / 1ps

module test_rx_gls;

reg clk;
reg rst;
reg en;
reg rx;
reg parity_en;
reg parity_odd;

reg [8:0] div;

wire [7:0] data_out;
wire nr_full;
wire nr_empty;
wire frame_error;
wire parity_error;
wire overrun_error;


top_rx dut(
             .clk(clk),
             .rst(rst),
             .en(en),
             .rx(rx),
             .parity_en(parity_en),
             .parity_odd(parity_odd),
             .div(div),
             .data_out(data_out),
             .frame_error(frame_error),
             .parity_error(parity_error),
             .nr_full(nr_full),
             .nr_empty(nr_empty),
             .overrun_error(overrun_error)
             );


//------------------------------------------------------------------------------
// Clock Generation
//------------------------------------------------------------------------------

always #2 clk = ~clk;


//------------------------------------------------------------------------------
// UART Bit Task
//------------------------------------------------------------------------------

task send_bit;
input bit_val;
begin
    rx = bit_val;
    #416;
end
endtask


//------------------------------------------------------------------------------
// UART Frame Task
//------------------------------------------------------------------------------

task send_uart_frame;
input [7:0] data;
input parity;
input stop;

integer i;

begin

    // START BIT
    send_bit(0);

    // DATA BITS (LSB FIRST)
    for(i=0;i<8;i=i+1)
        send_bit(data[i]);

    // PARITY BIT
    send_bit(parity);

    // STOP BIT
    send_bit(stop);

    // IDLE
    #500;

end
endtask


//------------------------------------------------------------------------------
// Initial Conditions
//------------------------------------------------------------------------------

initial
begin

    clk          = 0;
    rst          = 1;
    en           = 0;

    parity_en    = 1;
    parity_odd   = 1;

    div          = 9'd104;

    rx           = 1;

    $dumpfile("rx_gls.vcd");
    $dumpvars(0,test_rx_gls);
end


//------------------------------------------------------------------------------
// Test Sequence
//------------------------------------------------------------------------------

initial
begin

    //----------------------------------------------------------------------
    // RESET
    //----------------------------------------------------------------------

    #100;
    rst = 0;
    #100;
    en  = 1;
    #100;


    //----------------------------------------------------------------------
    // NORMAL FRAME : 8'h11
    //----------------------------------------------------------------------

    send_uart_frame(8'h11,1,1);


    //----------------------------------------------------------------------
    // NORMAL FRAME : 8'hA5
    //----------------------------------------------------------------------

    send_uart_frame(8'hA5,1,1);


    //----------------------------------------------------------------------
    // PARITY ERROR FRAME
    //----------------------------------------------------------------------

    send_uart_frame(8'h55,0,1);


    //----------------------------------------------------------------------
    // FRAMING ERROR FRAME
    //----------------------------------------------------------------------

    send_uart_frame(8'h33,1,0);


    //----------------------------------------------------------------------
    // BACK TO BACK FRAMES
    //----------------------------------------------------------------------

    send_uart_frame(8'h77,1,1);
    send_uart_frame(8'h88,1,1);
    send_uart_frame(8'h99,1,1);


    //----------------------------------------------------------------------
    // END SIMULATION
    //----------------------------------------------------------------------

    #100000;

    $finish;

end

endmodule
