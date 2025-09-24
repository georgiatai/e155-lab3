/////////////////////////
// testbench_keypad_scanner.sv
// Author: Georgia Tai, ytai@g.hmc.edu
// Date: Sep 23, 2025
// 
// Testbench for keypad_decoder.sv, checking that the outputs are in sync.
/////////////////////////

`timescale 1 ns / 1 ps

module testbench_keypad_scanner();
	
	logic clk, reset;
	logic [3:0] rows, cols, rowsSync, colsSync;
	logic [31:0] errors;
		
	// Instantiate DUT
	keypad_scanner dut(.clk(clk), .reset(reset), .rows(rows), 
                       .cols(cols), .rowsSync(rowsSync), .colsSync(colsSync));
	
	// Generate clock
	always begin
		clk = 1; #5; clk = 0; #5;
	end
	
	initial begin
		errors = 0;
		
		// Enable reset
		reset = 0; #22; reset = 1;
		
		// Set rows input for more than 2 cycles to allow for async input
		rows = 4'b0001; #22;
		assert (rowsSync === 4'b0001) else $display("Expected rowsSync = 4'b0001, Output rowsSync = %b", rowsSync); #10;
		
		rows = 4'b0010; #22;
		assert (rowsSync === 4'b0010) else $display("Expected rowsSync = 4'b0010, Output rowsSync = %b", rowsSync); #10;

		rows = 4'b0100; #22;
		assert (rowsSync === 4'b0100) else $display("Expected rowsSync = 4'b0100, Output rowsSync = %b", rowsSync); #10;

		rows = 4'b1000; #22;
		assert (rowsSync === 4'b1000) else $display("Expected rowsSync = 4'b1000, Output rowsSync = %b", rowsSync); #10;
	end
	
endmodule