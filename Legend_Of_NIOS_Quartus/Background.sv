module Background (input logic[9:0] DrawX, DrawY,
						 input logic bg_type,
						 output logic[7:0] Red, Green, Blue);

	logic wall_on;
	logic floor_on;
	logic [6:0] sprite_addr;
	logic [32:0] sprite_data;
	sprite_rom myROM(.addr(sprite_addr), .data(sprite_data));
	
	always_comb
    begin:Bg_on_proc
			//Status bar
			//if(DrawY < 32) begin
			
			//end
			if(DrawY < 32)
			begin
				wall_on = 1'b0;
				floor_on = 1'b0;
				sprite_addr = 0;
			end
			else
			begin
				wall_on = bg_type;
				floor_on = ~bg_type;
				sprite_addr = (DrawY%32);
				if(!bg_type)
					sprite_addr = (DrawY%32 + 32);
			end
    end
	 
	 always_comb
	 begin:RGB_Display
	   //Wall tile
		if (wall_on && sprite_data[DrawX%32] == 1'b1)
		begin
			Red = 8'h6f;
			Green = 8'h39;
			Blue = 8'h9d;
		end
		else if (wall_on && sprite_data[DrawX%32] == 1'b0)
		begin
			Red = 8'h3f;
			Green = 8'h2f;
			Blue = 8'h4d;
		end
		
		//Floor tile
		else if (floor_on && sprite_data[DrawX%32] == 1'b1)
		begin
			Red = 8'h6f;
			Green = 8'h39;
			Blue = 8'h9d;
		end
		else if (floor_on && sprite_data[DrawX%32] == 1'b0)
		begin
			Red = 8'h3f;
			Green = 8'h2f;
			Blue = 8'h4d;
		end
		
		//Background color
		else
		begin
			Red = 8'h00;
			Green = 8'h00;
			Blue = 8'h00;
		end
	 end
endmodule
