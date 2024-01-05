`timescale 1ns / 1ps
module scale_mux(
input logic[7:0] in_a,
input logic[7:0] in_b,
input logic sel_a,
output logic[7:0] out
);

always_comb begin
  unique case(sel_a)
  1'b1 : out = in_a;
  1'b0 : out = in_b;
  endcase
end
endmodule
