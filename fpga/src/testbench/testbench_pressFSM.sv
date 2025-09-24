/////////////////////////
// testbench_pressFSM.sv
// Author: Georgia Tai, ytai@g.hmc.edu
// Date: Sep 23, 2025
// 
// Testbench for keypad_decoder.sv, checking that the outputs are in sync.
/////////////////////////

`timescale 1ns/1ps

module press_FSM_tb();

    // DUT ports
    logic        clk, reset;
    logic        countDone;
    logic [3:0]  rows, cols;
    logic        updateKey, startDebounce;
    logic [3:0]  rowsAct, colsAct;
    logic [1:0]  state;

    // Instantiate DUT
    press_FSM dut (.clk(clk), .reset(reset), .countDone(countDone), .rows(rows),
                    .cols(cols), .updateKey(updateKey), .startDebounce(startDebounce), .rowsAct(rowsAct), .colsAct(colsAct), .state(state));

    always #5 clk = ~clk;

    // Task: press key
    task press_key(input [3:0] row, input [3:0] col);
        begin
            rows = row;
            cols = col;
            $display("[%0t] >>> Pressed key: row=%b col=%b", $time, row, col);
        end
    endtask

    // Task: release key (only rows drop, cols held constant)
    task release_key;
        begin
            rows = 4'b0000;
            $display("[%0t] <<< Released key (rows=0, col held=%b)", $time, cols);
        end
    endtask

    // Task: clear keypad
    task clear_keypad;
        begin
            rows = 4'b0000;
            cols = 4'b0000;
            $display("[%0t] --- Cleared keypad (no key active)", $time);
        end
    endtask

    initial begin
        clk       = 0;
        reset     = 0;
        countDone = 0;
        rows      = 0;
        cols      = 0;

        // Reset
        #12 reset = 1;
        $display("[%0t] Reset deasserted", $time);

        #10 press_key(4'b0001, 4'b0100);  // press key
        #10 countDone = 1;                // debounce ends
        #10 countDone = 0;
        #30;

        // Release key
        release_key();
        #10 countDone = 1;                // debounce release
        #10 countDone = 0;

        // Clear keypad fully
        #20 clear_keypad();


        #20 press_key(4'b0010, 4'b0100);  // press key
        #5  press_key(4'b0100, 4'b0100);  // bounce / glitch
        #5  press_key(4'b0010, 4'b0100);  // back to original row
        #10 countDone = 1;
        #10 countDone = 0;

        #20 release_key();
        #10 countDone = 1;
        #10 countDone = 0;
        #20 clear_keypad();

        #100 $finish;
    end

endmodule
