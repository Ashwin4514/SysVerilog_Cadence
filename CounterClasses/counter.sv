
module counterclass;

// add counter class here
 class counter;
 int count, min , max;
 function new(input int countinitial, min, max);
  this.count = countinitial;
  this.min = min;
  this.max = max;
  check_limit(min,max);
 endfunction
 
 function void load(input int count);
  this.count = count;
  if(check_set()) $display("Within Limits, Can proceed.");
  else begin $display("Error. Out of limits."); $finish; end
 endfunction
 
 function int getcount();
  return count;
 endfunction;
  
 extern function void check_limit(input int a, input int b);
 extern function bit check_set();
 
endclass    

function void counter::check_limit(input int a,input int b);
  this.max = (a >= b)? a : b;
  this.min = (a <= b)? a : b;
endfunction

function bit counter::check_set();
  if((this.max >= this.count) && (this.min <= this.count)) return 1;
  else return 0;
endfunction


class upcounter extends counter;

 function new(input int count);
  super.new(count,0,16);
 endfunction
 
 function void next();
  if(counter::max < counter::count) counter::count = counter::min;
  else counter::count += 1;
 endfunction
endclass

class downcounter extends counter;
 function new(input int count);
  super.new(count, 0, 16);
 endfunction
 
 function void next();
  if(counter::min > counter::count) counter::count = counter::max;
  else counter::count -= 1;
 endfunction
endclass

counter c1 = new(5,0,16);
counter c2 = new(5,0,16);
upcounter c3 = new(3);
downcounter c4 = new(9);


initial begin
 $display("Test-1");
 c1.load(4);
 $display("The output is: %h", c1.getcount);

 $display("Test-2");
  $display("The output before loading is : %h", c2.getcount);
  c2.load(7);
  $display("The output after loading is : %h", c2.getcount);
 
 $display("Test-3");
  $display("Upcounter before incrementing is : %h", c3.getcount);
  repeat(5) begin
  c3.next();
  $display("counter value incremented to : %h", c3.getcount);  
  end
  $display("Downcounter before decrementing is : %h", c4.getcount);
  repeat(5) begin
  c4.next();
  $display("counter value decremented to : %h", c4.getcount);  
  end
  
  $display("Test-4");
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
