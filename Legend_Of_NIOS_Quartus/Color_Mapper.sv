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
							  input			[9:0] Player_X, Player_Y, Enemy1_X, Enemy1_Y,
							  input logic	[7:0]	bg_r, bg_g, bg_b,
							  input logic	[10:0] font_addr,
							  input logic	[3:0] text_offset,
							  input logic 	draw_text,
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );
    
    logic [7:0] Red, Green, Blue;
    
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
	
	 
	 
	 //Player Character
	 logic pc_on;
	 logic enemy1_on;
	 
	 logic[10:0] pc_x;
	 logic[10:0] pc_y;
	 logic[10:0] pc_size_x = 32;
	 logic[10:0] pc_size_y = 32;
	 
	 assign pc_x = Player_X;
	 assign pc_y = Player_Y;
	 
	 //Sprite tables
	 logic[7:0] font_data;
	 font_rom font(.addr(font_addr), .data(font_data));
	 
	 logic[6:0] sprite_addr;
	 logic[31:0] sprite_data;
	 sprite_rom sprites(.addr(sprite_addr), .data(sprite_data));
	 
    always_comb
    begin:Ball_on_proc
			pc_on = 0;
			enemy1_on = 0;
			sprite_addr = 0;
			
			//Check for player
			if(DrawX >= pc_x && DrawY >= pc_y && DrawX < pc_x + 32 && DrawY < pc_y + 32) begin
				sprite_addr = (DrawY - pc_y + 64); //Player address in ROM
				pc_on = 1;
			end
			
			//Check for enemy1
			if(DrawX >= Enemy1_X && DrawY >= Enemy1_Y && DrawX < Enemy1_X + 32 && DrawY < Enemy1_X + 32) begin
				sprite_addr = (DrawY - Enemy1_Y + 64); //TODO change to enemy sprite
				enemy1_on = 1;
			end
    end
	 
	 always_comb
	 begin:RGB_Display
		//Draw Text
		if(draw_text && font_data[text_offset])begin
			Red = 8'hff;
			Green = 8'hff;
			Blue = 8'hff;
		end
		
		//Draw Player
		else if(pc_on && sprite_data[DrawX - pc_x]) begin
			Red = 8'hff;
			Green = 8'hff;
			Blue = 8'hff;
		end
		
		//Draw Enemy 1
		else if(enemy1_on && sprite_data[DrawX - Enemy1_X]) begin
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
