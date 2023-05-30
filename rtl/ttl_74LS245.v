module ttl_74LS245 (inout A0,
		    inout A1,
		    inout A2,
		    inout A3,
		    inout A4,
		    inout A5,
		    inout A6,
		    inout A7,
		    inout B0,
		    inout B1,
		    inout B2,
		    inout B3,
		    inout B4,
		    inout B5,
		    inout B6,
		    inout B7,
		    input DR,
		    input CS_n);

   assign A0 = (~DR & ~CS_n) ? B0 : 1'bz;
   assign A1 = (~DR & ~CS_n) ? B1 : 1'bz;
   assign A2 = (~DR & ~CS_n) ? B2 : 1'bz;
   assign A3 = (~DR & ~CS_n) ? B3 : 1'bz;
   assign A4 = (~DR & ~CS_n) ? B4 : 1'bz;
   assign A5 = (~DR & ~CS_n) ? B5 : 1'bz;
   assign A6 = (~DR & ~CS_n) ? B6 : 1'bz;
   assign A7 = (~DR & ~CS_n) ? B7 : 1'bz;

   assign B0 = (DR & ~CS_n) ? A0 : 1'bz;
   assign B1 = (DR & ~CS_n) ? A1 : 1'bz;
   assign B2 = (DR & ~CS_n) ? A2 : 1'bz;
   assign B3 = (DR & ~CS_n) ? A3 : 1'bz;
   assign B4 = (DR & ~CS_n) ? A4 : 1'bz;
   assign B5 = (DR & ~CS_n) ? A5 : 1'bz;
   assign B6 = (DR & ~CS_n) ? A6 : 1'bz;
   assign B7 = (DR & ~CS_n) ? A7 : 1'bz;
   
endmodule
