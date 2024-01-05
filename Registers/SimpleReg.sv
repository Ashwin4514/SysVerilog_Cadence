`timescale 1ns / 1ps
module SimpleReg(
input logic[7:0] data,
input logic enable,
input wire clk,
input wire rst_,
output logic[7:0] out
);

always_ff@(posedge clk) begin
if(rst_ === 0 || rst_ === 1'bX ) begin 
   out <= 0;
end else if(enable) begin
   out <= data;
 end
end

endmodule

