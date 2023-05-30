
module ttl_74LS244(input A11,
		   input  A12,
		   input  A13,
		   input  A14,
		   input  A21,
		   input  A22,
		   input  A23,
		   input  A24,
		   inout Y11,
		   inout Y12,
		   inout Y13,
		   inout Y14,
		   inout Y21,
		   inout Y22,
		   inout Y23,
		   inout Y24,
		   input  G1,
		   input  G2);

   assign Y11 = ~G1 ? A11 : 1'bz;
   assign Y12 = ~G1 ? A12 : 1'bz;
   assign Y13 = ~G1 ? A13 : 1'bz;
   assign Y14 = ~G1 ? A14 : 1'bz;

   assign Y21 = ~G2 ? A21 : 1'bz;
   assign Y22 = ~G2 ? A22 : 1'bz;
   assign Y23 = ~G2 ? A23 : 1'bz;
   assign Y24 = ~G2 ? A24 : 1'bz;

endmodule
