// Course Number: ECE 5440
// Author: Joshua Young, Last 4 digit PeopleSoft: 7752
// top_ROM_control
// THis module is the main access controller module that verifies user input based on the info stored in the ID ROM and password //ROM
module top_ROM_control(clk, rst, ID_Paswd_push, psh1, psh2, confirm_psh3, ID_Paswd_switch, id_led, pwd_led, id,
psh1_out, psh2_out, confirm_psh3_out, ID_Paswd_push_out, disp_id_paswd);

input clk, rst, ID_Paswd_push;
input[3:0] ID_Paswd_switch;
output[3:0] disp_id_paswd;
output id_led, pwd_led;
//combo buttons
input psh1, psh2, confirm_psh3;
output psh1_out, psh2_out, confirm_psh3_out, ID_Paswd_push_out;
output[1:0] id;
wire[3:0] q_ROM, id_addr, q_pwd_ROM; 
wire[4:0] pwd_addr;

//the controller feeds rom the adress,
// and rom spits out data in variable q which is set to data_out in controller
ROM_control control(clk, rst, ID_Paswd_push, psh1, psh2, confirm_psh3, q_ROM, q_pwd_ROM, ID_Paswd_switch, 
id_addr, pwd_addr, id_led, pwd_led, id, psh1_out, psh2_out, confirm_psh3_out, ID_Paswd_push_out, disp_id_paswd); 

ID_ROM memory(id_addr, clk, q_ROM);  
pwd_ROM pwd_memory(pwd_addr, clk, q_pwd_ROM); 

always @(posedge clk) begin 
  //$display("id address:%d", id_addr);
  //$display("pwd address:%d", pwd_addr);
end 

endmodule 

