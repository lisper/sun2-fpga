module ttl_27256_l(input A0,
		  input  A1,
		  input  A2,
		  input  A3,
		  input  A4,
		  input  A5,
		  input  A6,
		  input  A7,
		  input  A8,
		  input  A9,
		  input  A10,
		  input  A11,
		  input  A12,
		  input  A13,
		  input  A14,
		  inout O0,
		  inout O1,
		  inout O2,
		  inout O3,
		  inout O4,
		  inout O5,
		  inout O6,
		  inout O7,
		  input  OE_n,
		  input  CE_n);

   reg [7:0] out;
   wire [14:0] addr;

   assign addr = { A14,A13,A12,A11,A10,A9,A8,A7,A6,A5,A4,A3,A2,A1,A0 };

   always @(*)
     begin
	if (CE_n)
	  out = 8'b0;
	else
	  begin
	     case (addr)
//decoded backward
`include "bootprom_h.v"
	     endcase
	     //$display("bootrom_l: %x -> %x", addr, out);
	  end
     end
   
   assign O0 = ~OE_n ? out[0] : 1'bz;
   assign O1 = ~OE_n ? out[1] : 1'bz;
   assign O2 = ~OE_n ? out[2] : 1'bz;
   assign O3 = ~OE_n ? out[3] : 1'bz;
   assign O4 = ~OE_n ? out[4] : 1'bz;
   assign O5 = ~OE_n ? out[5] : 1'bz;
   assign O6 = ~OE_n ? out[6] : 1'bz;
   assign O7 = ~OE_n ? out[7] : 1'bz;

endmodule
