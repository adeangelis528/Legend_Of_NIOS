/*
Text engine displays health and score info along the top of the screen
@Input:  Coordinates on screen
@Output: is_drawn		announces that a character is drawn at this location
			addr 			row of sprite table that needs to be displayed
			offset		column of sprite table to be displayed

@TODO: This module will need to take input from the game state to dynamically
display health and score

Perhaps it would be more efficient to use a case statement or for loop
*/

module TextDisplay(input logic[9:0] DrawX, DrawY,
						 output logic is_drawn,
						 output logic[10:0] addr,
						 output logic[2:0] offset);

	always_comb begin
		//Only a single row is considered for now
		if(DrawY >= 8 && DrawY < 24)begin
			if(DrawX < 8) begin
				addr = DrawY - 8 + 16*'h03;
				offset = 7-DrawX%8;
				is_drawn = 1;
			end
			
			else if(DrawX < 16) begin
				addr = DrawY - 8 + 16*'h03;
				offset = 7-DrawX%8;
				is_drawn = 1;
			end
			
			else if(DrawX < 24) begin
				addr = DrawY - 8 + 16*'h03;
				offset = 7-DrawX%8;
				is_drawn = 1;
			end
			
			else if(DrawX < 32) begin
				addr = DrawY - 8 + 16*'h00;
				offset = 7-DrawX%8;
				is_drawn = 1;
			end
			
			else if(DrawX < 40) begin
				addr = DrawY - 8 + 16*'h04;
				offset = 7-DrawX%8;
				is_drawn = 1;
			end
			
			else if(DrawX < 48) begin
				addr = DrawY - 8 + 16*'h78;
				offset = 7-DrawX%8;
				is_drawn = 1;
			end
			
			else if(DrawX < 56) begin
				addr = DrawY - 8 + 16*'h30;
				offset = 7-DrawX%8;
				is_drawn = 1;
			end
			
			else if(DrawX < 64) begin
				addr = DrawY - 8 + 16*'h30;
				offset = 7-DrawX%8;
				is_drawn = 1;
			end
			
			//Draw no text
			else begin
				addr = 0;
				offset = 0;
				is_drawn = 0;
			end
		end
		//Draw no text
		else begin
				addr = 0;
				offset = 0;
				is_drawn = 0;
		end
		
	end

endmodule
