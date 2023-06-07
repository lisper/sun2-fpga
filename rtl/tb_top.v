`timescale 1ns/1ns

`include "top_ttl.v"

module tb();
   reg clk40;

   top dut(.clk40(clk40));

   task test_eeprom;
      begin
	 dut.m68010.m68k_rw_ram(24'h00000000, 6, 1, 16'h0000);
	 dut.m68010.m68k_rw_ram(24'h00000002, 6, 1, 16'h0000);
	 dut.m68010.m68k_rw_ram(24'h00000004, 6, 1, 16'h0000);
	 dut.m68010.m68k_rw_ram(24'h00000006, 6, 1, 16'h0000);
	 dut.m68010.m68k_rw_ram(24'h00000008, 6, 1, 16'h0000);
	 dut.m68010.m68k_rw_ram(24'h0000000a, 6, 1, 16'h0000);
	 dut.m68010.m68k_rw_ram(24'h0000000c, 6, 1, 16'h0000);
	 dut.m68010.m68k_rw_ram(24'h0000000f, 6, 1, 16'h0000);
      end
   endtask

   task test_mmu_regs;
      begin
	 // id
	 dut.m68010.m68k_rw_ram(24'h00000008, 3, 1, 16'h0000); // read
	 // diag
	 dut.m68010.m68k_rw_ram(24'h0000000a, 3, 0, 16'h00a5); // write
	 // bus error reg
	 dut.m68010.m68k_rw_ram(24'h0000000c, 3, 1, 16'h0000); // read
	 // enable
	 dut.m68010.m68k_rw_ram(24'h0000000e, 3, 1, 16'h0000); // read
	 dut.m68010.m68k_rw_ram(24'h0000000e, 3, 0, 16'h00ff); // write
      end
   endtask

   task setup_pmap;
      begin
	 // setup pagemap
	 // ma14..ma11
	 // 0000_0000
	 // 1111 11
	 // 5432 1098 7654 3210
	 //  xxx x
	 //  000 0               0000
	 //  000 1               0800
	 //  001 0               1000
	 //  001 1               1800
	 //  010 0               2000
	 //  011 0               3000

	 // VA
	 // 23          15      11                  1   0
	 // ----------------------------------------------
	 // |     (9)    |  (4)  |       (10)        |(1)|
	 // ----------------------------------------------
	 // segment #     page #      word #          byte #
	 //
	 // Context
	 // 23             8 7             0
	 // ---------------------------------
	 // | (res) |  (3)  | (res) |  (3)  |
	 // ---------------------------------
	 //  System Context    User Context
	 //
	 // Segment Map
	 // 7             0
	 // ---------------
	 // |    (8)      |
	 // ---------------
	 //     pmeg #
	 //
	 // Page Map
	 // 31 30      25   22   20 19       12         0
	 // ---------------------------------------------
	 // |1|  (6)     |  (3)  |1|1|       (20)       |
	 // ---------------------------------------------
	 //  v protection  type   a m      page #
	 //    (rwxrwx)
	 // v: valid bit
	 // a: accessed bit
	 // m: modified bit

	 $display("SETUP_PMAP");
	 dut.m68010.m68k_rw_ram(24'h00000, 3, 0, 16'hec00); // write page map

	 dut.m68010.m68k_rw_ram(24'h00006, 3, 0, 16'h0000); // write context reg
	 dut.m68010.m68k_rw_ram(24'h00004, 3, 0, 16'h0000); // write segment map (v & 0xff8000)
	 dut.m68010.m68k_rw_ram(24'h00000, 3, 0, 16'h8000); // write page map    (v & 0xfff800)

	 // dcp
	 dut.m68010.m68k_rw_ram(24'h01000, 3, 0, 16'h8050); // write page map
	 dut.m68010.m68k_rw_ram(24'h01002, 3, 0, 16'h0002); // write page map

	 // port
	 dut.m68010.m68k_rw_ram(24'h01800, 3, 0, 16'h8050); // write page map
	 dut.m68010.m68k_rw_ram(24'h01802, 3, 0, 16'h0003); // write page map

	 // scc
	 dut.m68010.m68k_rw_ram(24'h02000, 3, 0, 16'h8050); // write page map
	 dut.m68010.m68k_rw_ram(24'h02002, 3, 0, 16'h0004); // write page map

	 // timer
	 dut.m68010.m68k_rw_ram(24'h02800, 3, 0, 16'h8050); // write page map
	 dut.m68010.m68k_rw_ram(24'h02802, 3, 0, 16'h0005); // write page map

//	 dut.m68010.m68k_rw_ram(24'h03000, 3, 0, 16'h8050); // write page map
//	 dut.m68010.m68k_rw_ram(24'h03002, 3, 0, 16'h0004); // write page map

	 // rtc
	 dut.m68010.m68k_rw_ram(24'h03800, 3, 0, 16'h8050); // write page map
	 dut.m68010.m68k_rw_ram(24'h03802, 3, 0, 16'h0007); // write page map

//	 $display("SETUP_PMAP3");
//	 dut.m68010.m68k_rw_ram(24'h08004, 3, 0, 16'h0080); // write segment map
//	 dut.m68010.m68k_rw_ram(24'h01000, 3, 0, 16'hec40); // write page map
//	 dut.m68010.m68k_rw_ram(24'h00002, 3, 0, 16'h0000); // write page map
      end
   endtask

   task test_io_regs;
      begin
	 $display("TEST_IO_ REGS");
	 
	 // ma13..ma11
	 // 0000_0000
	 // 1111 11
	 // 5432 1098 7654 3210
	 //   xx x
	 //   01 0               1000  DCP
	 //   01 1               1800  PORT
	 //   10 0               2000  SCC
	 //   10 1               2800  TIMER
	 
	 // dcp
	 $display("r/w DCP");
	 dut.m68010.m68k_rw_ram(24'h001000, 5, 1, 16'h0000); // read
	 dut.m68010.m68k_rw_ram(24'h001000, 5, 0, 16'h0012); // write

	 // port
	 $display("r/w PORT");
	 dut.m68010.m68k_rw_ram(24'h001800, 5, 1, 16'h0000); // read
	 dut.m68010.m68k_rw_ram(24'h001800, 5, 0, 16'h0034); // write

	 // scc
	 $display("r/w SCC");
	 dut.m68010.m68k_rw_ram(24'h002000, 5, 1, 16'h0000); // read
	 dut.m68010.m68k_rw_ram(24'h002000, 5, 0, 16'h0056); // write

	 // timer
	 $display("r/w TIMER");
	 dut.m68010.m68k_rw_ram(24'h002800, 5, 1, 16'h0000); // read
	 dut.m68010.m68k_rw_ram(24'h002800, 5, 0, 16'h0078); // write

	 // rtc
	 $display("r/w RTC");
	 dut.m68010.m68k_rw_ram(24'h003800, 5, 1, 16'h0000); // read
	 dut.m68010.m68k_rw_ram(24'h003800, 5, 0, 16'h0078); // write
      end
   endtask

   task test_p2_mem;
      begin
	 dut.m68010.m68k_rw_ram(24'h000000, 5, 1, 16'h0000); // read
	 dut.m68010.m68k_rw_ram(24'h000000, 5, 0, 16'h00a5); // write

	 dut.m68010.m68k_rw_ram(24'h000004, 5, 1, 16'h0000); // read
	 dut.m68010.m68k_rw_ram(24'h000004, 5, 0, 16'h00a5); // write

	 dut.m68010.m68k_rw_ram(24'h001234, 5, 1, 16'h0000); // read
	 dut.m68010.m68k_rw_ram(24'h001234, 5, 0, 16'h00a5); // write

	 dut.m68010.m68k_rw_ram(24'h005678, 5, 1, 16'h0000); // read
	 dut.m68010.m68k_rw_ram(24'h005678, 5, 0, 16'h00a5); // write
      end
   endtask
	
   task run_tests;
      begin
	 setup_pmap;
//	 test_eeprom;
//	 test_mmu_regs;
//	 test_io_regs;
	 test_p2_mem;
      end
   endtask

   always
     begin
	#10 clk40 = 0;
	#10 clk40 = 1;
     end

   initial
     begin
	#200 run_tests;
	#10000 $finish;
     end
   
  initial
    begin
      $timeformat(-9, 0, "ns", 7);
      $dumpfile("sun2.vcd");
      $dumpvars(0, dut);
    end


endmodule

