
module ttl_74S491(input D0,
		  input  D1,
		  input  D2,
		  input  D8,
		  input  D9,
		  input  LD_n,
		  input  CT_n,
		  input  UP_n,
		  input  ST,
		  input  CI_n,
		  inout Q0_n,
		  inout Q1_n,
		  inout Q2_n,
		  inout Q3_n,
		  inout Q4_n,
		  inout Q5_n,
		  inout Q6_n,
		  inout Q7_n,
		  inout Q8_n,
		  inout Q9_n,
		  input  CLK,
		  input  OE);

   reg [9:0] count;

   always @(posedge CLK)
     begin
	if (ST)
	  count <= 10'b1111111111;
	else
	  if (~LD_n)
	    count <= { D9, D8, D2, D2, D2, D2, D2, D1, D0 };
	  else
	    if (~CT_n & ~CI_n)
	      begin
		 if (~UP_n)
		   count <= count + 10'b0000000001;
		 else
		   count <= count - 10'b0000000001;
	      end
     end
   
   assign Q0_n = ~OE ? count[0] : 1'bz;
   assign Q1_n = ~OE ? count[1] : 1'bz;
   assign Q2_n = ~OE ? count[2] : 1'bz;
   assign Q3_n = ~OE ? count[3] : 1'bz;
   assign Q4_n = ~OE ? count[4] : 1'bz;
   assign Q5_n = ~OE ? count[5] : 1'bz;
   assign Q6_n = ~OE ? count[6] : 1'bz;
   assign Q7_n = ~OE ? count[7] : 1'bz;
   assign Q8_n = ~OE ? count[8] : 1'bz;
   assign Q9_n = ~OE ? count[9] : 1'bz;
   
endmodule // ttl_74S491

