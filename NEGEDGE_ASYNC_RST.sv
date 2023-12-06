/********************************************************
 Project name                  : CRCU(Clock & Reset Control Unit)   
 File Name                     : NEGEDGE_ASYNC_RST.sv
 Module/class Name             : NEGEDGE_ASYNC_RST
 Author                        : Shoaib Ahmed
 Description                   : Generation of rst based on register values set by APB interface
 File version                  : 1.0 
 Copyright Smart Socs Technologies 
 THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION
 WHICH IS THE PROPERTY OF SMART SOCS TECHNOLOGIES OR ITS
 LICENSORS AND IS SUBJECT TO LICENSE TERMS. 
***************************************************************/

`timescale <DV team to add according to simulations>

module NEGEDGE_ASYNC_RST (
	input CRCU_CLK,
	input CRCU_RST,
	input [31:0] rst_ctl_reg,
	output reg rst
);

	parameter [15:0] reset_duration;
	
	reg [15:0] counter;
	
	always@(*) 
		reset_duration = rst_ctl_reg[18:3];		//extracting reset duration from a register and putting it in parameter	

	always @(negedge CRCU_CLK or negedge CRCU_RST) begin
		if(CRCU_RST)
			counter = 1'b0;
		else if(counter <= reset_duration-1)		//reset counter when count reaches reset_duration value (sync so reset_duration-1)
			counter = 1'b0;
		else 
			counter = counter + 1'b1;				//until counter reaches reset_duration keep incrementing
	end
	
	always@ (negedge CRCU_CLK or negedge CRCU_RST) begin
		if(CRCU_RST)
			rst = 1'b1;				// rst will be asserted when Master rst is asserted
		else if(counter)
			rst = 1'b1;				// rst will be asserted till the time counter reaches the reset_duration value
		else 
			rst = 1'b0;				// rst will be deasserted after reset_duration value
	end
	
endmodule