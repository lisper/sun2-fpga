module p2_ram(input clk,
	      input [22:0] addr,
	      input 	   decode,
	      input 	   wel_n,
	      input 	   weu_n,
	      input 	   rw_n,
	      input 	   go_n, 
	      inout 	   wait_n,
	      input [15:0] datai,
	      inout [15:0] datao);

   wire wr_en, en;
   assign wr_en = ~wel_n & ~weu_n;
   assign en = ~go_n;
   
   // for sim only
   reg [7:0] ramh[0:262143];
   reg [7:0] raml[0:262143];
   reg [15:0] do = 0;

   wire [21:0] b_addr;
   assign b_addr = addr[22:1];
   
   always @(posedge clk)
     begin
	if (en && wr_en)
	  begin
	     if (addr <= 524287)
	       begin
		  if (~wel_n)
		    raml[b_addr] <= datai[7:0];
		  if (~weu_n)
		    ramh[b_addr] <= datai[15:8];
	       end
	     if (~wel_n && ~weu_n)
	       $display("p2_ram: %x <- %x", addr, datai);
	     else
	       if (~wel_n)
		 $display("p2_ram: %x <- %x (b)", addr, datai[7:0]);
	       else
		 if (~weu_n)
		   $display("p2_ram: %x <- %x (b)", addr, datai[15:8]);
	  end
     end

   always @(posedge clk)
     begin
	if (en && ~wr_en)
	  begin
	     if (addr <= 524287)
	       begin
		  do <= { ramh[b_addr], raml[b_addr] };
		  $display("p2_ram: %x -> %x", addr, { ramh[b_addr], raml[b_addr] });
	       end
	     else
	       if (addr < 4096*1024)
		 begin
		    do <= 16'hffff;
		    $display("p2_ram: %x -> %x", addr, 16'hffff);
		 end
	  end
     end

   assign datao = (en & ~wr_en) ? do : 16'bz;
   
endmodule
