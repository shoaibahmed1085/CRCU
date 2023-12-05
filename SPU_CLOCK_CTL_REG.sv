/********************************************************
 Project name                  : CRCU(Clock & Reset Control Unit)   
 File Name                     : SPU_CLOCK_CTL_REG.sv
 Module/class Name             : SPU_CLOCK_CTL_REG
 Author                        : Shoaib Ahmed
 Description                   : Generation of spu_clk based on register values set by APB interface
 File version                  : 1.0 
 Copyright Smart Socs Technologies 
 THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION
 WHICH IS THE PROPERTY OF SMART SOCS TECHNOLOGIES OR ITS
 LICENSORS AND IS SUBJECT TO LICENSE TERMS. 
***************************************************************/

`timescale <DV team to add according to simulations>

`include "./clk_div_synth.sv"
`include "./clk_div_non_synth.sv"

module SPU_CLOCK_CTL_REG (
	input CRCU_CLK,
	input [31:0] spu_clock_ctl_reg,
	output spu_clk
);

//	method 1 ##################################################################
	//parameter N = 12;	//100MHz
	
/*	parameter N = (
					(spu_clock_ctl_reg[2:0] == 3'b000) ? 12 : 	//100MHz
					(spu_clock_ctl_reg[2:0] == 3'b001) ? 3	:	//400MHz
					(spu_clock_ctl_reg[2:0] == 3'b001) ? 2	:	//600MHz
					(spu_clock_ctl_reg[2:0] == 3'b001) ? 3	:	//800MHz
				  )
	// in this appraoch we cant generate 800Mhz as we cant pass parameter value to this, so best is to use generate statements
	
	*/
//	method 2	##################################################################
	// always @(posedge CRCU_CLK) begin
		// case(spu_clock_ctl_reg[2:0])
			// 3'b000  : 	;
			// 3'b000  :	;
			// 3'b000  :	;
			// 3'b000  :	;
			// default : ;
		// endcase
	// end
	
// method 3 ##################################################################	
	
	generate
		if(spu_clock_ctl_reg[2:0] == 3'b000)			//100MHz
			clk_div_synth #(.N(12)) one_hundred_MHz (
													.clk_in	(CRCU_CLK),
													.clk_out (spu_clk)
												);
		else if (spu_clock_ctl_reg[2:0] == 3'b001)		//400MHZ
			clk_div_synth #(.N(3)) four_hundred_MHz (
													.clk_in	(CRCU_CLK),
													.clk_out (spu_clk)
												);
		else if (spu_clock_ctl_reg[2:0] == 3'b010)		//600MHZ
			clk_div_synth #(.N(2)) six_hundred_MHz (
													.clk_in	(CRCU_CLK),
													.clk_out (spu_clk)
												);
		else if (spu_clock_ctl_reg[2:0] == 3'b011)		//800MHZ -> Non Synthesizable
			clk_div_non_synth #(.N(625)) eight_hundred_MHz (
													.clk_in	(CRCU_CLK),
													.clk_out (spu_clk)
												);	
	endgenerate
	
	assign spu_clk = (!spu_clock_ctl_reg[4] && spu_clock_ctl_reg[3]) ? spu_clk : 1'bz;	//only when clk gating is disabled and clk enable is high spu_clk is produced
								

endmodule