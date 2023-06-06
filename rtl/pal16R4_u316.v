// PAL16R4
// Rev 1.0             Thu Jun 29 1984                    JM
// U316                Statistic Bit Logic Pal for 120 cpu board
// Sun Microsystems Inc. Mt View CA

module pal16R4_u316 (input D0,
		     input  D1,
		     input  D2,
		     input  D3,
		     input  D4,
		     input  D5,
		     input  D6,
		     input  D7,

		     output O0,
		     input  O1, 
		     inout  Q0,
		     inout  Q1,
		     inout  Q2,
		     inout  Q3,
		     input  O2,
		     input  O3,

		     input  CLK,
		     input  OE_n);

   wire clk, read, p_fc0, p_fc1, booten;
   reg type0, type1, acc = 0, mod = 0;
   wire c_s5c, c_s6, en, itype0, itype1, imod, iacc;
   wire dis, p_back;
   
   // c.s5c type1 type0 mod en read p.fc0 p.fc1 /booten gnd
   assign c_s5c = clk;
   assign itype0 = D0;
   assign itype1 = D1;
   assign imod = D2;
   assign en = ~D3;
   assign read = ~D4;
   assign p_fc0 = D5;
   assign p_fc1 = D6;
   assign booten = ~D7;
   
   // /c.s6 c.s5 /p.back acc. mod. type0. type1. acc /dis vcc
//   assign O0 = ~OE_n ? ~dis : 1'bz;
   assign O0 = ~dis;
   assign iacc = O1;
//   assign Q0 = ~OE_n ? type1 : 1'bz;
//   assign Q1 = ~OE_n ? type0 : 1'bz;
// something seems broken for writing back mod/acc here...
assign Q0 = 1'bz;
assign Q1 = 1'bz;
   assign Q2 = ~OE_n ? mod : 1'bz;
   assign Q3 = ~OE_n ? acc : 1'bz;
   assign p_back = ~O2;
   assign c_s6 = O3;
   
   always @(posedge c_s5c)
     begin
	type1 <= itype1; // write back

	type0 <= itype0; // write back

	acc <= iacc * ~en * ~dis +            // keep old acc when not enabled
		 iacc * dis;                  // keep old acc when disabled

	mod <= imod * read * en * ~dis +      // keep mod value on read cycles
	       imod * ~en * ~dis +             // old value if not enabled
	       imod * dis;                     // old value if disabled

     end
   
   assign dis = p_fc0 * p_fc1 * ~p_back +       // mmu reference
		p_fc1 * p_back +                // refresh
		booten;

endmodule
