module GameState (input logic Clk, Frame_clk, Reset, Player_Attack,
						input logic [9:0] Player_X, Player_Y, Enemy1_X, Enemy1_Y, Enemy2_X, Enemy2_Y,
												Enemy3_X, Enemy3_Y, Enemy4_X, Enemy4_Y, Enemy5_X, Enemy5_Y,
						output logic Damage_E1, Damage_E2, Damage_E3, Damage_E4, Damage_E5,
						output logic [3:0] score1, score2,
						output logic [1:0] health,
						output logic game_over);
	

logic[6:0] counter;
logic[3:0] curr_score1, curr_score2, next_score1, next_score2;
logic[1:0] next_health;
logic next_damage;
logic damage;

initial begin
	health = 3;
	score1 = 0;
	score2 = 0;
	game_over = 0;
	damage = 0;
end

always_ff @ (posedge Frame_clk) begin
	
	Damage_E1 <= 0;
	Damage_E2 <= 0;
	Damage_E3 <= 0;
	Damage_E4 <= 0;
	Damage_E5 <= 0;
	health <= health;
	score1 <= next_score1;
	score2 <= next_score2;
	damage <= damage;
	game_over <= 0;
	if(counter < 125)
		counter <= counter + 1;
	else
		counter <= counter;
	
	
	if(Reset || health == 0) begin
		score1 <= 0;
		score2 <= 0;
		health <= 3;
		game_over <= 1;
	end
	
	//Player attack detection===================
	else if(Player_Attack && ((Player_X - Enemy1_X < 64 || Player_X - Enemy1_X > -64) 
				&& (Player_Y - Enemy1_Y < 64 || Player_Y - Enemy1_Y > -64))) begin
		Damage_E1 <= 1;
	end
	
	else if(Player_Attack && ((Player_X - Enemy2_X < 64 || Player_X - Enemy2_X > -64) 
				&& (Player_Y - Enemy2_Y < 64 || Player_Y - Enemy2_Y > -64))) begin
		Damage_E2 <= 1;
	end
	
	else if(Player_Attack && ((Player_X - Enemy3_X < 64 || Player_X - Enemy3_X > -64) 
				&& (Player_Y - Enemy3_Y < 64 || Player_Y - Enemy3_Y > -64))) begin
		Damage_E3 <= 1;
	end
	
	else if(Player_Attack && ((Player_X - Enemy4_X < 64 || Player_X - Enemy4_X > -64) 
				&& (Player_Y - Enemy4_Y < 64 || Player_Y - Enemy4_Y > -64))) begin
		Damage_E4 <= 1;
	end
	
	else if(Player_Attack && ((Player_X - Enemy5_X < 64 || Player_X - Enemy5_X > -64) 
				&& (Player_Y - Enemy5_Y < 64 || Player_Y - Enemy5_Y > -64))) begin
		Damage_E5 <= 1;
	end
	//End of Player Attack detection ===============================================
	
	//Enemy 1 damage
	else if((Player_X - Enemy1_X < 32 || Player_X - Enemy1_X > -32) && (Player_Y - Enemy1_Y < 32 || Player_Y - Enemy1_Y > -32)) begin
		if(counter >= 90) begin
			health <= health - 1;
			counter <= 0;
		end
	end
	
	//Enemy 2 damage
	else if((Player_X - Enemy2_X < 32 || Player_X - Enemy2_X > -32) && (Player_Y - Enemy2_Y < 32 || Player_Y - Enemy2_Y > -32)) begin
		if(counter >= 90) begin
			health <= health - 1;
			counter <= 0;
		end
	end
	
	//Enemy 3 damage
	else if((Player_X - Enemy3_X < 32 || Player_X - Enemy3_X > -32) && (Player_Y - Enemy3_Y < 32 || Player_Y - Enemy3_Y > -32)) begin
		if(counter >= 90) begin
			health <= health - 1;
			counter <= 0;
		end
	end
	
	//Enemy 4 damage
	else if((Player_X - Enemy4_X < 32 || Player_X - Enemy4_X > -32) && (Player_Y - Enemy4_Y < 32 || Player_Y - Enemy4_Y > -32)) begin
		if(counter >= 90) begin
			health <= health - 1;
			counter <= 0;
		end
	end
	
	//Enemy 5 damage
	else if((Player_X - Enemy5_X < 32 || Player_X - Enemy5_X > -32) && (Player_Y - Enemy5_Y < 32 || Player_Y - Enemy5_Y > -32)) begin
		if(counter >= 90) begin
			health <= health - 1;
			counter <= 0;
		end
	end
	
	else begin
	   
	end
end

always_comb begin
	next_score1 = score1;
	next_score2 = score2;
	next_health = health;
	
	if(Damage_E1 || Damage_E2 || Damage_E3 || Damage_E4 || Damage_E5) begin
		next_score1 = score1 + 1;
		if(score1 == 9) begin
			next_score2 = score2 + 1;
			next_score1 = 0;
			if(score2 == 9) begin
				next_score2 = 0;
			end
		end
	end

end

endmodule
