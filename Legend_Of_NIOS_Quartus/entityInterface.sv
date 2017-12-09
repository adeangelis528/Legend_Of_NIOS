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
	always_ff @ (posedge clk)
	begin
	
		toNIOS_X <= X_Out;
		toNIOS_Y <= Y_Out;
	
	end
	