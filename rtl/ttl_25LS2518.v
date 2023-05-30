module   ttl_25LS2518(input D0,
		      input  D1,
		      input  D2,
		      input  D3,
		      output Q0,
		      output Q1,
		      output Q2,
		      output Q3,
		      inout Y0,
		      inout Y1,
		      inout Y2,
		      inout Y3,
		      input  CK,
		      input  OE_n);

   reg [3:0] r = 0;

   always @(posedge CK)
     r <= { D3, D2, D1, D0 };

   assign Y0 = ~OE_n ? r[0] : 1'bz;
   assign Y1 = ~OE_n ? r[1] : 1'bz;
   assign Y2 = ~OE_n ? r[2] : 1'bz;
   assign Y3 = ~OE_n ? r[3] : 1'bz;
   
   assign Q0 = r[0];
   assign Q1 = r[1];
   assign Q2 = r[2];
   assign Q3 = r[3];
   
endmodule
