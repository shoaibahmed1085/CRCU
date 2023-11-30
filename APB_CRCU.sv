/********************************************************
 Project name                  : CRCU(Clock & Reset Control Unit)   
 File Name                     : APB_CRCU.sv
 Module/class Name             : APB_CRCU
 Author                        : Shoaib Ahmed
 Description                   : APB register configuration 
 File version                  : 1.0 
 Copyright Smart Socs Technologies 
 THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION
 WHICH IS THE PROPERTY OF SMART SOCS TECHNOLOGIES OR ITS
 LICENSORS AND IS SUBJECT TO LICENSE TERMS. 
***************************************************************/

module APB_CRCU (
	input PRESETN,
	input PCLK,
	input PSEL,
	input PENABLE,
	input [31:0] PWDATA,
	input [31:0] PADDR,
	input PWRITE,
	output reg PREADY,	//can be high irrespective of PENABLE from master
	output reg PSLVERR,
	output reg [31:0] PRDATA
	
	//output reg spu_clock_freq;
);

	//reg [31:0] apb_mem [0:123];	//memory declaration for APB with offset values 0x0000 to 0x007C

	/*should this mem be 32 depth or offset depth 
	if offset depth then how to write exactlt into this 
	should we model as a full reg?
	->> create 32 individual registers and directly hardcode conditions into state diagram and put data into address
	*/
	
	/*#####################################################
			REGISTERS DECLARATION
	#####################################################*/
	
	reg [31:0] spu_clock_ctl_reg;		// OFFSET 0x0000
	reg [31:0] vpu_clock_ctl_reg;       // OFFSET 0X0004
	reg [31:0] cpm_clock_ctl_reg;       // OFFSET 0X0008
	reg [31:0] ld_clock_ctl_reg;        // OFFSET 0X000C
	reg [31:0] wi_iol_clock_ctl_reg;    // OFFSET 0X0010
	reg [31:0] tap_clk_ctl_reg;  	    // OFFSET 0X0014
	reg [31:0] db_unit_clock_ctl_reg;   // OFFSET 0X0018
	reg [31:0] vp_debug_clock_ctl_reg;  // OFFSET 0X001C
	reg [31:0] spu_clock_sts_reg;       // OFFSET 0X0020
	reg [31:0] vpu_clock_sts_reg;       // OFFSET 0X0024
	reg [31:0] cpm_clock_sts_reg;       // OFFSET 0X0028
	reg [31:0] ld_clock_sts_reg;        // OFFSET 0X002C
	reg [31:0] wi_iol_clock_sts_reg;    // OFFSET 0X0030
	reg [31:0] tap_clk_sts_reg;         // OFFSET 0X0034
	reg [31:0] db_unit_clock_sts_reg;   // OFFSET 0X0038
	reg [31:0] vp_unit_clock_sts_reg;   // OFFSET 0X003C
	
	reg [31:0] spu_rst_ctl_reg;         // OFFSET 0X0040
	reg [31:0] vpu_rst_ctl_reg;         // OFFSET 0X0044
	reg [31:0] cpm_rst_ctl_reg;         // OFFSET 0X0048
	reg [31:0] ld_rst_ctl_reg;          // OFFSET 0X004C
	reg [31:0] wd_iol_rst_ctl_reg;      // OFFSET 0X0050
	reg [31:0] tap_unit_rst_ctl_reg;    // OFFSET 0X0054
	reg [31:0] db_unit_rst_ctl_reg;     // OFFSET 0X0058
	reg [31:0] vp_unit_rst_ctl_reg;     // OFFSET 0X005C
	reg [31:0] spu_rst_sts_reg;         // OFFSET 0X0060
	reg [31:0] vpu_rst_sts_reg;         // OFFSET 0X0064
	reg [31:0] cpm_rst_sts_reg;         // OFFSET 0X0068
	reg [31:0] ld_rst_sts_reg;          // OFFSET 0X006C
	reg [31:0] wd_iol_rst_sts_reg;      // OFFSET 0X0070
	reg [31:0] tap_unit_rst_sts_reg;    // OFFSET 0X0074
	reg [31:0] db_rst_sts_reg;          // OFFSET 0X0078
	reg [31:0] vp_unit_sts_reg;         // OFFSET 0X007C
	
	
	/*#############################################
			APB STATE CODING
			Here APB_CRCU acts as a Slave
	#############################################*/
	
	//state declaration
	typedef enum {IDLE=2'd0, SETUP=2'd1, ACCESS=2'd2, TRANSFER=2'd3} state_type;
	state_type STATE = IDLE;
	
	//state coding
	always @(posedge PCLK) begin	//synchronous active low reset
		if(!PRESETN) begin
			// for(int i=0; i<=123; i++)	// clear the apb_mem //registers will not be reset to 0. check actual operation in spec
				// apb_mem <= 'b0;	
			STATE <= IDLE;
			PREADY <= 1'b0;
			PSLVERR <= 1'b0;
			PRDATA <= 32'h0;				
		end
		
		else begin
			case(STATE)
				IDLE : begin
							PREADY <= 1'b0;
							PSLVERR <= 1'b0;
							PRDATA <= 32'd0;
							if(PSEL && !PENABLE)
								STATE <= SETUP;
							else
								STATE <= IDLE;
					   end
				SETUP : begin
							PREADY <= 1'b0;
							PSLVERR <= 1'b0;
							PRDATA <= 32'h0;
							if(PSEL && PENABLE)
								STATE <= ACCESS;
							else		
								STATE <= SETUP;
						end
				ACCESS : begin
							if(PSEL && PENABLE && PWRITE) begin	//WRITE OPERATION
								case(PADDR) 
									32'h0000 :  begin
													spu_clock_ctrl_reg <= PWDATA;
													PREADY <= 1'b1;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h0004 :  begin
													vpu_clock_ctrl_reg <= PWDATA;
													PREADY <= 1'b1;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h0008 :  begin
													cpm_clock_ctrl_reg <= PWDATA;
													PREADY <= 1'b1;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h000C :  begin
													ld_clock_ctrl_reg <= PWDATA;
													PREADY <= 1'b1;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end	
									32'h0010 :  begin
													wi_iol_clock_ctrl_reg <= PWDATA;
													PREADY <= 1'b1;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h0014 :  begin
													tap_clock_ctrl_reg <= PWDATA;
													PREADY <= 1'b1;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h0018 :  begin
													db_unit_clock_ctrl_reg <= PWDATA;
													PREADY <= 1'b1;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h001C :  begin
													vp_debug_clock_ctrl_reg <= PWDATA;
													PREADY <= 1'b1;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end	
									32'h0020 :  begin
													spu_clock_sts_reg <= PWDATA;
													PREADY <= 1'b1;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h0024 :  begin
													vpu_clock_sts_reg <= PWDATA;
													PREADY <= 1'b1;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h0028 :  begin
													cpm_clock_sts_reg <= PWDATA;
													PREADY <= 1'b1;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h002C :  begin
													ld_clock_sts_reg <= PWDATA;
													PREADY <= 1'b1;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end	
									32'h0030 :  begin
													wi_iol_clock_sts_reg <= PWDATA;
													PREADY <= 1'b1;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h0034 :  begin
													tap_clk_sts_reg <= PWDATA;
													PREADY <= 1'b1;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h0038 :  begin
													db_unit_clock_sts_reg <= PWDATA;
													PREADY <= 1'b1;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h003C :  begin
													vp_unit_clock_sts_reg <= PWDATA;
													PREADY <= 1'b1;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end	
									32'h0040 :  begin
													spu_rst_ctrl_reg <= PWDATA;
													PREADY <= 1'b1;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h0044 :  begin
													vpu_rst_ctrl_reg <= PWDATA;
													PREADY <= 1'b1;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h0048 :  begin
													cpm_rst_ctrl_reg <= PWDATA;
													PREADY <= 1'b1;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h004C :  begin
													ld_rst_ctrl_reg <= PWDATA;
													PREADY <= 1'b1;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end	
									32'h0050 :  begin
													wd_iol_rst_ctrl_reg <= PWDATA;
													PREADY <= 1'b1;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h0054 :  begin
													tap_unit_rst_ctrl_reg <= PWDATA;
													PREADY <= 1'b1;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h0058 :  begin
													db_unit_rst_ctrl_reg <= PWDATA;
													PREADY <= 1'b1;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h005C :  begin
													vp_unit_rst_ctrl_reg <= PWDATA;
													PREADY <= 1'b1;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end	
									32'h0060 :  begin
													spu_rst_sts_reg <= PWDATA;
													PREADY <= 1'b1;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h0064 :  begin
													vpu_rst_sts_reg <= PWDATA;
													PREADY <= 1'b1;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h0068 :  begin
													cpm_rst_sts_reg <= PWDATA;
													PREADY <= 1'b1;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h006C :  begin
													ld_rst_sts_reg <= PWDATA;
													PREADY <= 1'b1;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end	
									32'h0070 :  begin
													wd_iol_rst_sts_reg <= PWDATA;
													PREADY <= 1'b1;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h0074 :  begin
													tap_unit_rst_sts_reg <= PWDATA;
													PREADY <= 1'b1;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h0078 :  begin
													db_rst_sts_reg <= PWDATA;
													PREADY <= 1'b1;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h007C :  begin
													vp_unit_sts_reg <= PWDATA;
													PREADY <= 1'b1;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end	
									default : begin
												PREADY <= 1'b0;
												PSLVERR <= 1'b1;
												STATE <= TRANSFER;
												$display("ERROR : Address out of range for slave");
											  end
								endcase
							end
							
							else if(PSEL && PENABLE && !PWRITE) begin	//READ OPERATION
								case(PADDR)
									32'h0000 :  begin
													PRDATA <= spu_clock_ctl_reg;
													PREADY <= 1'b0;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h0004 :  begin
													PRDATA <= vpu_clock_ctl_reg;
													PREADY <= 1'b0;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h0008 :  begin
													PRDATA <= cpm_clock_ctl_reg;
													PREADY <= 1'b0;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h000C :  begin
													PRDATA <= ld_clock_ctl_reg;
													PREADY <= 1'b0;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end	
									32'h0010 :  begin
													PRDATA <= wi_iol_clock_ctl_reg;
													PREADY <= 1'b0;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h0014 :  begin
													PRDATA <= tap_clk_ctl_reg;
													PREADY <= 1'b0;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h0018 :  begin
													PRDATA <= db_unit_clock_ctrl_reg;
													PREADY <= 1'b0;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h001C :  begin
													PRDATA <= vp_debug_clock_ctrl_reg;
													PREADY <= 1'b0;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end	
									32'h0020 :  begin
													PRDATA <= spu_clock_sts_reg;
													PREADY <= 1'b0;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h0024 :  begin
													PRDATA <= vpu_clock_sts_reg;
													PREADY <= 1'b0;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h0028 :  begin
													PRDATA <= cpm_clock_sts_reg;
													PREADY <= 1'b0;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h002C :  begin
													PRDATA <= ld_clock_sts_reg;
													PREADY <= 1'b0;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end	
									32'h0030 :  begin
													PRDATA <= wi_iol_clock_sts_reg;
													PREADY <= 1'b0;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h0034 :  begin
													PRDATA <= tap_clk_sts_reg;
													PREADY <= 1'b0;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h0038 :  begin
													PRDATA <= db_unit_clock_sts_reg;
													PREADY <= 1'b0;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h003C :  begin
													PRDATA <= vp_unit_clock_sts_reg;
													PREADY <= 1'b0;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end	
									32'h0040 :  begin
													PRDATA <= spu_rst_ctrl_reg;
													PREADY <= 1'b0;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h0044 :  begin
													PRDATA <= vpu_rst_ctrl_reg;
													PREADY <= 1'b0;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h0048 :  begin
													PRDATA <= cpm_rst_ctrl_reg;
													PREADY <= 1'b0;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h004C :  begin
													PRDATA <= ld_rst_ctrl_reg;
													PREADY <= 1'b0;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end	
									32'h0050 :  begin
													PRDATA <= wd_iol_rst_ctrl_reg;
													PREADY <= 1'b0;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h0054 :  begin
													PRDATA <= tap_unit_rst_ctrl_reg;
													PREADY <= 1'b0;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h0058 :  begin
													PRDATA <= db_unit_rst_ctrl_reg;
													PREADY <= 1'b0;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h005C :  begin
													PRDATA <= vp_unit_rst_ctrl_reg;
													PREADY <= 1'b0;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end	
									32'h0060 :  begin
													PRDATA <= spu_rst_sts_reg;
													PREADY <= 1'b0;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h0064 :  begin
													PRDATA <= vpu_rst_sts_reg;
													PREADY <= 1'b0;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h0068 :  begin
													PRDATA <= cpm_rst_sts_reg;
													PREADY <= 1'b0;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h006C :  begin
													PRDATA <= ld_rst_sts_reg;
													PREADY <= 1'b0;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end	
									32'h0070 :  begin
													PRDATA <= wd_iol_rst_sts_reg;
													PREADY <= 1'b0;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h0074 :  begin
													PRDATA <= tap_unit_rst_sts_reg;
													PREADY <= 1'b0;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h0078 :  begin
													PRDATA <= db_rst_sts_reg;
													PREADY <= 1'b0;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end
									32'h007C :  begin
													PRDATA <= vp_unit_sts_reg;
													PREADY <= 1'b0;
													PSLVERR <= 1'b0;
													STATE <= TRANSFER;
												end	
									default : begin
												PRDATA <= 32'hX;	//drive to 0/x/z?
												PREADY <= 1'b1;
												PSLVERR <= 1'b1;
												STATE <= TRANSFER;
												$display("ERROR : Address out of range for slave");
											  end
								endcase
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
	
	//assign spu_clock_freq = spu_clock_ctl_reg[2:0];
	
endmodule
