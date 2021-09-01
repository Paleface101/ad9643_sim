`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.08.2021 12:46:54
// Design Name: 
// Module Name: User_test_patern_1
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


module User_test_pattern(
input  [15:0] in_UserTestPattern1,
input  [15:0] in_UserTestPattern2,
input  [15:0] in_UserTestPattern3,
input  [15:0] in_UserTestPattern4,

output [15:0] out_UserTestPattern1,
output [15:0] out_UserTestPattern2,
output [15:0] out_UserTestPattern3,
output [15:0] out_UserTestPattern4
    );
    
  assign out_UserTestPattern1 = in_UserTestPattern1;
  assign out_UserTestPattern2 = in_UserTestPattern2;
  assign out_UserTestPattern3 = in_UserTestPattern3;
  assign out_UserTestPattern4 = in_UserTestPattern4;
  
  
endmodule
