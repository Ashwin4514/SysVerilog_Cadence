
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
 constraint c3 { addr dist {[0:31]};}
 
 
 function new(input logic[4:0] addr, input logic[7:0] data);
  this.addr = addr;
  this.data = data;
 endfunction
 
 
endclass


bit         debug = 1;
logic [7:0] rdata;      // stores data read from memory for checking
logic [7:0] dynarr[];  //Dynamic Array
logic [7:0] assarr[int];
logic [0:12] queue[$];

randMem rM = new(5'b00000, 8'b00000000);


// Monitor Results
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
  int i;
  logic[0:12] temp;

    $display("Clear Memory Test");

    for (int i = 0; i< 32; i++)
       mbus.write_mem (i, 0, debug);
    for (int i = 0; i<32; i++)
      begin 
       mbus.read_mem (i, rdata, debug);
       // check each memory location for data = 'h00
       error_status = checkit (i, rdata, 8'h00);
      end

    printstatus(error_status);
    
    $display("Dynamic Arrays Test.");
    
      dynarr = new[64];
      $display("First change to size - %d", dynarr.size()); 

      for(int i=0; i<32; i++) begin
       ok = rM.randomize();
       $display("Address = %d", rM.addr);
       $display("Data = %d", rM.data);
       
       dynarr[rM.addr] = rM.data;
       mbus.write_mem(rM.addr,rM.data,1);
      end
      $display("Reading Values.");
      for(int i=0; i<32; i++) begin
       mbus.read_mem(i, rdata, 1);
       if(dynarr[i] != 0) begin 
        if(rdata == dynarr[i]) $display("considered.");
        else $display("Mistakes.");
       end
      end
    
      $display("Associative Arrays Test."); 

      for(int i=0; i<32; i++) begin
       ok = rM.randomize();
       $display("Address = %d", rM.addr);
       $display("Data = %d", rM.data);
       
       assarr[rM.addr] = rM.data;
       mbus.write_mem(rM.addr,rM.data,1);
      end
      $display("Reading Values.");
      $display("Number of values to be read: %d", assarr.size());    
      
      if(assarr.first(i))
       do begin
       mbus.read_mem(i, rdata, 1);
        if(assarr[i] != 0) begin 
         if(rdata == assarr[i]) $display("considered.");
         else $display("Mistakes.");
        end
      end while(assarr.next(i));
    
     $display("Queue Test.");
     
     for(int i=0; i<32; i++) begin
      ok = rM.randomize(data);
      queue.push_back({i , rM.data});
      mbus.write_mem(i,rM.data,1);
     end
     
     
     $display("Reading Values");
     
     for(int i=0; i<32; i++) begin
      mbus.read_mem(i,rdata,1);
      temp = queue.pop_front();
      if(temp[5:12] == rdata) $display("Considered.");
      else $display("Mistakes!");
     end
    printstatus(error_status);

    $finish;
  end

function int checkit (input [4:0] address,
                      input [7:0] actual, expected);
  static int error_status;   // static variable
  if (actual !== expected) begin
    $display("ERROR:  Address:%h  Data:%h  Expected:%h",
                address, actual, expected);

     error_status++;
   end

   return (error_status);
endfunction: checkit

function void printstatus(input int status);
if (status == 0)
   $display("Test Passed - No Errors!");
else
   $display("Test Failed with %d Errors", status);
endfunction

endmodule
