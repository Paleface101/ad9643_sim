`timescale 1ns / 1ps
// CPOL == 1'b0, CPHA = 1'b0, 

module spi_slave_lbus
  ( input             sclk,           // SPI
    input             mosi,           // SPI
    output reg        miso      =0,   // SPI
    input             reset_spi,      // ASYNC_RESET
    input       [7:0] rdata,          // LBUS
    output reg        rd_en     = 0,  // LBUS
    output reg        wr_en     = 0,  // LBUS
    output reg  [7:0] wdata     = 0,  // LBUS
    output reg [15:0] address   = 0,  // LBUS
    output reg        dir       = 1'b1
    );

   reg [6:0] mosi_buffer =0;
   reg [5:0] bit_count =0;
   reg       read_cycle =0;
   reg       write_cycle =0;
   reg       multi_cycle =0;

   always @(posedge sclk or posedge reset_spi)
     if (reset_spi) mosi_buffer <= 7'd0;
     else           mosi_buffer <= {mosi_buffer[5:0],mosi};

   always @(posedge sclk or posedge reset_spi)
     if (reset_spi)                                          bit_count <= 6'd0;
     else if ((read_cycle  == 1'b1) && (bit_count == 6'd23)) bit_count <= 6'd16;/////----maybe 24
     else if ((write_cycle == 1'b1) && (bit_count == 6'd24)) bit_count <= 6'd17;///----maybe 25
     else                                                    bit_count <= bit_count + 1;

   always @(negedge sclk or posedge reset_spi)
     if (reset_spi)              begin   miso <= 1'b0; dir <= 1'b1;  end
     else if (bit_count < 6'd16) begin   miso <= 1'b0; dir <= 1'b1;  end
     else if (rd_en == 1'b1)     begin   miso <= rdata[6'd23 - bit_count]; dir <= 1'b0; end///----maybe 24
     else                        begin   miso <= 1'b0;   end
     
//////////////////////////////////////read cycle detect and rd_en strobe generate//////
   

  always @(posedge sclk or posedge reset_spi)
     if (reset_spi)                                          read_cycle <= 1'b0;
   
       else if ((bit_count == 6'd0) && (mosi_buffer == 7'h00) && (mosi == 1'b1)) read_cycle <= 1'b1;
  always @(posedge sclk or posedge reset_spi)
      if (reset_spi)                                         rd_en <= 1'b0;
      else if ((read_cycle == 1'b1) && (bit_count >= 6'd15)) rd_en <= 1'b1;///----maybe 16
      else                                                   rd_en <= 1'b0;
///////////////////////////////////// write cycle detect and wr_en strobe generate/////////
  always @(posedge sclk or posedge reset_spi)
     if (reset_spi)                                          write_cycle <= 1'b0;
            else if ((bit_count == 6'd0) && (mosi_buffer == 7'h00) && (mosi == 1'b0)) write_cycle <= 1'b1;
   always @(posedge sclk or posedge reset_spi)
      if (reset_spi)                                          wr_en <= 1'b0;
      else if ((write_cycle == 1'b1) && (bit_count == 6'd23)) wr_en <= 1'b1;////----maybe 24
      else                                                    wr_en <= 1'b0;
/////////////////////////////////////////////address ////////////
    always @(posedge sclk or posedge reset_spi)
      if (reset_spi)                                                address[15:0] <= 16'h0000;
      else if ((read_cycle || write_cycle) && (bit_count == 6'd7))  address[15:8] <= {mosi_buffer[6:0],mosi}; //write msb address//changed 7 to 8
      else if ((read_cycle || write_cycle) && (bit_count == 6'd15)) address[7:0]  <= {mosi_buffer[6:0],mosi}; //write lsb address
  ///maybe 8 and 16-------------------------------------------^
/////////////////////// data  (write) ///////////
    always @(posedge sclk or posedge reset_spi)
      if (reset_spi)                                wdata <= 8'h00;
      else if (write_cycle && (bit_count == 6'd23)) wdata <= {mosi_buffer[6:0],mosi};// write data to wdata
//maybe 24----------------------------------------^
endmodule
