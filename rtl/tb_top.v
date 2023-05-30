`include "top_ttl.v"

module tb();
   reg clk40;

   top dut(.clk40(clk40));

   task run_tests;
      begin
	 dut.m68010.m68k_rw_ram(24'h00000000, 6, 1);
	 dut.m68010.m68k_rw_ram(24'h00000002, 6, 1);
	 dut.m68010.m68k_rw_ram(24'h00000004, 6, 1);
	 dut.m68010.m68k_rw_ram(24'h00000006, 6, 1);
	 dut.m68010.m68k_rw_ram(24'h00000008, 6, 1);
	 dut.m68010.m68k_rw_ram(24'h0000000a, 6, 1);
	 dut.m68010.m68k_rw_ram(24'h0000000c, 6, 1);
	 dut.m68010.m68k_rw_ram(24'h0000000f, 6, 1);
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
	#5000 $finish;
     end
   
  initial
    begin
      $timeformat(-9, 0, "ns", 7);
      $dumpfile("sun2.vcd");
      $dumpvars(0, dut);
    end


endmodule

