module Enemy(input logic Reset, frame_clk, Clk, damage, initialize,
				  input logic [2:0] dir, 
				  input logic [2:0] room, number,
				  output logic[9:0] Enemy_X, Enemy_Y,
				  output logic active,
				  output logic [1:0] Enemy_Type);

	
    parameter [9:0] Enemy_X_Start=700;  // Start enemy offscreen
    parameter [9:0] Enemy_Y_Start=700;  
    parameter [9:0] Enemy_X_Step=2;      // Step size on the X axis
    logic [9:0] Enemy_Y_Step=2;      // Step size on the Y axis
    
    logic [9:0] Enemy_X_Motion, Enemy_Y_Motion;
    logic [9:0] Enemy_X_Pos_in, Enemy_X_Motion_in, Enemy_Y_Pos_in, Enemy_Y_Motion_in;
    
	 //level data is used for collision detection.
	 logic [9:0] test_x, test_y;
	 logic is_wall, wall_flag;
	 level_rom leveldata(.DrawX(test_x), .DrawY(test_y), .room, .bg_type(is_wall));
	 logic active_next;
	 logic [1:0] Type_next;
	 
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
    
    // Detect rising edge of frame_clk
    logic frame_clk_delayed;
    logic frame_clk_rising_edge;
	 
	 initial
	 begin
		Enemy_X = 700;
		Enemy_Y = 700;
		active_next = 0;
	 end
	 
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
    end
	 
    assign frame_clk_rising_edge = (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    // Update ball position and motion
    always_ff @ (posedge Clk)
    begin
	 
        if (Reset)
        begin
            Enemy_X <= Enemy_X_Start;
            Enemy_Y <= Enemy_Y_Start;
				active <= 0;
            Enemy_X_Motion <= 10'd0;
            Enemy_Y_Motion <= 10'd0;
        end
		  
        else if (frame_clk_rising_edge)        // Update only at rising edge of frame clock
        begin
            Enemy_X <= Enemy_X_Pos_in;
            Enemy_Y <= Enemy_Y_Pos_in;
				active <= active_next;
				Enemy_Type <= Type_next;
            Enemy_X_Motion <= Enemy_X_Motion_in;
            Enemy_Y_Motion <= Enemy_Y_Motion_in;
        end
        // By defualt, keep the register values.
    end
    
    // You need to modify always_comb block.
    always_comb
    begin
	 
		  if(Enemy_Type == 3)
		  begin
				Enemy_Y_Step = 4;
		  end
		  else
		  begin
				Enemy_Y_Step = 2;
		  end
		  
        active_next = active;
		  Type_next = Enemy_Type;
		  
		  if(damage)
				active_next = 0;
		  
		  //For collision detection
		  test_x = Enemy_X_Pos_in;
		  test_y = Enemy_Y_Pos_in;
		  wall_flag = 0;
		  
    
        // By default, keep motion unchanged
        Enemy_X_Motion_in = 0;
        Enemy_Y_Motion_in = 0;
		  
		  if(active) begin
			  //Character controls
			  if(dir == 1)
			  begin
					/*//Test upper left corner
					if(!is_wall) begin
						//Test lower left corner
						test_y = test_y + 32;
						if(!is_wall) begin
							Enemy_X_Motion_in = ~(Enemy_X_Step) + 1'b1;
							Enemy_Y_Motion_in = 0;
						end
						else begin
							Enemy_X_Motion_in = 1'b1;
							Enemy_Y_Motion_in = 0;
						end
					end
					else begin
						Enemy_X_Motion_in = 1'b1;
						Enemy_Y_Motion_in = 0;
					end*/
					Enemy_X_Motion_in = ~(Enemy_X_Step) + 1'b1;
					Enemy_Y_Motion_in = 0;
					
					if(is_wall)
						wall_flag = 1;
					test_y = test_y + 32;
					if(is_wall)
						wall_flag = 1;
					if(wall_flag)
						Enemy_X_Motion_in = 1'b1;
					
			  end
			  else if(dir == 2)
			  begin
					//Test upper right corner
					test_x = test_x + 32;
					if(!is_wall) begin
						//Test lower right corner
						test_y = test_y + 32;
						if(!is_wall) begin
							Enemy_X_Motion_in = Enemy_X_Step;
							Enemy_Y_Motion_in = 0;
						end
						else begin
							Enemy_X_Motion_in = ~(10'b1) + 1'b1;
							Enemy_Y_Motion_in = 0;
						end
					end
					else begin
						Enemy_X_Motion_in = ~(10'b1) + 1'b1;
						Enemy_Y_Motion_in = 0;
					end
			  end
			  else if(dir == 3)
			  begin
					//Test bottom left corner
					test_y = test_y + 32;
					if(!is_wall) begin
						//Test lower right corner
						test_x = test_x + 32;
						if(!is_wall) begin
							Enemy_Y_Motion_in = Enemy_Y_Step;
							Enemy_X_Motion_in = 0;
						end
						else begin
							Enemy_Y_Motion_in = ~(10'b1) + 1'b1;
							Enemy_X_Motion_in = 0;
						end
					end
					else begin
						Enemy_Y_Motion_in = ~(10'b1) + 1'b1;
						Enemy_X_Motion_in = 0;
					end
			  end
			  else if(dir == 4)
			  begin
					//Test upper left corner
					if(!is_wall) begin
						//Test upper right corner
						test_x = test_x + 32;
						if(!is_wall) begin
							Enemy_Y_Motion_in = ~(Enemy_Y_Step) + 1'b1;
							Enemy_X_Motion_in = 0;
						end
						else begin
							Enemy_Y_Motion_in = 1'b1;
							Enemy_X_Motion_in = 0;
						end
					end
					else begin
						Enemy_Y_Motion_in = 1'b1;
						Enemy_X_Motion_in = 0;
					end
			  end
		  
		  end
		  
		  
		  Enemy_X_Pos_in = Enemy_X + Enemy_X_Motion;
		  Enemy_Y_Pos_in = Enemy_Y + Enemy_Y_Motion;
		  
		  if(!active)
			begin
					Enemy_X_Pos_in = 700;
					Enemy_Y_Pos_in = 700;
			end
		  
/*Enemy Types:
1 = Keese (Bat)
2 = ReDead (Zombie)
3 = Slider
*/		  
		  
		  if(initialize) begin
			  if(room == 0) begin
					if(number == 1) begin
						active_next = 1;
						Type_next = 3;
						Enemy_X_Pos_in = 64;
						Enemy_Y_Pos_in = 64;
					
					end
					else begin
						active_next = 0;
						Enemy_X_Pos_in = 700;
						Enemy_Y_Pos_in = 700;
						Type_next = 0;
					end
				end
				
				//Room 1 Enemy locations and types
				else if(room == 1) begin
					if(number == 1) begin
						active_next = 1;
						Enemy_X_Pos_in = 300;
						Enemy_Y_Pos_in = 200;
						Type_next = 1;
					end
					
					else if(number == 2) begin
						active_next = 1;
						Enemy_X_Pos_in = 70;
						Enemy_Y_Pos_in = 330;
						Type_next = 1;
					end
					
					else if(number == 3) begin
						active_next = 1;
						Enemy_X_Pos_in = 100;
						Enemy_Y_Pos_in = 330;
						Type_next = 1;
					end
					
					else if(number == 4) begin
						active_next = 1;
						Enemy_X_Pos_in = 150;
						Enemy_Y_Pos_in = 330;
						Type_next = 1;
					end
					
					else if(number == 5) begin
						active_next = 1;
						Enemy_X_Pos_in = 200;
						Enemy_Y_Pos_in = 330;
						Type_next = 1;
					end
					else begin
						active_next = 0;
						Enemy_X_Pos_in = 0;
						Enemy_Y_Pos_in = 0;
						Type_next = 0;
					end
				end
					
				else if(room == 2) begin
					if(number == 1) begin
						active_next = 1;
						Enemy_X_Pos_in = 448;
						Enemy_Y_Pos_in = 160;
						Type_next = 1;
					end
					
					else if(number == 2) begin
						active_next = 1;
						Enemy_X_Pos_in = 128;
						Enemy_Y_Pos_in = 160;
						Type_next = 1;
					end
					
					else if(number == 3) begin
						active_next = 1;
						Enemy_X_Pos_in = 288;
						Enemy_Y_Pos_in = 224;
						Type_next = 1;
					end
					
					else if(number == 4) begin
						active_next = 1;
						Enemy_X_Pos_in = 384;
						Enemy_Y_Pos_in = 352;
						Type_next = 2;
					end
					
					else if(number == 5) begin
						active_next = 1;
						Enemy_X_Pos_in = 192;
						Enemy_Y_Pos_in = 352;
						Type_next = 2;
					end
					else begin
						active_next = 0;
						Enemy_X_Pos_in = 700;
						Enemy_Y_Pos_in = 700;
						Type_next = 0;
					end
				end
					
				else if(room == 3) begin
					if(number == 1) begin
						active_next = 1;
						Enemy_X_Pos_in = 480;
						Enemy_Y_Pos_in = 96;
						Type_next = 1;
					end
					
					else if(number == 2) begin
						active_next = 1;
						Enemy_X_Pos_in = 64;
						Enemy_Y_Pos_in = 64;
						Type_next = 1;
					end
					
					else if(number == 3) begin
						active_next = 1;
						Enemy_X_Pos_in = 448;
						Enemy_Y_Pos_in = 256;
						Type_next = 1;
					end
					
					else if(number == 4) begin
						active_next = 1;
						Enemy_X_Pos_in = 64;
						Enemy_Y_Pos_in = 288;
						Type_next = 1;
					end
					
					else if(number == 5) begin
						active_next = 1;
						Enemy_X_Pos_in = 512;
						Enemy_Y_Pos_in = 416;
						Type_next = 1;
					end
					else begin
						active_next = 0;
						Enemy_X_Pos_in = 700;
						Enemy_Y_Pos_in = 700;
						Type_next = 0;
					end
				end
					
				else if(room == 4) begin
					if(number == 1) begin
						active_next = 1;
						Enemy_X_Pos_in = 384;
						Enemy_Y_Pos_in = 160;
						Type_next = 1;
					end
					
					else if(number == 2) begin
						active_next = 1;
						Enemy_X_Pos_in = 448;
						Enemy_Y_Pos_in = 352;
						Type_next = 2;
					end
					
					else if(number == 3) begin
						active_next = 1;
						Enemy_X_Pos_in = 576;
						Enemy_Y_Pos_in = 416;
						Type_next = 3;
					end
					
					else if(number == 4) begin
						active_next = 1;
						Enemy_X_Pos_in = 128;
						Enemy_Y_Pos_in = 128;
						Type_next = 2;
					end
					
					else if(number == 5) begin
						active_next = 1;
						Enemy_X_Pos_in = 32;
						Enemy_Y_Pos_in = 416;
						Type_next = 1;
					end
					
					else begin
						active_next = 0;
						Enemy_X_Pos_in = 700;
						Enemy_Y_Pos_in = 700;
						Type_next = 0;
					end
				end
				
				else if(room == 5) begin
					if(number == 1) begin
						active_next = 1;
						Enemy_X_Pos_in = 416;
						Enemy_Y_Pos_in = 192;
						Type_next = 3;
					end
					
					else if(number == 2) begin
						active_next = 1;
						Enemy_X_Pos_in = 192;
						Enemy_Y_Pos_in = 192;
						Type_next = 3;
					end
					
					else if(number == 3) begin
						active_next = 1;
						Enemy_X_Pos_in = 64;
						Enemy_Y_Pos_in = 224;
						Type_next = 2;
					end
					
					else if(number == 4) begin
						active_next = 1;
						Enemy_X_Pos_in = 416;
						Enemy_Y_Pos_in = 288;
						Type_next = 3;
					end
					
					else if(number == 5) begin
						active_next = 1;
						Enemy_X_Pos_in = 192;
						Enemy_Y_Pos_in = 288;
						Type_next = 3;
					end
					
					else begin
						active_next = 0;
						Enemy_X_Pos_in = 700;
						Enemy_Y_Pos_in = 700;
						Type_next = 0;
					end
				end
				
				else if(room == 6) begin
					if(number == 1) begin
						active_next = 1;
						Enemy_X_Pos_in = 416;
						Enemy_Y_Pos_in = 128;
						Type_next = 2;
					end
					
					else if(number == 2) begin
						active_next = 1;
						Enemy_X_Pos_in = 192;
						Enemy_Y_Pos_in = 128;
						Type_next = 2;
					end
					
					else if(number == 3) begin
						active_next = 1;
						Enemy_X_Pos_in = 320;
						Enemy_Y_Pos_in = 256;
						Type_next = 1;
					end
					
					else if(number == 4) begin
						active_next = 1;
						Enemy_X_Pos_in = 544;
						Enemy_Y_Pos_in = 288;
						Type_next = 2;
					end
					
					else if(number == 5) begin
						active_next = 1;
						Enemy_X_Pos_in = 64;
						Enemy_Y_Pos_in = 288;
						Type_next = 2;
					end
					
					else begin
						active_next = 0;
						Enemy_X_Pos_in = 700;
						Enemy_Y_Pos_in = 700;
						Type_next = 0;
					end
				end
				
				else begin
					active_next = 0;
					Enemy_X_Pos_in = 700;
					Enemy_Y_Pos_in = 700;
					Type_next = 0;
				end
			end
			
			
    end	
	
	
endmodule
