/////////////////////////
// seven_seg_decoder.sv
// Author: Georgia Tai, ytai@g.hmc.edu
// Date: Sep 1, 2025
// 
// Decoder for a 7-segment display to output a one-digit hex value.
/////////////////////////

module seven_seg_decoder(
	input  logic [3:0] hex,
	output logic [6:0] segments
);

	// Combinational logic to decode hex to 7-segment display
	// segments: {a, b, c, d, e, f, g} (active low)
	always_comb begin
		case(hex)
			4'h0: segments = 7'b0000001;
			4'h1: segments = 7'b1001111;
			4'h2: segments = 7'b0010010;
			4'h3: segments = 7'b0000110;
			4'h4: segments = 7'b1001100;
			4'h5: segments = 7'b0100100;
			4'h6: segments = 7'b0100000;
			4'h7: segments = 7'b0001111;
			4'h8: segments = 7'b0000000;
			4'h9: segments = 7'b0000100;
			4'hA: segments = 7'b0001000;    // A
			4'hB: segments = 7'b1100000;    // b
			4'hC: segments = 7'b0110001;    // C
			4'hD: segments = 7'b1000010;    // d
			4'hE: segments = 7'b0110000;    // E
			4'hF: segments = 7'b0111000;    // F
			default: segments = 7'b1111111; // all off
		endcase
	end	

endmodule