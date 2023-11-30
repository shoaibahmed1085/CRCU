// This design works for any div factor (odd or even)
// value needs to be passed directly, not like 2N or 2N+1, ex: if we need div by 4, N=4. If we need div by 7, N=7.
module clk_divn #(
	parameter N = 7
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
  
   //on every negedge increment neg_count and when it is equal to N-1(as it is sync) make it 0
 always @(negedge clk) begin
   if (reset)
		neg_count <=0;
	else if (neg_count ==N-1) 
		neg_count <= 0;
	else
		neg_count<= neg_count +1; 
 end
 
  //make o/p high whenever N/2 is reached
  
  /*############################################
          OUTPUT ONLY FOR ODD FACTORS
      assign clk_out = ((pos_count > (N>>1)) | (neg_count > (N>>1)));
    ############################################*/

    /*############################################
          OUTPUT ONLY FOR EVEN FACTORS
      assign clk_out = (pos_count >= (N>>1))?1'b1:1'b0
    ############################################*/
  
      /*############################################
          OUTPUT ONLY FOR EVEN AND ODD FACTORS --> GENERIC (COMBINING BOTH ODD & EVEN)
    ############################################*/
      assign clk_out = (N%2)?
    				((pos_count > (N>>1)) | (neg_count > (N>>1))):
    				(pos_count >= (N>>1)); 
  
endmodule
