module testflop ();
    timeunit 1ns;

    logic reset;
    logic [7:0] qin, din, qout, dreg;
// ---- clock generator code begin------
`define PERIOD 10
logic clk = 1'b0;

always
    #(`PERIOD/2)clk = ~clk;


// ---- clock generator code end------
    // Instantiating flipflop module with clocking block
    flipflop DUV (
        .* // Assuming flipflop module has a clock input named clk
    );

    // Clocking block definition
    default clocking cb @(posedge clk);
        input #1ns qout;
        output #4ns reset, qin;
    endclocking
    
    // Stimulus generation
    initial begin
        @(cb);
        cb.reset <= 1;
        ##3 cb.reset <= 0;
        
        for (int i=0; i<8; i++) begin
         @(cb); din <= i; 
        // Generating stimulus synchronized with clocking block
         @(din) begin
          cb.qin <= din;
          dreg <= cb.qout;
        end
        end
            // Wait for qin to be updated by flipflop DUV

            $display("Output qout at time %0t: %h", $time, dreg);
        end
endmodule
