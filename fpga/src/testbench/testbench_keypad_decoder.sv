/////////////////////////
// testbench_keypad_decoder.sv
// Author: Georgia Tai, ytai@g.hmc.edu
// Date: Sep 23, 2025
// 
// Testbench for keypad_decoder.sv, checking that combinations of rows and columns
// correctly output the expected hex digit.
/////////////////////////

`timescale 1 ns / 1 ps

module testbench_keypad_decoder();
	
	logic clk;
	logic reset;
	
	logic [3:0] rows, cols;
	logic [3:0] key;
    logic [31:0] errors;
		
	// Instantiate DUT
	keypad_decoder dut(.rows(rows), .cols(cols), .key(key));
	
	// Generate clock
	always begin
		clk = 1; #5; clk = 0; #5;
	end
	
	initial begin
        errors = 0;
        // Set reset
        reset = 1; #22; reset = 0; #10;
        
        // Simulate each combination of rows and columns
        rows = 4'b0001; cols = 4'b0001; #10;
        assert (key === 4'b0001)
            else begin
                $error("Expected output: 1, Output: %h", key);
                errors++;
            end

        rows = 4'b0001; cols = 4'b0010; #10;
        assert (key === 4'b0010)
            else begin
                $error("Expected output: 2, Output: %h", key);
                errors++;
            end

        rows = 4'b0001; cols = 4'b0100; #10;
        assert (key === 4'b0011)
            else begin
                $error("Expected output: 3, Output: %h", key);
                errors++;
            end

        rows = 4'b0001; cols = 4'b1000; #10;
        assert (key === 4'b1010)
            else begin
                $error("Expected output: A, Output: %h", key);
                errors++;
            end

        rows = 4'b0010; cols = 4'b0001; #10;
        assert (key === 4'b0100)
            else begin
                $error("Expected output: 4, Output: %h", key);
                errors++;
            end
        
        rows = 4'b0010; cols = 4'b0010; #10;
        assert (key === 4'b0101)
            else begin
                $error("Expected output: 5, Output: %h", key);
                errors++;
            end

        rows = 4'b0010; cols = 4'b0100; #10;
        assert (key === 4'b0110)
            else begin
                $error("Expected output: 6, Output: %h", key);
                errors++;
            end
        
        rows = 4'b0010; cols = 4'b1000; #10;
        assert (key === 4'b1011)
            else begin
                $error("Expected output: B, Output: %h", key);
                errors++;
            end

        rows = 4'b0100; cols = 4'b0001; #10;
        assert (key === 4'b0111)
            else begin
                $error("Expected output: 7, Output: %h", key);
                errors++;
            end

        rows = 4'b0100; cols = 4'b0010; #10;
        assert (key === 4'b1000)
            else begin
                $error("Expected output: 8, Output: %h", key);
                errors++;
            end

        rows = 4'b0100; cols = 4'b0100; #10;
        assert (key === 4'b1001)
            else begin
                $error("Expected output: 9, Output: %h", key);
                errors++;
            end

        rows = 4'b0100; cols = 4'b1000; #10;
        assert (key === 4'b1100)
            else begin
                $error("Expected output: C, Output: %h", key);
                errors++;
            end
        
        rows = 4'b1000; cols = 4'b0001; #10;
        assert (key === 4'b1110)
            else begin
                $error("Expected output: E, Output: %h", key);
                errors++;
            end
        
        rows = 4'b1000; cols = 4'b0010; #10;
        assert (key === 4'b0000)
            else begin
                $error("Expected output: 0, Output: %h", key);
                errors++;
            end

        rows = 4'b1000; cols = 4'b0100; #10;
        assert (key === 4'b1111)
            else begin
                $error("Expected output: F, Output: %h", key);
                errors++;
            end

        rows = 4'b1000; cols = 4'b1000; #10;
        assert (key === 4'b1101)
            else begin
                $error("Expected output: D, Output: %h", key);
                errors++;
            end

        $display("Test completed with %0d errors", errors);
        $finish;
    end
	
endmodule    