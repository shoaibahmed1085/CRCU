/********************************************************
 Project name                  : CRCU(Clock & Reset Control Unit)   
 File Name                     : DB_UNIT_CLOCK_CTL_REG.sv
 Module/class Name             : DB_UNIT_CLOCK_CTL_REG
 Author                        : Shoaib Ahmed
 Description                   : Generation of db_unit_clk based on register values set by APB interface
 File version                  : 1.0 
 Copyright Smart Socs Technologies 
 THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION
 WHICH IS THE PROPERTY OF SMART SOCS TECHNOLOGIES OR ITS
 LICENSORS AND IS SUBJECT TO LICENSE TERMS. 
***************************************************************/

`timescale <DV team to add according to simulations>

`include "./clk_div_synth.sv"
`include "./clk_div_non_synth.sv"

module DB_UNIT_CLOCK_CTL_REG (
	input CRCU_CLK,
	input [31:0] db_unit_clock_ctl_reg,
	output db_unit_clk
);
	
	generate
		if(db_unit_clock_ctl_reg[2:0] == 3'b000)			//100MHz
			clk_div_synth #(.N(12)) one_hundred_MHz (
													.clk_in	(CRCU_CLK),
													.clk_out (db_unit_clk)
												);
		else if (db_unit_clock_ctl_reg[2:0] == 3'b001)		//125MHZ
			clk_div_non_synth #(.N(4000)) hundred_twenty_five_MHz (
													.clk_in	(CRCU_CLK),
													.clk_out (db_unit_clk)
												);
		else if (db_unit_clock_ctl_reg[2:0] == 3'b010)		//180MHZ 
			clk_div_non_synth #(.N(2778)) hundred_eighty_MHz (
													.clk_in	(CRCU_CLK),
													.clk_out (db_unit_clk)
												);	
		else if (db_unit_clock_ctl_reg[2:0] == 3'b011)		//300MHZ 
			clk_div_synth #(.N(4)) three_hundred_MHz (
													.clk_in	(CRCU_CLK),
													.clk_out (db_unit_clk)
												);	
		else if (db_unit_clock_ctl_reg[2:0] == 3'b100)		//600MHZ 
			clk_div_synth #(.N(2)) six_hundred_MHz (
													.clk_in	(CRCU_CLK),
													.clk_out (db_unit_clk)
												);												
	endgenerate
	
	assign db_unit_clk = (!db_unit_clock_ctl_reg[4] && db_unit_clock_ctl_reg[3]) ? db_unit_clk : 1'bz;	//only when clk gating is disabled and clk enable is high db_unit_clk is produced
								

endmodule