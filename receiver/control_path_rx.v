//==============================================================================
// Module Name : control_path_rx
// Project     : UART Receiver
// Author      : Ansh Shinde
//
// Description :
//
// FSM-based UART receiver control path.
//
// Features:
// - UART receive sequencing
// - Start-bit detection handling
// - 16x oversampling control
// - UART frame sampling control
// - FIFO read/write control
// - Parity error detection
// - Frame error detection
// - Overrun error detection
//
// FSM States:
// - IDLE
// - SAMPLE
// - PARITY
// - PUSH
//
// Notes:
// - Current implementation uses simplified FSM architecture
// - Current implementation uses fixed UART frame format
// - Dynamic UART framing is not yet implemented
// - Current implementation supports single stop bit
//
//==============================================================================
module control_path_rx #(parameter DEPTH=8, 
                        WIDTH=8,
                        N=$clog2(DEPTH)
                      )(
                        input clk,
                        input rst,
                        input en,
                        input parity_en,
                        input parity_odd,
                        input [8:0]div,
                        input start,
                        input stop,
                        input [3:0]bit_count,
                        input [3:0]sample_count,
                        input full,
                        input empty,
                        input calculated_parity,
                        input parity_bit,
                        output reg rd,
                        output reg wr,
                        output reg sample_bit,
                        output reg clr_shiftreg,
                        output reg frame_error,
                        output reg parity_error,
                        output reg overrun_error,
                        output reg latch,
                        output reg en_counter
                        );
                        
                        parameter IDLE=0,SAMPLE=1,PARITY=2,PUSH=3;
                        reg [1:0]ns,ps;

//------------------------------------------------------------------------------
// State Register
//------------------------------------------------------------------------------
//
// Updates present state on clock edge.
//
// Functionality:
// - Stores current FSM state
// - Handles asynchronous reset
//
//------------------------------------------------------------------------------
                        always@(posedge clk or posedge rst)begin
                        if(rst)begin
                        ps<=IDLE;
                        end
                        else if(en)begin
                        ps<=ns;
                        end
                        end

//------------------------------------------------------------------------------
// Next-State Logic
//------------------------------------------------------------------------------
//
// Determines next FSM state based on:
//
// - Start-bit detection
// - UART frame progress
// - Parity validation
//
//------------------------------------------------------------------------------
                        always@(*)begin
                        case(ps)
                        IDLE:begin
                             if(start)begin
                             ns=SAMPLE;
                             end
                             else begin
                             ns=IDLE;
                             end
                             end
                        SAMPLE:begin
                               if(bit_count==11)begin
                               ns=PARITY;
                               end
                               else begin
                               ns=SAMPLE;
                               end
                               end
                        PARITY:begin
                               if(parity_bit == calculated_parity)begin
                               ns=PUSH;
                               end
                               else begin
                               ns=IDLE;
                               end
                               end
                        PUSH:begin
                             ns=IDLE;
                             end
                        default:ns=IDLE;
                        endcase
                        end

//------------------------------------------------------------------------------
// FSM Output Logic
//------------------------------------------------------------------------------
//
// Generates UART receiver control signals:
//
// - Sampling control
// - FIFO read/write control
// - Shift-register clear control
// - Error detection signals
// - Data latch control
//
//------------------------------------------------------------------------------
                        always@(*)begin
                          rd=              0;
                          wr             = 0;
                          sample_bit     = 0;
                          clr_shiftreg   = 0;
                          frame_error    = 0;
                          parity_error   = 0;
                          overrun_error  = 0;
                          latch          = 0;
                        en_counter = (ps == SAMPLE);
                        case(ps)
                        IDLE:begin
                             rd=0;
                             wr=0;
                             sample_bit=0;
                             clr_shiftreg=0;
                             frame_error=0;
                             parity_error=0;
                             overrun_error=0;
                             latch=0;
                             end
                        SAMPLE:begin
                               if(sample_count==7)begin
                               sample_bit=1;
                               end
                               else if(sample_count!=7)begin
                               sample_bit=0;
                               end
                               if(stop)begin
                               frame_error=0;
                               latch=1;
                               clr_shiftreg=0;
                               end
                               else begin
                               frame_error=1;
                               clr_shiftreg=1;
                               latch=0;
                               end
                               end
                        PARITY:begin
                               if(!(parity_bit == calculated_parity))begin
                               parity_error=1;
                               clr_shiftreg=1;
                               end
                               else begin
                               parity_error=0;
                               clr_shiftreg=0;
                               end
                               end
                        PUSH:begin
                             if(full && start)begin
                             wr=0;
                             overrun_error=1;
                             rd=1;
                             end
                             else if(empty)begin
                             rd=0;
                             wr=1;
                             end
                             else if(!full && !empty && !frame_error && !parity_error)begin
                             wr=1;
                             rd=1;
                             end
                             else begin
                             wr=0;
                             rd=0;
                             overrun_error=0;
                             end
                             end
                       default:begin
                               rd=0;
                               wr=0;
                               sample_bit=0;
                               clr_shiftreg=0;
                               frame_error=0;
                               parity_error=0;
                               overrun_error=0;
                               latch=0;
                               end
                       endcase
                       end
endmodule
                             






