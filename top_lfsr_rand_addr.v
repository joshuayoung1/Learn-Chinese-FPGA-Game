// Course Number: ECE 5440
// Author: Joshua Young, Last 4 digit PeopleSoft: 7752
// top_lfsr_rand_addr module
//module sends address every 10 seconds 
module top_lfsr_rand_addr(clk, rst, enable, two_bit_addr_RAM, forceChange);
input clk, rst, enable, forceChange;
output[1:0] two_bit_addr_RAM;
wire in_pulse;

lfsr_rand_addr(clk, rst, in_pulse, two_bit_addr_RAM);
count10_AND_100ms(clk, rst, enable, in_pulse, forceChange);

endmodule

