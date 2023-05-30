module ttl_74F374 (input D1,
		   input  D2,
		   input  D3,
		   input  D4,
		   input  D5,
		   input  D6,
		   input  D7,
		   input  D8,
		   output Q1,
		   output Q2,
		   output Q3,
		   output Q4,
		   output Q5,
		   output Q6,
		   output Q7,
		   output Q8,
		   input  CLK,
		   input  OE);

   reg q1, q2, q3, q4, q5, q6, q7, q8;

   always @(posedge CLK)
     begin
	q1 <= D1;
	q2 <= D2;
	q3 <= D3;
	q4 <= D4;
	q5 <= D5;
	q6 <= D6;
	q7 <= D7;
	q8 <= D8;
     end

     assign Q1 = ~OE ? q1 : 1'bz;
     assign Q2 = ~OE ? q2 : 1'bz;
     assign Q3 = ~OE ? q3 : 1'bz;
     assign Q4 = ~OE ? q4 : 1'bz;
     assign Q5 = ~OE ? q5 : 1'bz;
     assign Q6 = ~OE ? q6 : 1'bz;
     assign Q7 = ~OE ? q7 : 1'bz;
     assign Q8 = ~OE ? q8 : 1'bz;
   
endmodule

