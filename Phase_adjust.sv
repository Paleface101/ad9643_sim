`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module Phase_adjust(
   input [2:0] delay,
   input       in_clk_p_delay,
   input       in_clk_p,
   input        reset,
   output logic out_clk_p,
   output       out_clk_n 
    );
   
 logic [13:0] out_clk_p_reg;
 
 always_ff @(posedge in_clk_p or negedge in_clk_p)   begin
 if (reset) out_clk_p_reg <= 0;
 else begin
    for (integer  i = 13; i > 0; i-- ) begin
    out_clk_p_reg[i] <= out_clk_p_reg[i-1];
    end
    out_clk_p_reg[0] <= in_clk_p_delay;
 end
 end
  
   always_comb begin
    case ( delay )
    3'b000: out_clk_p = in_clk_p_delay;   //no delay 
    3'b001: out_clk_p = out_clk_p_reg[1]; //1 input clock cycle
    3'b010: out_clk_p = out_clk_p_reg[3]; //2 input clock cycle
    3'b011: out_clk_p = out_clk_p_reg[5]; //3 input clock cycle
    3'b100: out_clk_p = out_clk_p_reg[7]; //4 input clock cycle
    3'b101: out_clk_p = out_clk_p_reg[9]; //5 input clock cycle
    3'b110: out_clk_p = out_clk_p_reg[11]; //6 input clock cycle
    3'b111: out_clk_p = out_clk_p_reg[13]; //7 input clock cycle
    default:out_clk_p = in_clk_p_delay;   //no delay 
    endcase
   end
   
 assign out_clk_n = ~out_clk_p;
     
endmodule
