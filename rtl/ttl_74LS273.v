// octal D type flip flop with clear

module ttl_74LS273(input D1,
		   input D2,
		   input D3,
		   input D4,
		   input D5,
		   input D6,
		   input D7,
		   input D8,
		   output Q1,
		   output Q2,
		   output Q3,
		   output Q4,
		   output Q5,
		   output Q6,
		   output Q7,
		   output Q8,
		   input CK,
		   input CR_n);

   wire [7:0] in;
   reg [7:0]  r;

   assign in = { D8,D7,D6,D5,D4,D3,D2,D1 };
   
   always @(posedge CK or negedge CR_n)
     if (~CR_n)
       r <= 8'b0;
     else
       r <= in;
   
   assign Q1 = r[0];
   assign Q2 = r[1];
   assign Q3 = r[2];
   assign Q4 = r[3];
   assign Q5 = r[4];
   assign Q6 = r[5];
   assign Q7 = r[6];
   assign Q8 = r[7];
   
endmodule

