// Course Number: ECE 5440
// Author: Joshua Young, Last 4 digit PeopleSoft: 7752
// seconds_timer_99 Module
// This Module is used to display the amount of time in seconds that remains on two 7 segmens.
//The module is composed of 1 count10_AND_100ms module(1s timer) and 2 gameTime(decimal digit timer)



module seconds_timer_99(clk, rst, sec_timer_enable, timer_switch1, timer_switch0, time_reconfig1, time_reconfig0,
 time_remain1, timer_remain0, timeout); 


input clk, rst, time_reconfig1, time_reconfig0, sec_timer_enable;
input[3:0] timer_switch1, timer_switch0;
output[3:0] time_remain1, timer_remain0;
output timeout;
wire cantborrow, sendborrow;
wire blank;
wire signal_in;

gameTime gameTime1(clk, rst, timer_switch1, 1, cantborrow, time_reconfig1, blank, sendborrow, time_remain1);
gameTime gameTime0(clk, rst, timer_switch0, cantborrow, timeout, time_reconfig0, sendborrow, signal_in, timer_remain0);
one_sec_timer  test(clk, rst, sec_timer_enable, signal_in);

endmodule


