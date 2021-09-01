`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.08.2021 20:32:10
// Design Name: 
// Module Name: ad9643_sim
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
//`include "../config_dsp_tb.vh" 

module ad9643_sim #(
parameter PERIOD_250 = 4
 )
(
// SPI interface
     input wire sclk
    ,input wire csb
    ,inout wire sdio 
    ,input wire pdwn
    ,input wire sync
    
// ADC DDR interface
    ,input wire         clk_p
    ,input wire         clk_n
    ,output wire        or_p
    ,output wire        or_n
    ,output wire [13:0] data_p
    ,output wire [13:0] data_n
    ,output wire        dco_p
    ,output wire        dco_n
    
);

//logic data_spi_tx;
// data_spi_rx;

logic [1:0] OR_P;
logic       OVER_preparation ;

logic [14:0] data_count1 ;
logic        out_clk_n;
logic        out_clk_p;

reg   [13:0] data_p_reg ;
reg   [13:0] data_p_reg_delay;
//reg   [13:0] data_n_reg;
 
//assign data_p = data_p_reg  ;
//assign data_n = data_n_reg ;

assign data_n = ~data_p ;
assign dco_p = ~out_clk_p;
assign dco_n = ~out_clk_n;
assign or_p =  OR_P[1];
assign or_n = ~or_p;

initial begin 
data_count1 = 0;
OR_P = 0;
data_p_reg  = 0;
OVER_preparation = 0;
//data_n_reg  = 0;
#(10_000*PERIOD_250/2) OVER_preparation = 1;
@(negedge OR_P)
#(10*PERIOD_250/2) OVER_preparation = 0;
end


 always begin
 #(PERIOD_250/2) data_count1 <= data_count1 +1;
 if (data_count1 >= 14'b11_1111_1111_1111 && !OVER_preparation  )
    data_count1 <= 0;
 
end


always  @( posedge out_clk_p or posedge out_clk_n ) begin
   // data_p_reg <=  data_count1;
    if (data_count1 > 14'b11_1111_1111_1111 ) begin
         data_p_reg <= data_p_reg;
         OR_P[0]    <= 1;
    end
    else begin 
    OR_P[0]    <= 0;
    data_p_reg <=  data_count1;
    end
    
end 

//delay
always @( posedge out_clk_p or posedge out_clk_n ) begin
 OR_P[1] <= OR_P[0];
end

wire [15:0] in_UserTestPattern1_wire;
wire [15:0] out_UserTestPattern1_wire;

wire [15:0] in_UserTestPattern2_wire;
wire [15:0] out_UserTestPattern2_wire;

wire [15:0] in_UserTestPattern3_wire;
wire [15:0] out_UserTestPattern3_wire;

wire [15:0] in_UserTestPattern4_wire;
wire [15:0] out_UserTestPattern4_wire;

wire [7:0]  test_mode_wire;
//-----------------------------------------------------------
 spi_if SPI_IF0 (
 .sdio(sdio),
 .ss_n(csb),
 .sclk(sclk),
 //
 .in_clk_n(clk_n),
 .in_clk_p(clk_p),
 .out_clk_n(out_clk_n),
 .out_clk_p(out_clk_p),
 //
 .UserTestPattern1(in_UserTestPattern1_wire),
 .UserTestPattern2(in_UserTestPattern2_wire),
 .UserTestPattern3(in_UserTestPattern3_wire),
 .UserTestPattern4(in_UserTestPattern4_wire),
 // 
 .test_mode(test_mode_wire)
 );
//-------------------------------------------------------
 Test_mode Test_mode_p(
  .clk(out_clk_p),
  .normal_data(data_p_reg),
  .user_test_mode_control(test_mode_wire[7]),
  .reset_PN_long_gen(test_mode_wire[5]),
  .reset_PN_short_gen(test_mode_wire[4]),
  .select_mode(test_mode_wire[3:0]),
  .user_pattern_1(out_UserTestPattern1_wire),
  .user_pattern_2(out_UserTestPattern2_wire),
  .user_pattern_3(out_UserTestPattern3_wire),
  .user_pattern_4(out_UserTestPattern4_wire),
  .output_test_mode_reg(data_p));
 //-----------------------------------------------------------

  User_test_pattern  User_test_pattern(
  .in_UserTestPattern1 (in_UserTestPattern1_wire),
  .in_UserTestPattern2 (in_UserTestPattern2_wire),
  .in_UserTestPattern3 (in_UserTestPattern3_wire),
  .in_UserTestPattern4 (in_UserTestPattern4_wire),
  
  .out_UserTestPattern1(out_UserTestPattern1_wire),
  .out_UserTestPattern2(out_UserTestPattern2_wire),
  .out_UserTestPattern3(out_UserTestPattern3_wire),
  .out_UserTestPattern4(out_UserTestPattern4_wire)
  );


endmodule

