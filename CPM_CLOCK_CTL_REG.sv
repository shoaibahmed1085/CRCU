/********************************************************
 Project name                  : CRCU(Clock & Reset Control Unit)   
 File Name                     : CPM_CLOCK_CTL_REG.sv
 Module/class Name             : CPM_CLOCK_CTL_REG
 Author                        : Shoaib Ahmed
 Description                   : Generation of cpm_clk based on register values set by APB interface
 File version                  : 1.0 
 Copyright Smart Socs Technologies 
 THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION
 WHICH IS THE PROPERTY OF SMART SOCS TECHNOLOGIES OR ITS
 LICENSORS AND IS SUBJECT TO LICENSE TERMS. 
***************************************************************/

`timescale <DV team to add according to simulations>

`include "./clk_div_synth.sv"
`include "./clk_div_non_synth.sv"

module CPM_CLOCK_CTL_REG (
	input CRCU_CLK,
	input [31:0] cpm_clock_ctl_reg,
	output cpm_clk
);
	
	generate
		if(cpm_clock_ctl_reg[2:0] == 3'b000)			//200MHz
			clk_div_synth #(.N(12)) two_hundred_MHz (
													.clk_in	(CRCU_CLK),
													.clk_out (cpm_clk)
												);
		else if (cpm_clock_ctl_reg[2:0] == 3'b001)		//300MHZ
			clk_div_synth #(.N(3)) three_hundred_MHz (
													.clk_in	(CRCU_CLK),
													.clk_out (cpm_clk)
												);
		else if (cpm_clock_ctl_reg[2:0] == 3'b010)		//500MHZ -> Non Synthesizable
			clk_div_non_synth #(.N(1000)) five_hundred_MHz (
													.clk_in	(CRCU_CLK),
													.clk_out (cpm_clk)
												);	
		else if (cpm_clock_ctl_reg[2:0] == 3'b011)		//1100MHZ -> Non Synthesizable
			clk_div_non_synth #(.N(456)) eleven_hundred_MHz (
													.clk_in	(CRCU_CLK),
													.clk_out (cpm_clk)
												);												
	endgenerate
	
	assign cpm_clk = (!cpm_clock_ctl_reg[4] && cpm_clock_ctl_reg[3]) ? cpm_clk : 1'bz;	//only when clk gating is disabled and clk enable is high cpm_clk is produced
								

endmodule