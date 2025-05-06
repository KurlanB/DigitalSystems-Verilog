module hexdisp(a,b,c,d,e,f,g,x3,x2,x1,x0);

//Declaring inputs and outputs
input x3,x2,x1,x0;
output a,b,c,d,e,f,g;

//Boolean equations
assign a = ~((~x2 & ~x0) | (x3 & ~x0) | (x3 & ~x2 & ~x1) | (~x3 & x1) | (x2 & x1) | (~x3 & x2 & x0));
assign b = ~((~x3 & ~x2) | (~x2 & ~x1) | (~x2 & ~x0) | (~x1 & x0 & x3) | (x1 & x0 & ~x3) | (~x1 & ~x0 & ~x3));
assign c = ~((~x3 & x2) | (x3 & ~x2) | (~x1 & x0) | (~x3 & x0) | (~x3 & ~x1));
assign d = ~((x3&~x1)|(~x2&x1&x0)|(~x3&~x2&~x0)|(x2&x1&~x0)|(x2&~x1&x0));
assign e = ~((~x2&~x0)|(x3&x1)|(x1&~x0)|(x3&x2));
assign f = ~((x3|x2|~x0)&(x3|x2|~x1)&(~x3|~x2|x1|~x0)&(x3|~x1|~x0));
assign g = ~((x3|x2|x1)&(~x3|~x2|x1|x0)&(x3|~x2|~x1|~x0)); 

endmodule
