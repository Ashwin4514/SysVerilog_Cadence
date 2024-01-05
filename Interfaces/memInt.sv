`timescale 1ns / 1ps
interface memInt;
logic read; 
logic write; 
logic [4:0] addr; 
logic [7:0] data_in;
logic [7:0] data_out;

modport mem(input addr, input read, input write, input data_in, output data_out);
modport mem_test(input data_out, output addr, output read, output write, output data_in);

endinterface
