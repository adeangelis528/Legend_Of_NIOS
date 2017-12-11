/*
This state machine determines what to do when a player enters a door
List of doorcodes:
0: No door entered
1: left door
2: right door
3: top door
4: bottom door

5-7: unused
*/
module RoomState(		input logic[2:0] doorcode,
							input logic Reset,
							input logic vsync,
							output logic[2:0] room,
							output logic initialize_room);
							
			initial begin
				cur_room = 0;
			end
			logic[2:0] cur_room, next_room;
			
			always_ff @ (posedge vsync)
			begin
				cur_room <= next_room;
			end
			
			always_comb begin
				room = cur_room;
				initialize_room = |doorcode | Reset;
			
				case (cur_room)
					0: begin
							next_room = room;
							if(doorcode == 3)
								next_room = 2;
							else if(doorcode == 2)
								next_room = 1;
						end
					1: begin 
							next_room = room;
							if(doorcode == 1)
								next_room = 0;
							else if(doorcode == 2)
								next_room = 3;
						end
					2: begin 
							next_room = room;
							if(doorcode == 4)
								next_room = 0;
						end
					3: begin 
							next_room = room;
							if(doorcode == 1)
								next_room = 1;
							else if(doorcode == 4)
								next_room = 4;
						end
					4: begin 
							next_room = room;
							if(doorcode == 3)
								next_room = 3;
							else if(doorcode == 2)
								next_room = 5;
						end
					5: begin 
							next_room = room;
							if(doorcode == 1)
								next_room = 4;
							else if(doorcode == 2)
								next_room = 7;
							else if(doorcode == 3)
								next_room = 6;
						end
					6: begin 
							next_room = room;
							if(doorcode == 4)
								next_room = 5;
						end
					7: begin 
							next_room = room;
							if(doorcode == 1)
								next_room = 5;
						end
					default: next_room = room;
				endcase
				
				if(Reset)
					next_room = 0;
			end
							
endmodule
