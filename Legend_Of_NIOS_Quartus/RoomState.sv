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
							input logic vsync,
							output logic[2:0] room);
							
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
			
				case (cur_room)
					0: begin
							next_room = room;
							if(doorcode == 2)
								next_room = 1;
						end
					1: begin 
							next_room = room;
							if(doorcode == 1)
								next_room = 0;
						end
					default: next_room = room;
				endcase
			end
							
endmodule
