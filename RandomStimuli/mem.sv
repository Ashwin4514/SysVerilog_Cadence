module mem ( 
             mem_intf.mem mbus
	   );
// SYSTEMVERILOG: timeunit and timeprecision specification
timeunit 1ns;
timeprecision 1ns;

// SYSTEMVERILOG: logic data type
logic [7:0] memory [0:31] ;
  
  always @(posedge mbus.clk)
    if (mbus.write && !mbus.read)
// SYSTEMVERILOG: time literals
      #1 memory[mbus.addr] <= mbus.data_in;

// SYSTEMVERILOG: always_ff and iff event control
  always_ff @(posedge mbus.clk iff ((mbus.read == '1)&&(mbus.write == '0)) )
       mbus.data_out <= memory[mbus.addr];

endmodule
