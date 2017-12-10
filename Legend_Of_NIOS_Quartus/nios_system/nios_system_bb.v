
module nios_system (
	clk_clk,
	keycode_export,
	otg_hpi_address_export,
	otg_hpi_cs_export,
	otg_hpi_data_in_port,
	otg_hpi_data_out_port,
	otg_hpi_r_export,
	otg_hpi_w_export,
	reset_reset_n,
	sdram_out_clk,
	sdram_wire_addr,
	sdram_wire_ba,
	sdram_wire_cas_n,
	sdram_wire_cke,
	sdram_wire_cs_n,
	sdram_wire_dq,
	sdram_wire_dqm,
	sdram_wire_ras_n,
	sdram_wire_we_n,
	entity_select_export,
	entity_read_export,
	entity_write_export,
	entity_dir_export,
	entity_x_export,
	entity_y_export,
	entity_active_export);	

	input		clk_clk;
	output	[15:0]	keycode_export;
	output	[1:0]	otg_hpi_address_export;
	output		otg_hpi_cs_export;
	input	[15:0]	otg_hpi_data_in_port;
	output	[15:0]	otg_hpi_data_out_port;
	output		otg_hpi_r_export;
	output		otg_hpi_w_export;
	input		reset_reset_n;
	output		sdram_out_clk;
	output	[12:0]	sdram_wire_addr;
	output	[1:0]	sdram_wire_ba;
	output		sdram_wire_cas_n;
	output		sdram_wire_cke;
	output		sdram_wire_cs_n;
	inout	[31:0]	sdram_wire_dq;
	output	[3:0]	sdram_wire_dqm;
	output		sdram_wire_ras_n;
	output		sdram_wire_we_n;
	output	[2:0]	entity_select_export;
	output		entity_read_export;
	output		entity_write_export;
	output	[1:0]	entity_dir_export;
	input	[9:0]	entity_x_export;
	input	[9:0]	entity_y_export;
	input		entity_active_export;
endmodule
