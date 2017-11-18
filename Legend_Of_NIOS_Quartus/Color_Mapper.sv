//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper ( //input              is_ball,            // Whether current pixel belongs to ball 
                                                              //   or background (computed in ball.sv)
                       input        [9:0] DrawX, DrawY,       // Current pixel coordinates
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );
    
    logic [7:0] Red, Green, Blue;
    
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
	 
	 logic shape_on;
	 logic shape2_on;
	 
	 logic[10:0] shape_x = 300;
	 logic[10:0] shape_y = 300;
	 logic[10:0] shape_size_x = 8;
	 logic[10:0] shape_size_y = 16;
	 
	 logic[10:0] shape2_x = 100;
	 logic[10:0] shape2_y = 300;
	 logic[10:0] shape2_size_x = 8;
	 logic[10:0] shape2_size_y = 100;
	 
	 logic [10:0] sprite_addr;
	 logic [7:0] sprite_data;
	 font_rom myROM(.addr(sprite_addr), .data(sprite_data));
    
    // Assign color to sprites
    always_comb
    begin:Ball_on_proc
			//Status bar
			//if(DrawY < 32) begin
					
			//end
			
			if(DrawX >= shape_x && DrawX < shape_x + shape_size_x &&
				DrawY >= shape_y && DrawY < shape_y + shape_size_y)
			begin
				shape_on = 1'b1;
				shape2_on = 1'b0;
				sprite_addr = (DrawY-shape_y + 16*'h48);
			end
			
			
			if(DrawX >= shape2_x && DrawX < shape2_x + shape2_size_x &&
				DrawY >= shape2_y && DrawY < shape2_y + shape2_size_y)
			begin
				shape_on = 1'b0;
				shape2_on = 1'b1;
				sprite_addr = (DrawY-shape2_y + 16*'h01);
			end
			
			else
			begin
				shape_on = 1'b0;
				shape2_on = 1'b0;
				sprite_addr = 10'b0;
			end
    end
	 
	 always_comb
	 begin:RGB_Display
		if ((shape_on == 1'b1) && sprite_data[DrawX-shape_x] == 1'b1)
		begin
			Red = 8'h00;
			Green = 8'hff;
			Blue = 8'hff;
		end
		else if ((shape2_on == 1'b1) && sprite_data[DrawX-shape2_x] == 1'b1)
		begin
			Red = 8'hff;
			Green = 8'hff;
			Blue = 8'h00;
		end
		
		//Background color
		else
		begin
			Red = 8'h00;
			Green = 8'h00;
			Blue = 8'h44;
		end
	 end
    
endmodule
