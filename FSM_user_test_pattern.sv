`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.08.2021 16:18:16
// Design Name: 
// Module Name: FSM_user_test_pattern
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


module FSM_user_test_pattern(
input clk,
input mode_control,
input [15:0] user_pattern_1,
input [15:0] user_pattern_2,
input [15:0] user_pattern_3,
input [15:0] user_pattern_4,
input [3:0]  select_mode,

output logic [15:0] out_user_pattern
    );
enum logic [2:0] {P1,P2,P3,P4,O} next_state, state ;   
logic reset ;
assign reset = (select_mode ==4'b1000 )? 1'b0:1'b1;

always_comb begin
case (state)
P1: begin
    out_user_pattern = user_pattern_1;
    next_state = P2;
    end
    
P2: begin 
    out_user_pattern = user_pattern_2;
    next_state = P3;
    end
    
P3: begin 
    out_user_pattern = user_pattern_3;
    next_state = P4;
    end
    
P4: begin 
    out_user_pattern = user_pattern_4;
    next_state = (mode_control) ? O:P1;
    end
    
O:  begin 
    out_user_pattern = 0;
    next_state       = (mode_control) ? O:P1;
    end

endcase
end

always_ff @(posedge clk or negedge clk) begin
if (reset) state <= P1;
else       state <= next_state;

end

endmodule
