
module ttl_Z8530 (inout [7:0] D,
		  input WRFQA_n,
		  input WRFQB_n,
		  input IFI_n,
		  output IFO_n,
		  output INT,
		  input INTA_n,
		  input AB_n,
		  input DC_n,
		  input CE_n,
		  input RD_n,
		  input WR_n,
		  input PCLK,
		  output TXCA_n,
		  input RXCA_n,
		  output TXDA,
		  input RXDA,
		  output RTSA_n,
		  output CTSA_n,
		  output DTRA_n,
		  output DCDA_n,
		  output DSRA_n,
		  output TXCB_n,
		  output RXCB_n,
		  output TXDB,
		  output RXDB,
		  output RTSB_n,
		  output CTSB_n,
		  output DTRB_n,
		  output DCD_n,
		  output DSRN_n);

   wire clk;
   assign clk = PCLK;

   wire [1:0] addr;
   assign addr = { AB_n, DC_n };
   
   always @(posedge clk)
     if (~RD_n)
       begin
	  $display("scc: read %d", addr);
       end
   
   always @(posedge clk)
     if (~WR_n)
       begin
	  $display("scc: write %d", addr);
       end
   
   assign D = 8'bz;
   
endmodule
