`timescale 1ns / 1ps
module SimpleCounter(
input logic rst_,
input logic [4:0] data,  //You want to offset the start of the counter
input logic load, // when we want to do parallel load, we assert this to enable counting from there..
input logic enable,
input wire clk,
output logic [4:0] count 
);

logic [4:0] temp_counter;
always @(posedge clk) begin
 if(rst_ === 1'bX || rst_ === 0) begin
  count         <= 4'b0;
 end else if(load) begin
  count  <= data;
 end else if(enable) begin
  count  <= count + 1;
 end
 end
 
 assign count = temp_counter;
 
 endmodule
