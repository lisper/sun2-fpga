// octal D type flip flop with tri state outputs

module ttl_74LS534(input D1,
		   input D2,
		   input D3,
		   input D4,
		   input D5,
		   input D6,
		   input D7,
		   input D8,
		   inout Q1,
		   inout Q2,
		   inout Q3,
		   inout Q4,
		   inout Q5,
		   inout Q6,
		   inout Q7,
		   inout Q8,
		   input CK,
		   input OE_n);

   wire [7:0] in;
   reg [7:0]  r;

   assign in = { D8,D7,D6,D5,D4,D3,D2,D1 };
   
   always @(posedge CK)
     r <= in;
   
   assign Q1 = ~OE_n ? r[0] : 1'bz;
   assign Q2 = ~OE_n ? r[1] : 1'bz;
   assign Q3 = ~OE_n ? r[2] : 1'bz;
   assign Q4 = ~OE_n ? r[3] : 1'bz;
   assign Q5 = ~OE_n ? r[4] : 1'bz;
   assign Q6 = ~OE_n ? r[5] : 1'bz;
   assign Q7 = ~OE_n ? r[6] : 1'bz;
   assign Q8 = ~OE_n ? r[7] : 1'bz;
   
endmodule

