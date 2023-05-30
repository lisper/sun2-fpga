module ttl_74LS633 (input D1,
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
		    input EN,
		    input OE_n);

   assign Q1 = (~EN & ~OE_n) ? D1 : 1'bz;
   assign Q2 = (~EN & ~OE_n) ? D2 : 1'bz;
   assign Q3 = (~EN & ~OE_n) ? D3 : 1'bz;
   assign Q4 = (~EN & ~OE_n) ? D4 : 1'bz;
   assign Q5 = (~EN & ~OE_n) ? D5 : 1'bz;
   assign Q6 = (~EN & ~OE_n) ? D6 : 1'bz;
   assign Q7 = (~EN & ~OE_n) ? D7 : 1'bz;
   assign Q8 = (~EN & ~OE_n) ? D8 : 1'bz;
   
endmodule
