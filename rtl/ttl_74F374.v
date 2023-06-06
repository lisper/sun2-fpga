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

   reg [7:0] q = 8'b0;

   always @(posedge CLK)
     begin
	q <= { D8, D7, D6, D5, D4, D3, D2, D1 };
     end

     assign Q1 = ~OE ? q[0] : 1'bz;
     assign Q2 = ~OE ? q[1] : 1'bz;
     assign Q3 = ~OE ? q[2] : 1'bz;
     assign Q4 = ~OE ? q[3] : 1'bz;
     assign Q5 = ~OE ? q[4] : 1'bz;
     assign Q6 = ~OE ? q[5] : 1'bz;
     assign Q7 = ~OE ? q[6] : 1'bz;
     assign Q8 = ~OE ? q[7] : 1'bz;
   
endmodule

