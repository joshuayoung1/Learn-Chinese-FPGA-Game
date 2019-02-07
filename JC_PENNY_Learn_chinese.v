// Course Number: ECE 5440
// Author: Joshua Young, Last 4 digit PeopleSoft: 7752
// JC_PENNY_Learn_chinese
// This module is our top module that connects all the other modules

module JC_PENNY_Learn_chinese(clk, rst, ID_Paswd_push, psh2, confirm_psh3, ID_Paswd_switch, id_led, pwd_led,  
id_pw_displayed, symbol_disp1, score_displayer, time_remain_out1, time_remain_out0);

input clk, rst, ID_Paswd_push, psh2, confirm_psh3;
input[3:0] ID_Paswd_switch;
output id_led, pwd_led;
output[6:0] id_pw_displayed, symbol_disp1, score_displayer, time_remain_out1, time_remain_out0;

wire forceChange, psh1_out, psh2_out, confirm_psh3_out, ID_Paswd_push_out;
wire one_sec_en, symbol_lfsr_en, time_reconfig0, time_reconfig1, timeout, wren;
wire[1:0] unique_ID, symbol_addr, unique_ID_RAM_addr;
wire[3:0] timer_switch1, timer_switch0, timer_remain0, time_remain1;
wire[3:0] q, RAM_tota_points, score_from_RAM, disp_id_paswd;
wire[6:0] symbol;
wire pwd_psh_s, psh2_s, psh_confirm;

//game control instance 
Game_Control Game_Control_1(clk, rst, unique_ID, ID_Paswd_push_out, symbol, psh1_out, psh2_out, 
confirm_psh3_out, symbol_lfsr_en, symbol_disp1, one_sec_en, 
timer_switch1, timer_switch0, time_reconfig0, time_reconfig1, RAM_tota_points, q, wren, unique_ID_RAM_addr, forceChange, score_from_RAM,
time_remain1, timer_remain0);

//Access Control instance 
top_ROM_control top_ROM_control_1(clk, rst, pwd_psh_s, pwd_psh_s, psh2_s, psh_confirm, ID_Paswd_switch, id_led, pwd_led, unique_ID,
psh1_out, psh2_out, confirm_psh3_out, ID_Paswd_push_out, disp_id_paswd);

//Random chinese symbol gen
top_lfsr_rand_addr top_lfsr_rand_addr_1(clk, rst, symbol_lfsr_en, symbol_addr, forceChange);

//chinese symbol ROM control
top_symbol_ROM_control top_symbol_ROM_control_1(clk, rst, symbol_addr, symbol);

//30 seconds display board
seconds_timer_99 seconds_timer_99_1(clk, rst, one_sec_en, timer_switch1, timer_switch0, time_reconfig1, time_reconfig0,
 time_remain1, timer_remain0, timeout); 

//RAM for scoreboard
RAM_score RAM_score_1(unique_ID_RAM_addr, clk, RAM_tota_points, wren, q);

//seg decoder for ID and Password
seg_deco seg_deco1(disp_id_paswd, id_pw_displayed);

//seg decoder for score
seg_deco seg_deco2(score_from_RAM, score_displayer);

//segdecoder for time remain
seg_deco seg_deco3(time_remain1, time_remain_out1);
seg_deco seg_deco4(timer_remain0, time_remain_out0);

//button shapers
buttonShaper buttonShaper_pwd(ID_Paswd_push, clk, rst, pwd_psh_s);
buttonShaper buttonShaper_psh2(psh2, clk, rst, psh2_s);
buttonShaper buttonShaper_confirm3(confirm_psh3, clk, rst, psh_confirm);
endmodule 


