module ripple_adder3(X, Y, carryout, sum);
	input [2:0]X, Y; 
	output reg carryout;
   output reg [2:0]sum;
	reg [3:0]C;
	integer i;
	
	always @(X, Y)
	begin
		C[0] = 0;
		for (i = 0; i < 3; i = i+1)
		begin
			sum[i] = C[i] ^ X[i] ^ Y[i];
			C[i + 1] = (X[i] && Y[i]) | (C[i] && X[i]) | (C[i] && Y[i]);
		end
		carryout = C[3];
	end
	
endmodule


module reg3(D, Clock, Resetn, Q);
	input [2:0]D;
	input Clock, Resetn;
	output reg [2:0]Q;
	
	always @(posedge Clock, negedge Resetn)
	begin
		if(Resetn == 0)
			Q<=3'b000;
		else
			Q<=D;
	end
			
endmodule

module hexto7seg (bin, leds);
	input [3:0] bin;
	output reg [6:0]leds;

	always @(bin)
	begin
		case (bin) //switch case
			4'b0000: leds = 7'b1111110; // 0
			4'b0001: leds = 7'b0110000; // 1
			4'b0010: leds = 7'b1101101; // 2
			4'b0011: leds = 7'b1111001; // 3
			4'b0100: leds = 7'b0110011; // 4
			4'b0101: leds = 7'b1011011; // 5
			4'b0110: leds = 7'b1011111; // 6
			4'b0111: leds = 7'b1110000; // 7
			4'b1000: leds = 7'b1111111; // 8
			4'b1001: leds = 7'b1111011; // 9
			4'b1010: leds = 7'b1110111; // A
			4'b1011: leds = 7'b0011111; // b
			4'b1100: leds = 7'b1001110; // C
			4'b1101: leds = 7'b0111101; // d
			4'b1110: leds = 7'b1001111; // E
			4'b1111: leds = 7'b1000111; // F
			default: leds = 7'b0000000; // Blank display for undefined values
		endcase
		leds = ~leds;
	end 
endmodule

module alu3(X, Resetn, Clock, led);
	input [2:0]X;
	input Resetn, Clock;
	output [6:0]led;
	
	wire[2:0] reg1;
	wire [2:0] reg2;
	wire [3:0] sum;
	
	reg3 firstRegister(
		.D(X),
		.Clock(Clock),
		.Resetn(Resetn),
		.Q(reg1)
		);
	
	reg3 secondRegister(
		.D(sum[2:0]),
		.Clock(Clock),
		.Resetn(Resetn),
		.Q(reg2)
		);
		
	ripple_adder3(
		.X(reg1),
		.Y(reg2),
		.carryout(sum[3:3]),
		.sum(sum[2:0])
		);
		
	hexto7seg(
		.bin(sum),
		.leds(led)
		);
	
endmodule
