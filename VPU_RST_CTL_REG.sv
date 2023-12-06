/********************************************************
 Project name                  : CRCU(Clock & Reset Control Unit)   
 File Name                     : VPU_RST_CTL_REG.sv
 Module/class Name             : VPU_RST_CTL_REG
 Author                        : Shoaib Ahmed
 Description                   : Generation of vpu_rst based on register values set by APB interface
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

module VPU_RST_CTL_REG (
	input CRCU_CLK,
	input CRCU_RST,
	input [31:0] vpu_rst_ctl_reg,
	output vpu_rst
);

	wire async_rst;
	wire polarity;
	
	// Check conditions for reset enabling, polarity and type
	generate 
		if(!vpu_rst_ctl_reg[0]) begin
			assign vpu_rst = 1'b0;
		end
		
		else begin
			if(vpu_rst_ctl_reg[1])
				assign async_rst = 1'b1;	//async reset
			else
				assign async_rst = 1'b0;	//sync reset
				
			if(vpu_rst_ctl_reg[2])
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
													.rst_ctl_reg 		(vpu_rst_ctl_reg),
													.rst				(vpu_rst)
													);
		else if(!async_rst && polarity)
			POSEDGE_SYNC_RST posedge_sync_rst_inst (
													.CRCU_CLK			(CRCU_CLK),
													.CRCU_RST			(CRCU_RST),
													.rst_ctl_reg 		(vpu_rst_ctl_reg),
													.rst				(vpu_rst)			
													);
		else if(async_rst && !polarity)
			NEGEDGE_ASYNC_RST negedge_async_rst_inst (
													.CRCU_CLK			(CRCU_CLK),
													.CRCU_RST			(CRCU_RST),
													.rst_ctl_reg 		(vpu_rst_ctl_reg),
													.rst				(vpu_rst)			
													);
		else if(async_rst && polarity)
			POSEDGE_ASYNC_RST posedge_async_rst_inst (
													.CRCU_CLK			(CRCU_CLK),
													.CRCU_RST			(CRCU_RST),
													.rst_ctl_reg 		(vpu_rst_ctl_reg),
													.rst				(vpu_rst)			
													);	
	endgenerate


endmodule