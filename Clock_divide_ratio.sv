`timescale 1ns / 1ps

module Clock_divide_ratio(
input       in_clk_p,
input       in_clk_n,
input [2:0] clock_ratio,
input       reset,
output      out_clk_p
//output out_clk_n
    );
    
logic [2:0] counter_p     = 0;
logic [2:0] counter_n     = 0;
logic       out_clk_p_reg = 0;
logic       out_clk_n_reg = 0;
logic [3:0] ratio         = 0; 


always_comb begin
  //coder
  case (clock_ratio)
  3'b000: out_clk_p_reg = in_clk_p;// /division by 1
  3'b001: ratio = 4'b0000; //0;  // /division by 2
  3'b010: ratio = 4'b1011; //3; // /division by 3
  3'b011: ratio = 4'b0001; //1; // /division by 4
  3'b100: ratio = 4'b1101; //5;// /division by 5
  3'b101: ratio = 4'b0010; //2;// /division by 6
  3'b110: ratio = 4'b1111; //7;// /division by 7
  3'b111: ratio = 4'b0011; //3;// /division by 8
  default: out_clk_p_reg = in_clk_p;
  endcase
end

always_ff @( posedge in_clk_p ) begin
  if (reset) begin
  out_clk_p_reg  <= 1'b0;
  counter_p      <= 1'b0;
  end else begin
    if ( counter_p >= ratio  && clock_ratio != 0) begin
       out_clk_p_reg  <= ~out_clk_p_reg;
       counter_p      <= 1'b0;
     end else begin
       counter_p <= counter_p + 1'b1;
    end  
  end
end 
 
always_ff @( negedge in_clk_p or posedge in_clk_p) begin
    if (reset) begin
        counter_n     <= 1'b0;
        out_clk_n_reg <= 1'b0;
    end else begin
        if (counter_n >= ratio - 4'b1001  && clock_ratio != 0 ) begin
             out_clk_n_reg  <= ~out_clk_n_reg;
             counter_n      <= 1'b0;
        end else counter_n  <= counter_n + 1'b1;
    end
end  

assign  counter_p_w = counter_p; 
assign  counter_n_w = counter_n;
assign  out_clk_p   = (ratio[3]==0) ? out_clk_p_reg:out_clk_n_reg;
//assign out_clk_n = ~out_clk_p;

endmodule
