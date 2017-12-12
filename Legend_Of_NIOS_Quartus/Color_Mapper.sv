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
	 logic [3:0] anim_counter;
	 
	 logic[10:0] pc_x;
	 logic[10:0] pc_y;
	 logic[10:0] pc_size_x = 32;
	 logic[10:0] pc_size_y = 32;
	 
	 assign pc_x = Player_X;
	 assign pc_y = Player_Y;
	 
	 //Sprite tables
	 logic[7:0] font_data;
	 font_rom font(.addr(font_addr), .data(font_data));
	 
	 logic[9:0] outline_addr, color_addr;
	 logic[31:0] outline_data, color_data;
	 sprite_rom outlines(.addr(outline_addr), .data(outline_data));
	 sprite_rom colors(.addr(color_addr), .data(color_data));
	 
	 logic[7:0] color1_r, color1_g, color1_b, color2_r, color2_g, color2_b;
	 
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
			
			color1_r = 8'h00;
			color1_g = 8'hff;
			color1_b = 8'hff;
			color2_r = 8'hff;
			color2_g = 8'h00;
			color2_b = 8'h00;
			
			Red = bg_r;
			Blue = bg_b;
			Green = bg_g;
			
			outline_addr = 0;
			color_addr = 0;
			
			if(draw_text && font_data[text_offset])begin
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'hff;
			end
			
			if((DrawX > Enemy1_X)&&(DrawX < (Enemy1_X + 32))&& (DrawY>Enemy1_Y) && (DrawY < (Enemy1_Y + 32)))
			begin
				case(E1_Type)
					1: begin
							outline_addr = 8*32 + 64*animation + DrawY - Enemy1_Y;
							color1_r = 8'h00;
							color1_g = 8'h00;
							color1_b = 8'h00;
							color2_r = 8'h3f;
							color2_g = 8'h3f;
							color2_b = 8'h3f;
						end
					2: begin
							outline_addr = 12*32 + 64*animation + DrawY - Enemy1_Y;
							color1_r = 8'h00;
							color1_g = 8'h6f;
							color1_b = 8'h00;
							color2_r = 8'h00;
							color2_g = 8'hbf;
							color2_b = 8'h00;
						end
					3: begin
							outline_addr = 16*32 + DrawY - Enemy1_Y;
							color1_r = 8'h6f;
							color1_g = 8'h39;
							color1_b = 8'h9d;
							color2_r = 8'h3f;
							color2_g = 8'h2f;
							color2_b = 8'h4d;
						end
				endcase	
				
				color_addr = outline_addr + 32;
				if(outline_data[DrawX-Enemy1_X]) begin
					if(color_data[DrawX-Enemy1_X]) begin
						Red = color1_r;
						Green = color1_g;
						Blue = color1_b;
					end
					else begin
						Red = color2_r;
						Green = color2_g;
						Blue = color2_b;
					end
				end
			end
			
			if((DrawX > Enemy2_X)&&(DrawX < (Enemy2_X + 32))&& (DrawY>Enemy2_Y) && (DrawY < (Enemy2_Y + 32)))
			begin
				case(E2_Type)
					1: begin
							outline_addr = 8*32 + 64*animation + DrawY - Enemy2_Y;
							color1_r = 8'h00;
							color1_g = 8'h00;
							color1_b = 8'h00;
							color2_r = 8'h3f;
							color2_g = 8'h3f;
							color2_b = 8'h3f;
						end
					2: begin
							outline_addr = 12*32 + 64*animation + DrawY - Enemy2_Y;
							color1_r = 8'h00;
							color1_g = 8'h6f;
							color1_b = 8'h00;
							color2_r = 8'h00;
							color2_g = 8'hbf;
							color2_b = 8'h00;
						end
					3: begin
							outline_addr = 16*32 + DrawY - Enemy2_Y;
							color1_r = 8'h6f;
							color1_g = 8'h39;
							color1_b = 8'h9d;
							color2_r = 8'h3f;
							color2_g = 8'h2f;
							color2_b = 8'h4d;
						end
				endcase	
				
				color_addr = outline_addr + 32;
				if(outline_data[DrawX-Enemy2_X]) begin
					if(color_data[DrawX-Enemy2_X]) begin
						Red = color1_r;
						Green = color1_g;
						Blue = color1_b;
					end
					else begin
						Red = color2_r;
						Green = color2_g;
						Blue = color2_b;
					end
				end
			end
			
			if((DrawX > Enemy3_X)&&(DrawX < (Enemy3_X + 32))&& (DrawY>Enemy3_Y) && (DrawY < (Enemy3_Y + 32)))
			begin
				case(E3_Type)
					1: begin
							outline_addr = 8*32 + 64*animation + DrawY - Enemy3_Y;
							color1_r = 8'h00;
							color1_g = 8'h00;
							color1_b = 8'h00;
							color2_r = 8'h3f;
							color2_g = 8'h3f;
							color2_b = 8'h3f;
						end
					2: begin
							outline_addr = 12*32 + 64*animation + DrawY - Enemy3_Y;
							color1_r = 8'h00;
							color1_g = 8'h6f;
							color1_b = 8'h00;
							color2_r = 8'h00;
							color2_g = 8'hbf;
							color2_b = 8'h00;
						end
					3: begin
							outline_addr = 16*32 + DrawY - Enemy3_Y;
							color1_r = 8'h6f;
							color1_g = 8'h39;
							color1_b = 8'h9d;
							color2_r = 8'h3f;
							color2_g = 8'h2f;
							color2_b = 8'h4d;
						end
				endcase	
				
				color_addr = outline_addr + 32;
				if(outline_data[DrawX-Enemy3_X]) begin
					if(color_data[DrawX-Enemy3_X]) begin
						Red = color1_r;
						Green = color1_g;
						Blue = color1_b;
					end
					else begin
						Red = color2_r;
						Green = color2_g;
						Blue = color2_b;
					end
				end
			end
			
			if((DrawX > Enemy4_X)&&(DrawX < (Enemy4_X + 32))&& (DrawY>Enemy4_Y) && (DrawY < (Enemy4_Y + 32)))
			begin
				case(E4_Type)
					1: begin
							outline_addr = 8*32 + 64*animation + DrawY - Enemy4_Y;
							color1_r = 8'h00;
							color1_g = 8'h00;
							color1_b = 8'h00;
							color2_r = 8'h3f;
							color2_g = 8'h3f;
							color2_b = 8'h3f;
						end
					2: begin
							outline_addr = 12*32 + 64*animation + DrawY - Enemy4_Y;
							color1_r = 8'h00;
							color1_g = 8'h6f;
							color1_b = 8'h00;
							color2_r = 8'h00;
							color2_g = 8'hbf;
							color2_b = 8'h00;
						end
					3: begin
							outline_addr = 16*32 + DrawY - Enemy4_Y;
							color1_r = 8'h6f;
							color1_g = 8'h39;
							color1_b = 8'h9d;
							color2_r = 8'h3f;
							color2_g = 8'h2f;
							color2_b = 8'h4d;
						end
				endcase	
				
				color_addr = outline_addr + 32;
				if(outline_data[DrawX-Enemy4_X]) begin
					if(color_data[DrawX-Enemy4_X]) begin
						Red = color1_r;
						Green = color1_g;
						Blue = color1_b;
					end
					else begin
						Red = color2_r;
						Green = color2_g;
						Blue = color2_b;
					end
				end
			end
				
			if((DrawX > Enemy5_X)&&(DrawX < (Enemy5_X + 32))&& (DrawY>Enemy5_Y) && (DrawY < (Enemy5_Y + 32)))
			begin
				case(E5_Type)
					1: begin
							outline_addr = 8*32 + 64*animation + DrawY - Enemy5_Y;
							color1_r = 8'h00;
							color1_g = 8'h00;
							color1_b = 8'h00;
							color2_r = 8'h3f;
							color2_g = 8'h3f;
							color2_b = 8'h3f;
						end
					2: begin
							outline_addr = 12*32 + 64*animation + DrawY - Enemy5_Y;
							color1_r = 8'h00;
							color1_g = 8'h6f;
							color1_b = 8'h00;
							color2_r = 8'h00;
							color2_g = 8'hbf;
							color2_b = 8'h00;
						end
					3: begin
							outline_addr = 16*32 + DrawY - Enemy5_Y;
							color1_r = 8'h6f;
							color1_g = 8'h39;
							color1_b = 8'h9d;
							color2_r = 8'h3f;
							color2_g = 8'h2f;
							color2_b = 8'h4d;
						end
				endcase	
				
				color_addr = outline_addr + 32;
				if(outline_data[DrawX-Enemy5_X]) begin
					if(color_data[DrawX-Enemy5_X]) begin
						Red = color1_r;
						Green = color1_g;
						Blue = color1_b;
					end
					else begin
						Red = color2_r;
						Green = color2_g;
						Blue = color2_b;
					end
				end
			end
			
			if((DrawX > pc_x)&&(DrawX < (pc_x + 32))&& (DrawY>pc_y) && (DrawY < (pc_y + 32)))
			begin
				if(player_attack)begin
					outline_addr = 6*32 + DrawY - pc_y;
				end
				else begin
					outline_addr = 2*32 + 64*animation + DrawY - pc_y;
				end
				color_addr = outline_addr + 32;
				if(outline_data[DrawX-pc_x]) begin
					if(color_data[DrawX-pc_x]) begin
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
			end
			
			
		
	 end
    
endmodule
