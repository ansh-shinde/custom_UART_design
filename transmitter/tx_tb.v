//==============================================================================
// Module Name : test_tx
// Project     : UART Transmitter
// Author      : Ansh Shinde
//
// Description :
// Verification testbench for UART transmitter.
//
// Features tested:
// - FIFO write operation
// - UART frame transmission
// - Parity-enabled transmission
// - Baud-rate controlled shifting
// - FIFO buffering behavior
//
//==============================================================================

`timescale 1ns / 1ps
module test_tx;
reg clk,wr,rst,en,parity_en,parity_odd;
reg [7:0]data_in;
reg [8:0]div;
wire tx,full,nr_full,nr_empty;
integer i;

top_tx dut(
           .clk(clk),
           .wr(wr),
           .en(en),
           .rst(rst),
           .tx(tx),
           .full(full),
           .nr_full(nr_full),
           .parity_en(parity_en),
           .parity_odd(parity_odd),
           .nr_empty(nr_empty),
           .div(div),
           .data_in(data_in)
           );


//------------------------------------------------------------------------------
// Initial Conditions
//------------------------------------------------------------------------------
    initial
    begin
    clk=0;
    wr=0;
    rst=0;
    en=0;
    parity_en=1;
    parity_odd=1;
    div=9'd104;
    data_in=8'b0;
    $dumpfile("tx.vcd");
    $dumpvars(0,test_tx);
    $dumpvars(0, dut.dat.fifo.dat.str.regfile[0]);
    $dumpvars(0, dut.dat.fifo.dat.str.regfile[1]);
    $dumpvars(0, dut.dat.fifo.dat.str.regfile[2]);
    $dumpvars(0, dut.dat.fifo.dat.str.regfile[3]);
    $dumpvars(0, dut.dat.fifo.dat.str.regfile[4]);
    $dumpvars(0, dut.dat.fifo.dat.str.regfile[5]);
    $dumpvars(0, dut.dat.fifo.dat.str.regfile[6]);
    $dumpvars(0, dut.dat.fifo.dat.str.regfile[7]);
    #20000 $finish;
    end

//------------------------------------------------------------------------------
// Clock Generation
//------------------------------------------------------------------------------
    always #5 clk=~clk;


//------------------------------------------------------------------------------
// UART Transmission Stimulus
//------------------------------------------------------------------------------
    initial
    begin
    #4  rst=1;
    #10 wr=1;en=1;rst=0;
    #10 data_in=8'd11;
    #10 data_in=8'd22;
    #10 data_in=8'd33;
    #10 data_in=8'd44;
    #10 data_in=8'd55;
    #10 data_in=8'd66;
    #10 data_in=8'd77;
    #10 data_in=8'd88;
    #10 data_in=8'd99;
    #10 data_in=8'd00;

    end

endmodule
