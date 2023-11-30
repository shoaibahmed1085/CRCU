/********************************************************
 Project name                  : CRCU(Clock & Reset Control Unit)   
 File Name                     : CRCU_TOP.sv
 Module/class Name             : CRCU_TOP
 Author                        : Shoaib Ahmed
 Description                   : Top module for CRCU which contains signals seen in block diagram
 File version                  : 1.0 
 Copyright Smart Socs Technologies 
 THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION
 WHICH IS THE PROPERTY OF SMART SOCS TECHNOLOGIES OR ITS
 LICENSORS AND IS SUBJECT TO LICENSE TERMS. 
***************************************************************/

`include "./APB_CRCU.sv"

module CRCU_TOP (

//master inputs
	input CRCU_CLK,
	input CRCU_RST,
	
//apb inputs
	input PRESETN,
	input PCLK,
	input PSEL,
	input PENABLE,
	input [31:0] PWDATA,
	input [31:0] PADDR,
	input PWRITE,
	output PREADY,
	output PSLVERR,
	output [31:0] PRDATA,
	
//dut outputs	
	output spu_clk,
	output spu_rst,
	output vpu_clk,
	output vpu_rst,
	output cpm_clk,
	output cpm_rst,
	output ld_clk,
	output ld_rst,
	output wider_iol_clk,
	output wider_iol_rst,
	output tap_clk,
	output tap_rst,
	output debug_clk,
	output debug_rst,
	output vp_debug_clk,
	output vp_debug_rst
);


	//wire [2:0] spu_clock_freq;
	
/*###################################################################
		APB ADDRESS DECODER
###################################################################*/

	APB_CRCU apb_inst (
						.PRESETN(PRESETN),
                        .PCLK(PCLK),
                        .PSEL(PSEL),
                        .PENABLE(PENABLE),
                        .PWDATA(PWDATA),
                        .PADDR(PADDR),
                        .PWRITE(PWRITE),
                        .PREADY(PREADY),
                        .PSLVERR(PSLVERR),
                        .PRDATA(PRDATA)
					 );

/*###################################################################
		REGISTER MAPPING
###################################################################*/

	clock_management dut (
		.spu_clk_freq(spu_clk_freq) //input from APB for freq manipulation
		.
		.
		.spu_clk_o(spu_clk)//ouptut of top module connected to output of clock_management, LEGAL?
	);


endmodule
