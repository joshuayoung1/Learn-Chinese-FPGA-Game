// Course Number: ECE 5440
// Author: Joshua Young, Last 4 digit PeopleSoft: 7752
// top_RAM_Control
// THis module is a combination of the quartus RAM generated file and the RAM controller
module top_RAM_control(clk, rst, psh, RAM_read);

input clk, rst, psh;

wire wren;
wire[1:0] addr;
wire[3:0] q_from_RAM, data_to_wr;
output[3:0] RAM_read;

RAM_control RAM_score(clk, rst, psh, q_from_RAM, addr, data_to_wr, wren, RAM_read);
RAM_score score(addr, clk, data_to_wr, wren, q_from_RAM);

endmodule 
