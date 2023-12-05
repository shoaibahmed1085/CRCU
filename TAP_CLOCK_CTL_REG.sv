/********************************************************
 Project name                  : CRCU(Clock & Reset Control Unit)   
 File Name                     : TAP_CLOCK_CTL_REG.sv
 Module/class Name             : TAP_CLOCK_CTL_REG
 Author                        : Shoaib Ahmed
 Description                   : Generation of tap_clk based on register values set by APB interface
 File version                  : 1.0 
 Copyright Smart Socs Technologies 
 THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION
 WHICH IS THE PROPERTY OF SMART SOCS TECHNOLOGIES OR ITS
 LICENSORS AND IS SUBJECT TO LICENSE TERMS. 
***************************************************************/

`timescale <DV team to add according to simulations>

`include "./clk_div_synth.sv"
`include "./clk_div_non_synth.sv"

module TAP_CLOCK_CTL_REG (
	input CRCU_CLK,
	input [31:0] tap_clock_ctl_reg,
	output tap_clk
);
	
	generate
		if(tap_clock_ctl_reg[2:0] == 3'b000)			//10MHz
			clk_div_synth #(.N(120)) ten_MHz (
													.clk_in	(CRCU_CLK),
													.clk_out (tap_clk)
												);
		else if (tap_clock_ctl_reg[2:0] == 3'b001)		//25MHZ
			clk_div_synth #(.N(48)) twenty_five_MHz (
													.clk_in	(CRCU_CLK),
													.clk_out (tap_clk)
												);
		else if (tap_clock_ctl_reg[2:0] == 3'b010)		//40MHZ 
			clk_div_synth #(.N(30)) fourty_MHz (
													.clk_in	(CRCU_CLK),
													.clk_out (tap_clk)
												);	
		else if (tap_clock_ctl_reg[2:0] == 3'b011)		//80MHZ 
			clk_div_synth #(.N(15)) eighty_MHz (
													.clk_in	(CRCU_CLK),
													.clk_out (tap_clk)
												);	
		else if (tap_clock_ctl_reg[2:0] == 3'b100)		//100MHZ 
			clk_div_synth #(.N(12)) one_hundred_MHz (
													.clk_in	(CRCU_CLK),
													.clk_out (tap_clk)
												);												
	endgenerate
	
	assign tap_clk = (!tap_clock_ctl_reg[4] && tap_clock_ctl_reg[3]) ? tap_clk : 1'bz;	//only when clk gating is disabled and clk enable is high tap_clk is produced
								

endmodule