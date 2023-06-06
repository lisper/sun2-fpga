
module ttl_74F251(
		  input D0,
		  input D1,
		  input D2,
		  input D3,
		  input D4,
		  input D5,
		  input D6,
		  input D7,
		  input A,
		  input B,
		  input C,
		  input G_n,
		  inout Y,
		  inout W);

   wire mux;
   wire [2:0] sel;
   
   assign sel = {A, B, C};

   assign mux =
	       sel == 0 ? D0 :
	       sel == 1 ? D1 :
	       sel == 2 ? D2 :
	       sel == 3 ? D3 :
	       sel == 4 ? D4 :
	       sel == 5 ? D5 :
	       sel == 6 ? D6 :
	       D7;

   always @(sel or D0 or D1 or D2 or D3 or D4 or D5 or D6 or D7 or mux or A or B or C)
     begin
	$display("74f251; sel %b, mux %x, ABC %b%b%b D %b%b%b",
		 sel, mux, A, B, C, D5, D6, D7);
     end
   
   assign Y = ~G_n ? ~mux : 1'bz;
   assign W = ~G_n ? mux : 1'bz;
   
endmodule
