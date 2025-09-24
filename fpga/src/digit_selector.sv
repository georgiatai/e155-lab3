/////////////////////////
// digit_selector.sv
// Author: Georgia Tai, ytai@g.hmc.edu
// Date: Sep 8, 2025
//  
// Selector for the digit being displayed. Toggles display at ~60 Hz.
/////////////////////////

module digit_selector(
	input  logic       clk, reset,
	input  logic [3:0] s0, s1,
	output logic       disp0, disp1,
	output logic [3:0] segDispHex
);
	logic [24:0] counter = 0;
	
	// Toggles the display digit at ~60 Hz
	always_ff @(posedge clk, negedge reset) begin
		if (~reset) begin
			counter <= 0;
			disp0   <= 1;             // default to first display the digit[0]
		end else if (counter >= 'd50000) begin
			disp0   <= ~disp0;        // toggle the digit displayed
			counter <= 0;
	  	end else begin
			counter <= counter + 1;
	  	end
	end
	
	assign disp1 = ~disp0;
	assign segDispHex = (disp0) ? s0 : s1;
		  
endmodule