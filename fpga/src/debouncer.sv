/////////////////////////
// debouncer.sv
// Author: Georgia Tai, ytai@g.hmc.edu
// Date: Sep 21, 2025
//  
// Counter for debouncer, waits for about 100 ms.
/////////////////////////

module debouncer(
	input  logic clk, reset, start,
	output logic countDone
);
	logic [24:0] counter = 0;
	
	// Counter for the debouncer to wait for ~100 ms
	always_ff @(posedge clk, negedge reset) begin
		if (~reset) begin
			counter   <= 0;
			countDone <= 0;
		end else if (start) begin  // start counting when enabled by FSM
			if (counter >= 'd600000) begin
				countDone <= 1;
				counter   <= 0;
			end else begin
				counter   <= counter + 1;
				countDone <= 0;
			end
		end
		
	end
		  
endmodule