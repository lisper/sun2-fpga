
module p2_intf(input clk,
	       input [22:0]  addr,
	       input 	     ras_n,
	       input 	     cas_n,
	       input 	     wel_n,
	       input 	     weu_n,
	       input 	     rw_n,
	       input 	     go_n, 
	       inout 	     wait_n,
	       input [15:0]  datao,
	       output [15:0] datai);

// 23 bits
// 000000 memory 1-4Mbytes
// 700000 frame buffer
// 780000 keyboard/mouse scc
// 781800 video control register

   wire [3:0] decode;
   assign decode = 
		   addr[22:16] == 7'h00 ? 4'b1110 :
		   addr[22:16] == 7'h70 ? 4'b1101 :
		   addr[22:12] == 12'h780 ? 4'b1011 :
		   addr[22:12] == 12'h781 ? 4'b0111 :
		   4'b1111;
   
   wire ram_io, fb_io, kb_io, vdc_io;
   assign ram_io = decode[0];
   assign fb_io = decode[1];
   assign kb_io = decode[2];
   assign vdc_io = decode[3];

   p2_ram uram(.clk(clk),
	    .addr(addr),
	    .decode(ram_io),
	    .wel_n(wel_n),
	    .weu_n(weu_n),
	    .rw_n(rw_n),
	    .go_n(go_n),
	    .wait_n(wait_n),
	    .datai(datao),
	    .datao(datai));
   
   p2_video uvideo(.clk(clk),
		   .addr(addr),
		   .decode(fb_io),
		   .decode_ctl(vdc_io),
		   .wel_n(wel_n),
		   .weu_n(weu_n),
		   .go_n(go_n),
		   .wait_n(wait_n),
		   .datai(datao),
		   .datao(datai));
   
   p2_kb ukb(.clk(clk),
	    .addr(addr),
	    .decode(kb_io),
	    .wel_n(wel_n),
	    .weu_n(weu_n),
	    .rw_n(rw_n),
	    .go_n(go_n),
	    .wait_n(wait_n),
	    .datai(datao),
	    .datao(datai));
   
endmodule

