module p2_ram(input clk,
	      input [22:0]  addr,
	      input 	    decode,
	      input 	    wel_n,
	      input 	    weu_n,
	      input 	    rw_n,
	      input 	    go_n, 
	      inout 	    wait_n,
	      input [15:0]  datao,
	      output [15:0] datai);

   wire we_en;
   assign we_en = ~wel_n & ~weu_n;

   always @(posedge we_en)
     if (~go_n) $display("dram rw");

endmodule
