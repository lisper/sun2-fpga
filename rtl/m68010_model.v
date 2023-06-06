
module m68010_model(
		    input  C100,
		    input  P_VPA_n,
		    input  P_BERR_n,
		    input  P_DTACK_n,
		    input  P_BR_n,
		    output P_BGACK_n,

		    inout  P_RESET_n,
		    inout  P_HALT_n,

		    inout  P_AS_n,
		    inout  P_RW_n,
		    inout  P_UDS_n,
		    inout  P_LDS_n,
		    inout  P_BG_n,

		    input  IPL2_n,
		    input  IPL1_n,
		    input  IPL0_n,

		    output P_FC2,
		    inout  P_FC1,
		    output P_FC0,
   
		    inout  P_A1,
		    inout  P_A2,
		    inout  P_A3,
		    inout  P_A4,
		    inout  P_A5,
		    inout  P_A6,
		    inout  P_A7,
		    inout  P_A8,
		    inout  P_A9,
		    inout  P_A10,
		    inout  P_A11,
		    inout  P_A12,
		    inout  P_A13,
		    inout  P_A14,
		    inout  P_A15,
		    inout  P_A16,
		    inout  P_A17,
		    inout  P_A18,
		    inout  P_A19,
		    inout  P_A20,
		    inout  P_A21,
		    inout  P_A22,
		    inout  P_A23,

		    inout  P_D0,
		    inout  P_D1,
		    inout  P_D2,
		    inout  P_D3,
		    inout  P_D4,
		    inout  P_D5,
		    inout  P_D6,
		    inout  P_D7,
		    inout  P_D8,
		    inout  P_D9,
		    inout  P_D10,
		    inout  P_D11,
		    inout  P_D12,
		    inout  P_D13,
		    inout  P_D14,
		    inout  P_D15
		   );

   reg drive;

   reg [15:0] data;
   reg [23:0] addr;
   reg 	      drive_data, drive_addr, drive_bus;
   
   assign P_A1 = drive_addr ? addr[1] : 1'bz;
   assign P_A2 = drive_addr ? addr[2] : 1'bz;
   assign P_A3 = drive_addr ? addr[3] : 1'bz;
   assign P_A4 = drive_addr ? addr[4] : 1'bz;
   assign P_A5 = drive_addr ? addr[5] : 1'bz;
   assign P_A6 = drive_addr ? addr[6] : 1'bz;
   assign P_A7 = drive_addr ? addr[7] : 1'bz;
   assign P_A8 = drive_addr ? addr[8] : 1'bz;
   assign P_A9 = drive_addr ? addr[9] : 1'bz;
   assign P_A10 = drive_addr ? addr[10] : 1'bz;
   assign P_A11 = drive_addr ? addr[11] : 1'bz;
   assign P_A12 = drive_addr ? addr[12] : 1'bz;
   assign P_A13 = drive_addr ? addr[13] : 1'bz;
   assign P_A14 = drive_addr ? addr[14] : 1'bz;
   assign P_A15 = drive_addr ? addr[15] : 1'bz;
   assign P_A16 = drive_addr ? addr[16] : 1'bz;
   assign P_A17 = drive_addr ? addr[17] : 1'bz;
   assign P_A18 = drive_addr ? addr[18] : 1'bz;
   assign P_A19 = drive_addr ? addr[19] : 1'bz;
   assign P_A20 = drive_addr ? addr[20] : 1'bz;
   assign P_A21 = drive_addr ? addr[21] : 1'bz;
   assign P_A22 = drive_addr ? addr[22] : 1'bz;
   assign P_A23 = drive_addr ? addr[23] : 1'bz;

   assign P_D0 = drive_data ? data[0] : 1'bz;
   assign P_D1 = drive_data ? data[1] : 1'bz;
   assign P_D2 = drive_data ? data[2] : 1'bz;
   assign P_D3 = drive_data ? data[3] : 1'bz;
   assign P_D4 = drive_data ? data[4] : 1'bz;
   assign P_D5 = drive_data ? data[5] : 1'bz;
   assign P_D6 = drive_data ? data[6] : 1'bz;
   assign P_D7 = drive_data ? data[7] : 1'bz;
   assign P_D8 = drive_data ? data[8] : 1'bz;
   assign P_D9 = drive_data ? data[9] : 1'bz;
   assign P_D10 = drive_data ? data[10] : 1'bz;
   assign P_D11 = drive_data ? data[11] : 1'bz;
   assign P_D12 = drive_data ? data[12] : 1'bz;
   assign P_D13 = drive_data ? data[13] : 1'bz;
   assign P_D14 = drive_data ? data[14] : 1'bz;
   assign P_D15 = drive_data ? data[15] : 1'bz;

   reg [2:0]  ipl;
   reg [2:0]  fc;
   
//   assign IPL2_n = ipl[2];
//   assign IPL1_n = ipl[1];
//   assign IPL0_n = ipl[0];

   assign P_FC2 = fc[2];
   assign P_FC1 = drive_bus ? fc[1] : 1'bz;
   assign P_FC0 = fc[0];

   reg BGACK = 0;
   reg RESET = 0;
   reg HALT = 0;

   assign P_BGACK_n = BGACK;

   assign P_RESET_n = drive_bus ? ~RESET : 1'bz;
   //assign P_HALT_n = drive_bus ? ~HALT : 1'bz;

   reg AS;
   reg RW;
   reg UDS;
   reg LDS;
   reg BG;

   assign P_AS_n  = drive_bus ? ~AS : 1'bz;
   assign P_RW_n  = drive_bus ? ~RW : 1'bz;
   assign P_UDS_n = drive_bus ? ~UDS : 1'bz;
   assign P_LDS_n = drive_bus ? ~LDS : 1'bz;
   assign P_BG_n  = drive_bus ? ~BG : 1'bz;

   task wait_clock_high;
      while (~C100)
	begin
	   #1;
	end
   endtask

   task wait_clock_low;
      while (C100)
	begin
	   #1;
	end
   endtask

   task m68k_rw_ram(input [23:0] _addr,
		    input [2:0] _fc,
		    input 	read,
                    input [15:0] w_data);
      begin
	 $display("m68k_rw_ram(addr=%x, fc=%d)", _addr, _fc);
	 wait_clock_high;
	 // S0
	 fc = _fc;
	 addr = _addr;
	 wait_clock_low;
	 // S1
	 AS = 1;
	 wait_clock_high;
	 // S2
	 AS = 1;
	 UDS = 1;
	 LDS = 1;
	 RW = 0;
	 drive_bus = 1;
	 wait_clock_low;
	 // S3
	 if (read)
	   begin
	      drive_data = 0;
	      RW = 0;
	   end
	 else
	   begin
	      drive_data = 1;
	      RW = 1;
	      data = w_data;
	   end
	 drive_addr = 1;
	 wait_clock_high;
	 // S4
	 wait_clock_low;
	 // S5
	 wait_clock_high;
	 // S6
	 while (P_DTACK_n)
	   begin
//	      #1;
	      wait_clock_high;
	      wait_clock_low;
	   end

	 wait_clock_low;
	 wait_clock_high;

	 wait_clock_low;
	 wait_clock_high;

	 #40;
	 AS = 0;
	 UDS = 0;
	 LDS = 0;

	 while (~P_DTACK_n)
	   begin
//	      #1;
	      wait_clock_low;
	      wait_clock_high;
	   end

	 wait_clock_low;
	 wait_clock_high;

	 //
	 #1 drive_data = 0;
	 $display("m68k_rw_ram(addr=%x, fc=%d) done", _addr, _fc);
      end
   endtask

   
   initial
     begin
	BGACK = 0;
	RESET = 0;
	HALT = 0;

	ipl = 0;
	fc = 0;

	AS = 0;
	RW = 0;
	UDS = 0;
	LDS = 0;
	BG = 0;
	
	data = 0;
	addr = 0;
	drive_data = 0;
	drive_addr = 0;
	drive_bus = 0;
     end
endmodule
