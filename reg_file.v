`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.08.2021 12:58:15
// Design Name: 
// Module Name: reg_file
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


module reg_file(
  
   input              clk,
   input              reset,
   input              write,
   input       [12:0] Addr,
   input       [7:0]  wrData,
   output      [7:0]  rdData,
   output wire [7:0]  clock_divide,
   output wire [15:0] UserTestPattern1,
   output wire [15:0] UserTestPattern2,
   output wire [15:0] UserTestPattern3,
   output wire [15:0] UserTestPattern4,
   output wire [7:0]  test_mode
     );

   reg [7:0]    regfile [0:8191];

   assign rdData           =  regfile [Addr];
   assign clock_divide     =  regfile [13'h0B];
   assign UserTestPattern1 = {regfile [13'h1A],regfile [13'h19]};
   assign UserTestPattern2 = {regfile [13'h1C],regfile [13'h1B]};
   assign UserTestPattern3 = {regfile [13'h1E],regfile [13'h1D]};
   assign UserTestPattern4 = {regfile [13'h20],regfile [13'h1F]};
   assign test_mode        =  regfile [13'h0D];
   integer   i;

   always @(posedge clk) begin
      if (reset) begin
            for (i = 0; i < 8192; i = i + 1) begin
                regfile[i] <= 0;
            end
      end else begin
            if (write) regfile[Addr] <= wrData;
            else  regfile[Addr] <= regfile[Addr];
      end 
   end
endmodule
