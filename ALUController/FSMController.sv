`timescale 1ns / 1ps
include "typedefs.sv";

import typedefs::*;

module FSMController(
                output logic      load_ac ,
                output logic      mem_rd  ,
                output logic      mem_wr  ,
                output logic      inc_pc  ,
                output logic      load_pc ,
                output logic      load_ir ,
                output logic      halt    ,
                input  opcode_t opcode  , // opcode type name must be opcode_t
                input             zero    ,
                input             clk     ,
                input             rst_   
                );
// SystemVerilog: time units and time precision specification
timeunit 1ns;
timeprecision 100ps;


//HLT = 3'b000, SKZ = 3'b001, ADD = 3'b010, AND = 3'b011, 
//XOR = 3'b100, LDA = 3'b101, STO = 3'b110, JMP = 3'b111

logic ALUOP = 0;
integer counter = 0;

//Writing Counter Logic

logic [2:0] state;
always_ff@(posedge clk or negedge rst_) begin
 if(!rst_ || counter ==  7) begin counter <= 0; end
 else if(counter < 7)
 begin
  counter <= counter + 1;
 end
end

always_comb begin

ALUOP = (opcode inside {ADD, AND, XOR, LDA})? 1 : 0;
if(!rst_) begin
{mem_rd, load_ir, halt, inc_pc, load_ac, load_pc, mem_wr} = 7'b0000000;
end

{mem_rd, load_ir, halt, inc_pc, load_ac, load_pc, mem_wr} = 7'b0000000;
casex (counter)
// 1 : mem_rd = 1;
 1 : begin mem_rd = 1; end  
// 2 : begin mem_rd = 1; load_ir = 1; end
 2 : begin mem_rd = 1; load_ir = 1; end 
 3 : begin mem_rd = 1; load_ir = 1; end
 4 : begin halt = (opcode_t'(opcode) == HLT)? 1 : 0; 
           inc_pc = 1;
           end
 5 : begin mem_rd = (ALUOP == 1)? 1 : 0; end
 6 : begin mem_rd = (ALUOP == 1)? 1 : 0; 
           inc_pc = ((opcode_t'(opcode) == SKZ) && 
                     zero)? 1 : 0;
           load_ac = (ALUOP == 1)? 1 : 0;
           load_pc = (opcode_t'(opcode) == JMP)? 1 : 0;
           end
 7:  begin mem_rd  = (ALUOP == 1)? 1 : 0;
           inc_pc  = (opcode_t'(opcode) == JMP)? 1 : 0;
           load_ac = (ALUOP == 1)? 1 : 0;
           load_pc = (opcode_t'(opcode) == JMP)? 1 : 0;
           mem_wr  = (opcode_t'(opcode) == STO)? 1 : 0;
           end
 default: begin {mem_rd, load_ir, halt, inc_pc, load_ac, load_pc, mem_wr} = 7'b0000000; end
endcase
end
endmodule
