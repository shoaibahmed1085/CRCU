/********************************************************
 Project name                  : CRCU(Clock & Reset Control Unit)   
 File Name                     : VPU_CLOCK_CTL_REG.sv
 Module/class Name             : VPU_CLOCK_CTL_REG
 Author                        : Shoaib Ahmed
 Description                   : Generation of vpu_clk based on register values set by APB interface
 File version                  : 1.0 
 Copyright Smart Socs Technologies 
 THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION
 WHICH IS THE PROPERTY OF SMART SOCS TECHNOLOGIES OR ITS
 LICENSORS AND IS SUBJECT TO LICENSE TERMS. 
***************************************************************/

`timescale <DV team to add according to simulations>

`include "./clk_div_synth.sv"
`include "./clk_div_non_synth.sv"

module VPU_CLOCK_CTL_REG (
	input CRCU_CLK,
	input [31:0] vpu_clock_ctl_reg,
	output vpu_clk
);
	
	generate
		if(vpu_clock_ctl_reg[2:0] == 3'b000)			//100MHz
			clk_div_synth #(.N(12)) one_hundred_MHz (
													.clk_in	(CRCU_CLK),
													.clk_out (vpu_clk)
												);
		else if (vpu_clock_ctl_reg[2:0] == 3'b001)		//400MHZ
			clk_div_synth #(.N(3)) four_hundred_MHz (
													.clk_in	(CRCU_CLK),
													.clk_out (vpu_clk)
												);
		else if (vpu_clock_ctl_reg[2:0] == 3'b010)		//600MHZ
			clk_div_synth #(.N(2)) six_hundred_MHz (
													.clk_in	(CRCU_CLK),
													.clk_out (vpu_clk)
												);
		else if (vpu_clock_ctl_reg[2:0] == 3'b011)		//800MHZ -> Non Synthesizable
			clk_div_non_synth #(.N(625)) eight_hundred_MHz (
													.clk_in	(CRCU_CLK),
													.clk_out (vpu_clk)
												);
		else if (vpu_clock_ctl_reg[2:0] == 3'b100)		//1000MHZ -> Non Synthesizable
			clk_div_non_synth #(.N(500)) one_thousand_MHz (
													.clk_in	(CRCU_CLK),
													.clk_out (vpu_clk)
												);												
	endgenerate
	
	assign vpu_clk = (!vpu_clock_ctl_reg[4] && vpu_clock_ctl_reg[3]) ? vpu_clk : 1'bz;	//only when clk gating is disabled and clk enable is high vpu_clk is produced
								

endmodule