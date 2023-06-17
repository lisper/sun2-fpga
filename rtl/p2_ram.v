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
   reg [15:0] ram[0:524287];
   reg [15:0] do = 0;

   always @(posedge clk)
     begin
	if (en && wr_en)
	  begin
	     if (addr <= 524287)
	       ram[addr] <= datai;
	     $display("p2_ram: %x <- %x", addr, datai);
	  end
     end

   always @(posedge clk)
     begin
	if (en && ~wr_en)
	  begin
	     if (addr <= 524287)
	       do <= ram[addr];
	     else
	       do <= 16'hffff;
	     
	     $display("p2_ram: %x -> %x", addr, ram[addr]);
	  end
     end

   assign datao = (en & ~wr_en) ? do : 16'bz;
   
endmodule
