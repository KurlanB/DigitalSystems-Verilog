// Seven segment module

// Top Level Module
module lab2demo(sw9, sw8, sw7, sw5, sw4, sw3, sw2, sw1, hex5, hex4);

input sw9, sw8, sw7, sw5, sw4, sw3, sw2, sw1;
output[6:0]hex5;
output[6:0]hex4;

hexdisp(
	.x3(sw9),
	.x2(sw8), 
	.x1(sw7), 
	.x0(sw5),
	.a(hex5[0]),
	.b(hex5[1]),
	.c(hex5[2]),
	.d(hex5[3]),
	.e(hex5[4]),
	.f(hex5[5]),
	.g(hex5[6])
	);

name(
	.x3(sw4),
	.x2(sw3), 
	.x1(sw2), 
	.x0(sw1),
	.a(hex4[0]),
	.b(hex4[1]),
	.c(hex4[2]),
	.d(hex4[3]),
	.e(hex4[4]),
	.f(hex4[5]),
	.g(hex4[6])
	);

endmodule
