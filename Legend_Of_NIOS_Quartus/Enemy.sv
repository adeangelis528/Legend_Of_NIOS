module Enemy(input logic Reset, frame_clk, Clk, damage, initialize,
				  input logic [1:0] dir,
				  input logic [2:0] room,
				  output logic[9:0] Enemy_X, Enemy_Y,
				  output logic active);

	
    parameter [9:0] Enemy_X_Start=700;  // Start enemy offscreen
    parameter [9:0] Enemy_Y_Start=600;  
    parameter [9:0] Enemy_X_Step=2;      // Step size on the X axis
    parameter [9:0] Enemy_Y_Step=2;      // Step size on the Y axis
    
    logic [9:0] Enemy_X_Motion, Enemy_Y_Motion;
    logic [9:0] Enemy_X_Pos_in, Enemy_X_Motion_in, Enemy_Y_Pos_in, Enemy_Y_Motion_in;
    
	 //level data is used for collision detection.
	 logic [9:0] test_x, test_y;
	 logic is_wall, wall_flag;
	 level_rom leveldata(.DrawX(test_x), .DrawY(test_y), .room, .bg_type(is_wall));
	 
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
    
    // Detect rising edge of frame_clk
    logic frame_clk_delayed;
    logic frame_clk_rising_edge;
	 
	 initial
	 begin
		Enemy_X = Enemy_X_Start;
		Enemy_Y = Enemy_Y_Start;
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
            Enemy_X_Motion <= 10'd0;
            Enemy_Y_Motion <= 10'd0;
        end
		  
        else if (frame_clk_rising_edge)        // Update only at rising edge of frame clock
        begin
            Enemy_X <= Enemy_X_Pos_in;
            Enemy_Y <= Enemy_Y_Pos_in;
            Enemy_X_Motion <= Enemy_X_Motion_in;
            Enemy_Y_Motion <= Enemy_Y_Motion_in;
        end
        // By defualt, keep the register values.
    end
    
    // You need to modify always_comb block.
    always_comb
    begin
		  
        // Update the ball's position with its motion
        Enemy_X_Pos_in = Enemy_X + Enemy_X_Motion;
        Enemy_Y_Pos_in = Enemy_Y + Enemy_Y_Motion;
		  
		  //For collision detection
		  test_x = Enemy_X_Pos_in;
		  test_y = Enemy_Y_Pos_in;
		  wall_flag = 0;
		  
    
        // By default, keep motion unchanged
        Enemy_X_Motion_in = 0;
        Enemy_Y_Motion_in = 0;
		  
		  //Character controls
		  if(dir == 0)
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
		  else if(dir == 1)
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
		  else if(dir == 2)
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
		  else if(dir == 3)
		  begin
				//Test upper left corner
				if(!is_wall) begin
					//Test upper right corner
					test_x = test_x + 32;
					if(!is_wall) begin
						Enemy_Y_Motion_in = ~(Enemy_X_Step) + 1'b1;
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
	
	
endmodule
