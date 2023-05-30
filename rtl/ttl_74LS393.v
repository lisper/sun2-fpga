
module ttl_74LS393(input A,
		   input  B,
		   output A0,
		   output A1,
		   output A2,
		   output A3,
		   output B0,
		   output B1,
		   output B2,
		   output B3,
		   input  CA,
		   input  CB);

   reg [3:0] c1 = 0, c2 = 0;

   always @(posedge A or posedge CA)
     if (CA)
       c1 <= 4'b0000;
     else
       c1 <= c1 + 4'b0001;

   assign A0 = c1[0];
   assign A1 = c1[1];
   assign A2 = c1[2];
   assign A3 = c1[3];
   
   always @(posedge B or posedge CB)
     if (CB)
       c2 <= 4'b0000;
     else
       c2 <= c2 + 4'b0001;

   assign B0 = c2[0];
   assign B1 = c2[1];
   assign B2 = c2[2];
   assign B3 = c2[3];
   
endmodule
