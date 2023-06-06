// PAL16R4             u718                     arb
// Rev 1.2             Jul  6 1984              JM
// 120 CPU P1 Bus (Multibus) Arbiter
// Sun Microsystems Inc                  Mt View, CA

module pal16R4_u718(input D0,
		     input D1,
		     input D2,
		     input D3,
		     input D4,
		     input D5,
		     input D6,
		     input D7,
		     output O0_n,
		     output O1_n,
		     output Q0_n,
		     output Q1_n,
		     output Q2_n,
		     output Q3_n,
		     output O2_n,
		     output O3_n,
		    input CLK,
		    input OE_n);

   wire clk, p1bprn, p1init, sysb, test;
   wire p1bpro, p1busy, p1cbrq;
   reg 	cbrqo = 0, aen = 0, q0 = 0, q1 = 0;
   wire p1breq;

   // clk /p1bprn /p1init sysb /test vcc vcc vcc vcc gnd
   assign clk = CLK;
   assign p1bprn = ~D0;
   assign p1init = ~D1;
   assign sysb = D2;
   assign test = ~D3;
   
   // /oe /p1breq /p1cbrq /cbrqo q0 q1 /aen /p1busy /p1bpro vcc
   assign O0_n = ~p1breq;
   assign O1_n = ~p1cbrq;
   assign Q0_n = ~cbrqo;
   assign Q1_n = q0;
   assign Q2_n = q1;
   assign Q3_n = ~aen;
   assign O2_n = ~p1busy;
   assign O3_n = ~p1bpro;

   assign p1bpro = q1 * q0 * p1bprn * ~p1init;
   assign p1busy = aen;
   assign p1cbrq = cbrqo;

  assign p1breq = ~q1 * ~p1init +
		  ~q0 * ~p1init;
   
   always @(posedge clk)
     begin
	cbrqo <= q1 * ~q0 * p1busy * ~p1init +
		 q1 * ~q0 * ~p1bprn * ~p1init +
		 q1 * q0 * sysb * ~p1init;
     
	aen <= ~q1 * q0 * ~p1init +
	       ~q1 * sysb * ~p1init +
	       ~q0 * ~test * sysb * ~p1busy * p1bprn * ~p1init;

//	$display("u718: aen=%b cbrqo=%b; q %b%b, p1init %b, sysb %b, test %b, p1cbrq %b p1busy %b p1bprn %b",
//		 aen, cbrqo, q1,q0, p1init, sysb, test, p1cbrq, p1busy, p1bprn);

	q1 <= ~q1 * ~p1cbrq * p1bprn * ~p1init +
	       ~q1 * q0 * ~p1init +
	       ~q1 * sysb * ~p1init +
	       q1 * ~q0 * ~p1busy * p1bprn * ~p1init;

	q0 <= ~q1 * ~q0 * ~p1cbrq * p1bprn * ~p1init +
	       q1 * ~q0 * p1busy * ~p1init +
	       q1 * ~q0 * ~p1bprn * ~p1init +
	       sysb * ~p1init;
     end

endmodule
