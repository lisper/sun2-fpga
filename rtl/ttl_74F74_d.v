   
module ttl_74F74_d(input D,
		 input 	CLK,
		 input 	S,
		 input 	R,
		 output Q,
		 output Q_n);

   reg q = 0;
   
   always @(posedge CLK or negedge R or negedge S)
     begin
         if (~R)
	   begin
              q <= 0;
	      $display("%d q<-0; R %b", $time, R);
	   end
         else if (~S)
	   begin
              q <= 1;
	      $display("%d q<-1; S %b", $time, S);
	   end
         else
	   begin
             q <= D;
	      $display("%d q<-d %d", $time, D);
	   end
     end

   assign Q = q;
   assign Q_n = ~q;
   
endmodule
