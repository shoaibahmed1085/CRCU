/********************************************************
 Project name                  : CRCU(Clock & Reset Control Unit)   
 File Name                     : VP_DEBUG_CLOCK_CTL_REG.sv
 Module/class Name             : VP_DEBUG_CLOCK_CTL_REG
 Author                        : Shoaib Ahmed
 Description                   : Generation of vp_debug_clk based on register values set by APB interface
 File version                  : 1.0 
 Copyright Smart Socs Technologies 
 THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION
 WHICH IS THE PROPERTY OF SMART SOCS TECHNOLOGIES OR ITS
 LICENSORS AND IS SUBJECT TO LICENSE TERMS. 
***************************************************************/

`timescale <DV team to add according to simulations>

`include "./clk_div_synth.sv"
`include "./clk_div_non_synth.sv"

module VP_DEBUG_CLOCK_CTL_REG (
	input CRCU_CLK,
	input [31:0] vp_debug_clock_ctl_reg,
	output vp_debug_clk
);
	
	generate
		if(vp_debug_clock_ctl_reg[2:0] == 3'b000)			//10KHz
			clk_div_non_synth #(.N(50000000)) ten_KHz (
													.clk_in	(CRCU_CLK),
													.clk_out (vp_debug_clk)
												);
		else if (vp_debug_clock_ctl_reg[2:0] == 3'b001)		//20KHZ
			clk_div_non_synth #(.N(25000000)) twenty_KHz (
													.clk_in	(CRCU_CLK),
													.clk_out (vp_debug_clk)
												);
		else if (vp_debug_clock_ctl_reg[2:0] == 3'b010)		//80KHZ 
			clk_div_non_synth #(.N(6250000)) eighty_KHz (
													.clk_in	(CRCU_CLK),
													.clk_out (vp_debug_clk)
												);	
		else if (vp_debug_clock_ctl_reg[2:0] == 3'b011)		//100KHZ 
			clk_div_non_synth #(.N(5000000)) hundred_KHz (
													.clk_in	(CRCU_CLK),
													.clk_out (vp_debug_clk)
												);
		else if (vp_debug_clock_ctl_reg[2:0] == 3'b100)		//125KHZ 
			clk_div_non_synth #(.N(4000000)) hundred_twenty_five_KHz (
													.clk_in	(CRCU_CLK),
													.clk_out (vp_debug_clk)
												);											
	endgenerate
	
	assign vp_debug_clk = (!vp_debug_clock_ctl_reg[4] && vp_debug_clock_ctl_reg[3]) ? vp_debug_clk : 1'bz;	//only when clk gating is disabled and clk enable is high vp_debug_clk is produced
								

endmodule