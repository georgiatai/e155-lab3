/////////////////////////
// keypad_scanner.sv
// Author: Georgia Tai, ytai@g.hmc.edu
// Date: Sep 20, 2025
// 
// Scan the keypad by column, check if any rows is on.
/////////////////////////

module keypad_scanner(
	input  logic       clk, reset,
	input  logic [3:0] rows, 
	output logic [3:0] cols,
	output logic [3:0] rowsSync, colsSync
);
	logic [3:0] rowsInter, colsInter;
	
	// cycle through the columns
	always_ff @(posedge clk, negedge reset) begin
        if (~reset) cols <= 4'b1000;
        else        cols <= {cols[0], cols[3:1]};
    end
	
	// synchronizer to sync the rows (async input) and cols
	always_ff @(posedge clk, negedge reset) begin
        if (~reset) begin
			colsInter <= 4'b0000;
			rowsInter <= 4'b0000;
			colsSync  <= 4'b0000;
			rowsSync  <= 4'b0000;
        end else begin
			colsInter <= cols;
			colsSync  <= colsInter;
			rowsInter <= rows;
			rowsSync  <= rowsInter;
		end
    end
	
endmodule