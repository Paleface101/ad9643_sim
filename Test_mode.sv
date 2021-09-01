`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////



module Test_mode(
input               clk,
input        [13:0] normal_data,
input               user_test_mode_control,
input        [3:0]  select_mode,
input               reset_PN_long_gen,
input               reset_PN_short_gen,
input        [15:0] user_pattern_1,
input        [15:0] user_pattern_2,
input        [15:0] user_pattern_3,
input        [15:0] user_pattern_4,
output logic [13:0] output_test_mode_reg
    );
    
 logic [15:0] out_user_pattern;
 logic [13:0] output_test_mode;
always_comb begin
     case (select_mode) 
     4'b0000: output_test_mode = normal_data;
     4'b1000: output_test_mode = out_user_pattern;//user_test_mode
     default: output_test_mode = normal_data;
     endcase 
end

always_ff @(posedge clk or negedge clk ) begin
output_test_mode_reg <= output_test_mode;
end

FSM_user_test_pattern FSM_user_test_pattern(
.clk(clk),
.mode_control(user_test_mode_control),
.select_mode(select_mode),
.user_pattern_1(user_pattern_1),
.user_pattern_2(user_pattern_2),
.user_pattern_3(user_pattern_3),
.user_pattern_4(user_pattern_4),
.out_user_pattern(out_user_pattern)
);

endmodule
