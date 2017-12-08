module GameState (input logic Clk, Frame_clk, Reset,
						input logic [9:0] Player_X, Player_Y,
						output logic [3:0] score1, score2,
						output logic [1:0] health);
	

logic[5:0] counter;
logic[3:0] curr_score1, curr_score2, next_score1, next_score2;
logic[1:0] next_health;

always_ff @ (posedge Frame_clk) begin

	if(counter == 60) begin
		counter <=0;
		health <= next_health;
		score1 <= next_score1;
		score2 <= next_score2;
	end
	else
		counter <= counter + 1;
end

always_comb begin
	next_score1 = score1;
	next_score2 = score2;
	next_health = health;
	
	next_score1 = score1 + 1;
	if(score1 == 9) begin
		next_score1 = 0;
		next_score2 = score2 + 1;
		if(score2 == 9) begin
			next_score2 = 0;
		end
	end
	
	next_health = health + 1;
	if(health == 3)
		next_health = 0;

end

endmodule
