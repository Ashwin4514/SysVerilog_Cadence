`include "memInt.sv"
module mem (
    input        clk,
    memInt.mem  ifa
);

    // SYSTEMVERILOG: timeunit and timeprecision specification
    timeunit 1ns;
    timeprecision 1ns;

    // SYSTEMVERILOG: logic data type
    logic [7:0] memory [0:31];

    always @(posedge clk) begin
        if (ifa.write && !ifa.read) begin
            memory[ifa.addr] <= ifa.data_in;
        end
    end
    assign ifa.data_out = ((ifa.read == 1)? memory[ifa.addr] : ifa.data_out);
    
endmodule

