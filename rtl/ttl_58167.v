// RTC chip

   module ttl_58167(inout D0,
		    inout D1,
		    inout D2,
		    inout D3,
		    inout D4,
		    inout D5,
		    inout D6,
		    inout D7,
		    input A0,
		    input A1,
		    input A2,
		    input A3,
		    input A4,
		    input CS_n,
		    input RD_n,
		    input WR_n,
		    input PD_n);

   assign D0 = ~CS_n ? 1'b0 : 1'bz;
   assign D1 = ~CS_n ? 1'b0 : 1'bz;
   assign D2 = ~CS_n ? 1'b0 : 1'bz;
   assign D3 = ~CS_n ? 1'b0 : 1'bz;
   assign D4 = ~CS_n ? 1'b0 : 1'bz;
   assign D5 = ~CS_n ? 1'b0 : 1'bz;
   assign D6 = ~CS_n ? 1'b0 : 1'bz;
   assign D7 = ~CS_n ? 1'b0 : 1'bz;
   
endmodule
