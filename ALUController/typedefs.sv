`timescale 1ns / 1ps
package typedefs;

typedef enum bit[2:0]{HLT = 3'b000, SKZ = 3'b001, ADD = 3'b010, AND = 3'b011, 
XOR = 3'b100, LDA = 3'b101, STO = 3'b110, JMP = 3'b111} opcode_t;

typedef enum bit[2:0]{mem_rd, load_ir, halt, inc_pc, load_ac, load_pc, mem_wr} state_t;

typedef enum bit[2:0]{INST_ADDR, INST_FETCH, INST_LOAD, IDLE, OP_ADDR, OP_FETCH, ALU_OP, STORE} instruction_t;

endpackage

