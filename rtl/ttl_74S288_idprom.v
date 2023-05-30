
module ttl_74S288_idprom(input A0,
			 input 	A1,
			 input 	A2,
			 input 	A3,
			 input 	A4,
			 inout Q0,
			 inout Q1,
			 inout Q2,
			 inout Q3,
			 inout Q4,
			 inout Q5,
			 inout Q6,
			 inout Q7,
			 input 	S0_n);

   reg [7:0] out;
   wire [4:0] addr;

   assign addr = { A4,A3,A2,A1,A0 };

   always @(*)   
     case (addr)
       5'h00: out = 8'h01;
       5'h01: out = 8'h01;
       5'h02: out = 8'h08;
       5'h03: out = 8'h00;
       5'h04: out = 8'h20;
       5'h05: out = 8'h01;
       5'h06: out = 8'h06;
       5'h07: out = 8'he0;
       5'h08: out = 8'h1a;
       5'h09: out = 8'he4;
       5'h0a: out = 8'h23;
       5'h0b: out = 8'h3b;
       5'h0c: out = 8'h00;
       5'h0d: out = 8'h0d;
       5'h0e: out = 8'h72;
       5'h0f: out = 8'h56;
       5'h10: out = 8'hff;
       5'h11: out = 8'hff;
       5'h12: out = 8'hff;
       5'h13: out = 8'hff;
       5'h14: out = 8'hff;
       5'h15: out = 8'hff;
       5'h16: out = 8'hff;
       5'h17: out = 8'hff;
       5'h18: out = 8'hff;
       5'h19: out = 8'hff;
       5'h1a: out = 8'hff;
       5'h1b: out = 8'hff;
       5'h1c: out = 8'hff;
       5'h1d: out = 8'hff;
       5'h1e: out = 8'hff;
       5'h1f: out = 8'hff;
     endcase
   
   assign Q0 = ~S0_n ? out[0] : 1'bz;
   assign Q1 = ~S0_n ? out[1] : 1'bz;
   assign Q2 = ~S0_n ? out[2] : 1'bz;
   assign Q3 = ~S0_n ? out[3] : 1'bz;
   assign Q4 = ~S0_n ? out[4] : 1'bz;
   assign Q5 = ~S0_n ? out[5] : 1'bz;
   assign Q6 = ~S0_n ? out[6] : 1'bz;
   assign Q7 = ~S0_n ? out[7] : 1'bz;
endmodule

