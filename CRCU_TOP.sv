/********************************************************
 Project name                  : CRCU(Clock & Reset Control Unit)   
 File Name                     : CRCU_TOP.sv
 Module/class Name             : CRCU_TOP
 Author                        : Shoaib Ahmed
 Description                   : Top module for CRCU which contains ports seen in block diagram and instantiates address decoder, clock & reset management block
 File version                  : 1.0 
 Copyright Smart Socs Technologies 
 THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION
 WHICH IS THE PROPERTY OF SMART SOCS TECHNOLOGIES OR ITS
 LICENSORS AND IS SUBJECT TO LICENSE TERMS. 
***************************************************************/

`timescale <DV team to add according to simulations>

`include "./APB_CRCU.sv"
`include "./CLOCK_AND_RESET_MANAGEMENT.sv"

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
	output SPU_CLK,
	output VPU_CLK,
	output CPM_CLK,
	output LD_CLK,
	output WIDER_IOL_CLK,
	output TAP_CLK,
	output DEBUG_CLK,
	output VP_DEBUG_CLK,
	
	output SPU_RST,	
	output VPU_RST,	
	output CPM_RST,	
	output LD_RST,
	output WIDER_IOL_RST,
	output TAP_RST,
	output DEBUG_RST,
	output VP_DEBUG_RST
);


	//wire [2:0] spu_clock_freq;
	
/*###################################################################
	WIRE DECLARATION FOR CONNECTING APB OUTPUT TO CLK_MGMT INPUT
###################################################################*/	
	
	wire [31:0] spu_clock_ctl_wire;		
	wire [31:0] vpu_clock_ctl_wire;     
	wire [31:0] cpm_clock_ctl_wire;     
	wire [31:0] ld_clock_ctl_wire;      
	wire [31:0] wi_iol_clock_ctl_wire;  
	wire [31:0] tap_clk_ctl_wire;  	    
	wire [31:0] db_unit_clock_ctl_wire; 
	wire [31:0] vp_debug_clock_ctl_wire;
	
	/*wire [31:0] spu_clock_sts_wire;     
	wire [31:0] vpu_clock_sts_wire;     
	wire [31:0] cpm_clock_sts_wire;     
	wire [31:0] ld_clock_sts_wire;      
	wire [31:0] wi_iol_clock_sts_wire;  
	wire [31:0] tap_clk_sts_wire;       
	wire [31:0] db_unit_clock_sts_wire; 
	wire [31:0] vp_unit_clock_sts_wire;*/
	
	wire [31:0] spu_rst_ctl_wire;       
	wire [31:0] vpu_rst_ctl_wire;       
	wire [31:0] cpm_rst_ctl_wire;       
	wire [31:0] ld_rst_ctl_wire;        
	wire [31:0] wd_iol_rst_ctl_wire;    
	wire [31:0] tap_unit_rst_ctl_wire;  
	wire [31:0] db_unit_rst_ctl_wire;   
	wire [31:0] vp_unit_rst_ctl_wire;
	
	/*wire [31:0] spu_rst_sts_wire;       
	wire [31:0] vpu_rst_sts_wire;       
	wire [31:0] cpm_rst_sts_wire;       
	wire [31:0] ld_rst_sts_wire;        
	wire [31:0] wd_iol_rst_sts_wire;    
	wire [31:0] tap_unit_rst_sts_wire;  
	wire [31:0] db_rst_sts_wire;        
	wire [31:0] vp_unit_sts_wire;  */     
		
	
/*###################################################################
		APB ADDRESS DECODER
###################################################################*/

	APB_CRCU apb_inst (
						.PRESETN					(PRESETN),
                        .PCLK						(PCLK),
                        .PSEL						(PSEL),
                        .PENABLE					(PENABLE),
                        .PWDATA						(PWDATA),
                        .PADDR						(PADDR),
                        .PWRITE						(PWRITE),
                        .PREADY						(PREADY),
                        .PSLVERR					(PSLVERR),
                        .PRDATA						(PRDATA),
						.spu_clock_ctl_reg			(spu_clock_ctl_wire),				// what will these ports be connected to? declare wires and connect?
						.vpu_clock_ctl_reg     		(vpu_clock_ctl_wire    ), 
						.cpm_clock_ctl_reg     		(cpm_clock_ctl_wire    ), 
						.ld_clock_ctl_reg      		(ld_clock_ctl_wire     ), 
						.wi_iol_clock_ctl_reg  		(wi_iol_clock_ctl_wire ), 
						.tap_clk_ctl_reg  	    	(tap_clk_ctl_wire  	   ),
						.db_unit_clock_ctl_reg 		(db_unit_clock_ctl_wire), 
						.vp_debug_clock_ctl_reg		(vp_debug_clock_ctl_wire), 
						
						/*.spu_clock_sts_reg     		(spu_clock_sts_wire    ), 
						.vpu_clock_sts_reg     		(vpu_clock_sts_wire    ), 
						.cpm_clock_sts_reg     		(cpm_clock_sts_wire    ), 
						.ld_clock_sts_reg      		(ld_clock_sts_wire     ), 
						.wi_iol_clock_sts_reg  		(wi_iol_clock_sts_wire ), 
						.tap_clk_sts_reg       		(tap_clk_sts_wire      ), 
						.db_unit_clock_sts_reg 		(db_unit_clock_sts_wire), 
						.vp_unit_clock_sts_reg 		(vp_unit_clock_sts_wire), */
						
						.spu_rst_ctl_reg       		(spu_rst_ctl_wire      ), 
						.vpu_rst_ctl_reg       		(vpu_rst_ctl_wire      ), 
						.cpm_rst_ctl_reg       		(cpm_rst_ctl_wire      ), 
						.ld_rst_ctl_reg        		(ld_rst_ctl_wire       ), 
						.wd_iol_rst_ctl_reg    		(wd_iol_rst_ctl_wire   ), 
						.tap_unit_rst_ctl_reg  		(tap_unit_rst_ctl_wire ), 
						.db_unit_rst_ctl_reg   		(db_unit_rst_ctl_wire  ), 
						.vp_unit_rst_ctl_reg   		(vp_unit_rst_ctl_wire  )
						
						/*.spu_rst_sts_reg       		(spu_rst_sts_wire      ), 
						.vpu_rst_sts_reg       		(vpu_rst_sts_wire      ), 
						.cpm_rst_sts_reg       		(cpm_rst_sts_wire      ), 
						.ld_rst_sts_reg        		(ld_rst_sts_wire       ), 
						.wd_iol_rst_sts_reg    		(wd_iol_rst_sts_wire   ), 
						.tap_unit_rst_sts_reg  		(tap_unit_rst_sts_wire ), 
						.db_rst_sts_reg        		(db_rst_sts_wire       ), 
						.vp_unit_sts_reg       		(vp_unit_sts_wire      ) */
					 );

/*###################################################################
		CLOCK & RESET MANAGEMENT BLOCK
###################################################################*/

	/*
	clock_management dut (
		.spu_clk_freq(spu_clk_freq) //input from APB for freq manipulation
		.
		.
		.spu_clk_o(spu_clk)//ouptut of top module connected to output of clock_management, LEGAL?
	);
	*/
	
	
	CLOCK_AND_RESET_MANAGEMENT clk_rst_mgmt_inst (
									.CRCU_CLK                       (CRCU_CLK),
									.CRCU_RST                       (CRCU_RST),
									.spu_clock_ctl_reg  			(spu_clock_ctl_wire),	//wire connected
									.vpu_clock_ctl_reg              (vpu_clock_ctl_wire    ),
									.cpm_clock_ctl_reg              (cpm_clock_ctl_wire    ),
									.ld_clock_ctl_reg               (ld_clock_ctl_wire     ),
									.wi_iol_clock_ctl_reg           (wi_iol_clock_ctl_wire ),
									.tap_clk_ctl_reg	            (tap_clk_ctl_wire  	   ),
									.db_unit_clock_ctl_reg          (db_unit_clock_ctl_wire),
									.vp_debug_clock_ctl_reg         (vp_debug_clock_ctl_wire),
									
									/*.spu_clock_sts_reg              (spu_clock_sts_wire    ),
									.vpu_clock_sts_reg              (vpu_clock_sts_wire    ),
									.cpm_clock_sts_reg              (cpm_clock_sts_wire    ),
									.ld_clock_sts_reg               (ld_clock_sts_wire     ),
									.wi_iol_clock_sts_reg           (wi_iol_clock_sts_wire ),
									.tap_clk_sts_reg                (tap_clk_sts_wire      ),
									.db_unit_clock_sts_reg          (db_unit_clock_sts_wire),
									.vp_unit_clock_sts_reg          (vp_unit_clock_sts_wire),*/
									
									.spu_rst_ctl_reg                (spu_rst_ctl_wire      ),
									.vpu_rst_ctl_reg                (vpu_rst_ctl_wire      ),
									.cpm_rst_ctl_reg                (cpm_rst_ctl_wire      ),
									.ld_rst_ctl_reg                 (ld_rst_ctl_wire       ),
									.wd_iol_rst_ctl_reg             (wd_iol_rst_ctl_wire   ),
									.tap_unit_rst_ctl_reg           (tap_unit_rst_ctl_wire ),
									.db_unit_rst_ctl_reg            (db_unit_rst_ctl_wire  ),
									.vp_unit_rst_ctl_reg            (vp_unit_rst_ctl_wire  ),
									
									/*.spu_rst_sts_reg                (spu_rst_sts_wire      ),
									.vpu_rst_sts_reg                (vpu_rst_sts_wire      ),
									.cpm_rst_sts_reg                (cpm_rst_sts_wire      ),
									.ld_rst_sts_reg                 (ld_rst_sts_wire       ),
									.wd_iol_rst_sts_reg             (wd_iol_rst_sts_wire   ),
									.tap_unit_rst_sts_reg           (tap_unit_rst_sts_wire ),
									.db_rst_sts_reg                 (db_rst_sts_wire       ),
									.vp_unit_sts_reg                (vp_unit_sts_wire      ),*/
									
								// outputs
									.spu_clk                        (SPU_CLK),
                                    .vpu_clk                        (VPU_CLK),
                                    .cpm_clk                        (CPM_CLK),
                                    .ld_clk                         (LD_CLK),
                                    .wi_iol_clk                     (WIDER_IOL_CLK),
                                    .tap_clk                        (TAP_CLK),
                                    .db_unit_clk                    (DEBUG_CLK),
                                    .vp_debug_clk                   (VP_DEBUG_CLK),
									
									.spu_rst			            (SPU_RST),
									.vpu_rst                        (VPU_RST),
									.cpm_rst                        (CPM_RST),
									.ld_rst                         (LD_RST),
									.wi_iol_rst                     (WIDER_IOL_RST),
									.tap_rst                        (TAP_RST),
									.db_unit_rst                    (DEBUG_RST),
									.vp_debug_rst                   (VP_DEBUG_RST),
									
									);


endmodule
