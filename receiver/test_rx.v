//==============================================================================
// Module Name : test_rx
// Project     : UART Receiver
// Author      : Ansh Shinde
//
// Description :
//
// Verification testbench for UART receiver.
//
// Features tested:
// - UART frame reception
// - Start-bit detection
// - 16x oversampling
// - UART deserialization
// - Parity checking
// - FIFO buffering
// - Error handling
//
// Verification Method:
// - Manual UART serial stimulus
// - Waveform-based verification using GTKWave
//
//==============================================================================
`timescale 100ns / 1ps
module test_rx;
reg clk,rst,en,rx,parity_en,parity_odd;
reg [8:0]div;
wire [7:0]data_out;
wire nr_full,nr_empty,frame_error,parity_error,overrun_error;

top_rx   dut(
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
             always #5 clk=~clk;


//------------------------------------------------------------------------------
// Initial Conditions and Waveform Dump
//------------------------------------------------------------------------------
             initial
             begin
             clk=0;
             rst=0;
             en=0;
             parity_en=1;
             parity_odd=1;
             div=9'd104;
             rx=1;

             $dumpfile("rx.vcd");
             $dumpvars(0,test_rx);
             $dumpvars(0, dut.dat.fifo.dat.str.regfile[0]);
             $dumpvars(0, dut.dat.fifo.dat.str.regfile[1]);
             $dumpvars(0, dut.dat.fifo.dat.str.regfile[2]);
             $dumpvars(0, dut.dat.fifo.dat.str.regfile[3]);
             $dumpvars(0, dut.dat.fifo.dat.str.regfile[4]);
             $dumpvars(0, dut.dat.fifo.dat.str.regfile[5]);
             $dumpvars(0, dut.dat.fifo.dat.str.regfile[6]);
             $dumpvars(0, dut.dat.fifo.dat.str.regfile[7]);

             #200000 $finish;
             end

 //------------------------------------------------------------------------------
// UART RX Stimulus
//------------------------------------------------------------------------------
             initial
             begin
             #130 rst=1;
             #70 rst=0; en=1;
             #140 rx=0;
             #1000 rx=0;
             #1000 rx=0;
             #1000 rx=0;
             #1000 rx=0;
             #1000 rx=1;
             #1000 rx=1;
             #1000 rx=1;
             #1000 rx=1;
             #1000 rx=0;
             #1000 rx=1;
             end
endmodule

        

             



    

