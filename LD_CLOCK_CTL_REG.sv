/********************************************************
 Project name                  : CRCU(Clock & Reset Control Unit)   
 File Name                     : LD_CLOCK_CTL_REG.sv
 Module/class Name             : LD_CLOCK_CTL_REG
 Author                        : Shoaib Ahmed
 Description                   : Generation of ld_clk based on register values set by APB interface
 File version                  : 1.0 
 Copyright Smart Socs Technologies 
 THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION
 WHICH IS THE PROPERTY OF SMART SOCS TECHNOLOGIES OR ITS
 LICENSORS AND IS SUBJECT TO LICENSE TERMS. 
***************************************************************/

`timescale <DV team to add according to simulations>

`include "./clk_div_synth.sv"
`include "./clk_div_non_synth.sv"

module LD_CLOCK_CTL_REG (
	input CRCU_CLK,
	input [31:0] ld_clock_ctl_reg,
	output ld_clk
);
	
	generate
		if(ld_clock_ctl_reg[2:0] == 3'b000)			//200MHz
			clk_div_synth #(.N(6)) two_hundred_MHz (
													.clk_in	(CRCU_CLK),
													.clk_out (ld_clk)
												);
		else if (ld_clock_ctl_reg[2:0] == 3'b001)		//300MHZ
			clk_div_synth #(.N(4)) three_hundred_MHz (
													.clk_in	(CRCU_CLK),
													.clk_out (ld_clk)
												);
		else if (ld_clock_ctl_reg[2:0] == 3'b010)		//400MHZ 
			clk_div_synth #(.N(3)) four_hundred_MHz (
													.clk_in	(CRCU_CLK),
													.clk_out (ld_clk)
												);	
		else if (ld_clock_ctl_reg[2:0] == 3'b011)		//500MHZ 
			clk_div_non_synth #(.N(1000)) five_hundred_MHz (
													.clk_in	(CRCU_CLK),
													.clk_out (ld_clk)
												);	
		else if (ld_clock_ctl_reg[2:0] == 3'b100)		//600MHZ 
			clk_div_synth #(.N(2)) six_hundred_MHz (
													.clk_in	(CRCU_CLK),
													.clk_out (ld_clk)
												);												
	endgenerate
	
	assign ld_clk = (!ld_clock_ctl_reg[4] && ld_clock_ctl_reg[3]) ? ld_clk : 1'bz;	//only when clk gating is disabled and clk enable is high ld_clk is produced
								

endmodule