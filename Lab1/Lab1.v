module dual2(f1, f2, x1, x0, y1, y0);

//Declaring of inputs and outputs
	input x0;
	input x1;
	input y0;
	input y1;
	output f1;
	output f2;
	
//Boolean Equations

//Simplified form
	assign f1 = (y1 | ((~x1|x0) && (~x0|y0))) && ((~x1|~x0) | ((y1|~y0) && (~y1|y0)));
	
//Canonical form
	assign f2 = (x1|x0|y1|~y0) && (x1|x0|~y1|y0) && (x1|x0|~y1|~y0) && (x1|~x0|y1|y0) && (x1|~x0|~y1|y0) && (x1|~x0|~y1|~y0) && (~x1|x0|y1|y0) 
					&& (~x1 | x0 | y1 | ~y0) && (~x1 | x0 | ~y1 | ~y0) && (~x1 | ~x0 | y1 | y0) && (~x1 | ~x0 | y1 | ~y0) && (~x1 | ~x0 | ~y1 | y0);
	
endmodule
