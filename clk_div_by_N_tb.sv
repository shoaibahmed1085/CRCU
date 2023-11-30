// Code your testbench here
// or browse Examples
`timescale 1ns/100ps
module clkdiv3_tb;
  reg clk,reset;
  wire clk_out;
 
  parameter N=4;
  
  clk_divn #(N) t1 (clk,reset,clk_out);
  
     initial clk= 1'b0;
     always #5  clk=~clk; 
  
        initial begin
               #5 reset=1'b1;
               #10 reset=1'b0;
               #5000 $finish;
        end
//initial $monitor("clk=%b,reset=%b,clk_out=%b",clk,reset,clk_out);
 
        initial begin
              $dumpfile("dump.vcd");
              $dumpvars(1);
        end
  
    endmodule
