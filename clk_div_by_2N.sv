//divide by 2N counter
//output should be high for N full clk cycles and then be toggled

module clk_div_2N #(
	parameter N=4
) (
	input i_clk, rst,
  	output reg out_clk
);
  
  reg [(N<<1)-1:0] count;
  
  always @(posedge i_clk) begin
    if(rst)
      out_clk <= 'b0;
    else if (count<=N-1)
      out_clk <= 'b1;
    else if(count>=N && (count <= (N<<1)-1) )
      out_clk <= 'b0;
  end
  
  always @(posedge i_clk) begin
    if(rst)
      count = 'b0;
    else if(count==(N<<1)-1)
      count = 'b0;
    else
      count = count + 1'b1;
  end
  
endmodule
