/********************************************************
 Project name                  : CRCU(Clock & Reset Control Unit)   
 File Name                     : CLOCK_MANAGEMENT.sv
 Module/class Name             : CLOCK_MANAGEMENT
 Author                        : Shoaib Ahmed
 Description                   : Clock Management configurations through register values updated by APB Interface 
 File version                  : 1.0 
 Copyright Smart Socs Technologies 
 THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION
 WHICH IS THE PROPERTY OF SMART SOCS TECHNOLOGIES OR ITS
 LICENSORS AND IS SUBJECT TO LICENSE TERMS. 
***************************************************************/

`timescale <DV team to add according to simulations>

`include "./SPU_CLOCK_CTL_REG.sv"
`include "./VPU_CLOCK_CTL_REG.sv"
`include "./CPM_CLOCK_CTL_REG.sv"
`include "./LD_CLOCK_CTL_REG.sv"
`include "./WI_IOL_CLOCK_CTL_REG.sv"
`include "./TAP_CLK_CTL_REG.sv"
`include "./DB_UNIT_CLOCK_CTL_REG.sv"
`include "./VP_DEBUG_CLOCK_CTL_REG.sv"

// need to add more files (reset files)

module CLOCK_AND_RESET_MANAGEMENT (
	input CRCU_CLK						,
	input CRCU_RST						,
	input [31:0] spu_clock_ctl_reg  	,
	input [31:0] vpu_clock_ctl_reg      ,
	input [31:0] cpm_clock_ctl_reg      ,
	input [31:0] ld_clock_ctl_reg       ,
	input [31:0] wi_iol_clock_ctl_reg   ,
	input [31:0] tap_clk_ctl_reg	    ,
	input [31:0] db_unit_clock_ctl_reg  ,
	input [31:0] vp_debug_clock_ctl_reg ,
	
	/*input [31:0] spu_clock_sts_reg      ,
	input [31:0] vpu_clock_sts_reg      ,
	input [31:0] cpm_clock_sts_reg      ,
	input [31:0] ld_clock_sts_reg       ,
	input [31:0] wi_iol_clock_sts_reg   ,
	input [31:0] tap_clk_sts_reg        ,
	input [31:0] db_unit_clock_sts_reg  ,
	input [31:0] vp_unit_clock_sts_reg  ,*/
										
	input [31:0] spu_rst_ctl_reg        ,
	input [31:0] vpu_rst_ctl_reg        ,
	input [31:0] cpm_rst_ctl_reg        ,
	input [31:0] ld_rst_ctl_reg         ,
	input [31:0] wd_iol_rst_ctl_reg     ,
	input [31:0] tap_unit_rst_ctl_reg   ,
	input [31:0] db_unit_rst_ctl_reg    ,
	input [31:0] vp_unit_rst_ctl_reg    ,
	
	/*input [31:0] spu_rst_sts_reg        ,
	input [31:0] vpu_rst_sts_reg        ,
	input [31:0] cpm_rst_sts_reg        ,
	input [31:0] ld_rst_sts_reg         ,
	input [31:0] wd_iol_rst_sts_reg     ,
	input [31:0] tap_unit_rst_sts_reg   ,
	input [31:0] db_rst_sts_reg         ,
	input [31:0] vp_unit_sts_reg        ,*/
	
	output spu_clk,
	output vpu_clk,
	output cpm_clk,
	output ld_clk,
	output wi_iol_clk,
	output tap_clk,
	output db_unit_clk,
	output vp_debug_clk,
	
	output spu_rst,
	output vpu_rst,
	output cpm_rst,
	output ld_rst,
	output wi_iol_rst,
	output tap_rst,
	output db_unit_rst,
	output vp_debug_rst

//	spu_clk_ctrl_inst and spu_clk_sts_inst output Clock are same or different? -> sts registers do not produce an output

);

/*############################################################
		CLOCKING MODULES INSTANTIATION
############################################################*/

	SPU_CLOCK_CTL_REG spu_clk_ctrl_inst (
								.CRCU_CLK				(CRCU_CLK),				// Master clk
								.spu_clock_ctl_reg		(spu_clock_ctl_reg),    // Reading register configurations
							    .spu_clk				(spu_clk)               // Generated output clock
							   );
//###### TO BE CODED
/*	VPU_CLOCK_CTL_REG vpu_clk_ctrl_inst (
								.CRCU_CLK				(CRCU_CLK),
								.vpu_clock_ctl_reg		(vpu_clock_ctl_reg),
							    .vpu_clk				(vpu_clk)
							   );
							   
	CPM_CLOCK_CTL_REG cpm_clk_ctrl_inst (
								.CRCU_CLK				(CRCU_CLK),
								.cpm_clock_ctl_reg		(cpm_clock_ctl_reg),
							    .cpm_clk				(cpm_clk)
							   );

	LD_CLOCK_CTL_REG ld_clk_ctrl_inst (
								.CRCU_CLK				(CRCU_CLK),
								.ld_clock_ctl_reg		(ld_clock_ctl_reg),
							    .ld_clk					(ld_clk)
							   );

	WI_IOL_CLOCK_CTL_REG wi_iol_clk_ctrl_inst (
								.CRCU_CLK				(CRCU_CLK),
								.wi_iol_clock_ctl_reg	(wi_iol_clock_ctl_reg),
							    .wi_iol_clk				(wi_iol_clk)
							   );

	TAP_CLOCK_CTL_REG tap_clk_ctrl_inst (
								.CRCU_CLK				(CRCU_CLK),
								.tap_clock_ctl_reg		(tap_clock_ctl_reg),
							    .tap_clk				(tap_clk)
							   );

	DB_UNIT_CLOCK_CTL_REG db_unit_clk_ctrl_inst (
								.CRCU_CLK					(CRCU_CLK),
								.db_unit_clock_ctl_reg		(db_unit_clock_ctl_reg),
							    .db_unit_clk				(db_unit_clk)
							   );

	VP_DEBUG_CLOCK_CTL_REG vp_debug_clk_ctrl_inst (
								.CRCU_CLK					(CRCU_CLK),
								.vp_debug_clock_ctl_reg		(vp_debug_clock_ctl_reg),
							    .vp_debug_clk				(vp_debug_clk)
							   );							   

	//########################################################################################
			NOT REQUIRED
	SPU_CLOCK_STS_REG spu_clk_sts_inst (
								.CRCU_CLK				(CRCU_CLK),
								.spu_clock_sts_reg		(spu_clock_sts_reg),
							    .spu_clk				(spu_clk)
							   );

	VPU_CLOCK_STS_REG vpu_clk_sts_inst (
								.CRCU_CLK				(CRCU_CLK),
								.vpu_clock_sts_reg		(vpu_clock_sts_reg),
							    .vpu_clk				(vpu_clk)
							   );
							   
	CPM_CLOCK_STS_REG cpm_clk_sts_inst (
								.CRCU_CLK				(CRCU_CLK),
								.cpm_clock_sts_reg		(cpm_clock_sts_reg),
							    .cpm_clk				(cpm_clk)
							   );

	LD_CLOCK_STS_REG ld_clk_sts_inst (
								.CRCU_CLK				(CRCU_CLK),
								.ld_clock_sts_reg		(ld_clock_sts_reg),
							    .ld_clk					(ld_clk)
							   );

	WI_IOL_CLOCK_STS_REG wi_iol_clk_sts_inst (
								.CRCU_CLK				(CRCU_CLK),
								.wi_iol_clock_sts_reg	(wi_iol_clock_sts_reg),
							    .wi_iol_clk				(wi_iol_clk)
							   );

	TAP_CLOCK_STS_REG tap_clk_sts_inst (
								.CRCU_CLK				(CRCU_CLK),
								.tap_clock_sts_reg		(tap_clock_sts_reg),
							    .tap_clk				(tap_clk)
							   );

	DB_UNIT_CLOCK_STS_REG db_unit_clk_sts_inst (
								.CRCU_CLK					(CRCU_CLK),
								.db_unit_clock_sts_reg		(db_unit_clock_sts_reg),
							    .db_unit_clk				(db_unit_clk)
							   );

	VP_DEBUG_CLOCK_STS_REG vp_debug_clk_sts_inst (
								.CRCU_CLK					(CRCU_CLK),
								.vp_debug_clock_sts_reg		(vp_debug_clock_sts_reg),
							    .vp_debug_clk				(vp_debug_clk)
							   );
	//###################################################################################
*/

/*############################################################
	RESET MODULES INSTANTIATION
############################################################*/


endmodule