`include "memInt.sv"

module top;

timeunit 1ns;
timeprecision 1ns;

// SYSTEMVERILOG: logic and bit data types
bit       clk;
wire       read=0;
wire       write=0;
wire  [4:0] addr=0;

wire [7:0] data_out=0;      // data_from_mem
wire [7:0] data_in=0;       // data_to_mem
//logic [4:0] addr, [7:0] data_in, [7:0] data_out, read, write 
memInt intf(.read(read), .write(write), .addr(addr), .data_out(data_out), .data_in(data_in));


mem_test test (clk, intf);
mem memory (clk, intf);


always #5 clk = ~clk;
endmodule
