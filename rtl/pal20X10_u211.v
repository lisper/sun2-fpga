// PAL20X10
// Rev 1.1			Wed Jul  4 1984
// U211		Timer controller PAL for 120 cpu board
// Sun Microsystems Inc, Mt View CA

module pal20X10_u211 (input I0,
		      input  I1,
		      input  I2,
		      input  I3,
		      input  I4,
		      input  I5,
		      input  I6,
		      input  I7,
		      input  I8,
		      input  I9,
		      output O0,
		      output O1,
		      output O2,
		      output O3,
		      output O4,
		      output O5,
		      output O6,
		      output O7,
		      output O8,
		      output O9,
		      input  CLK,
		      input OE_n);

   wire c100, c200, por, sysb, sds, initin, ren, p_halt, as, tin;
   reg q0=0, q1=0, q2=0, q3=0, q4=0, q5=0, rreq, init = 0, t=0, timeout = 0;
   
   // c100 /c200 /por sysb /sds /initin notused /ren /p.halt /as tin gnd
   assign c100 = CLK;
   assign c200 = I0;
   assign por = ~I1;
   assign sysb = I2;
   assign sds = ~I3;
   assign initin = ~I4;
   assign ren = ~I6;
   assign p_halt = ~I7;
   assign as = ~I8;
   assign tin = I9;
   
   // /oe /timeout /t /init /rreq /q5 /q4 /q3 /q2 /q1 /q0 vcc
   assign O0 = ~q0;
   assign O1 = ~q1;
   assign O2 = ~q2;
   assign O3 = ~q3;
   assign O4 = ~q4;
   assign O5 = ~q5;
   assign O6 = ~rreq;
   assign O7 = ~init;
   assign O8 = ~t;
   assign O9 = ~timeout;

//
// Macros
//
//#define Q7-	/t
//#define Q6-	/rreq
//#define CY4	c200
//#define CY8	CY4 * q0
//#define CY16	CY8 * q1
//#define CY32	CY16 * q2
//#define CY64	CY32 * q3
//#define CY128	CY64 * q4
//#define CY256	CY128 * q5
//#define CY512	CY256 * /Q6-
//#define CY1024	CY512 * /Q7-
//
//q0	:= q0 + por :+:   // C400
//	   CY4 * /por
//
//q1	:= q1 1 por :+:   // C800
//	   CY8 * /por
//
//q2	:= q2 + por :+:   // C1600
//	    CY16 * /por
//
//q3	:= q3 + por :+:   // C3200
//	   CY32 * /por
//
//q4	:= q4 + por :+:   // C6400
//	   CY64 * /por
//
//q5	:= q5 + por :+:   // C12800
//	   CY128 * /por
//
//rreq	:= rreq * /ren +
//	   CY256 * /ren
//
//init	:= init + por :+:
//	   //
//	   // watchdog reset!
//	   //
//	   CY256 * p.halt * /sds * /sysb
//	     * /por
//
//t	:= t * as :+:
//	   CY128 * as
//
//timeout	:= timeout * as +
//	   tin * as

   always @(posedge c100)
     begin
	q0 <= q0 + por ^ // C400
	      c200 * ~por;
	
	q1 <= q1 + por ^ // C800
	      c200 * q0 * ~por;

	q2 <= q2 + por ^ // C1600
	      c200 * q0 * q1 * ~por;
	
	q3 <= q3 + por ^ // C3200
	      c200 * q0 * q1 * q2 * ~por;
	
	q4 <= q4 + por ^ // C6400
	      c200 * q0 * q1 * q2 * q3 * ~por;

	q5 <= q5 + por ^ // C12800
	      c200 * q0 * q1 * q2 * q3 * q4 * ~por;

	rreq <= rreq * ~ren +
		c200 * q0 * q1 * q2 * q3 * q4 * q5 * ~ren;

//	init <= init + por ^
		//
		// watchdog reset!
		//
//		c200 * q0 * q1 * q2 * q3 * q4 * q5 * p_halt * ~sds * ~sysb * ~por;
//temp
	init <= init + por;
	
	
	t <= t * as ^
	     c200 * q0 * q1 * q2 * q3 * q4 * as;
	
	timeout <= timeout * as +
		   tin * as;
     end

endmodule
