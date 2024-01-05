`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/24/2023 03:09:54 PM
// Design Name: 
// Module Name: alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

include "typedefs.sv";
import typedefs::*;

module alu(
  input logic[7:0] accum,
  input logic[7:0] data,
  input clk,
  opcode_t opcode,
  output logic[7:0] out,
  output logic zero
);

always_comb
begin
  if(accum[7:0] == 0) zero = 1;
  else zero = 0;
end

always_ff@(posedge clk)
begin
case(opcode)
 HLT, STO, JMP, SKZ : out <= accum;
 ADD : out <= data + accum;
 AND : out <= data & accum;
 XOR : out <= data ^ accum;
 LDA : out <= data;
endcase
end
endmodule
