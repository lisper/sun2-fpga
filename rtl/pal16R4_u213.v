// PAL16R4
// Rev 1.1             Wed Aug 15 1984                    JM
// U213                DVMA Controller PAL for 120 cpu board
// Sun Microsystems Inc. Mt View CA

module pal16R4_u213(input D0,
		   input  D1,
		   input  D2,
		   input  D3,
		   input  D4,
		   input  D5,
		   input  D6,
		   input  D7,
		   inout  O0,
		   inout  O1,
		   output Q0,
		   output Q1,
		   output Q2,
		   output Q3,
		   output O2,
		   output O3,
		   input  CLK,
		   input  OE_n);

   wire c100, sysb, ben, sack, sas, p_bg, xreq, rreq, sds;
   wire p_back, p_br, fc1, p_as;
   reg 	xen, ren, xberr, xhalt;
       
   // c100 sysb /ben /sack /sas /p.bg /xreq /rreq /sds gnd
   assign c100 = CLK;
   assign sysb = D0;
   assign ben = ~D1;
   assign sack = ~D2;
   assign sas = ~D3;
   assign p_bg = ~D4;
   assign xreq = ~D5;
   assign rreq = ~D6;
   assign sds = ~D7;
   // /oe /p.back /p.br /xberr /xhalt /ren /xen fc1 /p.as vcc
   // notused notused notused notused
   assign O3 = ~p_back ;
   assign O2 = ~p_br;
   assign Q3 = ~xberr;
   assign Q2 = ~xhalt;
   assign Q1 = ~ren;
   assign Q0 = ~xen;
   assign O1 = p_back ? fc1 : 1'bz;
   assign O0 = p_back ? p_as : 1'bz;

//temp
//   assign p_back  = ren +
//		    xen;
   assign p_back = 0;

   assign p_br    = xreq * ~p_back +
		    rreq * ~p_back;
   
   assign fc1 = xen;     // SUPERVISOR DATA FOR XDMA

   assign p_as = sack * ren +
                 sack * xen * xreq;

   always @(posedge c100)
     begin
	xen <= ~xen * ~ren * p_bg * ~sas * ~rreq * sds +     // SET
               xen * sds;                                    // CLEAR

	ren <= ~xen * ~ren * p_bg * ~sas * rreq +     // STATE 0
               ren * ~sack +                          // STATE 1
               ren * ~sas;                            // STATE 2

	xberr <= sds * sysb * xhalt +                   // SET ON MULTIBUS DEADLOCK
		 rreq * ~ben * sysb * xhalt +           // SET ON REFRESH DEADLOCK
		 xberr * sas;                           // HOLD

        //ASSERT XHALT-
        //
	xhalt <= sds * sysb +                           // SET ON MULTIBUS DEADLOCK
		 rreq * ~ben * sysb +                   // SET ON REFRESH DEADLOCK
		 xberr;                                 // XBERR PLUS ONE STATE
   end

endmodule
