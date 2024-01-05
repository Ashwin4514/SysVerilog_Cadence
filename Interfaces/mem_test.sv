`include "memInt.sv"

task automatic printstatus(input int status);
  if(status == 0) begin $display("Mavane, Nee Pass Ra!");end
  if(status != 0) begin $display("10th fail da nee. Onga kadai japti dhan.");end 
endtask


module mem_test (
    input logic clk,
    memInt.mem_test ifa
);

    // ... (timeunit and timeprecision specifications)
logic [7:0] rdata;
logic read, write; 
logic [4:0] addr;
logic [7:0] data_in, data_out; 


//    initial begin
//        clk = 0;
//        forever #5 clk = ~clk; // Toggle every 5 time units
//    end
    // Declare an instance of the memory module
    // ... (initial block for timeout and formatting)

    initial begin: memtest
        int error_status;
        read = 0;
        write = 0;

        // Clear Memory Test
        $display("Clear Memory Test");

        for (int i = 0; i < 32; i++) begin
            // Write zero data to every address location
            @(posedge clk);
            write = 1;
            write_mem(.wraddr(i),.wrdata_in(8'h00),.debug(1));
            @(posedge clk);
            write = 0;
        end

        for (int i = 0; i < 32; i++) begin
            // Read every address location
            @(posedge clk);
            read = 1;
//            addr = i;
            read_mem(.rdaddr(i),.rddata_out(rdata),.debug(1));
            
            @(posedge clk);            
            read = 0;
            // Verify the data read matches the expected value
            wait(read == 0);
            if (rdata != 0) begin
                $display("Error at address %0d. Expected: %h, Got: %h", i, 8'h00, rdata);
                error_status = 1;
            end
            
        end

        // Print results of test
        if (error_status == 0) begin
            $display("Clearing the Data Test success!");
        end else begin
            $display("Clearing the Data Test failed!");
            // You may want to handle this failure accordingly
            printstatus(error_status);
        end

        // Data = Address Test
        $display("Data = Address Test");

        for (int i = 0; i < 32; i++) begin
            // Write data equal to the address to every location
            @(posedge clk);
            write = 1;
//            addr = i;
//            data_in = i;
            write_mem(.wraddr(i),.wrdata_in(i),.debug(1));
            @(posedge clk);  // Wait for one clock cycle
            write = 0;
        end

        for (int i = 0; i < 32; i++) begin
            // Read every address location
            @(posedge clk);
            read = 1;
//            addr = i;
            read_mem(.rdaddr(i),.rddata_out(rdata),.debug(1));
            // Verify the data read matches the expected value
            #1;
            $display("rdata : %h", rdata);
            
            if (rdata !== i) begin
                $display("Error at address %0d. Expected: %h, Got: %h", i, i, rdata);
                error_status = 1;
                printstatus(error_status);
            end
            
            @(posedge clk);  // Wait for one clock cycle
            read = 0;
        end

        // Print results of test
        if (error_status == 0) begin
            $display("Data = Address Test success!");
        end else begin
            $display("Data = Address Test failed!");
        end 
            // You may want to handle this failure accordingly
        printstatus(error_status);
        end
        
task automatic write_mem (
 input logic [4:0] wraddr,
 input logic [7:0] wrdata_in,
 input logic debug);
  
 read  = 0;
 addr = wraddr;
 data_in = wrdata_in;
 //mem_instances[wraddr] <= 
    // Activate read after a delay
    
  if(debug==1) begin
  $display("Write_Addr = %h", ifa.addr);
  $display("Data = %h",ifa.data_in);  
  end
endtask
        // Finish the simulation
task automatic read_mem(
 input logic [4:0] rdaddr,
 output logic [7:0] rddata_out,
 input logic debug);
 
 write = 0; 
 read  = 1;
 addr = rdaddr;
 
 #1;
 rddata_out = data_out;

 if(debug==1) begin
  $display("Read_Addr = %h", rdaddr);
  $display("Data in mem = %h", rddata_out); 
  end 
endtask : read_mem;
//// add result print function
//printstatus(0);
assign ifa.read = read;
assign ifa.write = write;
assign ifa.addr = addr;
assign ifa.data_in = data_in;
assign data_out = ifa.data_out;


endmodule
