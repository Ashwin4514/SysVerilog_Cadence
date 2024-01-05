
module counterclass;

// add counter class here
virtual class counter;  
 pure virtual function void check_limit(input int a, input int b);
 pure virtual function bit check_set();
 pure virtual function void load(input int count);
 pure virtual function int getcount();
 pure virtual function void next();
endclass    

class upcounter extends counter;
 int count, min , max;
 function new(input int countinitial, min, max);
  this.count = countinitial;
  this.min = min;
  this.max = max;
  check_limit(min,max);
 endfunction
 
 virtual function void load(input int count);
  this.count = count;
  if(check_set()) $display("Within Limits, Can proceed.");
  else begin $display("Error. Out of limits."); $finish; end
 endfunction
 
 virtual function int getcount();
  return count;
 endfunction;
 
 
 virtual function void next();
  if(this.max < this.count) this.count = this.min;
  else this.count += 1;
 endfunction
 
 virtual function void check_limit(input int a,input int b);
  this.max = (a >= b)? a : b;
  this.min = (a <= b)? a : b;
 endfunction

 virtual function bit check_set();
  if((this.max >= this.count) && (this.min <= this.count)) return 1;
  else return 0;
 endfunction
endclass

class downcounter extends counter;
 
 int count, min , max;
 function new(input int countinitial, min, max);
  this.count = countinitial;
  this.min = min;
  this.max = max;
  check_limit(min,max);
 endfunction
 
 virtual function void load(input int count);
  this.count = count;
  if(check_set()) $display("Within Limits, Can proceed.");
  else begin $display("Error. Out of limits."); $finish; end
 endfunction
 
 virtual function int getcount();
  return count;
 endfunction;
 
 virtual function void next();
  if(this.max < this.count) this.count = this.min;
  else this.count += 1;
 endfunction
 
 virtual function void check_limit(input int a,input int b);
  this.max = (a >= b)? a : b;
  this.min = (a <= b)? a : b;
 endfunction

 virtual function bit check_set();
  if((this.max >= this.count) && (this.min <= this.count)) return 1;
  else return 0;
 endfunction
endclass

upcounter c3 = new(3,0,16);
downcounter c4 = new(9,0,16);


initial begin
 $display("Test-1");
 
  $display("Upcounter before incrementing is : %h", c3.getcount);
  repeat(15) begin
  c3.next();
  $display("counter value incremented to : %h", c3.getcount);  
  end
  $display("Downcounter before decrementing is : %h", c4.getcount);
  repeat(15) begin
  c4.next();
  $display("counter value decremented to : %h", c4.getcount);  
  end
  $display("Trying to load 17 in c4.");
  c4.load(17);
end

endmodule
