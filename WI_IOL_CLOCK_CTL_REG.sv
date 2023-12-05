/********************************************************
 Project name                  : CRCU(Clock & Reset Control Unit)   
 File Name                     : WI_IOL_CLOCK_CTL_REG.sv
 Module/class Name             : WI_IOL_CLOCK_CTL_REG
 Author                        : Shoaib Ahmed
 Description                   : Generation of wi_iol_clk based on register values set by APB interface
 File version                  : 1.0 
 Copyright Smart Socs Technologies 
 THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION
 WHICH IS THE PROPERTY OF SMART SOCS TECHNOLOGIES OR ITS
 LICENSORS AND IS SUBJECT TO LICENSE TERMS. 
***************************************************************/

`timescale <DV team to add according to simulations>

`include "./clk_div_synth.sv"
`include "./clk_div_non_synth.sv"

module WI_IOL_CLOCK_CTL_REG (
	input CRCU_CLK,
	input [31:0] wi_iol_clock_ctl_reg,
	output wi_iol_clk
);
	
	generate
		if(wi_iol_clock_ctl_reg[2:0] == 3'b000)			//100MHz
			clk_div_synth #(.N(12)) one_hundred_MHz (
													.clk_in	(CRCU_CLK),
													.clk_out (wi_iol_clk)
												);	
		else if (wi_iol_clock_ctl_reg[2:0] == 3'b001)		//125MHZ 
			clk_div_non_synth #(.N(4000)) one_hundred_twenty_five_MHz (
													.clk_in	(CRCU_CLK),
													.clk_out (ld_clk)
												);												
	endgenerate
	
	assign wi_iol_clk = (!wi_iol_clock_ctl_reg[4] && wi_iol_clock_ctl_reg[3]) ? wi_iol_clk : 1'bz;	//only when clk gating is disabled and clk enable is high wi_iol_clk is produced
								

endmodule