module ttl_am9513 (inout [15:0] D,
		   input  CD_n,
		   input  CS_n,
		   input  RD_n,
		   input  WR_n,
		   input  X1,
		   input  X2,
		   input  FOUT,
		   input  SRC1,
		   input  SRC2,
		   input  SRC3,
		   input  SRC4,
		   input  SRC5,
		   input  SRC6,
		   input  GAT1,
		   input  GAT2,
		   input  GAT3,
		   input  GAT4,
		   input  GAT5,
		   output OUT1,
		   output OUT2,
		   output OUT3,
		   output OUT4,
		   output OUT5);

   reg [15:0] data_out = 0;
   reg [15:0] status_out = 0;
   wire read, write, clk;
   wire [15:0] bus_out;

   reg [15:0] cmd = 0;
   reg [15:0] data_in = 0;
   
   assign clk = X2;
   assign read = ~RD_n & ~CS_n;
   assign write = ~WR_n & ~CS_n;

   assign bus_out = CD_n ? status_out : data_out;
   assign D = read ? bus_out : 16'bz;

   always @(posedge read) $display("am9513: read cd_n %b; bus %x D %x", CD_n, bus_out, D);
   always @(posedge write) $display("am9513: write cd_n %b; bus %x D %x", CD_n, bus_out, D);

   always @(posedge clk)
     begin
	status_out = 16'h0b00;
	data_out = 16'h0b00;
     end

   always @(posedge clk)
     if (write) begin
	if (CD_n)
	  begin
	     cmd <= D;
	  end
	else
	  begin
	     data_in <= D;
	  end
     end
   
endmodule

