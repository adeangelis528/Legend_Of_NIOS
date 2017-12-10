module EntityInterface(input logic[2:0] select,
							  input logic clk,
							  input logic read, write,
							  input logic[1:0] sel_dir,
							  input logic[9:0] Enemy1_X, Enemy2_X, Enemy3_X, Enemy4_X, Enemy5_X, Player_X,
							  input logic[9:0] Enemy1_Y, Enemy2_Y, Enemy3_Y, Enemy4_Y, Enemy5_Y, Player_Y,
							  input logic Enemy1_Active, Enemy2_Active, Enemy3_Active, Enemy4_Active, Enemy5_Active,
							  output logic[9:0] toNIOS_X, toNIOS_Y,
							  output logic[1:0] toEnemy1_dir, toEnemy2_dir, toEnemy3_dir, toEnemy4_dir, toEnemy5_dir,
							  output logic toNIOS_Active);
			

				logic[9:0] X_Out, Y_Out;
				
				logic[1:0] Enemy1_dir_in, Enemy2_dir_in, Enemy3_dir_in, Enemy4_dir_in, Enemy5_dir_in;
	always_ff @ (posedge clk)
	begin
		toEnemy1_dir<=Enemy1_dir_in;
		toEnemy2_dir<=Enemy2_dir_in;
		toEnemy3_dir<=Enemy3_dir_in;
		toEnemy4_dir<=Enemy4_dir_in;
		toEnemy5_dir<=Enemy5_dir_in;
	
		toNIOS_X <= X_Out;
		toNIOS_Y <= Y_Out;
	
	end
	
	always_comb begin
		toNIOS_Active = 0;
		X_Out = 0;
		Y_Out = 0;
	
		Enemy1_dir_in = toEnemy1_dir;
		Enemy2_dir_in = toEnemy2_dir;
		Enemy3_dir_in = toEnemy3_dir;
		Enemy4_dir_in = toEnemy4_dir;
		Enemy5_dir_in = toEnemy5_dir;
		
		if(write) begin
			case (select)
				1 : Enemy1_dir_in = sel_dir;
				2 : Enemy2_dir_in = sel_dir;
				3 : Enemy3_dir_in = sel_dir;
				4 : Enemy4_dir_in = sel_dir;
				5 : Enemy5_dir_in = sel_dir;
			endcase
		end
		
		if(read) begin
			case (select)
				0 : begin
					 X_Out = Player_X;
					 Y_Out = Player_Y;
					 end
				1 : begin
					 X_Out = Enemy1_X;
					 Y_Out = Enemy1_Y;
					 toNIOS_Active = Enemy1_Active;
					 end
				2 : begin
					 X_Out = Enemy2_X;
					 Y_Out = Enemy2_Y;
					 toNIOS_Active = Enemy2_Active;
					 end
				3 : begin
					 X_Out = Enemy3_X;
					 Y_Out = Enemy3_Y;
					 toNIOS_Active = Enemy3_Active;
					 end
				4 : begin
					 X_Out = Enemy4_X;
					 Y_Out = Enemy4_Y;
					 toNIOS_Active = Enemy4_Active;
					 end
				5 : begin
					 X_Out = Enemy5_X;
					 Y_Out = Enemy5_Y;
					 toNIOS_Active = Enemy5_Active;
					 end
			endcase		
		end
	
	end
endmodule	