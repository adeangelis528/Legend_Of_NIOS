module Frame_Buffer( input [9:0] Addr_X, Addr_Y,
							input clk,
							input write_en, read_en,
							input [3:0] Color_in,
							output [3:0] Color_out);
							
	logic [9:0][9:0][4:0] Frame_Storage;
	
	always_ff@(posedge clk)
	begin
		if(write_en)
			Frame_Storage[Addr_X][Addr_Y] <= Color_in;
		else
			Frame_Storage <= Frame_Storage;
	end
	
	always_comb
	begin
		if(read_en)
			Color_out = Frame_Storage[Addr_X][Addr_Y];
		else
			Color_out = 4'bZZZZ;
	end
	
endmodule
							
