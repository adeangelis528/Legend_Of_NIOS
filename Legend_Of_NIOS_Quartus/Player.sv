module Player(input logic Reset, frame_clk, Clk,
				  input logic [7:0] keycode,
				  output logic[9:0] Player_X, Player_Y);

	
    parameter [9:0] Player_X_Center=320;  // Center position on the X axis
    parameter [9:0] Player_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] Player_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Player_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Player_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Player_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Player_X_Step=1;      // Step size on the X axis
    parameter [9:0] Player_Y_Step=1;      // Step size on the Y axis
    parameter [9:0] Ball_Size=4;        // Ball size
    
    logic [9:0] Player_X_Motion, Player_Y_Motion;
    logic [9:0] Player_X_Pos_in, Player_X_Motion_in, Player_Y_Pos_in, Player_Y_Motion_in;
    
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
    
    //////// Do not modify the always_ff blocks. ////////
    // Detect rising edge of frame_clk
    logic frame_clk_delayed;
    logic frame_clk_rising_edge;
	 
	 initial
	 begin
		Player_X = 320;
		Player_Y = 240;
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
            Player_X <= Player_X_Center;
            Player_Y <= Player_Y_Center;
            Player_X_Motion <= 10'd0;
            Player_Y_Motion <= 10'd0;
        end
		  
        else if (frame_clk_rising_edge)        // Update only at rising edge of frame clock
        begin
            Player_X <= Player_X_Pos_in;
            Player_Y <= Player_Y_Pos_in;
            Player_X_Motion <= Player_X_Motion_in;
            Player_Y_Motion <= Player_Y_Motion_in;
        end
        // By defualt, keep the register values.
    end
    
    // You need to modify always_comb block.
    always_comb
    begin
        // Update the ball's position with its motion
        Player_X_Pos_in = Player_X + Player_X_Motion;
        Player_Y_Pos_in = Player_Y + Player_Y_Motion;
    
        // By default, keep motion unchanged
        Player_X_Motion_in = 0;
        Player_Y_Motion_in = 0;
		  
		  if(keycode == 4)
		  begin
				Player_X_Motion_in = ~(Player_X_Step) + 1'b1;
				Player_Y_Motion_in = 0;
		  end
		  else if(keycode == 7)
		  begin
				Player_X_Motion_in = Player_X_Step;
				Player_Y_Motion_in = 0;
		  end
		  else if(keycode == 22)
		  begin
				Player_X_Motion_in = 0;
				Player_Y_Motion_in = Player_Y_Step;
		  end
		  else if(keycode == 26)
		  begin
				Player_X_Motion_in = 0;
				Player_Y_Motion_in = ~(Player_Y_Step) + 1'b1;
		  end
        
    end	
	
	
endmodule
