`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////



module Transfer(
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
    
  wire [7:0] data_wire [8191:0]; 
  wire       transfer_wire;
 
  

  
  reg_file_m reg_file_m( 
 .clk(clk),
 .reset(reset),
 
 .write(write),
 .Addr(Addr),
 .wrData(wrData),
 
 .rdData(rdData),
 
 .data(data_wire),
 .transfer_reg(transfer_wire)
 
  );
  //-------------------------------------------
  reg_file_s   reg_file_s(
  .clk(clk),
  .reset(reset),
 
  .data(data_wire),
  .transfer_reg(transfer_wire),
         
  .clock_divide(clock_divide),
  .UserTestPattern1(UserTestPattern1),
  .UserTestPattern2(UserTestPattern2),
  .UserTestPattern3(UserTestPattern3),
  .UserTestPattern4(UserTestPattern4),
  .test_mode(test_mode)
  ) ; 
    
endmodule
