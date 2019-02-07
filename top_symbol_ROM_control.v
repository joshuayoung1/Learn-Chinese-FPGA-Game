// Course Number: ECE 5440
// Author: Joshua Young, Last 4 digit PeopleSoft: 7752
// top_symbol_ROM_control
//module that interfaces with the   ROM that stores symbols and the controller that waits 2 cycles between each read


module top_symbol_ROM_control(clk, rst, symbol_addr, data_out);
input clk, rst;
input[1:0] symbol_addr;
wire[6:0] q;
wire[1:0] address; 
output[6:0] data_out;

symbol_ROM_control symbol_control(clk, rst, symbol_addr, q, address, data_out);
symbol_ROM ROM_symbol(address, clk, q);

endmodule 