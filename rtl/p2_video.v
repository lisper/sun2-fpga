// DISPLAY
// 1152x900
// 128k video memory (131072 bytes, 0x20000)
// 0x0070_0000 - 0x0071_ffff

module p2_video(input clk,
	      input [22:0] addr,
	      input 	   decode,
	      input 	   decode_ctl,
	      input 	   wel_n,
	      input 	   weu_n,
	      input 	   go_n, 
	      inout 	   wait_n,
	      input [15:0] datai,
	      inout [15:0] datao);

   wire we_en, en_0, ctrl;
   assign we_en = ~wel_n | ~weu_n;
   assign en_0 = ~go_n & decode;
   assign ctrl = ~go_n & decode_ctl;
   
   wire [16:0] vram_addr;
   assign vram_addr = addr[16:0];

   always @(posedge clk)
     if (~go_n & ~we_en)
       begin
	  if (en_0) $display("video write %x ", vram_addr);
	  if (ctrl) $display("ctrl write %x", vram_addr);
       end

   always @(posedge clk)
     if (~go_n & we_en)
     begin
	if (en_0) $display("video read %x", vram_addr);
	if (ctrl) $display("ctrl read %x", vram_addr);
     end
   
   dpram_128k vram(.clk(clk),
		   .wr_en(we_en),
		   .data_in(datai),
		   .data_out_0(datao),
		   .data_out_1(),
		   .addr_0(vram_addr),
		   .addr_1(),
		   .en_0(en_0),
		   .en_1()
		   );
   
endmodule
