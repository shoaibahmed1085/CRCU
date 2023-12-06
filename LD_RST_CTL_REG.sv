/********************************************************
 Project name                  : CRCU(Clock & Reset Control Unit)   
 File Name                     : LD_RST_CTL_REG.sv
 Module/class Name             : LD_RST_CTL_REG
 Author                        : Shoaib Ahmed
 Description                   : Generation of ld_rst based on register values set by APB interface
 File version                  : 1.0 
 Copyright Smart Socs Technologies 
 THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION
 WHICH IS THE PROPERTY OF SMART SOCS TECHNOLOGIES OR ITS
 LICENSORS AND IS SUBJECT TO LICENSE TERMS. 
***************************************************************/

`timescale <DV team to add according to simulations>

`include "./NEGEDGE_SYNC_RST.sv"
`include "./POSEDGE_SYNC_RST.sv"
`include "./NEGEDGE_ASYNC_RST.sv"
`include "./POSEDGE_ASYNC_RST.sv"

module LD_RST_CTL_REG (
	input CRCU_CLK,
	input CRCU_RST,
	input [31:0] ld_rst_ctl_reg,
	output ld_rst
);

	wire async_rst;
	wire polarity;
	
	// Check conditions for reset enabling, polarity and type
	generate 
		if(!ld_rst_ctl_reg[0]) begin
			assign ld_rst = 1'b0;
		end
		
		else begin
			if(ld_rst_ctl_reg[1])
				assign async_rst = 1'b1;	//async reset
			else
				assign async_rst = 1'b0;	//sync reset
				
			if(ld_rst_ctl_reg[2])
				assign polarity = 1'b1;		//posedge triggered
			else
				assign polarity = 1'b0;		//negedge triggered
		end
	endgenerate
	
	// Generating modules based on values updated by APB
	generate
		if(!async_rst && !polarity)
			NEGEDGE_SYNC_RST negedge_sync_rst_inst (
													.CRCU_CLK			(CRCU_CLK),
													.CRCU_RST			(CRCU_RST),
													.rst_ctl_reg 		(ld_rst_ctl_reg),
													.rst				(ld_rst)
													);
		else if(!async_rst && polarity)
			POSEDGE_SYNC_RST posedge_sync_rst_inst (
													.CRCU_CLK			(CRCU_CLK),
													.CRCU_RST			(CRCU_RST),
													.rst_ctl_reg 		(ld_rst_ctl_reg),
													.rst				(ld_rst)			
													);
		else if(async_rst && !polarity)
			NEGEDGE_ASYNC_RST negedge_async_rst_inst (
													.CRCU_CLK			(CRCU_CLK),
													.CRCU_RST			(CRCU_RST),
													.rst_ctl_reg 		(ld_rst_ctl_reg),
													.rst				(ld_rst)			
													);
		else if(async_rst && polarity)
			POSEDGE_ASYNC_RST posedge_async_rst_inst (
													.CRCU_CLK			(CRCU_CLK),
													.CRCU_RST			(CRCU_RST),
													.rst_ctl_reg 		(ld_rst_ctl_reg),
													.rst				(ld_rst)			
													);	
	endgenerate


endmodule