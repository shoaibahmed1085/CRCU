/********************************************************
 Project name                  : CRCU(Clock & Reset Control Unit)   
 File Name                     : APB_CRCU.sv
 Module/class Name             : APB_CRCU
 Author                        : Shoaib Ahmed
 Description                   : APB register configuration (Ctrl registers are R/W and sts registers are RO)
 File version                  : 1.0 
 Copyright Smart Socs Technologies 
 THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION
 WHICH IS THE PROPERTY OF SMART SOCS TECHNOLOGIES OR ITS
 LICENSORS AND IS SUBJECT TO LICENSE TERMS. 
***************************************************************/

`timescale <DV team to add according to simulations>

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
	output reg [31:0] PRDATA,
		
	/*#####################################################
			CONTROL REGISTERS DECLARATION - R/W
	#####################################################*/
	
	output reg [31:0] spu_clock_ctl_reg,	   // OFFSET 0x0000
	output reg [31:0] vpu_clock_ctl_reg,       // OFFSET 0X0004
	output reg [31:0] cpm_clock_ctl_reg,       // OFFSET 0X0008
	output reg [31:0] ld_clock_ctl_reg,        // OFFSET 0X000C
	output reg [31:0] wi_iol_clock_ctl_reg,    // OFFSET 0X0010
	output reg [31:0] tap_clk_ctl_reg,  	   // OFFSET 0X0014
	output reg [31:0] db_unit_clock_ctl_reg,   // OFFSET 0X0018
	output reg [31:0] vp_debug_clock_ctl_reg,  // OFFSET 0X001C
	
	output reg [31:0] spu_rst_ctl_reg,         // OFFSET 0X0040
	output reg [31:0] vpu_rst_ctl_reg,         // OFFSET 0X0044
	output reg [31:0] cpm_rst_ctl_reg,         // OFFSET 0X0048
	output reg [31:0] ld_rst_ctl_reg,          // OFFSET 0X004C
	output reg [31:0] wd_iol_rst_ctl_reg,      // OFFSET 0X0050
	output reg [31:0] tap_unit_rst_ctl_reg,    // OFFSET 0X0054
	output reg [31:0] db_unit_rst_ctl_reg,     // OFFSET 0X0058
	output reg [31:0] vp_unit_rst_ctl_reg,     // OFFSET 0X005C
	
	//output reg spu_clock_freq; -> IF WE CREATE THIS AS OUTPUT REG THEN WHAT WILL WE CONNECT THIS PORT TO IN TOP MODULE????
	/*
	n this example, sub_module has 4 output ports, but top_module requires only 2 of them. So, we have connected only the required output ports (out1 and out2) while instantiating the sub_module in top_module.

PLEASE NOTE THAT ANY UNCONNECTED OUTPUT PORTS WILL BE LEFT FLOATING, WHICH MAY CAUSE ISSUES IN YOUR DESIGN. YOU CAN AVOID THIS BY CONNECTING THE UNCONNECTED OUTPUT PORTS TO A CONSTANT VALUE OR A HIGH-IMPEDANCE STATE, DEPENDING ON YOUR DESIGN REQUIREMENTS.
	*/
);
	
	/*#####################################################
			STATUS REGISTERS DECLARATION - RO
	#####################################################*/
	
	reg [31:0] spu_clock_sts_reg,       // OFFSET 0X0020
	reg [31:0] vpu_clock_sts_reg,       // OFFSET 0X0024
	reg [31:0] cpm_clock_sts_reg,       // OFFSET 0X0028
	reg [31:0] ld_clock_sts_reg,        // OFFSET 0X002C
	reg [31:0] wi_iol_clock_sts_reg,    // OFFSET 0X0030
	reg [31:0] tap_clk_sts_reg,         // OFFSET 0X0034
	reg [31:0] db_unit_clock_sts_reg,   // OFFSET 0X0038
	reg [31:0] vp_unit_clock_sts_reg,   // OFFSET 0X003C
		
	reg [31:0] spu_rst_sts_reg,         // OFFSET 0X0060
	reg [31:0] vpu_rst_sts_reg,         // OFFSET 0X0064
	reg [31:0] cpm_rst_sts_reg,         // OFFSET 0X0068
	reg [31:0] ld_rst_sts_reg,          // OFFSET 0X006C
	reg [31:0] wd_iol_rst_sts_reg,      // OFFSET 0X0070
	reg [31:0] tap_unit_rst_sts_reg,    // OFFSET 0X0074
	reg [31:0] db_rst_sts_reg,          // OFFSET 0X0078
	reg [31:0] vp_unit_sts_reg          // OFFSET 0X007C
	
	
	/*########################################################################
					APB STATE CODING
					Here APB_CRCU acts as a Slave
	########################################################################*/
	
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
									/*32'h0020 :  begin
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
												end	*/
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
									/*32'h0060 :  begin
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
												end	*/
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

	/*##########################################################
		Assigning Control Register values to Status Registers
	##########################################################*/	

	assign spu_clock_sts_reg       = spu_clock_ctl_reg	   ;
	assign vpu_clock_sts_reg       = vpu_clock_ctl_reg     ;
	assign cpm_clock_sts_reg       = cpm_clock_ctl_reg     ;
	assign ld_clock_sts_reg        = ld_clock_ctl_reg      ;
	assign wi_iol_clock_sts_reg    = wi_iol_clock_ctl_reg  ;
	assign tap_clk_sts_reg         = tap_clk_ctl_reg  	   ;
	assign db_unit_clock_sts_reg   = db_unit_clock_ctl_reg ;
	assign vp_unit_clock_sts_reg   = vp_debug_clock_ctl_reg;
	
	assign spu_rst_sts_reg        = spu_rst_sts_reg     ;
	assign vpu_rst_sts_reg        = vpu_rst_sts_reg     ;
	assign cpm_rst_sts_reg        = cpm_rst_sts_reg     ;
	assign ld_rst_sts_reg         = ld_rst_sts_reg      ;
	assign wd_iol_rst_sts_reg     = wd_iol_rst_sts_reg  ;
	assign tap_unit_rst_sts_reg   = tap_unit_rst_sts_reg;
	assign db_rst_sts_reg         = db_rst_sts_reg      ;
	assign vp_unit_sts_reg        = vp_unit_sts_reg     ;
	
endmodule
