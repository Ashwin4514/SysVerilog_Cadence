
module mem_test ( 
                  mem_intf.tb mbus
                );
// SYSTEMVERILOG: timeunit and timeprecision specification
timeunit 1ns;
timeprecision 1ns;

class randMem;
 rand logic [4:0] addr;
 rand logic [7:0] data;
 
 constraint c1 { data dist {[8'h41:8'h5a]:=80 }; }
 constraint c2 { data dist {[8'h61:8'h7a]:=20 }; }
 
 
 function new(input logic[4:0] addr, input logic[7:0] data);
  this.addr = addr;
  this.data = data;
 endfunction
 
 
endclass


// SYSTEMVERILOG: new data types - bit ,logic
bit         debug = 1;
logic [7:0] rdata;      // stores data read from memory for checking


randMem rM = new(5'b00000, 8'b00000000);


// Monitor Results
  initial begin
      $timeformat ( -9, 0, " ns", 9 );
// SYSTEMVERILOG: Time Literals
      #40000ns $display ( "MEMORY TEST TIMEOUT" );
      $finish;
    end
 function [7:0] gen_data_capital(input logic [7:0] dataTemp);
   int ok;
   ok = randomize(dataTemp) with {dataTemp >= 8'h41; dataTemp<8'h5a;};
   return dataTemp;
 endfunction
 
 function [7:0] gen_data_smaller(input logic [7:0] dataTemp);
   int ok;
   ok = randomize(dataTemp) with {dataTemp >= 8'h61; dataTemp <= 8'h7a;};
   return dataTemp;
 endfunction
 
initial
  begin: memtest
  int error_status;
  int ok;
  logic[7:0] dataTemp;
  
    $display("Clear Memory Test");
// SYSTEMVERILOG: enhanced for loop
    for (int i = 0; i< 32; i++)
       mbus.write_mem (i, 0, debug);
    for (int i = 0; i<32; i++)
      begin 
       mbus.read_mem (i, rdata, debug);
       // check each memory location for data = 'h00
       error_status = checkit (i, rdata, 8'h00);
      end

    $display("Random Class Test");
      
     repeat(64) begin 
     ok = rM.randomize();
     $display("Address = %h", rM.addr);
     $display("Data = %h", rM.data);
  
     mbus.write_mem(rM.addr,rM.data,1);
     $display("Value Written.");   
     end
     
     for (int i = 0; i<32; i++)
      begin
       mbus.read_mem (i, rdata, debug);
       // check each memory location for data = address
       $display(" Address: %d, Data: %c" , i, rdata);
       if(rdata >= 8'h20 && rdata <= 8'h75) 
        $display("Considered.");
        else 
        $display("ERRORRRRRRRR!!!!!!.");
      end
    $display("Random Data Test FOR CLASS Success.");  
    
    printstatus(error_status);

    $finish;
  end

function int checkit (input [4:0] address,
                      input [7:0] actual, expected);
  static int error_status;   // static variable
  if (actual !== expected) begin
    $display("ERROR:  Address:%h  Data:%h  Expected:%h",
                address, actual, expected);
// SYSTEMVERILOG: post-increment
     error_status++;
   end
// SYSTEMVERILOG: function return
   return (error_status);
endfunction: checkit

// SYSTEMVERILOG: void function
function void printstatus(input int status);
if (status == 0)
   $display("Test Passed - No Errors!");
else
   $display("Test Failed with %d Errors", status);
endfunction

endmodule
