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
	 
	 logic[7:0] bg_r, bg_g, bg_b;
	 logic[10:0] font_addr;
	 logic[7:0] font_data;
	 logic[3:0] text_offset;
	 logic draw_text;
	 
	 logic shape_on;
	 logic[10:0] shape_x = 300;
	 logic[10:0] shape_y = 300;
	 logic[10:0] shape_size_x = 32;
	 logic[10:0] shape_size_y = 32;
	 
	 logic shape2_on;
	 logic[10:0] shape2_x = 100;
	 logic[10:0] shape2_y = 300;
	 logic[10:0] shape2_size_x = 8;
	 logic[10:0] shape2_size_y = 100;
	 
	 //Display modules
	 font_rom font(.addr(font_addr), .data(font_data));
	 
	 Background bg(.Red(bg_r), .Green(bg_g), .Blue(bg_b), .DrawX, .DrawY);
	 TextDisplay text(.DrawX, .DrawY, .is_drawn(draw_text), .addr(font_addr), .offset(text_offset));
	 
    always_comb
    begin:Ball_on_proc
			//@TODO logic for sprites
    end
	 
	 always_comb
	 begin:RGB_Display
		if(draw_text && font_data[text_offset])begin
			Red = 8'hff;
			Green = 8'hff;
			Blue = 8'hff;
		end
		
		else begin
			Red = bg_r;
			Green = bg_g;
			Blue = bg_b;
		end
	 end
    
endmodule
