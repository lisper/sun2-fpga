module ttl_2168_sram(
		     input  A0,
		     input  A1,
		     input  A2,
		     input  A3,
		     input  A4,
		     input  A5,
		     input  A6,
		     input  A7,
		     input  A8,
		     input  A9,
		     input  A10,
		     input  A11,
		     input  WE_n,
		     input  CE_n,
		     inout D0,
		     inout D1,
		     inout D2,
		     inout D3,
		     input [3:0] id
		     );

   wire [11:0] addr;
   wire [3:0]  data;
   reg [3:0]   ram[0:4095];

   task init;
      integer a;
      begin
	 // random value?
	 for (a = 0; a <= 4095; a = a + 1) ram[a] = 4'b0;
      end
   endtask
   
   initial
     begin
	init;
     end
   
   assign addr = { A11, A10, A9, A8, A7, A6, A5, A4, A3, A2, A1, A0 };
   assign data = ram[addr];

   always @(addr or WE_n or CE_n)
     begin
	if (~WE_n) begin

	   ram[addr] = { D3, D2, D1, D0 };
	   //$display("ram u30%x [%x] <- %x; %t", id, addr, { D3,D2,D1,D0 }, $time); 
	end

	if (~CE_n & WE_n) begin
	   //$display("ram u30%x [%x] -> %x; %t", id, addr, data, $time); 
	end
     end
   
   assign D0 = (~CE_n & WE_n) ? data[0] : 1'bz;
   assign D1 = (~CE_n & WE_n) ? data[1] : 1'bz;
   assign D2 = (~CE_n & WE_n) ? data[2] : 1'bz;
   assign D3 = (~CE_n & WE_n) ? data[3] : 1'bz;

endmodule
