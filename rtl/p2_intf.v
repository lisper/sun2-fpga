
module p2_intf(input clk,
	       input [22:0] addr,
	       input 	    ras_n,
	       input 	    cas_n,
	       input 	    wel_n,
	       input 	    weu_n,
	       input 	    rw_n,
	       input 	    go_n, 
	       inout 	    wait_n,
	       input [15:0] datai,
	       inout [15:0] datao);

// 23 bits
// 000000 memory 1-4Mbytes
// 700000 frame buffer
// 780000 keyboard/mouse scc
// 781800 video control register

   wire [3:0] decode;
   assign decode = 
		   addr[22:16] == 7'h00   ? 4'b0001 :
		   addr[22:16] == 7'h70   ? 4'b0010 :
		   addr[22:12] == 12'h780 ? 4'b0100 :
		   addr[22:12] == 12'h781 ? 4'b1000 :
                                            4'b0000;
   
   wire ram_io, fb_io, kb_io, vdc_io;
   assign ram_io = decode[0];
   assign fb_io = decode[1];
   assign kb_io = decode[2];
   assign vdc_io = decode[3] & addr[11];

   always @(posedge clk)
     begin
//	if (~go_n && ram_io) $display("p2: ram_io %x", addr);
	if (~go_n && fb_io) $display("p2: fb_io %x", addr);
	if (~go_n && kb_io) $display("p2: kb_io %x", addr);
	if (~go_n && vdc_io) $display("p2: vdc_io %x", addr);

	if (~go_n && ram_io)
	  begin
	     if (addr != 23'h2800)
	       begin
		  //$display("XXX %x %b", addr, addr);
		  //$dumpon;
		  //$pli_cosim(0, 1, 0, 10);
		  //tb.cpu_trace = 1;
	       end
	  end
     end
   
   p2_ram uram(.clk(clk),
	    .addr(addr),
	    .decode(ram_io),
	    .wel_n(wel_n),
	    .weu_n(weu_n),
	    .rw_n(rw_n),
	    .go_n(go_n),
	    .wait_n(wait_n),
	    .datai(datai),
	    .datao(datao));
   
   p2_video uvideo(.clk(clk),
		   .addr(addr),
		   .decode(fb_io),
		   .decode_ctl(vdc_io),
		   .wel_n(wel_n),
		   .weu_n(weu_n),
		   .go_n(go_n),
		   .wait_n(wait_n),
		   .datai(datai),
		   .datao(datao));
   
   p2_kb ukb(.clk(clk),
	    .addr(addr),
	    .decode(kb_io),
	    .wel_n(wel_n),
	    .weu_n(weu_n),
	    .rw_n(rw_n),
	    .go_n(go_n),
	    .wait_n(wait_n),
	    .datai(datai),
	    .datao(datao));
   
endmodule

