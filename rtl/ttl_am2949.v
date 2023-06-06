// octal tri state bidirectional buffer
module ttl_am2949( inout A0,
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
		   input T_n,
		   input R_n);

   wire [7:0] a, b;
   assign a = { A7, A6, A5, A4, A3, A2, A1, A0 };
   assign b = { B7, B6, B5, B4, B3, B2, B1, B0 };
   
   assign B0 = ~T_n ? A0 : 1'bz;
   assign B1 = ~T_n ? A1 : 1'bz;
   assign B2 = ~T_n ? A2 : 1'bz;
   assign B3 = ~T_n ? A3 : 1'bz;
   assign B4 = ~T_n ? A4 : 1'bz;
   assign B5 = ~T_n ? A5 : 1'bz;
   assign B6 = ~T_n ? A6 : 1'bz;
   assign B7 = ~T_n ? A7 : 1'bz;

   assign A0 = ~R_n ? B0 : 1'bz;
   assign A1 = ~R_n ? B1 : 1'bz;
   assign A2 = ~R_n ? B2 : 1'bz;
   assign A3 = ~R_n ? B3 : 1'bz;
   assign A4 = ~R_n ? B4 : 1'bz;
   assign A5 = ~R_n ? B5 : 1'bz;
   assign A6 = ~R_n ? B6 : 1'bz;
   assign A7 = ~R_n ? B7 : 1'bz;

endmodule


