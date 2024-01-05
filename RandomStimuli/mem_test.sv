
module mem_test ( 
                  mem_intf.tb mbus
                );

timeunit 1ns;
timeprecision 1ns;


bit         debug = 1;
logic [7:0] rdata;      // stores data read from memory for checking

  initial begin
      $timeformat ( -9, 0, " ns", 9 );

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
// SYSTEMVERILOG: void function
    printstatus(error_status);

    $display("Data = Address Test");
// SYSTEMVERILOG: enhanced for loop
    for (int i = 0; i< 32; i++)
       mbus.write_mem (i, i, debug);
    for (int i = 0; i<32; i++)
      begin
       mbus.read_mem (i, rdata, debug);
       // check each memory location for data = address
       error_status = checkit (i, rdata, i);
      end
// SYSTEMVERILOG: void function

    $display("Random Data");
    repeat(64) begin
    logic[7:0] dataTemp;
    logic[4:0] addrTemp;
     ok = randomize(dataTemp) with {dataTemp>=8'h20; dataTemp<8'h7F;} with {dataTemp != 8'h0E;};
     ok = randomize(addrTemp) with {addrTemp>=0; addrTemp<=31;} with {dataTemp != addrTemp;};
     mbus.write_mem(addrTemp,dataTemp,1);
           
    end
    
    for (int i = 0; i<32; i++)
      begin
       mbus.read_mem (i, rdata, debug);
       // check each memory location for data = address
       $display(" Address: %d, Data: %c" , i, rdata);
       if(rdata >= 8'h20 && rdata <8'h7F) $display("Considered..");
       else $display("Error");
      end
    $display("Random Data Test Success.");  
    
    $display("Random Data - 2");
    

    for(int i=0; i<32; i++) begin
     ok = randomize(dataTemp) with {dataTemp>=8'h20; dataTemp<8'h7F;};
     mbus.write_mem(i,dataTemp,1);
    end
    
    for (int i = 0; i<32; i++)
      begin
       mbus.read_mem (i, rdata, debug);
       // check each memory location for data = address
       $display(" Address: %d, Data: %c" , i, rdata);
       if(rdata >= 8'h20 && rdata <8'h7F) $display("Considered..");
       else $display("Error");
      end
    $display("Random Data Test - 2 Success.");  
    
    $display("Random Data - 3");
    
    for(int i=0; i<31; i++) begin
    randcase
     80 : dataTemp = gen_data_capital(dataTemp);
     20 : dataTemp = gen_data_smaller(dataTemp);
    endcase 
    mbus.write_mem(i,dataTemp,1);
    end
    
    for (int i = 0; i<32; i++)
      begin
       mbus.read_mem (i, rdata, debug);
       // check each memory location for data = address
       $display(" Address: %d, Data: %c" , i, rdata);
       if(rdata >= 8'h20 && rdata <8'h7F) $display("Considered..");
       else $display("Error");
      end
    $display("Random Data Test - 3 Success.");  
    
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
