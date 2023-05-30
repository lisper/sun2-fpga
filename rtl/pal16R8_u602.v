// PAL16R8                    u602           dcpctl
// Rev 0.1                    Aug 15 1984    JM
// 120 CPU DCP Control pal
// JM Sun Microsystems Inc               Mt View, CA

module pal16R8_u602 (input D0,
		     input D1,
		     input D2,
		     input D3,
		     input D4,
		     input D5,
		     input D6,
		     input D7,
		     output Q0_n,
		     output Q1_n,
		     output Q2_n,
		     output Q3_n,
		     output Q4_n,
		     output Q5_n,
		     output Q6_n,
		     output Q7_n,
		     input CLK,
		     input OE_n);

   wire clk, sanity, wrdcp, rddcp, la1;
   reg ack, mds, mas, q2 = 0, q1 = 0, q0 = 0, x400 = 0, x200 = 0;
       
   // clk /sanity vcc vcc /wrdcp /rddcp vcc la1 vcc gnd
   assign clk = CLK;
   assign sanity = ~D0;
   assign wrdcp = ~D3;
   assign rddcp = ~D4;
   assign la1 = D6;
   
   // /oe /mas /mds q0 /x400 /x200 /ack q1 q2 vcc
   assign Q7_n = ~mds;
   assign Q6_n = ~mas;
   assign Q5_n = q0;
   assign Q4_n = ~x400;
   assign Q3_n = ~x200;
   assign Q2_n = ~ack;
   assign Q1_n = q1;
   assign Q0_n = q2;

   always @(posedge clk)
     begin

	ack <= ~q2 * q1 * ~sanity +
	       q2 * ~q1 * q0 * x200 * ~sanity +
	       q1 * ~q0 * ~x200 * ~sanity;
	
	mds <= q2 * ~q1 * q0 * x200 * ~sanity +
	       q2 * q1 * ~q0 * ~sanity +
	       q2 * q1 * ~x200 * ~x400 * ~la1 * rddcp * ~sanity +
	       q2 * q1 * ~x200 * ~x400 * ~la1 * wrdcp * ~sanity;
	
	mas <= ~q2 * q1 * q0 * ~sanity +
	       q1 * q0 * la1 * rddcp * ~sanity +
	       q1 * q0 * la1 * wrdcp * ~sanity;
	
	q2 <= ~q2 * q1 * q0 * ~sanity +
	       q1 * q0 * la1 * rddcp * ~sanity +
	       q1 * q0 * la1 * wrdcp * ~sanity;
	
	q1 <= q2 * ~q1 * q0 * x200 *~sanity +
	       q2 * q1 * ~q0 * ~x200 * ~sanity;

	q0 <= ~q2 * q1 * q0 * ~sanity +
	       q2 * q1 * ~q0 * x200 * ~sanity +
	       q1 * q0 * ~x200 * ~x400 * ~la1 * rddcp * ~sanity +
	       q1 * q0 * ~x200 * ~x400 * ~la1 * wrdcp * ~sanity;

	x400 <= x400 * x200 * ~sanity +
		~x400 * ~x200 * ~sanity;

	x200 <= ~x200 * ~sanity;

     end
   

endmodule
