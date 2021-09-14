`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.09.2021 15:35:09
// Design Name: 
// Module Name: reg_file_m
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


module reg_file_m(
   input                clk,
   input                reset,
   input                write,
   input         [12:0] Addr,
   input         [7:0]  wrData,
   output        [7:0]  rdData,
   output   wire [7:0]  data [0:8191],
   output   wire        transfer_reg
     );

   reg [7:0]    regfile [0:8191];
   
   assign data         = regfile;
   assign transfer_reg = regfile [13'hFF];
   assign rdData       = regfile [Addr];
   
   integer   i;

   always @(posedge clk) begin
      if (reset) begin
            for (i = 0; i < 8192; i = i + 1) begin
                regfile[i] <= 0;
            end
      end else begin
            if (write) regfile[Addr] <= wrData;
           // else  regfile[Addr] <= regfile[Addr];
            if ( regfile [13'hFF][0] == 1 && !write ) regfile [13'hFF][0] <= 0;
      end 
      
   end
endmodule