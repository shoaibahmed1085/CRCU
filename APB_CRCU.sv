/*#############################################
	APB STATE CODING
	Here APB_CRCU acts as a Slave
#############################################*/
module APB_CRCU (
	input PRESETN,
	input PCLK,
	input PSEL,
	input PENABLE,
	input [31:0] PWDATA,
	input [31:0] PADDR,
	input PWRITE,
	output PREADY,	//can be high irrespective of PENABLE from master
	output PSLVERR,
	output [31:0] PRDATA
);

	reg [31:0] apb_mem [0:123];	//memory declaration for APB with offset values 0x0000 to 0x007C

	/*should this mem be 32 depth or offset depth 
	if offset depth then how to write exactlt into this 
	should we model as a full reg?*/
	
	//state declaration
	typedef enum {IDLE=2'd0, SETUP=2'd1, ACCESS=2'd2, TRANSFER=2'd3} state_type;
	state_type STATE = IDLE;
	
	//state coding
	always @(posedge PCLK) begin
		if(!PRESETN) begin
			for(int i=0; i<=123; i++)	// clear the apb_mem
				apb_mem <= 'b0;	
			STATE <= IDLE;
			PREADY <= 1'b0;
			PSLVERR <= 1'b0;
			PRDATA <= 32'd0;				
		end
		
		else begin
			case(STATE)
				IDLE : begin
							PREADY <= 1'b0;
							PSLVERR <= 1'b0;
							PRDATA <= 32'd0;
							if(!PSEL && !PENABLE)
								STATE <= SETUP;
							else
								STATE <= IDLE;
					   end
				SETUP : begin
							PREADY <= 1'b0;
							PSLVERR <= 1'b0;
							PRDATA <= 32'd0;
							if(PSEL && !PENABLE)
								STATE <= ACCESS;
							else
								STATE <= SETUP;
						end;
				ACCESS : begin
							if(PSEL && PENABLE && PWRITE) begin	//WRITE OPERATION
								if(PADDR <= 123) begin
									apb_mem[PADDR] <= PDATA;	//write data present on apb bus to the address of apb mem
									PREADY <= 1'b1;
									PSLVERR <= 1'b0;
									STATE <= TRANSFER;
								end
								else begin
									PREADY <= 1'b0;
									PSLVERR <= 1'b1;
									STATE <= TRANSFER;
									$display("ERROR : Address out of range for slave");
								end
							end
							
							else if(PSEL && PENABLE && !PWRITE) begin	//READ OPERATION
								if(PADDR <= 123) begin
									PRDATA <= apb_mem[PADDR];
									PREADY <= 1'b1;
									PSLVERR <= 1'b0;
									STATE <= TRANSFER;
								end
								else begin
									PRDATA <= 32'hxxxx_xxxx;
									PREADY <= 1'b1;
									PSLVERR <= 1'b1;
									STATE <= TRANSFER;
									$display("ERROR : Address out of range for slave");
								end
							end
							
						 end
				TRANSFER : begin	//why this state is required? what are the conditions for this?
								STATE <= SETUP;
								PREADY <= 1'b0;
								PSLVERR <= 1'b0;
						   end
				default : STATE <= IDLE;
			endcase
		end	
	end
		
endmodule