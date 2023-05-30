// 1-of-8 decode/demux

module ttl_74F138(input A0,
		   input A1,
		   input A2,
		   input F1,
		   input F2,
		   input F3,
		   output Q0,
		   output Q1,
		   output Q2,
		   output Q3,
		   output Q4,
		   output Q5,
		   output Q6,
		   output Q7);

   wire [2:0] sel;
   wire [7:0] out;
   wire ena;

   assign sel = { A2, A1, A0 };

   assign out =
	       sel == 0 ? 8'b11111110 :
	       sel == 1 ? 8'b11111101 :
	       sel == 2 ? 8'b11111011 :
	       sel == 3 ? 8'b11110111 :
	       sel == 4 ? 8'b11101111 :
	       sel == 5 ? 8'b11011111 :
	       sel == 6 ? 8'b10111111 :
	       8'b01111111;

   assign ena = ~F1 & ~F2 & F3;
   
   assign Q0 = ena ? out[0] : 1'b1;
   assign Q1 = ena ? out[1] : 1'b1;
   assign Q2 = ena ? out[2] : 1'b1;
   assign Q3 = ena ? out[3] : 1'b1;
   assign Q4 = ena ? out[4] : 1'b1;
   assign Q5 = ena ? out[5] : 1'b1;
   assign Q6 = ena ? out[6] : 1'b1;
   assign Q7 = ena ? out[7] : 1'b1;
   
endmodule
