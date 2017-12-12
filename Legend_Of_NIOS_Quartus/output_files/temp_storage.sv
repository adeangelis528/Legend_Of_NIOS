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
module  temp_mapper ( //input              is_ball,            // Whether current pixel belongs to ball 
                                                              //   or background (computed in ball.sv)
                       input        [9:0] DrawX, DrawY,       // Current pixel coordinates
							  input			[9:0] Player_X, Player_Y, Enemy1_X, Enemy1_Y, Enemy2_X, Enemy2_Y,
														Enemy3_X, Enemy3_Y, Enemy4_X, Enemy4_Y, Enemy5_X, Enemy5_Y,
							  input logic  [1:0] E1_Type, E2_Type, E3_Type, E4_Type, E5_Type,
							  input logic	[7:0]	bg_r, bg_g, bg_b,
							  input logic	[10:0] font_addr,
							  input logic	[3:0] text_offset,
							  input logic 	draw_text, frame_clk, player_attack,
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );
    
    logic [7:0] Red, Green, Blue;
    
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
	
	 
	 
	 //Player Character
	 logic pc_on;
	 logic enemy1_on, enemy2_on, enemy3_on, enemy4_on, enemy5_on;
	 logic animation;
	 logic [5:0] anim_counter;
	 
	 logic[10:0] pc_x;
	 logic[10:0] pc_y;
	 logic[10:0] pc_size_x = 32;
	 logic[10:0] pc_size_y = 32;
	 
	 assign pc_x = Player_X;
	 assign pc_y = Player_Y;
	 
	 //Sprite tables
	 logic[7:0] font_data;
	 font_rom font(.addr(font_addr), .data(font_data));
	 
	 logic[9:0] sprite_addr;
	 logic[31:0] sprite_data;
	 sprite_rom sprites(.addr(sprite_addr), .data(sprite_data));
	 
	 //Animation logic
	 always_ff @ (posedge frame_clk) begin
			anim_counter <= anim_counter + 1;
			if(anim_counter == 0)
				animation <= ~animation;
			else
				animation <= animation;
	 end
	 
	 //Render sprites on screen
    always_comb
    begin:Ball_on_proc
			pc_on = 0;
			enemy1_on = 0;
			enemy2_on = 0;
			enemy3_on = 0;
			enemy4_on = 0;
			enemy5_on = 0;
			sprite_addr = 0;
			
			//Check for player
			if(DrawX >= pc_x && DrawY >= pc_y && DrawX < pc_x + 32 && DrawY < pc_y + 32) begin
				if(player_attack)
					sprite_addr = (DrawY - pc_y + 32*6); //Player attack outline in ROM
				else
					sprite_addr = (DrawY - pc_y + 32*2 + 64*animation); //Player outline in ROM
				pc_on = 1;
			end
			
			//Check for enemy1
			if(DrawX >= Enemy1_X && DrawY >= Enemy1_Y && DrawX < Enemy1_X + 32 && DrawY < Enemy1_Y + 32) begin
				enemy1_on = 1;
				case (E1_Type)
					1: sprite_addr = (DrawY - Enemy1_Y + 32*8 + 64*animation); //Bat
					2: sprite_addr = (DrawY - Enemy1_Y + 32*12 + 64*animation); //Zombie
					3: sprite_addr = (DrawY - Enemy1_Y + 32*16 + 64*animation); //Slider
				endcase
			end
			
			//Check for enemy2
			if(DrawX >= Enemy2_X && DrawY >= Enemy2_Y && DrawX < Enemy2_X + 32 && DrawY < Enemy2_Y + 32) begin
				sprite_addr = (DrawY - Enemy2_Y + 64); //TODO change to enemy sprite
				enemy2_on = 1;
			end
			
			//Check for enemy3
			if(DrawX >= Enemy3_X && DrawY >= Enemy3_Y && DrawX < Enemy3_X + 32 && DrawY < Enemy3_Y + 32) begin
				sprite_addr = (DrawY - Enemy3_Y + 64); //TODO change to enemy sprite
				enemy3_on = 1;
			end
			
			//Check for enemy4
			if(DrawX >= Enemy4_X && DrawY >= Enemy4_Y && DrawX < Enemy4_X + 32 && DrawY < Enemy4_Y + 32) begin
				sprite_addr = (DrawY - Enemy4_Y + 64); //TODO change to enemy sprite
				enemy4_on = 1;
			end
			
			//Check for enemy5
			if(DrawX >= Enemy5_X && DrawY >= Enemy5_Y && DrawX < Enemy5_X + 32 && DrawY < Enemy5_Y + 32) begin
				sprite_addr = (DrawY - Enemy5_Y + 64); //TODO change to enemy sprite
				enemy5_on = 1;
			end
   // end
	 
	// always_comb
	// begin:RGB_Display
		//Draw Text
		if(draw_text && font_data[text_offset])begin
			Red = 8'hff;
			Green = 8'hff;
			Blue = 8'hff;
		end
		
		//Draw Player
		else if(pc_on && sprite_data[DrawX - pc_x]) begin
			if(player_attack)
				sprite_addr = (DrawY - pc_y + 32*6 + 32); //Player attack color in ROM
			else
				sprite_addr = (DrawY - pc_y + 32*2 + 64*animation + 32); //Player color in ROM
			if(sprite_data[DrawX-pc_x]) begin
				Red = 8'h00;
				Green = 8'h00;
				Blue = 8'hff;
			end
			else begin
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'h00;
			end
		end
		
		//Draw Enemy 1
		else if(enemy1_on && sprite_data[DrawX - Enemy1_X]) begin
			case (E1_Type)
					1: sprite_addr = (DrawY - Enemy1_Y + 32*8 + 64*animation + 32); //Bat
					2: sprite_addr = (DrawY - Enemy1_Y + 32*12 + 64*animation + 32); //Zombie
					3: sprite_addr = (DrawY - Enemy1_Y + 32*16 + 64*animation + 32); //Slider
				endcase
			if(sprite_data[DrawX-Enemy1_X]) begin
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'hff;
			end
			else begin
				Red = 8'h00;
				Green = 8'h00;
				Blue = 8'h00;
			end
		end
		
		//Draw Enemy 2
		else if(enemy2_on && sprite_data[DrawX - Enemy2_X]) begin
			Red = 8'hff;
			Green = 8'hff;
			Blue = 8'hff;
		end
		
		//Draw Enemy 3
		else if(enemy3_on && sprite_data[DrawX - Enemy3_X]) begin
			Red = 8'hff;
			Green = 8'hff;
			Blue = 8'hff;
		end
		
		//Draw Enemy 4
		else if(enemy4_on && sprite_data[DrawX - Enemy4_X]) begin
			Red = 8'hff;
			Green = 8'hff;
			Blue = 8'hff;
		end
		
		//Draw Enemy 5
		else if(enemy5_on && sprite_data[DrawX - Enemy5_X]) begin
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
