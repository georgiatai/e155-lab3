/////////////////////////
// press_FSM.sv
// Author: Georgia Tai, ytai@g.hmc.edu
// Date: Sep 22, 2025
// 
// Main FSM of the design to handle key press and debounce logic.
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
	
	// To store the pressed key's rows and columns
	logic [3:0] rowsPrev, colsPrev;
	
	always_ff @(posedge clk, negedge reset) begin
		if (~reset) begin
			currState <= IDLE;
		end else begin
			currState <= nextState;
		end
	end
	
	// Update the stored rows and cols only when entering the DEBOUNCE state
	always_ff @(posedge clk, negedge reset) begin
		if (~reset) begin
			rowsPrev  <= 4'b0;
			colsPrev  <= 4'b0;
		end else if ((nextState == DEBOUNCE) && ($onehot(rows))) begin // ensure that only one row is active
			rowsPrev  <= rows;
			colsPrev  <= cols;
		end else begin
			rowsPrev  <= rowsPrev;
			colsPrev  <= colsPrev;
		end
	end
	
	// Next state logic
	always_comb begin
		case (currState)
			IDLE: begin
				if (rows != 4'b0)  // check if any row is active
					nextState = DEBOUNCE;
				else
					nextState = IDLE;
			end
			DEBOUNCE: begin
				if (countDone)    // move on since debounce period is over
					nextState = HOLD;
				else if (cols == colsPrev && rows != rowsPrev) // if row (key pressed) changed
					nextState = IDLE;
				else
					nextState = DEBOUNCE;
			end
			HOLD: begin
				if ((cols == colsPrev) && (rows == 4'b0))     // if key is released
					nextState = RELEASE;
				else
					nextState = HOLD;
			end
			RELEASE: begin
				if (countDone)   // move on since debounce period is over
					nextState = IDLE;
				else if (cols == colsPrev && rows == rowsPrev) // if key is pressed again
					nextState = HOLD;
				else
					nextState = RELEASE;
			end
		endcase
	end
	
	// Output logic
	assign rowsAct       = rowsPrev;
	assign colsAct       = colsPrev;
	assign startDebounce = (currState == DEBOUNCE || currState == RELEASE); // debouncer enable
	assign updateKey     = (nextState == HOLD && currState == DEBOUNCE);    // updaate key once before entering HOLD
	assign state         = currState;
	
endmodule