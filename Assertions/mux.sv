`timescale 1 ns / 1 ns

module mux
(
  input  logic       clock  ,
  input  logic [3:0] ip1    ,
  input  logic [3:0] ip2    ,
  input  logic [3:0] ip3    ,
  input  logic       sel1   ,
  input  logic       sel2   ,
  input  logic       sel3   ,
  output logic [3:0] mux_op  
) ;

always @(posedge clock) begin
  if (sel1 == 1)
    mux_op <= ip1 ;
  else
    if (sel2 == 1)
      mux_op <= ip2 ;
    else
      if (sel3 == 1)
        mux_op <= ip3 ;
end
// assertions go here
//#### edit ###

property prop_1;
 @(posedge clock) sel1 == 1'b1 |=> mux_op == ip1;
endproperty
property prop_2;
 @(posedge clock) (sel1 != 1'b1 && sel2 == 1'b1) |=> mux_op == ip2;
endproperty
property prop_3;
 @(posedge clock) (sel1 != 1'b1 && sel2 != 1'b1 && sel3 == 1'b1) |=> mux_op == ip3;
endproperty


ASSERT1 : assert property(prop_1) $display("Successful at prop1"); else $fatal("Multiple Properties Are True at prop1..");
ASSERT2 : assert property(prop_2) $display("Successful at prop2"); else $fatal("Multiple Properties Are True at prop2..");
ASSERT3 : assert property(prop_3) $display("Successful at prop3"); else $fatal("Multiple Properties Are True at prop3..");

//#### end of edit ###
endmodule
