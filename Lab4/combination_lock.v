module inputConditioning (clk, A, A_pulse);

	input clk;       // Clock signal (from KEY[1])
	input A;       // Input signal A (from KEY[0])
	output A_pulse;
	 
	reg [1:0] state, next_state;
    
	 // Define states as parameters
	parameter INERT = 2'b00;
	parameter ACTION = 2'b01;
	parameter WAIT = 2'b10;

    // State registers
    

    // State transition logic (combinational)
	always @(A, state) 
	begin
		case (state)
			INERT: 
			begin
				if (A == 0)
					next_state = INERT;   // Transition to ACTION if A is high
            else
               next_state = ACTION;    // Remain in INERT if A is low
         end

         ACTION: 
			begin
            next_state = WAIT;        // Transition to WAIT after one clock cycle
         end

         WAIT: 
			begin
            if (A == 0)
                next_state = INERT;    // Go back to INERT if A goes low
            else
                next_state = WAIT;    // Remain in WAIT if A stays high
         end
				default: next_state = INERT;   // Default case (safety)
      endcase
    end

    // State flip-flops (sequential logic)
   always @(posedge clk) 
	begin
		state <= next_state;
	end

   assign A_pulse = (state == ACTION);

endmodule


module fsm (clk, reset, enter, change, match, state, new);

	input clk, reset, enter, change, match;
	output reg [2:0] state;
	output reg new;
   
	// State encoding
	parameter INERT = 3'b000, CHECK_ALARM = 3'b001, OPEN = 3'b010, 
             ALARM = 3'b011, CHANGE = 3'b101;
   
   reg [2:0] next_state;
	
    // State transition logic (combinational logic)
   always @(enter, reset, match, change) 
	begin
		case (state)
			INERT: 
			begin
				new = 0;
				if(enter == 0) 
				begin
					if(match == 0)
					begin
						next_state = CHECK_ALARM;
					end
					else if(match == 1)
					begin
						next_state = OPEN;
					end
				end
            else if (change == 0 && match == 1)
               next_state = CHANGE;
				else
					next_state = INERT;
			end
         CHECK_ALARM:
			begin
				if(enter == 0)
				begin
					if(match == 0)
					begin
						next_state = ALARM;
					end
					else if(match == 1)
					begin
						next_state = OPEN;
					end
				end
			end
			OPEN: 
			begin
            if(enter == 0) 
					next_state = INERT;
				else
					next_state = OPEN;
         end
         
			ALARM: 
			begin
            if(reset == 0)	
					next_state = INERT;
				else
					next_state = ALARM;
         end
         
			CHANGE: 
			begin
				new = 1;
            if(enter == 0 || change == 0)
				begin	
					next_state = INERT;
				end
				else
					next_state = CHANGE;
         end
        endcase
	end

    // State flip-flops (sequential logic)
   always @(posedge clk, negedge reset) 
	begin
		if(reset == 0) 
		begin
			state <= INERT;
      end
		else
			state <= next_state;
   end

endmodule


module register_4bit (clk, reset, load, data_in, data_out);
	input clk, reset, load;
	input [3:0] data_in;
	
	output reg [3:0] data_out;
	
	always @(posedge clk, negedge reset) 
	begin
		if (reset == 0)
			data_out <= 4'b0110;  // Default combination on reset
      else if (load == 1)
         data_out <= data_in;
   end
endmodule

module comparator_4bit(a, b, match);

	input [3:0] a, b;
	output match;
	
	assign match = (a == b);
endmodule


module led_display_driver(next_step, hex_display);
	input [2:0] next_step;
	output reg [6:0] hex_display;
	
	always @(*) 
	begin
		case(next_step)
			3'b011: hex_display = 7'b0001000; // Display 'A' for Alarm
			3'b101: hex_display = 7'b1101010; // Display 'n' for New combination
			3'b010: hex_display = 7'b0000001; // Display 'O' for Open
			default: hex_display = 7'b1111110; // Display '-' for INERT state
		endcase
	end
endmodule



module combination_lock (clk, reset, X, enter, change, HEX5);
	input clk, reset, enter, change;
	input [3:0] X;
	output [6:0] HEX5;
	
	wire [2:0] next_step;
	wire [3:0] stored_combination;
   wire [2:0] state;
	wire match, condition_enter, condition_change;

   // Instantiate 4-bit register to store the combination
	register_4bit comb_register (
        .clk(clk),
        .reset(reset),
        .load(new),           // Load on new signal from FSM
        .data_in(X),
        .data_out(stored_combination)
	);

   // Instantiate comparator to compare X with stored_combination
   comparator_4bit comb_compare (
        .a(X),
        .b(stored_combination),
        .match(match)
   );

	inputConditioning enter_condition(
		.clk(clk),
		.A(enter),
		.A_pulse(condition_enter)
	);
	
	inputConditioning change_condition(
		.clk(clk),
		.A(change),
		.A_pulse(condition_change)
	);
	
   // Instantiate FSM
   fsm lock_fsm (
        .clk(clk),
        .reset(reset),
        .enter(!condition_enter),
        .change(!condition_change),
        .match(match),
        .state(state),
		  .new(new)
   );

   // Instantiate LED display driver
   led_display_driver display (
        .next_step(state),
        .hex_display(HEX5)
   );
endmodule
