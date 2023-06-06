// PAL16R6              u415            PAL DESIGN SPECIFICATIØN
// 120 CPU BOARD                        KB 06/12/84
// I/O ACKNOWLEDGE AND TOD RD/WR CONTROL SIGNAL GENERATOR
// SUN MICROSYSTEMS

module pal16R4_u415 (input D0,
		   input D1,
		   input D2,
		   input D3,
		   input D4,
		   input D5,
		   input D6,
		   input D7,
		   output Q0,
		   output Q1,
		   output Q2,
		   output Q3,
		   output Q4,
		   output Q5,
		   output O1,
		   output O2,
		   input CLK,
		   input OE_n);

   // /CLK100 MA14 MA13 MA12 MA11 /RDIO /WRIO CS7 CS5 GND
   wire CLK100, MA14, MA13, MA12, MA11, RDIO, WRIO, CS7, CS5;
   
   assign CLK100 = ~CLK;
   assign MA14 = D0;
   assign MA13 = D1;
   assign MA12 = D2;
   assign MA11 = D3;
   assign RDIO = ~D4;
   assign WRIO = ~D5;
   assign CS7 = D6;
   assign CS5 = D7;
   
   // GND /RDRTC /IOACK NC IQ0 IQ1 IQ2 IQ3 /WRRTC VCC
   wire	RDRTC, WRRTC;
   
   reg IOACK = 0, IQ0 = 0, IQ1 = 0, IQ2 = 0, IQ3 = 0;
   
   assign O1 = ~WRRTC;
   assign O2 = ~RDRTC;
   assign Q5 = ~IOACK;
   
   assign RDRTC = ~MA14 * MA13 * MA12 * MA11 * RDIO * CS7;  //58167 read strobe
   
   assign WRRTC = ~MA14 * MA13 * MA12 * MA11 * WRIO *      //58167 write strobe
                                        CS7 * ~IOACK;      //which goes inactive
                                                           //when IOACK active

   always @(posedge CLK100)
     begin							    
        //RD / WR ACK for the Parallel Port ( 2 wait states )
        IOACK <= ~MA14 * ~MA13 * MA12 * MA11 * RDIO * CS5 +
                 ~MA14 * ~MA13 * MA12 * MA11 * WRIO * CS5 +
                 //RD / WR ACK for PROM, SCC, Timer ( 2 wait states )
                 ~MA14 * ~MA12 * RDIO * CS5 +
                 ~MA14 * ~MA12 * WRIO * CS5 +
                 //RD /WR ACK for 58167 when the counter is equal to 10 or 11
                 // ( 12 wait states )
                 ~MA14 * MA13 * MA12 * MA11 * RDIO * IQ3 * ~IQ2 * IQ1 * CS5 +
                 ~MA14 * MA13 * MA12 * MA11 * WRIO * IQ3 * ~IQ2 * IQ1 * CS5;

        IQ0 <= ~CS5 +                                   // reset
               CS5 *  IQ0 * ~IOACK +                    // toggle
               CS5 * ~IQ0 *  IOACK;                     // hold at eleven

        IQ1 <= ~CS5 +                                   // reset
               CS5 * ~IQ1 * ~IQ0 +                      // hold
               CS5 *  IQ1 *  IQ0 * ~IOACK +             // toggle
               CS5 * ~IQ1 *  IOACK;                     // hold at eleven

        IQ2 <= ~CS5 +                                   // reset
               CS5 * ~IQ2 * ~IQ0 +                      // hold
               CS5 * ~IQ2 * ~IQ1 +                      // hold
               CS5 *  IQ2 *  IQ1 *  IQ0 * ~IOACK +      // toggle
               CS5 * ~IQ2 *  IOACK;                     // hold at eleven

        IQ3 <= ~CS5 +                                   // reset
               CS5 * ~IQ3 * ~IQ0 +                      // hold
               CS5 * ~IQ3 * ~IQ1 +                      // hold
               CS5 * ~IQ3 * ~IQ2 +                      // hold
               CS5 *  IQ3 *  IQ2 * IQ1 * IQ0 * ~IOACK + // toggle
               CS5 * ~IQ2 *  IOACK;                     // hold at eleven
     end
   
endmodule
