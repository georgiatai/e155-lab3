/////////////////////////
// lab3_gt.sv
// Author: Georgia Tai, ytai@g.hmc.edu
// Date: Sep 14, 2025
// 
// Top level module for Lab 3 of E155 @HMC. 
// Takes in a 4-by-4 keypad and uses dual seven segment display to 
// show the most recent two inputs.
/////////////////////////

module lab3_gt(
	input  logic       reset,
	input  logic [3:0] rows,
	output logic [3:0] cols,
	output logic [6:0] seg,
	output logic       disp0, disp1,  // enabling signal for displays (1 = left, 0 = right)
	output logic [1:0] state
);

	logic clk;
	logic countDone, updateKey, startDebounce;
	logic [3:0] keyNew, segDispHex, s0, s1;
	logic [3:0] rowsSync, colsSync, rowsAct, colsAct;
	
	// Internal high-speed oscillator (freq = 6 MHz)
	HSOSC #(.CLKHF_DIV(2'b11)) 
	      hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));
		  
	keypad_scanner keypadScanner (.clk(clk), .reset(reset), .rows(rows), 
                                  .cols(cols), .rowsSync(rowsSync), .colsSync(colsSync));
								  
	debouncer      debouncer (.clk(clk), .reset(reset), .start(startDebounce), .countDone(countDone));
								  
	press_FSM      pressFSM (.clk(clk), .reset(reset), .countDone(countDone), .rows(rowsSync), .cols(colsSync),
							  .updateKey(updateKey), .startDebounce(startDebounce), .rowsAct(rowsAct), .colsAct(colsAct), .state(state));
		  
	keypad_decoder keypadDecoder (.rows(rowsAct), .cols(colsAct), .key(keyNew));
	
	// Register the old and new input for dual segment display
	always_ff @(posedge clk, negedge reset) begin
        if (~reset) begin
            s0 <= 4'h0;
            s1 <= 4'h0;
        end else if (updateKey) begin
            s0 <= keyNew;
            s1 <= s0;
        end else begin
            s0 <= s0;
            s1 <= s1;
        end
	end

	// Uses clock controll to select the digit displayed
	digit_selector digitSelector(.clk(clk), .reset(reset), .s0(s0), .s1(s1),
					              .disp0(disp0), .disp1(disp1), .segDispHex(segDispHex));
	
	// Decode the selected digit to 7-segment display
	seven_seg_decoder segDecoder (.hex(segDispHex), .segments(seg));	


endmodule