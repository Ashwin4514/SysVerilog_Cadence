
module event_m ;

  timeunit      1ns;
  timeprecision 1ns;

  event e1, e2 ;

  initial begin
      fork

        begin : EMITTER_1
          $display ( "%m emitting event e1" ) ;
          ->> e1 ;
        end  : EMITTER_1

        begin : EMITTER_2
          $display ( "%m emitting event e2" ) ;
          ->> e2 ;
        end  : EMITTER_2

        begin : WAITER_1
          $display ( "%m  waiting  event e1" ) ;
          @e1;
          $display ( "%m  received event e1" ) ;
        end  : WAITER_1

        begin : WAITER_2
          $display ( "%m  waiting  event e2" ) ;
          @e2;
          $display ( "%m  received event e2" ) ;
        end  : WAITER_2

      join_none
      #10ns;
      disable fork;
      $display("TEST COMPLETE");
      $finish(0);
    end

endmodule : event_m
