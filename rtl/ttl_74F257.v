module ttl_74F257(input A1,
		  input A2,
		  input A3,
		  input A4,
		  input B1,
		  input B2,
		  input B3,
		  input B4,
		  output Y1,
		  output Y2,
		  output Y3,
		  output Y4,
		  input B,
		  input OE_n);
   
   assign Y1 = ~OE_n ? (~B ? A1 : B1) : 1'bz;
   assign Y2 = ~OE_n ? (~B ? A2 : B2) : 1'bz;
   assign Y3 = ~OE_n ? (~B ? A3 : B3) : 1'bz;
   assign Y4 = ~OE_n ? (~B ? A4 : B4) : 1'bz;
   
endmodule // ttl_74F257
