// Should infer to dual port sync ram - 128kbytes

module dpram_128k(input clk,
		  input 	wr_en,
		  input [15:0] 	data_in,
		  output [15:0] data_out_0,
		  output [15:0] data_out_1,
		  input [16:0] 	addr_0,
		  input [16:0] 	addr_1,
		  input 	en_0,
		  input 	en_1
		  );

   reg [15:0] ram[0:131071];
   reg [15:0] do_0 = 0;
   reg [15:0] do_1 = 0;
   
   always @(posedge clk)
     begin
	if (en_0 && wr_en)
	  ram[addr_0] <= data_in;
     end

   always @(posedge clk)
     begin
	if (en_0)
	  do_0 <= ram[addr_0];
     end

   always @(posedge clk)
     begin
	if (en_1)
	  do_1 <= ram[addr_1];
     end

   assign data_out_0 = do_0;
   assign data_out_1 = do_1;
   
endmodule

   
