/////////////////////////
// keypad_decoder.sv
// Author: Georgia Tai, ytai@g.hmc.edu
// Date: Sep 14, 2025
// 
// Decoder for 4-by-4 keypad to output the key pressed in binary.
/////////////////////////

module keypad_decoder(
	input  logic [3:0] rows, cols,
	output logic [3:0] key
);

	// Combinational logic to decode the key pressed with
	// the input rows and columns
	always_comb begin
		case(rows)
			4'b0001: begin
				case(cols)
					4'b0001: key = 4'b0001; // 1
					4'b0010: key = 4'b0010; // 2
					4'b0100: key = 4'b0011; // 3
					4'b1000: key = 4'b1010; // A
					default: key = 4'b0000;
				endcase
			end
			4'b0010: begin
				case(cols)
					4'b0001: key = 4'b0100; // 4
					4'b0010: key = 4'b0101; // 5
					4'b0100: key = 4'b0110; // 6
					4'b1000: key = 4'b1011; // B
					default: key = 4'b0000;
				endcase
			end
			4'b0100: begin
				case(cols)
					4'b0001: key = 4'b0111; // 7
					4'b0010: key = 4'b1000; // 8
					4'b0100: key = 4'b1001; // 9
					4'b1000: key = 4'b1100; // C
					default: key = 4'b0000;
				endcase
			end
			4'b1000: begin
				case(cols)
					4'b0001: key = 4'b1110; // E
					4'b0010: key = 4'b0000; // 0
					4'b0100: key = 4'b1111; // F
					4'b1000: key = 4'b1101; // D
					default: key = 4'b0000;
				endcase
			end
			default: key = 4'b0000; // default to 0
		endcase
	end

endmodule