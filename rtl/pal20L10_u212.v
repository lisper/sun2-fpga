// PAL20L10
// Rev 1.1         Aug 15 1984             JM
// U212            DVMA Decoder Pal for 120 cpu board
// Sun Microsystems Inc, Mt View CA

module pal20L10_u212(input I0,
		      input  I1,
		      input  I2,
		      input  I3,
		      input  I4,
		      input  I5,
		      input  I6,
		      input  I7,
		      input  I8,
		      input  I9,
		      input  I10,
		      input  I11,
		      output O0,
		      input  O1,
		      output O2,
		      input  O3,
		      inout  O4,
		      inout  O5,
		      inout  O6,
		      output O7,
		      output O8,
		      output O9);

   wire ce_word, ce_byte, pltop, p_wr, p_lds, p_uds, p1_xack, xeq;
   wire p1_a18, p1_a19, p1_a0, p1_bhen,  p1_mrdc,  p1_mrwc;
   wire proterr, en_dvma, c_s7, parerr, mrdc;
   wire aen, iorc, xreq, xen;

   // /p1.a18 /p1.a19 /p1.a0 /p1.bhen /p1.mrdc /p1.mrwc
   // /proterr en.dvma c.s7 parerr /mrdc gnd
   assign p1_a18 = I0;
   assign p1_a19 = I1;
   assign p1_a0 = I2;
   assign p1_bhen = ~I3;
   assign p1_mrdc = ~I4;
   assign p1_mrwc = ~I5;
   assign proterr = ~I6;
   assign en_dvma = I7;
   assign c_s7 = I8;
   assign parerr = I9;
   assign mrdc = ~I10;

   // /iorc /ce.word /ce.byte /p1.xack /p.uds /p.lds
   // /p.wr /xen /xreq /aen /pltop vcc
   assign iorc = ~I11;
   assign O0 = ~pltop;
   assign aen = ~O1;
   assign O2 = ~xreq;
   assign xen = ~O3;
   assign O4 = xen ? ~p_wr : 1'bz;
   assign O5 = xen ? ~p_lds : 1'bz;
   assign O6 = xen ? ~p_uds : 1'bz;
   assign O7 = xen ? ~p1_xack : 1'bz;
   assign O8 = ~ce_byte;
   assign O9 = ~ce_word;

   assign ce_word = aen * p_lds +                 // CPU CYCLE R/W LOW BYTE/WORD
		    aen * p_wr +                  // CPU WRITE
		    xen * p_lds;                  // DVMA CYCLE (R/W LOW BYTE/WORD)

   assign ce_byte = aen * ~p_lds * p_uds * ~p_wr + // CPU CYCLE (READ UPPER BYTE)
		    xen * ~p_lds * p_uds;          // DVMA CYCLE (R/W UPPER BYTE)

   assign pltop   = ~xen * mrdc +                  // NON_DVMA MRDC CYCLE
		    ~xen * iorc +                  // NON_DVMA IODC CYCLE
		    xen * p_wr;                    // DVMA WRITE CYCLE CONDITION

   // ASSERTED ON DVMA CYCLES ONLY
   assign p_wr = p1_mrwc * ~p1_mrdc * ~c_s7 +  // SET
		 p_wr * ~p1_mrdc;              // HOLD

   // ASSERTED ON DVMA CYCLES ONLY
   assign p_lds = ~p1_a0 * xreq * xen +        // EVEN BYTE
		  p1_bhen * xreq * xen +       // WORD
		  p_lds * p1_mrwc;             // HOLD

   // ASSERTED ON DVMA CYCLES ONLY
   assign p_uds = p1_a0 * xreq * xen +         // ODD BYTE
		  p1_bhen * xreq * xen +       // WORD
		  p_uds * p1_mrwc;             // HOLD

   // ASSERTED ON DVMA CYCLES ONLY
   assign p1_xack = c_s7 * p1_mrdc * ~proterr * ~parerr + // DVMA READ CYCLE
		    c_s7 * p1_mrwc * ~p1_mrdc * ~proterr; // DVMA WRITE CYCLE

   assign xreq = en_dvma * ~p1_a19 * ~p1_a18 * p1_mrwc * ~aen * ~xen +  // SET
		 xreq * p1_mrwc;                                        // HOLD

endmodule

