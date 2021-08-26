`timescale 1ns / 1ps

module spi_if

  ( 
    input       sclk,   // SPI CLK
    input       ss_n,   // SPI CS_N
    inout       sdio,
    output      direct, //----my changing
    
    //for clock divider
    input in_clk_p,
    input in_clk_n,
    output out_clk_n,
    output out_clk_p
    );

   wire  [7:0] rdata;
   wire  [7:0] wdata;
   wire [15:0] address;
   wire  [7:0] rdata_cdc;
   wire  [7:0] wdata_cdc;
   wire [15:0] address_cdc;
   wire        rd_en;
   wire        wr_en;
   wire        rd_en_cdc;
   wire        wr_en_cdc;
   wire        reset_spi;
   wire         dir;
   wire         mosi;
   wire         miso;
   wire  [7:0]  wire_clock_divide;
  
   reg sys_clk   = 1'b0;
   reg sys_reset = 1'b1;///
   assign direct = dir;//--------my 

   always begin
      sys_clk = 1'b0;
      #(3.0/2) sys_clk = 1'b1;
      #(3.0/2);
   end
 
   
   initial begin

   #1 @(posedge sys_clk) sys_reset =1'b0;
     end
   
   assign reset_spi = sys_reset || ss_n; // clear the SPI when the chip_select is inactive

   spi_slave_lbus u_spi_slave_lbus
     ( .sclk(sclk),      // input
       .mosi(mosi),      // input
       .miso(miso),      // output
       .reset_spi(reset_spi), // input
       .rdata(rdata),     // input [7:0]
       .rd_en(rd_en),     // output
       .wr_en(wr_en),     // output
       .wdata(wdata),     // output [7:0]
       .address(address ),    // output [15:0]
       .dir (dir)
       );

  sync_bits #(
  .NUM_OF_BITS (1),
  .ASYNC_CLK (1)
) sync_rd_en(
  .in_bits (rd_en),
  .out_resetn (1'b1),
  .out_clk (sys_clk),
  .out_bits (rd_en_cdc)
); 

  sync_bits #(
  .NUM_OF_BITS (1),
  .ASYNC_CLK (1)
) sync_wr_en(
  .in_bits (wr_en),
  .out_resetn (1'b1),
  .out_clk (sys_clk),
  .out_bits (wr_en_cdc)
); 

  sync_bits #(
  .NUM_OF_BITS (8),
  .ASYNC_CLK (1)
) sync_wdata(
  .in_bits (wdata),
  .out_resetn (1'b1),
  .out_clk (sys_clk),
  .out_bits (wdata_cdc)
); 

  sync_bits #(
  .NUM_OF_BITS (16),
  .ASYNC_CLK (1)
) sync_address(
  .in_bits (address),
  .out_resetn (1'b1),
  .out_clk (sys_clk),
  .out_bits (address_cdc)
); 


sync_data #(
  .NUM_OF_BITS(8),
  .ASYNC_CLK (1)
) sync_rdata (
  .in_clk (sys_clk),
  .in_data (rdata),
  .out_clk (sclk),
  .out_data (rdata_cdc)
); 


reg_file reg_file(
  
   .clk (sclk),/// changing sys_clk on a sclk
   .reset (sys_reset),
   .write (wr_en_cdc),
   .Addr (address_cdc [12:0]),
   .wrData (wdata_cdc),
   .rdData (rdata),
   .clock_divide(wire_clock_divide)
     );
     
  Clock_divide Clock_divide(
    .in_clk_p(in_clk_p),
    .in_clk_n(in_clk_n),
    .out_clk_n(out_clk_n),
    .out_clk_p(out_clk_p), 
    .register_value( wire_clock_divide)
                );   

IOBUF #(
      .DRIVE(12), // Specify the output drive strength
      .IBUF_LOW_PWR("TRUE"),  // Low Power - "TRUE", High Performance = "FALSE" 
      .IOSTANDARD("DEFAULT"), // Specify the I/O standard
      .SLEW("SLOW") // Specify the output slew rate
   ) IOBUF (
      .O(mosi),     // Buffer output
      .IO(sdio),   // Buffer inout port (connect directly to top-level port)
      .I(miso),     // Buffer input
      .T(dir)      // 3-state enable input, high=input, low=output
   );
 
endmodule