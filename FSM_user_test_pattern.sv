`timescale 1ns / 1ps
//======================================
 
module FSM_user_test_pattern(
input              clk,
input              mode_control,
input       [15:0] user_pattern_1,
input       [15:0] user_pattern_2,
input       [15:0] user_pattern_3,
input       [15:0] user_pattern_4,
input logic [3:0]  select_mode,

output logic [15:0] out_user_pattern =0
    );

enum logic [2:0] {P1,P2,P3,P4,O} next_state, state ;   
     
     logic reset ;
     logic last_data = 0;
     bit   no_data = 0;
     string N_pattern;
assign reset = (select_mode ==4'b1000 )? 1'b0:1'b1;


always_comb begin
case (state)
P1: begin
    N_pattern = "1";
    next_state = P2;
    end
    
P2: begin 
    N_pattern = "2";
    next_state = P3;
    end
    
P3: begin 
    N_pattern = "3";
    next_state = P4;
    end
    
P4: begin 
    N_pattern = "4";
    next_state = (mode_control) ? O:P1;
    end
    
O:  begin 
    next_state = (mode_control) ? O:P1;
    end

endcase
end
integer i;
always_ff @(posedge clk or negedge clk) begin

    if (reset) begin 
        state            <= P1; i = 0;
        out_user_pattern <= 0;
       
    end  else begin
        case (state)
        P1: begin 
                read_file(.user_pattern(user_pattern_1),
                .i(i),.last_data(last_data),
                .N_pattern(N_pattern),
                .out_data(out_user_pattern)
                );

                    if (last_data) begin state <= next_state; i = 0;   end
                    else           begin state <= state;      i = i + 1; end
          
            end
        P2: begin 
                read_file(.user_pattern(user_pattern_2),
                .i(i),
                .last_data(last_data),
                .N_pattern(N_pattern),
                .out_data(out_user_pattern)
              
                );
                    if (last_data) begin state <= next_state; i = 0;   end
                    else           begin state <= state;      i = i + 1; end
            end
        P3: begin 
                read_file(.user_pattern(user_pattern_3),
                .i(i),
                .last_data(last_data),
                .N_pattern(N_pattern),
                .out_data(out_user_pattern)
                );
                    if (last_data) begin state <= next_state; i = 0;   end
                    else           begin state <= state;      i = i + 1; end
            end
        P4: begin 
                read_file(.user_pattern(user_pattern_4),
                .i(i),
                .last_data(last_data),
                .N_pattern(N_pattern),
                .out_data(out_user_pattern)
               
                );
                
           
                    if (last_data) begin state <= next_state; i = 0;   end
                    else           begin state <= state;      i = i + 1; end
            
            end
        O: begin 
            state            <= next_state;
            out_user_pattern <= 0; 
            end
        endcase
    end
 
end
//--------------------function----------------------------------------------------------------------------
function string  user_patern_str(input logic [3:0] user_patern);
    case (user_patern)
    4'h1:user_patern_str = "1";
    4'h2:user_patern_str = "2"; 
    4'h3:user_patern_str = "3";
    4'h4:user_patern_str = "4";
    4'h5:user_patern_str = "5";
    4'h6:user_patern_str = "6";
    4'h7:user_patern_str = "7";
    4'h8:user_patern_str = "8";
    4'h9:user_patern_str = "9";
    4'hA:user_patern_str = "A";
    4'hB:user_patern_str = "B";
    4'hC:user_patern_str = "C";
    4'hD:user_patern_str = "D";
    4'hE:user_patern_str = "E";
    4'hF:user_patern_str = "F";
endcase

endfunction
//---------------------------------------------------------------------------------------------
// task----------------------------------------------------------------------------------------------------------------

 task read_file (
    input string        N_pattern,
    input integer       i,
    input        [15:0] user_pattern,
    output logic [15:0] out_data,
    output logic        last_data
  
 );
automatic string file_name = 
{
//"C:/MC10/testreadfile/testreadfile.srcs/sim_1/new/",
 N_pattern,
 user_patern_str(user_pattern[15:12]),
 user_patern_str(user_pattern[11:8]),
 user_patern_str(user_pattern[7:4]),
 user_patern_str(user_pattern[3:0]),
 ".txt"
 };

 logic [15:0]   array [];
 
 last_data = 0;

 
  if (i ==0) begin
       if (array.size !=0) begin 
           array.delete();  
       end
  $readmemh(file_name, array); 
  end
     if (array.size == 0) begin
       // no_data = 1;
        $display ({"File ",file_name," not found or empty.--> output data = register value(",
                                                                                    user_patern_str(user_pattern[15:12]),
                                                                                    user_patern_str(user_pattern[11:8]),
                                                                                    user_patern_str(user_pattern[7:4]),
                                                                                    user_patern_str(user_pattern[3:0]),
                                                                                    ")"});//^^
        
         out_data  = user_pattern ;
         last_data = 1;                                                                          
     end else begin
        out_data  = array[i];
        if (i >= array.size - 1) 
            last_data = 1; 
     end
       
 endtask
 //-----------------------------------------------------------------------------------------------------------------------   

endmodule
