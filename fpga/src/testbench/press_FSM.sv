/////////////////////////
// keypad_decoder.sv
// Author: Georgia Tai, ytai@g.hmc.edu
// Date: Sep 14, 2025
// 
// Decoder for 4-by-4 keypad to output the key pressed in binary.
/////////////////////////

module press_FSM(
	input  logic       clk, reset,
	input  logic       countDone,
	input  logic [3:0] rows, cols,
	output logic       updateKey, startDebounce,
	output logic [3:0] rowsAct, colsAct,
	output logic [1:0] state
);
	
	// FSM states
    typedef enum logic [1:0] {
        IDLE,
        DEBOUNCE,
        HOLD,
        RELEASE
    } state_t;
	
	state_t currState, nextState;
	
	logic [3:0] rowsPrev, colsPrev;
	
	always_ff @(posedge clk, negedge reset) begin
		if (~reset) begin
			currState <= IDLE;
		end else begin
			currState <= nextState;
		end
	end
	
	always_ff @(posedge clk, negedge reset) begin
		if (~reset) begin
			rowsPrev  <= 4'b0;
			colsPrev  <= 4'b0;
		end else if ((nextState == DEBOUNCE) && ($onehot(rows))) begin
			rowsPrev  <= rows;
			colsPrev  <= cols;
		end else begin
			rowsPrev  <= rowsPrev;
			colsPrev  <= colsPrev;
		end
	end
	
	always_comb begin
		case (currState)
			IDLE: begin
				if (rows != 4'b0) begin
					nextState = DEBOUNCE;
				end else begin
					nextState = IDLE;
				end
			end
			DEBOUNCE: begin
				if (countDone)
					nextState = HOLD;
				else if (cols == colsPrev && rows != rowsPrev)
					nextState = IDLE;
				else
					nextState = DEBOUNCE;
			end
			HOLD: begin
				if ((cols == colsPrev) && (rows == 4'b0))
					nextState = RELEASE;
				else
					nextState = HOLD;
			end
			RELEASE: begin
				if (countDone)
					nextState = IDLE;
				else if (cols == colsPrev && rows == rowsPrev)
					nextState = HOLD;
				else
					nextState = RELEASE;
			end
		endcase
	end
	
	assign rowsAct = rowsPrev;
	assign colsAct = colsPrev;
	assign startDebounce = (currState == DEBOUNCE || currState == RELEASE);
	assign updateKey     = (nextState == HOLD && currState == DEBOUNCE);
	assign state         = currState;
	
endmodule