// Course Number: ECE 5440
// Author: Joshua Young, Last 4 digit PeopleSoft: 7752
// buttonShaper Module
// This Module is used to output a single cycle pulse to the output when a button from the FPGA is pressed 
//regardless of the duration 
 

module buttonShaper (push_in, clk, reset, push_out);
 
  input push_in;
  input clk, reset;
  output push_out; 
  reg push_out;
  reg[1:0] state, stateNext;

  parameter s_unpushed = 0, s_pushed = 1, s_wait=2;
 
//button push CombLogic

  always @ (state, push_in) 
  begin
 
  case(state) 
  //unpushed state, we dont want to output a pulse
  //if  a person pushed the button we want to go to pushed state
  s_unpushed:
  begin
  push_out = 0;
  if(push_in == 0)
    stateNext = s_pushed;
  else
    stateNext = s_unpushed; 
  end

  //pushed state, we want to output a pulse
  // we want the next state to be the wait state
  s_pushed: 
  begin
  push_out = 1;
  stateNext = s_wait; 
  end
  //wait state, we dont want a pulse at the output
  // if the button is unpushed, the nextState will go to unpushed state, else wait at this state
  s_wait:
  begin
  push_out = 0;
  if(push_in == 0)
  stateNext = s_wait;
  else
  stateNext = s_unpushed;
  end
  default:
  stateNext = s_unpushed;
  endcase
 end  
  
 
// button push state Reg
always @ (posedge clk) 
begin
  //reset is a push button 
  //if reset is 0 means th button is pressed and we want to reset our state machine back to 0
  //This calculates the current State
  if (reset == 0)
   state <= s_unpushed; 
  else
    state <= stateNext;
end
     
  
endmodule


