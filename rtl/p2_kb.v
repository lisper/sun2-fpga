module p2_kb(input clk,
	      input [22:0]  addr,
	      input 	    decode,
	      input 	    wel_n,
	      input 	    weu_n,
	      input 	    rw_n,
	      input 	    go_n, 
	      inout 	    wait_n,
	      input [15:0]  datao,
	      output [15:0] datai);
endmodule
