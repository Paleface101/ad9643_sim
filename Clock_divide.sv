`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module Clock_divide( 
input       in_clk_p,
input       in_clk_n,
input [7:0] register_value,
output      out_clk_p,
output      out_clk_n
    );
    
logic       reset;
logic [7:0] register_value_delay ; 

   // detect changes register value 
 always_ff @(posedge in_clk_p or negedge in_clk_p)   begin
        register_value_delay  <= register_value;
        reset                 <= 0;  
    if (register_value != register_value_delay )
        reset <= 1;
 end
    
    
 Clock_divide_ratio Clock_divide_ratio(
 .in_clk_p(in_clk_p),
 .in_clk_n(in_clk_n),
 .clock_ratio(register_value[2:0]),
 .reset(reset),
 .out_clk_p(out_clk_p_wire)
 );    
    
Phase_adjust Phase_adjust(
  .delay(register_value[5:3]),
  .in_clk_p_delay(out_clk_p_wire),
  .in_clk_p(in_clk_p),
  .reset(reset),
  .out_clk_p(out_clk_p),
  .out_clk_n (out_clk_n)
 );  
    
    
endmodule

