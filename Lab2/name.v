module name(a,b,c,d,e,f,g,x3,x2,x1,x0);

// Declaring inputs and outputs
input x3,x2,x1,x0;
output a,b,c,d,e,f,g;

// Assigning outputs to boolean equations

// Sum-of-Product
assign a = ~(~x1 & x0 & ~x2 | x1 & ~x0 & ~x2);
assign b = ~(x0 & x2 | x1 & ~x2);
assign c = ~(~x0 & ~x2 | x0 & x2 | x1 & ~x2);
assign d = ~(x2 & x1 | ~x1 & x0 | ~x3 & ~x2 & ~x1);

// Product-of-Sum
assign e = ~(~x2 | x1 | ~x0);
assign f = ~((x3 | ~x2 | x1 | x0) & (~x3 | x2 | x1 | x0));
assign g = ~(~x2 | ~x1);

endmodule
