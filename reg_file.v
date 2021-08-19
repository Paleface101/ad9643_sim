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
  
   input clk,
   input reset,
   input write,
   input [12:0] Addr,
   input [7:0] wrData,
   output [7:0] rdData
     );

   reg [7:0]    regfile [0:8191];

   assign rdData = regfile[Addr];
  
   integer   i;

   always @(posedge clk) begin
      if (reset) begin
            for (i = 0; i < 8192; i = i + 1) begin
                regfile[i] <= 0;
            end
      end else begin
            if (write) regfile[Addr] <= wrData;
           // else  regfile[Addr] <= regfile[Addr];
      end 
   end
endmodule
