/********************************************************
 Project name                  : CRCU(Clock & Reset Control Unit)   
 File Name                     : clk_div_non_synth.sv
 Module/class Name             : clk_div_non_synth
 Author                        : Shoaib Ahmed
 Description                   : Non-Synthesizable clock generation module
 File version                  : 1.0 
 Copyright Smart Socs Technologies 
 THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION
 WHICH IS THE PROPERTY OF SMART SOCS TECHNOLOGIES OR ITS
 LICENSORS AND IS SUBJECT TO LICENSE TERMS. 
***************************************************************/

`timescale <DV team to add according to simulations>

module clk_div_non_synth #(
	parameter N = 4				// N value passed should be half the time period of the required Clock, Ex: for 800MHz, in ps scale we pass N=625
) (
	input clk_in,
  	output reg clk_out
);

	initial clk_out = 1'b0;		// initializing clk_out to view output, else it remains at high impedance.
	
	always #N clk_out = ~clk_out;
	
endmodule