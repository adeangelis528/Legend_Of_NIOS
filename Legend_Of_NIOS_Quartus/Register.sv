module Register
			#(parameter width = 16)
			(input logic [width-1:0] Data_in,
		input logic Clk, Reset, Load_En,
		output logic [width-1:0] Data_out);
			
		logic [width-1:0] Data_next;
			
		always_ff @ (posedge Clk)
		begin
			Data_out <= Data_next;
		end
			
		always_comb
		begin
			if(Reset)
				Data_next = 0;
			else if(Load_En)
				Data_next = Data_in;
			else
				Data_next = Data_out;
		end
endmodule
			