
//need to add psh1, psh2, psh3 to game control
module Game_Control(clk, rst, unique_ID, ID_Paswd_push, symbol, psh1, psh2, 
confirm_psh3, symbol_lfsr_en, symbol_disp1, one_sec_en, 
time1, time0, time_reconfig1, time_reconfig2, RAM_tota_points, q_from_RAM, wren_RAM, unique_ID_RAM_addr,
forceChange, score_from_RAM, time_remain1, timer_remain0);

input clk, rst, psh1, psh2, confirm_psh3, ID_Paswd_push;
//input timeout; //when the time of play runs out, its a 1 
input[3:0] q_from_RAM, time_remain1, timer_remain0; //output data from RAM
input[6:0] symbol; //random symbol from ROM
output reg symbol_lfsr_en; //this will send a constant 1 to LFSR to generate random address for ROM storing symbols
output reg wren_RAM; //This will be used to assert red/write input of score_RAM
output reg  one_sec_en, time_reconfig1, time_reconfig2; //for the timer display
output reg[3:0] time1, time0, RAM_tota_points, score_from_RAM;  
output reg[6:0] symbol_disp1;
input[1:0] unique_ID;
output reg [1:0] unique_ID_RAM_addr;
reg timeFlag;
reg[6:0] prev_symbol;

/////////////////////////////////////////////////
output reg forceChange;
/////////////////////////////////////////////////

//reg flag1, flag2, flag3, flag4;
reg[6:0] state;
reg timeout;

parameter init=0, stage1=1,  path=2, one=3, two=4, three=5, seven=6, one_b=7, one_c=8, point=9,
two_b=10, two_c=11, three_b=12, three_c=13, three_d=14, seven_b=15, seven_c=16, seven_d=17,
endgame=18, wait1=19;

always @(posedge clk) begin

if(time_remain1 > 0 && timer_remain0 > 0) begin
	timeFlag <=1;
end
if(time_remain1 == 0 && timer_remain0 == 0 && timeFlag == 1) begin
	timeout <= 1;
end
else begin
	timeout<= 0;
end

if(rst == 0) begin
score_from_RAM <= 0;
wren_RAM <= 0;
unique_ID_RAM_addr <=0;
RAM_tota_points <=0;
symbol_disp1<=7'b1111111;
symbol_lfsr_en <=0;
time_reconfig1 <= 0;
time_reconfig2 <= 0;
time1 <= 0;
time0 <= 0;
one_sec_en <= 0;
timeout <= 0;
timeFlag <= 0;
prev_symbol <= 7'b1111111;
//This flag will keep track of the the button combinations 

state <=init;
end
else begin
case(state)
init: begin
/////////////////////////////////////////////////
  forceChange <= 0;
/////////////////////////////////////////////////
  one_sec_en <= 0;

  score_from_RAM <= 0; //will be connected to 7 seg to display the high score
  wren_RAM <=0;//low means write to RAM is OFF
  unique_ID_RAM_addr <=0;
  RAM_tota_points <=0; //keeps track of player's score
  time_reconfig1 <= 0;
  time_reconfig2 <= 0;
  time1 <= 0;
  time0 <= 0;
  symbol_disp1<=7'b1111111;
  prev_symbol <= 7'b1111111;
  symbol_lfsr_en <= 0;
  timeout <= 0;
  timeFlag <= 0;
  if(ID_Paswd_push == 1) begin//press id psh buttn to start the game 
  state <= stage1;
  end
  else 
   state <= init;

end
stage1: begin 
//enable the 30 seconds timer and display the symbol 
symbol_lfsr_en <= 1; //this will make sure the LFSR random # gen is always running 
one_sec_en <= 1; //this will start the 30 seconds countdown

// set 30 seconds 
time1 <= 3;
time0 <= 0;
time_reconfig1 <= 1;
time_reconfig2 <=  1;

// display the symbol
symbol_disp1 <= symbol; //symbol displays every 10 seconds 

state <= path; 
end

path: begin 
time_reconfig1 <= 0; //turn off timereconfig
time_reconfig2 <=  0; //turn off time reconfig
symbol_disp1 <= symbol; //symbol displays every 10 seconds 
/////////////////////////////////////////////////
forceChange <= 0;
/////////////////////////////////////////////////
 prev_symbol <= symbol;
 if(prev_symbol == symbol) begin
   forceChange<= 1; 
   state <= path;
 end
 else if(symbol == 7'b0111111) begin
 state <= one;
 end
 else if(symbol == 7'b0111110) begin
 state <= two;
 end
 else if(symbol == 7'b0110110) begin
 state <= three;
  end
 else if(symbol == 7'b0000111) begin
 state <= seven;
  end
 else 
  state <= path; 
end

one: begin 
if (timeout != 1) begin
  if(psh1 == 1 && psh2==0 && confirm_psh3==0)//fist key combo
    state <= one_b;
  else begin
    state <= one;
  end

end
else
 state <= endgame;

end
one_b: begin 
if (timeout != 1) begin //making sure time has not run out
  if(psh1 == 1 && psh2==0 && confirm_psh3==0)//2nd key combo
    state <= one_c;
  else begin
    state <= one_b;
  end
end
else
 state <= endgame;
end

one_c: begin 
if (timeout != 1) begin //when to go back to path stage
  if(psh1 == 0 && psh2==0 && confirm_psh3==1)//point is given
    state <= point;
  else begin
    state <= one_c;
  end
end
else
 state <= endgame;
end

point: begin
//I want to write the score to RAM
RAM_tota_points <= RAM_tota_points + 1; //data that will be written to RAM
unique_ID_RAM_addr <= unique_ID; //sending the unique id as RAM address
wren_RAM <= 1; //asserting Write to RAM high

/////////////////////////////////////////////////
  forceChange <= 1;
/////////////////////////////////////////////////
if(psh1 == 1 || psh2 == 1 || confirm_psh3 == 1) begin
	state <= path;
end
if (timeout != 1)
   state <= path; //go back to check which pattern is shown on the board
   
else
  state <= endgame;

//Also write the point to the RAM

end

two: begin
if (timeout != 1) begin
  if(psh1 == 1 && psh2==0 && confirm_psh3==0)//fist key combo
    state <= two_b;
  else begin
    state <= two;
  end

end
else
 state <= endgame;

end

two_b: begin
if (timeout != 1) begin //making sure time has not run out
  if(psh1 == 0 && psh2==1 && confirm_psh3==0)//2nd key combo
    state <= two_c;
  else begin
    state <= two_b;
  end

end
else
 state <= endgame;

end
two_c: begin
if (timeout != 1) begin //making sure time has not run out
  if(psh1 == 0 && psh2==0 && confirm_psh3==1)// key combo complete
    state <= point;
  else begin
    state <= two_c;
  end
end
else
 state <= endgame;
end

three: begin
if (timeout != 1) begin //making sure time has not run out
  if(psh1 == 1 && psh2==0 && confirm_psh3==0)//1st key combo
    state <= three_b;
  else begin
    state <= three;
  end
end
else
 state <= endgame;


end
three_b: begin
if (timeout != 1) begin //making sure time has not run out
  if(psh1 == 0 && psh2==1 && confirm_psh3==0)//2nd key combo
    state <= three_c;
  else begin
    state <= three_b;
  end
end
else
 state <= endgame;
end
three_c: begin
if (timeout != 1) begin //making sure time has not run out
  if(psh1 == 1 && psh2==0 && confirm_psh3==0)//3rd key combo
    state <= three_d;
  else begin
    state <= three_c;
  end
end
else
 state <= endgame;

end
three_d: begin
if (timeout != 1) begin //making sure time has not run out
  if(psh1 == 0 && psh2==0 && confirm_psh3==1)// key combo complete
    state <= point;
  else begin
    state <= three_d;
  end
end
else
 state <= endgame;
end

seven: begin
if (timeout != 1) begin //making sure time has not run out
  if(psh1 == 0 && psh2==1 && confirm_psh3==0)//1st key combo
    state <= seven_b;
  else begin
    state <= seven;
  end
end
else
 state <= endgame;
end
seven_b: begin
if (timeout != 1) begin //making sure time has not run out
  if(psh1 == 1 && psh2==0 && confirm_psh3==0)//2nd key combo
    state <= seven_c;
  else begin
    state <= seven_b;
  end
end
else
 state <= endgame;
end

seven_c: begin
if (timeout != 1) begin //making sure time has not run out
  if(psh1 == 0 && psh2==1 && confirm_psh3==0)//3rd key combo
    state <= seven_d;
  else begin
    state <= seven_c;
  end
end
else
 state <= endgame;
end

seven_d: begin
if (timeout != 1) begin //making sure time has not run out
  if(psh1 == 0 && psh2==0 && confirm_psh3==1)// key combo complete
    state <= point;
  else begin
    state <= seven_d;
  end
end
else
 state <= endgame;
end

endgame: begin
// i want to display the player's high score
score_from_RAM <= q_from_RAM; //output will be connected to a 7 seg decoder
unique_ID_RAM_addr <= unique_ID; //sending the unique id as RAM address to read from
wren_RAM <= 0; //asserting Read from RAM

/////////////////////////////////////////////////
forceChange <= 0;
/////////////////////////////////////////////////

state <= wait1; //this state will allow the player to decide ifthey want to go to stage 2
end
wait1: begin
state <= wait1;
end

endcase

end


end





endmodule 
