	nios_system u0 (
		.clk_clk                (<connected-to-clk_clk>),                //             clk.clk
		.keycode_export         (<connected-to-keycode_export>),         //         keycode.export
		.otg_hpi_address_export (<connected-to-otg_hpi_address_export>), // otg_hpi_address.export
		.otg_hpi_cs_export      (<connected-to-otg_hpi_cs_export>),      //      otg_hpi_cs.export
		.otg_hpi_data_in_port   (<connected-to-otg_hpi_data_in_port>),   //    otg_hpi_data.in_port
		.otg_hpi_data_out_port  (<connected-to-otg_hpi_data_out_port>),  //                .out_port
		.otg_hpi_r_export       (<connected-to-otg_hpi_r_export>),       //       otg_hpi_r.export
		.otg_hpi_w_export       (<connected-to-otg_hpi_w_export>),       //       otg_hpi_w.export
		.reset_reset_n          (<connected-to-reset_reset_n>),          //           reset.reset_n
		.sdram_out_clk          (<connected-to-sdram_out_clk>),          //       sdram_out.clk
		.sdram_wire_addr        (<connected-to-sdram_wire_addr>),        //      sdram_wire.addr
		.sdram_wire_ba          (<connected-to-sdram_wire_ba>),          //                .ba
		.sdram_wire_cas_n       (<connected-to-sdram_wire_cas_n>),       //                .cas_n
		.sdram_wire_cke         (<connected-to-sdram_wire_cke>),         //                .cke
		.sdram_wire_cs_n        (<connected-to-sdram_wire_cs_n>),        //                .cs_n
		.sdram_wire_dq          (<connected-to-sdram_wire_dq>),          //                .dq
		.sdram_wire_dqm         (<connected-to-sdram_wire_dqm>),         //                .dqm
		.sdram_wire_ras_n       (<connected-to-sdram_wire_ras_n>),       //                .ras_n
		.sdram_wire_we_n        (<connected-to-sdram_wire_we_n>),        //                .we_n
		.entity_select_export   (<connected-to-entity_select_export>),   //   entity_select.export
		.entity_read_export     (<connected-to-entity_read_export>),     //     entity_read.export
		.entity_write_export    (<connected-to-entity_write_export>),    //    entity_write.export
		.entity_dir_export      (<connected-to-entity_dir_export>),      //      entity_dir.export
		.entity_x_export        (<connected-to-entity_x_export>),        //        entity_x.export
		.entity_y_export        (<connected-to-entity_y_export>),        //        entity_y.export
		.entity_active_export   (<connected-to-entity_active_export>)    //   entity_active.export
	);

