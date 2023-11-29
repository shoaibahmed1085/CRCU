`include "./APB_CRCU.sv"

module CRCU_TOP (

//master inputs
	input master_clk,
	input master_rst,
	
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

/*###################################################################
		APB CODE
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

	//if i am writing first data at offset 0x0000 and it is 32 bit wide and 
	// if i am writing next data at offset 0x0004 then what is left in 0x0001-0x0003? is it blank?
	// this logic applies if it is a depth memory, but if it is contiguous then how to model it?
	
	// SPU CLK REGISTER
	always @(posedge PCLK) begin
		if(apb_mem[][])
			<do this>
	end



endmodule