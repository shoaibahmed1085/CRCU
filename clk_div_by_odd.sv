module clk_divn #(
	parameter N = 7 //odd value should be directly passed here, not in the for of 2N+1
	)	(
	input clk,
	input reset,
	output clk_out
 );
 
reg [$clog2(N)-1:0] pos_count, neg_count;
 
  //on every posedge increment pos_count and when it is equal to N-1(as it is sync) make it 0
 always @(posedge clk) begin
	if (reset)
		pos_count <=0;
	else if (pos_count ==N-1) 
		pos_count <= 0;
	else 
		pos_count<= pos_count +1;
 end
  
   //on every posedge increment pos_count and when it is equal to N-1(as it is sync) make it 0
 always @(negedge clk) begin
	if (reset)
		neg_count <=0;
	else if (neg_count ==N-1) 
		neg_count <= 0;
	else
		neg_count<= neg_count +1; 
 end
 
  //make o/p high whenever N/2 is reached
assign clk_out = ((pos_count > (N>>1)) | (neg_count > (N>>1))); 

endmodule
