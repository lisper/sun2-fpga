// Sun2 "guts" in verilog
//
// Pretty much a straight transcription of the schematics into verilog,
// using modules for all TTL chips.  I want to first get things stable
// using old school 74xxx parts and then slowly convert it into more modern
// verilog, and then eventually into an FPGA with a real plastic 68010 chip.
//
// I should be able to squeeze the basic SCC, timer chip and dram into a simple FPGA
// with some HDMI video.
//
// Brad Parker brad@heeltoe.com 6/2023
//
  
   module sun2_ttl(
		   input  clk40,
		   output C100,
		   output P_VPA_n,
		   output P_BERR_n,
		   inout  P_DTACK_n,
		   output P_BR_n,
		   input  P_BGACK_n,

		   inout  P_RESET_n,
		   inout  P_HALT_n,

		   inout  P_AS_n,
		   inout  P_RW_n,
		   inout  P_UDS_n,
		   inout  P_LDS_n,
		   inout  P_BG_n,

		   output IPL2_n,
		   output IPL1_n,
		   output IPL0_n,

		   input  P_FC2,
		   inout  P_FC1,
		   input  P_FC0,
   
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

    wire [15:0] p_databus;
    assign p_databus = { P_D15, P_D14, P_D13, P_D12, P_D11, P_D10, P_D9, P_D8,
			    P_D7, P_D6, P_D5, P_D4, P_D3, P_D2, P_D1, P_D0 };

    wire [23:0] p_addr;
    assign p_addr = { P_A23, P_A22, P_A21, P_A20, P_A19, P_A18, P_A17, P_A16, 
		      P_A15, P_A14, P_A13, P_A12, P_A11, P_A10, P_A9, P_A8,
		      P_A7, P_A6, P_A5, P_A4, P_A3, P_A2, P_A1, 1'b0 };

   wire H, L, H0, L0, H1, L1;
   assign H = 1'b1;
   assign H0 = 1'b1;
   assign H1 = 1'b1;
   assign L = 1'b0;
   assign L0 = 1'b0;
   assign L1 = 1'b0;
   
//   reg [2:0] p_ipl;
//   assign IPL2_n = p_ipl[2];
//   assign IPL1_n = p_ipl[1];
//   assign IPL0_n = p_ipl[0];

   wire [2:0] p_fc;
   assign p_fc = { IPL2_n, IPL1_n, IPL0_n };
   
   reg POR_n;
   initial
     begin
	POR_n = 1'b0;
	#25 POR_n = 1'b1;
     end

   // DTACK generator
   wire IOACK_n, IOACK;
   
   assign IOACK = ~IOACK_n | ~DCPACK_n;

   wire P2_WAIT_n;
   assign P2_WAIT_n = 1'b1;

   wire LTYPE0, LTYPE1;
   
   ttl_74F251 u111(.D0(C_S5),
		   .D1(C_S5),
		   .D2(C_S5),
		   .D3(C_S5),
		   .D4(P2_WAIT_n),
		   .D5(IOACK),
		   .D6(XACK),
		   .D7(XACK),
		   .A(LTYPE0),
		   .B(LTYPE1),
		   .C(C_S4),
		   .G_n(1'b0),
		   .Y(P_DTACK_n),
		   .W());

   assign ERR = ~PROTERR_n | ~TIMEOUT_n | ~PARERRL_n | ~PARERRU_n;
   assign ERR_n = ~(ERR & EN_S4);

   ttl_74F74 u105_a(.D(ERR_n),
		    .CLK(C100_n),
		    .S(P_BACK_n),
		    .R(H0),
		    .Q(BERR_n),
		    .Q_n(BERR));

   assign P_BERR_n = ~( ~XBERR_n | ~BERR_n );

   ttl_74LS148 u119(.I_n({INT7_n, INT6_n, INT5_n, INT4_n, INT3_n, INT2_n, INT1_n, L}),
		    .A_n({IPL2_n, IPL1_n, IPL0_n}),
		    .EI_n(~EN_INT),
		    .EO_n(),
		    .GS_n()
		    );

   wire INT1_n, INT2_n, INT3_n, INT6_n;
   wire INITOUT_n;
   
   assign INT1_n = ~EN_INT1;
   assign INT2_n = ~EN_INT2;
   assign INT3_n = ~EN_INT3;
   assign INT6_n = INT_SCC_n;

   assign P_HALT_n = XHALT_n | INIT_n;
   assign P_RESET_n = INIT_n;
   assign INITOUT_n = INIT_n;
   

   // -------------------------
//   wire [15:0] IOD;
//   assign IOD = p_databus;

assign AS = ~P_AS_n;
   assign Q_AS_n = ~AS;

   tri1 IOD15,IOD14,IOD13,IOD12,IOD11,IOD10,IOD9,IOD8;
   tri1 IOD7,IOD6,IOD5,IOD4,IOD3,IOD2,IOD1,IOD0;

   wire [15:0] iodata;
   assign iodata = {IOD15,IOD14,IOD13,IOD12,IOD11,IOD10,IOD9,IOD8,IOD7,IOD6,IOD5,IOD4,IOD3,IOD2,IOD1,IOD0};

   assign d_u102 = ~(~RD_IO_n | ~BOOTEN_n);
   
   ttl_74LS245 u102(.A0(P_D0),
		    .A1(P_D1),
		    .A2(P_D2),
		    .A3(P_D3),
		    .A4(P_D4),
		    .A5(P_D5),
		    .A6(P_D6),
		    .A7(P_D7),
		    .B0(IOD0),
		    .B1(IOD1),
		    .B2(IOD2),
		    .B3(IOD3),
		    .B4(IOD4),
		    .B5(IOD5),
		    .B6(IOD6),
		    .B7(IOD7),
		    .DR(d_u102),
		    .CS_n(Q_AS_n));
      
   ttl_74LS245 u103(.A0(P_D8),
		    .A1(P_D9),
		    .A2(P_D10),
		    .A3(P_D11),
		    .A4(P_D12),
		    .A5(P_D13),
		    .A6(P_D14),
		    .A7(P_D15),
		    .B0(IOD8),
		    .B1(IOD9),
		    .B2(IOD10),
		    .B3(IOD11),
		    .B4(IOD12),
		    .B5(IOD13),
		    .B6(IOD14),
		    .B7(IOD15),
		    .DR(d_u102),
		    .CS_n(Q_AS_n));
      
   reg [5:1] LA1_5 = 0;
   always @(posedge AS)
     LA1_5 <= {P_A5, P_A4, P_A3, P_A2, P_A1 };

   assign DS_n = ~(~P_UDS_n | ~P_LDS_n);
   assign RW = ~P_RW_n;

   wire rw_s7;
   assign rw_s7 = ~(~RW | ~C_S7);
   
   assign IODS_n = ~(~DS_n & ~rw_s7);
   assign IOUDS = ~P_UDS_n & ~rw_s7;
   assign IOLDS = ~P_LDS_n & ~rw_s7;
   

   // -------------------

   wire C50, C50_n, C100_n;

   ttl_74F74 u203_a(.D(C50_n),
		    .CLK(clk40),
		    .S(H1),
		    .R(H0),
		    .Q(C50),
		    .Q_n(C50_n));

   ttl_74F74 u201_a(.D(C100_n),
		    .CLK(C50),
		    .S(H1),
		    .R(H0),
		    .Q(C100),
		    .Q_n(C100_n));

   assign #50 as_d = AS;
   
   ttl_74F74 u201_b(.D(C100_n),
		    .CLK(C50_n),
		    .S(C_S3_n),
//		    .R(AS),
 .R(as_d),
		    .Q(C_S3),
		    .Q_n(C_S3_n));

   ttl_74F74 u204_a(.D(C_S3),
		    .CLK(C100_n),
		    .S(H1),
		    .R(AS),
		    .Q(C_S5),
		    .Q_n(C_S5_n));
   
   ttl_74F74 u205_a(.D(C_S6),
		    .CLK(C100_n),
		    .S(H1),
		    .R(AS),
		    .Q(C_S7),
		    .Q_n());

   ttl_74F74 u203_b(.D(VALID),
		    .CLK(C100),
		    .S(H1),
		    .R(EN_S4),
		    .Q(C_S4),
		    .Q_n(C_S4_n));
   
   ttl_74F74 u204_b(.D(C_S4),
		    .CLK(C100),
		    .S(H1),
		    .R(EN_S4),
		    .Q(C_S6),
		    .Q_n(C_S6_n));


   ttl_74F74 u208_a(.D(P_DTACK_n),
		    .CLK(C100_n),
		    .S(H1),
		    .R(H0),
		    .Q(ENDS6_n),
		    .Q_n(ENDS6));

   ttl_74F74 u208_b(.D(ENDS6_n),
		    .CLK(C100_n),
		    .S(H1),
		    .R(H0),
		    .Q(ENDS7_n),
		    .Q_n(ENDS7));

   wire DIS_n;

   // Don't start S4 if mmu or refresh
   assign EN_S4 = DIS_n & C_S3;

   // DVMA decoder
   wire P1_MRWC_n, P1_MWRC_n;
   tri1 P1_MRDC_n;

   assign P1_MRWC_n = ~(~P1_MWTC_n | ~P1_MRDC_n);

   wire P1_A18_n, P1_A19_n;
   assign P1_A18_n = 1;
   assign P1_A19_n = 1;
   
   pal20L10_u212 u212(.I0(P1_A18_n),
		      .I1(P1_A19_n),
		      .I2(P1_AC_n),
		      .I3(P1_NHEN_n),
		      .I4(P1_MRDC_n),
		      .I5(P1_MRWC_n),
		      .I6(PROTERR_n),
		      .I7(EN_DVMA),
		      .I8(C_S7),
		      .I9(PARERR),
		      .I10(MROC_n),
		      .I11(IORC_n),
		      .O0(P1IOP_n),
		      .O1(DATAEN_n),
		      .O2(XREQ_n),
		      .O3(XEN_n),
		      .O4(P_RW_n),
		      .O5(P_LDS_n),
		      .O6(P_UDS_n),
		      .O7(P1_XACK_n),
		      .O8(CE_BYTE_n),
		      .O9(CE_WORD_n));

   ttl_74F374 u207(.D1(ENDS6),
		   .D2(1'b1),
		   .D3(P_BACK_n),
		   .D4(Q_AS_n),
		   .D5(1'b1),
		   .D6(1'b1),
		   .D7(1'b1),
		   .D8(XREQ_n),
		   .Q1(ENDS8),
		   .Q2(),
		   .Q3(SACK_n),
		   .Q4(SAS_n),
		   .Q5(),
		   .Q6(),
		   .Q7(),
		   .Q8(SDS_n),
		   .CLK(C100),
		   .OE(1'b0));

//temp - disable refresh
wire REN_n = 1'b1;
wire XEN_n = 1'b1;
   
   // DVMA Controller
   pal16R4_u213 u213(.D0(SYSB),
		     .D1(BEN_n),
		     .D2(SACK_n),
		     .D3(SAS_n),
		     .D4(P_BG_n),
		     .D5(XREQ_n),
		     .D6(RREQ_n),
		     .D7(SDS_n),
		     .O0(P_AS_n),
		     .O1(P_FC1),
//temp
//		     .Q0(XEN_n),
//		     .Q1(REN_n),
		     .Q2(XHALT_n),
		     .Q3(XBERR_n),
		     .O2(P_BR_n),
		     .O3(P_BACK_n),
		     .CLK(C100),
		     .OE_n(1'b0));

   // Timeout counter
   ttl_74LS393 u209(.A(T_n),
		    .B(C100_n),
		    .A0(),
		    .A1(),
		    .A2(),
		    .A3(TIMEOUT),
		    .B0(C200),
		    .B1(C400),
		    .B2(),
		    .B3(),
		    .CA(C_S4_n),
		    .CB(1'b0)); 

   pal20X10_u211 u211(.I0(C200),
		      .I1(POR_n),
		      .I2(SYSB),
		      .I3(SDS_n),
		      .I4(INITIN_n),
		      .I5(H),
		      .I6(REN_n),
		      .I7(P_HALT_n),
		      .I8(C_S4_n),
		      .I9(TIMEOUT),
		      .O0(Q0_n),
		      .O1(Q1_n),
		      .O2(Q2_n),
		      .O3(Q3_n),
		      .O4(Q4_n),
		      .O5(Q5_n),
		      .O6(RREQ_n),
		      .O7(INIT_n),
		      .O8(T_n),
		      .O9(TIMEOUT_n),
		      .CLK(C100),
		      .OE_n(1'b0));

   // Refresh counter
   ttl_74S491 u210(.D0(L),
		   .D1(L),
		   .D2(L),		   
		   .D8(L),
		   .D9(L),
		   .LD_n(H),
		   .CT_n(L),
		   .UP_n(L),
		   .ST(L),
		   .CI_n(L),
		   .Q0_n(P_A1),
		   .Q1_n(P_A2),
		   .Q2_n(P_A3),
		   .Q3_n(P_A4),
		   .Q4_n(P_A5),
		   .Q5_n(P_A6),
		   .Q6_n(P_A7),
		   .Q7_n(P_A8),
		   .Q8_n(P_A9),
		   .Q9_n(P_A10),
		   .CLK(REN_n),
		   .OE(REN_n));
		   
		   
   // -------------------

   // Context Register

   ttl_25LS2518 u300(
		     .D0(P_D0),
		     .D1(P_D1),
		     .D2(P_D2),
		     .D3(P_D3),
		     .Q0(CXU0),
		     .Q1(CXU1),
		     .Q2(CXU2),
		     .Q3(CXU3),
		     .Y0(P_D0),
		     .Y1(P_D1),
		     .Y2(P_D2),
		     .Y3(P_D3),
		     .CK(WR_CXL_n),
		     .OE_n(RD_CXL_n));

   ttl_25LS2518 u301(.D0(P_D8),
		     .D1(P_D9),
		     .D2(P_D10),
		     .D3(P_D11),
		     .Q0(CXS0),
		     .Q1(CXS1),
		     .Q2(CXS2),
		     .Q3(CXS3),
		     .Y0(P_D8),
		     .Y1(P_D9),
		     .Y2(P_D10),
		     .Y3(P_D11),
		     .CK(WR_CXU_n),
		     .OE_n(RD_CXU_n));

   ttl_74F257 u302(.A1(CXU0),
		   .A2(CXU1),
		   .A3(CXU2),
		   .A4(CXU3),
		   .B1(CXS0),
		   .B2(CXS1),
		   .B3(CXS2),
		   .B4(CXS3),
		   .Y1(cx_a0),
		   .Y2(cx_a1),
		   .Y3(cx_a2),
		   .Y4(),
		   .B(P_FC2),
		   .OE_n(1'b0));

   // Segment map
   wire [11:0] sm_addr;
   assign sm_addr = {P_A23, P_A22, P_A21, P_A20, P_A19, P_A18, P_A17, P_A16, P_A15, cx_a2, cx_a1, cx_a0};

   ttl_2168_sram u303(.A0(cx_a0),
		      .A1(cx_a1),
		      .A2(cx_a2),
		      .A3(P_A15),
		      .A4(P_A16),
		      .A5(P_A17),
		      .A6(P_A18),
		      .A7(P_A19),
		      .A8(P_A20),
		      .A9(P_A21),
		      .A10(P_A22),
		      .A11(P_A23),
		      .WE_n(WR_SMAP_n),
		      .CE_n(1'b0),
		      .D0(IA23),
		      .D1(IA22),
		      .D2(IA21),
		      .D3(IA20),
		      .id(4'h3));

   ttl_2168_sram u304(.A0(cx_a0),
		      .A1(cx_a1),
		      .A2(cx_a2),
		      .A3(P_A15),
		      .A4(P_A16),
		      .A5(P_A17),
		      .A6(P_A18),
		      .A7(P_A19),
		      .A8(P_A20),
		      .A9(P_A21),
		      .A10(P_A22),
		      .A11(P_A23),
		      .WE_n(WR_SMAP_n),
		      .CE_n(1'b0),
		      .D0(IA19),
		      .D1(IA18),
		      .D2(IA17),
		      .D3(IA16),
		      .id(4'h4));

   wire [11:0] pm_addr;
   assign pm_addr = {IA22,IA21,IA20,IA19,IA18,IA17,IA16,IA23,P_A14,P_A13,P_A12,P_A11};

   tri1 VALID, PROT5, PROT4, PROT3, PROT2, PROT1, PROT0, TYPE2, TYPE1, TYPE0, ACC, MOD;

   // Page Map
   ttl_2168_sram u305(.A0(P_A11),
		      .A1(P_A12),
		      .A2(P_A13),
		      .A3(P_A14),
		      .A4(IA23),
		      .A5(IA16),
		      .A6(IA17),
		      .A7(IA18),
		      .A8(IA19),
		      .A9(IA20),
		      .A10(IA21),
		      .A11(IA22),
		      .WE_n(WR_PMAP0U_n),
		      .CE_n(1'b0),
		      .D0(VALID),
		      .D1(PROT5),
		      .D2(PROT4),
		      .D3(PROT3),
		      .id(4'h5)
		      );

   ttl_2168_sram u306(.A0(P_A11),
		      .A1(P_A12),
		      .A2(P_A13),
		      .A3(P_A14),
		      .A4(IA23),
		      .A5(IA16),
		      .A6(IA17),
		      .A7(IA18),
		      .A8(IA19),
		      .A9(IA20),
		      .A10(IA21),
		      .A11(IA22),
		      .WE_n(WR_PMAP0U_n),
		      .CE_n(1'b0),
		      .D0(PROT2),
		      .D1(PROT1),
		      .D2(PROT0),
		      .D3(TYPE2),
		      .id(4'h6)
		      );

//   tri1 TYPE1;
//   tri1 TYPE0;
//   tri1 MA14, MA13, MA12, MA11;

   wire [22:0] map_addr;
   assign map_addr = { MA22,MA21,MA20,MA19,MA18,MA17,MA16,
		       MA15,MA14,MA13,MA12,MA11,11'b0 };

   wire [22:0] ia_addr;
   assign ia_addr = { IA22,IA21,IA20,IA19,IA18,IA17,IA16, 16'b0 };
   
   //always @(posedge C_S5) $display("ia_addr %x", ia_addr);
   //always @(posedge C_S5) $display("map_addr %x", map_addr);
   
   ttl_2168_sram u307(
		      .A0(P_A11),
		      .A1(P_A12),
		      .A2(P_A13),
		      .A3(P_A14),
		      .A4(IA23),
		      .A5(IA16),
		      .A6(IA17),
		      .A7(IA18),
		      .A8(IA19),
		      .A9(IA20),
		      .A10(IA21),
		      .A11(IA22),
		      .WE_n(WR_PMAP0X_n),
		      .CE_n(1'b0),
		      .D0(TYPE1),
		      .D1(TYPE0),
		      .D2(ACC),
		      .D3(MOD),
		      .id(4'h7)
		      );

   ttl_2168_sram u308(
		      .A0(P_A11),
		      .A1(P_A12),
		      .A2(P_A13),
		      .A3(P_A14),
		      .A4(IA23),
		      .A5(IA16),
		      .A6(IA17),
		      .A7(IA18),
		      .A8(IA19),
		      .A9(IA20),
		      .A10(IA21),
		      .A11(IA22),
		      .WE_n(WR_PMAP1U_n),
		      .CE_n(1'b0),
		      .D0(MA22),
		      .D1(MA21),
		      .D2(MA20),
		      .D3(MA19),
		      .id(4'h8)
		      );

   ttl_2168_sram u309(
		      .A0(P_A11),
		      .A1(P_A12),
		      .A2(P_A13),
		      .A3(P_A14),
		      .A4(IA23),
		      .A5(IA16),
		      .A6(IA17),
		      .A7(IA18),
		      .A8(IA19),
		      .A9(IA20),
		      .A10(IA21),
		      .A11(IA22),
		      .WE_n(WR_PMAP1U_n),
		      .CE_n(1'b0),
		      .D0(MA18),
		      .D1(MA17),
		      .D2(MA16),
		      .D3(MA15),
		      .id(4'h9)
		      );

   ttl_2168_sram u310(
		      .A0(P_A11),
		      .A1(P_A12),
		      .A2(P_A13),
		      .A3(P_A14),
		      .A4(IA23),
		      .A5(IA16),
		      .A6(IA17),
		      .A7(IA18),
		      .A8(IA19),
		      .A9(IA20),
		      .A10(IA21),
		      .A11(IA22),
		      .WE_n(WR_PMAP1U_n),
		      .CE_n(1'b0),
		      .D0(MA14),
		      .D1(MA13),
		      .D2(MA12),
		      .D3(MA11),
		      .id(4'ha)
		   );

   // Statistics bit logic
   ttl_74F74 u312_a(.D(TYPE0),
		    .CLK(C_S4),
		    .S(H1),
		    .R(H0),
		    .Q(LTYPE0),
		    .Q_n());

   ttl_74F74 u312_b(.D(TYPE1),
		    .CLK(C_S4),
		    .S(H1),
		    .R(H0),
		    .Q(LTYPE1),
		    .Q_n());

   pal16R4_u316 u316(.D0(TYPE0),
		     .D1(TYPE1),
		     .D2(MOD),
		     .D3(ERR_n),
		     .D4(P_RW_n),
		     .D5(P_FC0),
		     .D6(P_FC1),
		     .D7(BOOTEN_n),
		     .O0(DIS_n),
		     .O1(ACC),		
		     .Q0(TYPE1),
		     .Q1(TYPE0),
		     .Q2(MOD),
		     .Q3(ACC),
		     .O2(P_BACK_n),
		     .O3(C_S6),
		     .CLK(C_S6),
		     .OE_n(C_S6_n));

   wire WR_PMAP0X_n;
//   assign WR_PMAP0X_n = ~(~C_S6_n | ~WR_PMAP0L_n);
//assign WR_PMAP0X_n = ~C_S6_n & ~WR_PMAP0L_n;
//assign WR_PMAP0X_n = /*C_S6_n &*/ WR_PMAP0L_n;
//assign WR_PMAP0X_n = ~(~C_S6_n | WR_PMAP0L_n);
   assign WR_PMAP0X_n = WR_PMAP0L_n;
		   
   // Protection decoder
   ttl_am2949 u314(.A0(IA16),
		   .A1(IA17),
		   .A2(IA18),
		   .A3(IA19),
		   .A4(IA20),
		   .A5(IA21),
		   .A6(IA22),
		   .A7(IA23),
		   .B0(P_D0),
		   .B1(P_D1),
		   .B2(P_D2),
		   .B3(P_D3),
		   .B4(P_D4),
		   .B5(P_D5),
		   .B6(P_D6),
		   .B7(P_D7),
		   .T_n(RD_SMAP_n),
		   .R_n(WR_SMAP_n));

   ttl_74F151 u315(.D0(PROT2),
		   .D1(PROT1),
		   .D2(PROT0),
		   .D3(L),
		   .D4(PROT5),
		   .D5(PROT4),
		   .D6(PROT3),
		   .D7(L),
		   .A(RW),
		   .B(P_FC1),
		   .C(P_FC2),
// bug?
//		   .Y(PROTERR_n),
//		   .W(),
		   .Y(),
		   .W(PROTERR_n),
		   .S(C_S4_n));

   wire Z0, Z1, Z2, Z3, Z4, Z5, Z6, Z7;
   assign Z0 = 1'b0;
   assign Z1 = 1'b0;
   assign Z2 = 1'b0;
   assign Z3 = 1'b0;
   assign Z4 = 1'b0;
   assign Z5 = 1'b0;
   assign Z6 = 1'b0;
   assign Z7 = 1'b0;
   
   ttl_am2949 u317(.A0(Z0),
		   .A1(Z1),
		   .A2(Z2),
		   .A3(Z3),
		   .A4(MOD),
		   .A5(ACC),
		   .A6(TYPE0),
		   .A7(TYPE1),
		   .B0(P_D0),
		   .B1(P_D1),
		   .B2(P_D2),
		   .B3(P_D3),
		   .B4(P_D4),
		   .B5(P_D5),
		   .B6(P_D6),
		   .B7(P_D7),
		   .T_n(RD_PMAP0L_n),
		   .R_n(WR_PMAP0L_n));
		   
   ttl_am2949 u318(.A0(TYPE2),
		   .A1(PROT0),
		   .A2(PROT1),
		   .A3(PROT2),
		   .A4(PROT3),
		   .A5(PROT4),
		   .A6(PROT5),
		   .A7(VALID),
		   .B0(P_D8),
		   .B1(P_D9),
		   .B2(P_D10),
		   .B3(P_D11),
		   .B4(P_D12),
		   .B5(P_D13),
		   .B6(P_D14),
		   .B7(P_D15),
		   .T_n(RD_PMAP0U_n),
		   .R_n(WR_PMAP0U_n));
		   
   ttl_am2949 u319(.A0(MA11),
		   .A1(MA12),
		   .A2(MA13),
		   .A3(MA14),
		   .A4(MA15),
		   .A5(MA16),
		   .A6(MA17),
		   .A7(MA18),
		   .B0(P_D0),
		   .B1(P_D1),
		   .B2(P_D2),
		   .B3(P_D3),
		   .B4(P_D4),
		   .B5(P_D5),
		   .B6(P_D6),
		   .B7(P_D7),
		   .T_n(RD_PMAP1L_n),
		   .R_n(WR_PMAP1L_n));
		   
   ttl_am2949 u320(.A0(MA19),
		   .A1(MA20),
		   .A2(MA21),
		   .A3(MA22),
		   .A4(Z4),
		   .A5(Z5),
		   .A6(Z6),
		   .A7(Z7),
		   .B0(P_D8),
		   .B1(P_D9),
		   .B2(P_D10),
		   .B3(P_D11),
		   .B4(P_D12),
		   .B5(P_D13),
		   .B6(P_D14),
		   .B7(P_D15),
		   .T_n(RD_PMAP1U_n),
		   .R_n(WR_PMAP1U_n));

   //
   ttl_74F138 u321(.A0(P_FC0),
		   .A1(P_FC1),
		   .A2(P_FC2),
		   .F1(P_AS_n),
		   .F2(1'b0),
		   .F3(P_BACK_n),
		   .Q0(),
		   .Q1(),
		   .Q2(),
		   .Q3(P_MMU_n),
		   .Q4(),
		   .Q5(),
		   .Q6(P_SPROG_n),
		   .Q7(P_VPA_n));

   ttl_74F138 u322(.A0(P_A1),
		   .A1(P_A2),
		   .A2(RW),
		   .F1(P_A3),
		   .F2(P_MMU_n),
		   .F3(IOLDS),
		   .Q0(RD_PMAP0L_n),
		   .Q1(RD_PMAP1L_n),
		   .Q2(RD_SMAP_n),
		   .Q3(RD_CXL_n),
		   .Q4(WR_PMAP0L_n),
		   .Q5(WR_PMAP1L_n),
		   .Q6(WR_SMAP_n),
		   .Q7(WR_CXL_n));

   ttl_74F138 u323(.A0(P_A1),
		   .A1(P_A2),
		   .A2(RW),
		   .F1(P_A3),
		   .F2(P_MMU_n),
		   .F3(IOUDS),
		   .Q0(RD_PMAP0U_n),
		   .Q1(RD_PMAP1U_n),
		   .Q2(),
		   .Q3(RD_CXU_n),
		   .Q4(WR_PMAP0U_n),
		   .Q5(WR_PMAP1U_n),
		   .Q6(),
		   .Q7(WR_CXU_n));

   always @(negedge WR_PMAP0L_n) $display("WR_PMAP0L_n assert; addr %x data %x", p_addr, p_databus);
   always @(negedge WR_PMAP1L_n) $display("WR_PMAP1L_n assert; addr %x data %x", p_addr, p_databus);

   always @(negedge RD_PMAP0L_n) $display("RD_PMAP0L_n assert; addr %x data %x", p_addr, p_databus);
   always @(negedge RD_PMAP1L_n) $display("RD_PMAP1L_n assert; addr %x data %x", p_addr, p_databus);
   
`ifdef xx
   always @(negedge WR_SMAP_n) $display("WR_SMAP_n assert");
   always @(negedge WR_PMAP0L_n) $display("WR_PMAP0L_n assert");
   always @(negedge WR_PMAP1L_n) $display("WR_PMAP1L_n assert");
   always @(negedge WR_PMAP0U_n) $display("WR_PMAP0U_n assert");
   always @(negedge WR_PMAP1U_n) $display("WR_PMAP1U_n assert");
   always @(negedge WR_CXL_n) $display("WR_CXL_n assert");
   always @(negedge WR_CXU_n) $display("WR_CXU_n assert");
`endif
   
   ttl_74F138 u324(.A0(P_A1),
		   .A1(P_A2),
		   .A2(RW),
		   .F1(IODS_n),
		   .F2(P_MMU_n),
		   .F3(P_A3),
		   .Q0(RD_ID_n),
		   .Q1(),
		   .Q2(RD_ERROR_n),
		   .Q3(RD_ENABLE_n),
		   .Q4(),
		   .Q5(WR_DIAG_n),
		   .Q6(),
		   .Q7(WR_ENABLE_n));

   always @(negedge RD_ENABLE_n) $display("RD_ENABLE_n asserts");
   always @(negedge WR_ENABLE_n) $display("WR_ENABLE_n asserts");
   always @(negedge BOOT_n) $display("BOOT_n asserts");
   always @(posedge BOOT_n) $display("BOOT_n deasserts");

   // -------------------

   always @(negedge RD_RAM_n) $display("RD_RAM_n assert; addr %x data %x", p_addr, p_databus);
   always @(negedge WR_RAM_n) $display("WR_RAM_n assert; addr %x data %x", p_addr, p_databus);

   // Strobe Decoders
   ttl_74F138 U400(.A0(LTYPE0),
		   .A1(LTYPE1),
		   .A2(RW),
		   .F1(ERR),
		   .F2(DS_n),
		   .F3(C_S6),
		   .Q0(RD_RAM_n),
		   .Q1(RD_IO_n),
		   .Q2(MRDC_n),
		   .Q3(IORC_n),
		   .Q4(WR_RAM_n),
		   .Q5(WR_IO_n),
		   .Q6(MWTC_n),
		   .Q7(IOWC_n));

   ttl_74F138 u401(.A0(MA11),
		   .A1(MA12),
		   .A2(MA13),
		   .F1(1'b0),
		   .F2(RD_IO_n),
		   .F3(H1),
		   .Q0(RD_PROM_n),
		   .Q1(),
		   .Q2(RD_DCP_n),
		   .Q3(RD_PORT_n),
		   .Q4(RD_SCC_n),
		   .Q5(RD_TIMER_n),
		   .Q6(),
		   .Q7());

   always @(negedge RD_DCP_n) $display("RD_DCP_n asserts");
   always @(negedge RD_PORT_n) $display("RD_PORT_n asserts");
   always @(negedge RD_SCC_n) $display("RD_SCC_n asserts");
   always @(negedge RD_TIMER_n) $display("RD_TIMER_n asserts");
//   always @(negedge RD_PROM_n) $display("RD_PROM_n asserts");
//   always @(negedge RD_IO_n) $display("RD_IO_n asserts");
   

   ttl_74F138 u402(.A0(MA11),
		   .A1(MA12),
		   .A2(MA13),
		   .F1(ENDS7),
		   .F2(WR_IO_n),
		   .F3(H1),
		   .Q0(),
		   .Q1(),
		   .Q2(WR_DCP_n),
		   .Q3(),
		   .Q4(WR_SCC_n),
		   .Q5(WR_TIMER_n),
		   .Q6(),
		   .Q7());

   always @(negedge WR_DCP_n) $display("WR_DCP_n asserts");
   always @(negedge WR_SCC_n) $display("WR_SCC_n asserts");
   always @(negedge WR_TIMER_n) $display("WR_TIMER_n asserts");
   
   // ID PRom
   ttl_74S288_idprom u411(.A0(P_A11),
			  .A1(P_A12),
			  .A2(P_A13),
			  .A3(P_A14),
			  .A4(P_A15),
			  .Q0(P_D8),
			  .Q1(P_D9),
			  .Q2(P_D10),
			  .Q3(P_D11),
			  .Q4(P_D12),
			  .Q5(P_D13),
			  .Q6(P_D14),
			  .Q7(P_D15),
			  .S0_n(RD_ID_n));

   // Boot proms
   ttl_27256_l u406(.A0(P_A1),
		    .A1(P_A2),
		    .A2(P_A3),
		    .A3(P_A4),
		    .A4(P_A5),
		    .A5(P_A6),
		    .A6(P_A7),
		    .A7(P_A8),
		    .A8(P_A9),
		    .A9(P_A10),
		    .A10(P_A11),
		    .A11(P_A12),
		    .A12(P_A13),
		    .A13(P_A14),
		    .A14(P_A15),
		    .O0(IOD0),
		    .O1(IOD1),
		    .O2(IOD2),
		    .O3(IOD3),
		    .O4(IOD4),
		    .O5(IOD5),
		    .O6(IOD6),
		    .O7(IOD7),
		    .OE_n(rom_oe_n),
		    .CE_n(1'b0));

   ttl_27256_h u407(.A0(P_A1),
		    .A1(P_A2),
		    .A2(P_A3),
		    .A3(P_A4),
		    .A4(P_A5),
		    .A5(P_A6),
		    .A6(P_A7),
		    .A7(P_A8),
		    .A8(P_A9),
		    .A9(P_A10),
		    .A10(P_A11),
		    .A11(P_A12),
		    .A12(P_A13),
		    .A13(P_A14),
		    .A14(P_A15),
		    .O0(IOD8),
		    .O1(IOD9),
		    .O2(IOD10),
		    .O3(IOD11),
		    .O4(IOD12),
		    .O5(IOD13),
		    .O6(IOD14),
		    .O7(IOD15),
		    .OE_n(rom_oe_n),
		    .CE_n(1'b0));

   wire BOOTEN_n;
   assign BOOTEN_n = ~(~BOOT_n & ~P_SPROG_n);
   assign rom_oe_n = ~(~RD_PROM_n | ~BOOTEN_n);

   // Real time clock
`ifdef xx
   ttl_58167 u420(.D0(IOD8),
		  .D1(IOD9),
		  .D2(IOD10),
		  .D3(IOD11),
		  .D4(IOD12),
		  .D5(IOD13),
		  .D6(IOD14),
		  .D7(IOD15),
		  .A0(LA1_5[1]),
		  .A1(LA1_5[2]),
		  .A2(LA1_5[3]),
		  .A3(LA1_5[4]),
		  .A4(LA1_5[5]),
		  .CS_n(1'b0),
		  .RD_n(RD_RTC_n),
		  .WR_n(WR_RTC_n),
		  .PD_n(POR_n));
`endif
   
   // Bus error reg
   ttl_74LS534 u412(.D1(PARERRL_n),
		   .D2(TIMEOUT_n),
		   .D3(AEN_n),
		   .D4(H),
		   .D5(C_S4_n),
		   .D6(H),
		   .D7(PROTERR_n),
		   .D8(PARERRU_n),
		   .Q1(P_D0),
		   .Q2(P_D2),
		   .Q3(P_D4),
		   .Q4(P_D6),
		   .Q5(P_D7),
		   .Q6(P_D5),
		   .Q7(P_D3),
		   .Q8(P_D1),
		   .CK(BERR),
		   .OE_n(RD_ERROR_n));

   // System Enable Reg.
   ttl_74LS273 u413(
		    .D1(P_D0),
		    .D2(P_D2),
		    .D3(P_D4),
		    .D4(P_D6),
		    .D5(P_D7),
		    .D6(P_D5),
		    .D7(P_D3),
		    .D8(P_D1),
		    .Q1(EN_PARGEN),
		    .Q2(EN_INT2),
		    .Q3(EN_PARERR),
		    .Q4(EN_INT),
		    .Q5(BOOT_n),
		    .Q6(EN_DVMA),
		    .Q7(EN_INT3),
		    .Q8(EN_INT1),
		    .CK(WR_ENABLE_n),
		    .CR_n(INIT_n));

   ttl_74LS244 u414(.A11(EN_PARGEN),
		    .A12(EN_INT2),
		    .A13(EN_PARERR),
		    .A14(EN_INT),
		    .A21(BOOT_n),
		    .A22(EN_DVMA),
		    .A23(EN_INT3),
		    .A24(EN_INT1),
		    .Y11(P_D0),
		    .Y12(P_D2),
		    .Y13(P_D4),
		    .Y14(P_D6),
		    .Y21(P_D7),
		    .Y22(P_D5),
		    .Y23(P_D3),
		    .Y24(P_D1),
		    .G1(RD_ENABLE_n),
		    .G2(RD_ENABLE_n));

   pal16R4_u415 u415(.D0(MA14),
		     .D1(MA13),
		     .D2(MA12),
		     .D3(MA11),
		     .D4(RD_IO_n),
		     .D5(WR_IO_n),
		     .D6(C_S7),
		     .D7(C_S5),
		     .Q0(),
		     .Q1(),		
		     .Q2(),
		     .Q3(),
		     .Q4(),
		     .Q5(IOACK_n),
		     .O1(WR_RTC_n),
		     .O2(RD_RTC_n),
		     .CLK(C100_n),
		     .OE_n(1'b0));
		 
   // -------------------

   // Parity logic
   assign PARERR = 1'b0;
   assign PARERRL_n = 1'b1;
   assign PARERRU_n = 1'b1;

   // P2 Bus interface
   wire [15:0] p2_do;
   assign P2_DO15 = p2_do[15];
   assign P2_DO14 = p2_do[14];
   assign P2_DO13 = p2_do[13];
   assign P2_DO12 = p2_do[12];
   assign P2_DO11 = p2_do[11];
   assign P2_DO10 = p2_do[10];
   assign P2_DO9 = p2_do[9];
   assign P2_DO8 = p2_do[8];
   assign P2_DO7 = p2_do[7];
   assign P2_DO6 = p2_do[6];
   assign P2_DO5 = p2_do[5];
   assign P2_DO4 = p2_do[4];
   assign P2_DO3 = p2_do[3];
   assign P2_DO2 = p2_do[2];
   assign P2_DO1 = p2_do[1];
   assign P2_DO0 = p2_do[0];

   wire [15:0] p2_di;
   assign p2_di = { P2_DI15, P2_DI14, P2_DI13, P2_DI12, P2_DI11, P2_DI10, P2_DI9, P2_DI8,
		    P2_DI7, P2_DI6, P2_DI5, P2_DI4, P2_DI3, P2_DI2, P2_DI1, P2_DI0 };
   
   ttl_74LS244 u500(.A11(P_A1),
		   .A12(P_A2),
		   .A13(P_A3),
		   .A14(P_A4),
		   .A21(P_A5),
		   .A22(P_A6),
		   .A23(P_A7),
		   .A24(P_A8),
		   .Y11(P2_A01),
		   .Y12(P2_A02),
		   .Y13(P2_A03),
		   .Y14(P2_A04),
		   .Y21(P2_A05),
		   .Y22(P2_A06),
		   .Y23(P2_A07),
		   .Y24(P2_A08),
		   .G1(C_S3),
		   .G2(C_S3));

   ttl_74LS244 u501(.A11(MA17),
		   .A12(P_A10),
		   .A13(MA11),
		   .A14(MA12),
		   .A21(MA13),
		   .A22(MA14),
		   .A23(MA15),
		   .A24(MA16),
		   .Y11(P2_A01),
		   .Y12(P2_A02),
		   .Y13(P2_A03),
		   .Y14(P2_A04),
		   .Y21(P2_A05),
		   .Y22(P2_A06),
		   .Y23(P2_A07),
		   .Y24(P2_A08),
		   .G1(C_S3_n),
		   .G2(C_S3_n));

   ttl_74LS244 u504(.A11(P_D1),
		    .A12(P_D0),
		    .A13(P_D2),
		    .A14(P_D3),
		    .A21(P2_DO3),
		    .A22(P2_DO2),
		    .A23(P2_DO0),
		    .A24(P2_DO1),
		   .Y11(P2_DI1),
		   .Y12(P2_DI0),
		   .Y13(P2_DI2),
		   .Y14(P2_DI3),
		   .Y21(P_D3),
		   .Y22(P_D2),
		   .Y23(P_D0),
		   .Y24(P_D1),
		   .G1(P2_RW_n),
		   .G2(RD_RAM_n));

   ttl_74LS244 u505(.A11(P_D7),
		   .A12(P_D6),
		   .A13(P_D5),
		   .A14(P_D4),
		   .A21(P2_DO4),
		   .A22(P2_DO5),
		   .A23(P2_DO6),
		   .A24(P2_DO7),
		   .Y11(P2_DI7),
		   .Y12(P2_DI6),
		   .Y13(P2_DI5),
		   .Y14(P2_DI4),
		   .Y21(P_D4),
		   .Y22(P_D5),
		   .Y23(P_D6),
		   .Y24(P_D7),
		   .G1(P2_RW_n),
		   .G2(RD_RAM_n));

   ttl_74LS244 u502(.A11(P_A9),
		   .A12(MA18),
		   .A13(MA19),
		   .A14(MA20),
		   .A21(MA21),
		   .A22(MA22),
		   .A23(C_S4_n),
		   .A24(BEN_n),
		   .Y11(P2_A09),
		   .Y12(P2_A18),
		   .Y13(P2_A19),
		   .Y14(P2_A20),
		   .Y21(P2_A21),
		   .Y22(P2_A22),
		   .Y23(P2_CAS_n),
		   .Y24(P2_REFR_n),
		   .G1(1'b0),
		   .G2(1'b0));

   ttl_74LS244 u506(.A11(P_D9),
		   .A24(P2_DO9),
		   .A12(P_D8),
		   .A23(P2_DO8),
		   .A13(P_D10),
		   .A22(P2_DO10),
		   .A14(P_D11),
		   .A21(P2_DO11),
		   .Y11(P2_DI9),
		   .Y24(P_D9),
		   .Y12(P2_DI8),
		   .Y23(P_D8),
		   .Y13(P2_DI10),
		   .Y22(P_D10),
		   .Y14(P2_DI11),
		   .Y21(P_D11),
		   .G1(P2_RW_n),
		   .G2(RD_RAM_n));

   ttl_74LS244 u507(.A11(P_D15),
		   .A24(P2_DO15),
		   .A12(P_D14),
		   .A23(P2_DO14),
		   .A13(P_D13),
		   .A22(P2_DO13),
		   .A14(P_D12),
		   .A21(P2_DO12),
		   .Y11(P2_DI15),
		   .Y24(P_D15),
		   .Y12(P2_DI14),
		   .Y23(P_D14),
		   .Y13(P2_DI13),
		   .Y22(P_D13),
		   .Y14(P2_DI12),
		   .Y21(P_D12),
		   .G1(P2_RW_n),
		   .G2(RD_RAM_n));

   assign P2_RW_n = ~RW;

   ttl_74F74 u514_a(.D(H0),
		    .CLK(AS),
		    .Q(x_as),
		    .Q_n(),
		    .S(H1),
		    .R(C_S5_n));

   wire RASEN_n, P2_RAS_n, P2_WEL_n, P2_WEU_n;

   wire P_AS_n_xx;
   assign P_AS_n_xx = ~x_as;

   assign RASEN_n = ~(~C_S7 | ~SYSB);

   assign P2_RAS_n = ~(~RASEN_n & ~P_AS_n_xx);

   assign P2_WEL_n = ~(~P_LDS_n & ~WR_RAM_n);

   assign P2_WEU_n = ~(~P_UDS_n & ~WR_RAM_n);

   // -------------------

   wire MDS_n;
   
`ifdef xx
   ttl_9518 u801(.MP0(IOD8),
		 .MP1(IOD9),
		 .MP2(IOD10),
		 .MP3(IOD11),
		 .MP4(IOD12),
		 .MP5(IOD13),
		 .MP6(IOD14),
		 .MP7(IOD15),
		 .MCS_n(1'b0),
		 .MAS_n(MAS_n),
		 .MDS_n(MDS_n),
		 .MRW_n(P_RW_n),
		 .MFLG_n(),
		 .SP0(1'b1),
		 .SP1(1'b1),
		 .SP2(1'b1),
		 .SP3(1'b1),
		 .SP4(1'b1),
		 .SP5(1'b1),
		 .SP6(1'b1),
		 .SP7(1'b1),
		 .SCS_n(1'b1),
		 .SDS_n(1'b1),
		 .SFLG_n(),
		 .AUX0(1'b1),
		 .AUX1(1'b1),
		 .AUX2(1'b1),
		 .AUX3(1'b1),
		 .AUX4(1'b1),
		 .AUX5(1'b1),
		 .AUX6(1'b1),
		 .AUX7(1'b1),
		 .ASTB_n(1'b1),
		 .AFLG_n(),
		 .PAR_n()
		 .CK_n(1'b0),
		 .CLK(C400));
`endif
		   
ttl_am9513 u804(.D({IOD15,IOD14,IOD13,IOD12,IOD11,IOD10,IOD9,IOD8,IOD7,IOD6,IOD5,IOD4,IOD3,IOD2,IOD1,IOD0}),
		.CD_n(LA1_5[1]),
		.CS_n(1'b0),
		.RD_n(RD_TIMER_n),
		.WR_n(WR_TIMER_n),
		.X1(),
		.X2(C200),
		.FOUT(1'b0),
		.SRC1(1'b0),
		.SRC2(1'b0),
		.SRC3(1'b0),
		.SRC4(1'b0),
		.SRC5(1'b0),
		.SRC6(1'b0),
		.GAT1(1'b0),
		.GAT2(1'b0),
		.GAT3(1'b0),
		.GAT4(1'b0),
		.GAT5(1'b0),
		.OUT1(int7),
		.OUT2(int6a),
		.OUT3(int6b),
		.OUT4(int6c),
		.OUT5(int5));

   always @(posedge RD_TIMER_n)
     if (LA1_5[1])
       $display("timer read c %x", iodata);
     else
       $display("timer read d %x", iodata);

   always @(posedge WR_TIMER_n)
     if (LA1_5[1])
       $display("timer write c %x", iodata);
     else
       $display("timer write d %x", iodata);
   
   
   assign INT7_n = ~int7;
   assign INT6_n = ~(int6a | int6b | int6c);
   assign INT5_n = ~int5;

   ttl_Z8530 u806(.D({IOD15,IOD14,IOD13,IOD12,IOD11,IOD10,IOD9,IOD8}),
		  .WRFQA_n(),
		  .WRFQB_n(),
		  .IFI_n(1'b1),
		  .IFO_n(),
		  .INT(INT_SCC_n),
		  .INTA_n(1'b1),
		  .AB_n(LA1_5[2]),
		  .DC_n(LA1_5[1]),
		  .CE_n(1'b0),
		  .RD_n(RD_SCC_n),
		  .WR_n(WR_SCC_n),
		  .PCLK(C200),
		  .TXCA_n(TXCA_n),
		  .RXCA_n(RXCA_n),
		  .TXDA(TXDA),
		  .RXDA(RXDA),
		  .RTSA_n(RTSA_n),
		  .CTSA_n(CTSA_n),
		  .DTRA_n(DTRA_n),
		  .DCDA_n(DCDA_n),
		  .DSRA_n(SYNA_n),
		  .TXCB_n(TXCB_n),
		  .RXCB_n(RXCB_n),
		  .TXDB(TXDB),
		  .RXDB(RXDB),
		  .RTSB_n(RTSB_n),
		  .CTSB_n(CTSB_n),
		  .DTRB_n(DTRB_n),
		  .DCD_n(DCD_n),
		  .DSRN_n(SYNB_n));

   pal16R8_u602 u602(.D0(INIT_n),
		     .D1(1'b1),
		     .D2(1'b1),
		     .D3(WR_DCP_n),
		     .D4(RD_DCP_n),
		     .D5(1'b1),
		     .D6(LA1_5[1]),
		     .D7(1'b1),
		     .Q0_n(),
		     .Q1_n(),
		     .Q2_n(DCPACK_n),
		     .Q3_n(X200_n),
		     .Q4_n(X400_n),
		     .Q5_n(),
		     .Q6_n(XMDS_n),
		     .Q7_n(MAS_n),
		     .CLK(C100),
		     .OE_n(1'b0));

   assign MDS_n = XMDS_n;

   // -------------------

   // Address out
   ttl_74LS633 u700(.D1(P_LDS_n),
		    .D2(P_A1),
		    .D3(P_A2),
		    .D4(P_A3),
		    .D5(P_A4),
		    .D6(P_A5),
		    .D7(P_A6),
		    .D8(P_A7),
		    .Q1(P1_A0),
		    .Q2(P1_A1),
		    .Q3(P1_A2),
		    .Q4(P1_A3),
		    .Q5(P1_A4),
		    .Q6(P1_A5),
		    .Q7(P1_A6),
		    .Q8(P1_A7),
		    .EN(en),
		    .OE_n(AEN_n));
   
   ttl_74LS633 u701(.D1(MA12),
		    .D2(MA13),
		    .D3(MA14),
		    .D4(MA15),
		    .D5(MA11),
		    .D6(P_A10),
		    .D7(P_A9),
		    .D8(P_A8),
		    .Q1(P1_A12_n),
		    .Q2(P1_A13_n),
		    .Q3(P1_A14_n),
		    .Q4(P1_A15_n),
		    .Q5(P1_A11_n),
		    .Q6(P1_A10_n),
		    .Q7(P1_A9_n),
		    .Q8(P1_A8_n),
		    .EN(en),
		    .OE_n(AEN_n));

   assign d1 = IOLDS & IOUDS;
   
   ttl_74LS633 u702(.D1(d1),
		    .D2(H),
		    .D3(H),
		    .D4(H),
		    .D5(MA16),
		    .D6(MA17),
		    .D7(MA18),
		    .D8(MA19),
		    .Q1(P1_BHEN_n),
		    .Q2(),
		    .Q3(),
		    .Q4(),
		    .Q5(P1_A16_n),
		    .Q6(P1_A17_n),
		    .Q7(P1_A18_n),
		    .Q8(P1_A19_n),
		    .EN(en),
		    .OE_n(AEN_n));

   ttl_74LS633 u707(.D1(P1_A8_n),
		    .D2(P1_A9_n),
		    .D3(P1_A10_n),
		    .D4(P1_A11_n),
		    .D5(P1_A12_N),
		    .D6(P1_A13_n),
		    .D7(P1_A14_n),
		    .D8(P1_A15_n),
		    .Q1(P_A8),
		    .Q2(P_A9),
		    .Q3(P_A10),
		    .Q4(P_A11),
		    .Q5(P_A12),
		    .Q6(P_A13),
		    .Q7(P_A14),
		    .Q8(P_A15),
		    .EN(XEN_n),
		    .OE_n(XEN_n));
   
   ttl_74LS633 u708(.D1(P1_A16_n),
		    .D2(P1_A17_n),
		    .D3(P1_A18_n),
		    .D4(P1_A19_n),
		    .D5(1'b0),
		    .D6(1'b0),
		    .D7(1'b0),
		    .D8(1'b0),
		    .Q1(P_A16),
		    .Q2(P_A17),
		    .Q3(P_A18),
		    .Q4(P_A191),
		    .Q5(P_A20),
		    .Q6(P_A21),
		    .Q7(P_A22),
		    .Q8(P_A23),
		    .EN(XEN_n),
		    .OE_n(XEN_n));

`ifdef xx
    // Data buffers
    ttl_74LS640 u712(
		     .A0(P_D0),
		     .A1(P_D1),
		     .A2(P_D2),
		     .A3(P_D3),
		     .A4(P_D4),
		     .A5(P_D5),
		     .A6(P_D6),
		     .A7(P_D7),
		     .B0(P1_D0),
		     .B1(P1_D1),
		     .B2(P1_D2),
		     .B3(P1_D3),
		     .B4(P1_D4),
		     .B5(P1_D5),
		     .B6(P1_D6),
		     .B7(P1_D7),
		     .DR(P1TOP_n),
		     .CS_n(CE_WORD_n));
   
    ttl_74LS640 u713(.A0(P_D8),
		     .A1(P_D9),
		     .A2(P_D10),
		     .A3(P_D11),
		     .A4(P_D12),
		     .A5(P_D13),
		     .A6(P_D14),
		     .A7(P_D15),
		     .B0(P1_D8),
		     .B1(P1_D9),
		     .B2(P1_D10),
		     .B3(P1_D11),
		     .B4(P1_D12),
		     .B5(P1_D13),
		     .B6(P1_D14),
		     .B7(P1_D15),
		     .DR(P1TOP_n),
		     .CS_n(CE_WORD_n));

    ttl_74LS640 u714(.A0(P_D8),
		     .A1(P_D9),
		     .A2(P_D10),
		     .A3(P_D11),
		     .A4(P_D12),
		     .A5(P_D13),
		     .A6(P_D14),
		     .A7(P_D15),
		     .B0(P1_D0),
		     .B1(P1_D1),
		     .B2(P1_D2),
		     .B3(P1_D3),
		     .B4(P1_D4),
		     .B5(P1_D5),
		     .B6(P1_D6),
		     .B7(P1_D7),
		     .DR(P1TOP_n),
		     .CS_n(CE_BYTE_n));
`endif //  `ifdef xx
   
   assign en = C_S3 & C_S6_n;

   wire P1_BCLK_n;
   assign P1_BCLK_n = C100_n;
   
   assign BCLK = ~P1_BCLK_n;

   ttl_74F74 u105_b(.D(SYSB),
		    .CLK(BCLK),
		    .S(),
		    .R(),
		    .Q(d2),
		    .Q_n());
   
   assign SYSB = TYPE1 & C_S4;

   wire P1_BPRN_n, P1_INIT_n;
   assign P1_BPRN_n = 1'b1;
   assign P1_INIT_n = 1'b1;
   
   pal16R4_u718 u718(.D0(P1_BPRN_n),
		     .D1(P1_INIT_n),
		     .D2(d2),
		     .D3(1'b1),
		     .D4(1'b1),
		     .D5(1'b1),
		     .D6(1'b1),
		     .D7(1'b1),
		     .O0_n(P1_BPRO_n),
		     .O1_n(P1_BUSY_n),
		     .Q0_n(AEN_n),
		     .Q1_n(),
		     .Q2_n(),
		     .Q3_n(),
		     .O2_n(P1_CBRQ_n),
		     .O3_n(P1_BREQ_n),
		     .CLK(BCLK),
		     .OE_n(1'b0));
   
   ttl_74F74 u709_a(.D(AEN_n),
		    .CLK(C100_n),
		    .S(SYSB),
		    .R(H),
		    .Q(DATAEN_n),
		    .Q_n(qb));

    assign d = ~(qb & RREQ_n);

    ttl_74F74 u709_b(.D(d),
		    .CLK(C100_n),
		    .S(SYSB),
		    .R(BEN_n),
		    .Q(BEN_n),
		     .Q_n());
   
   assign XMWTC_n = ~(~MWTC_n & ~ENDS6);
   assign XIOWC_n = ~(~IOWC_n & ~ENDS6);

   tri1 y24;

   tri1 P1_XACK_n, P1_WRDC_n, P1_IORC_n, P1_MWTC_n, P1_IOWC_n;
   
   ttl_74LS244 u717(.A11(MRDC_n),
		   .A12(IORC_n),
		   .A13(XMWTC_n),
		   .A14(XIOWC_n),
		   .A21(P1_INIT_n),
		   .A22(C100),
		   .A23(C100),
		   .A24(P1_XACK_n),
		   .Y11(P1_WRDC_n),
		   .Y12(P1_IORC_n),
		   .Y13(P1_MWTC_n),
		   .Y14(P1_IOWC_n),
		   .Y21(),
		   .Y22(),
		   .Y23(),
		   .Y24(y24),
		   .G1(BEN_n),
		   .G2(1'b0));

   assign XACK = ~y24 & ~AEN_n;
		     
   // -------------------

   reg [7:0]   diag_reg;

   always @(posedge WR_DIAG_n or negedge P_RESET_n)
     if (WR_DIAG_n)
       diag_reg <= p_databus;
     else
       if (~P_RESET_n)
	 diag_reg <= 8'b0;
  

   wire [7:0]  leds;
   assign leds = diag_reg;


   // -------------------

   reg [22:0]  p2_cap_addr = 0;

   wire [22:0] p2_addr;
   assign p2_addr = { P2_A22, P2_A21, P2_A20, P2_A19, P2_A18,   1'b0,   1'b0,
                        1'b0,   1'b0,   1'b0,   1'b0,   1'b0,   1'b0, P2_A09, P2_A08,
		      P2_A07, P2_A06, P2_A05, P2_A04, P2_A03, P2_A02, P2_A01, 1'b0    };
   
   always @(posedge C100_n)
     if (C_S3_n & ~P2_RAS_n)
       begin
	  p2_cap_addr[9:0] <= { P2_A09, P2_A08,
				P2_A07, P2_A06, P2_A05, P2_A04,
				P2_A03, P2_A02, P2_A01, 1'b0 };
	  p2_cap_addr[22:18] <= { P2_A22, P2_A21, P2_A20, P2_A19, P2_A18 };
       end

   always @(posedge C100)
       if (~C_S3_n & ~P2_CAS_n)
	 begin
	    p2_cap_addr[17] <= P2_A01;
	    p2_cap_addr[10] <= P2_A02;
	    p2_cap_addr[11] <= P2_A03;
	    p2_cap_addr[12] <= P2_A04;
	    p2_cap_addr[13] <= P2_A05;
	    p2_cap_addr[14] <= P2_A06;
	    p2_cap_addr[15] <= P2_A07;
	    p2_cap_addr[16] <= P2_A08;
	 end

   wire go_n;
   assign go_n = ~(~RD_RAM_n | ~WR_RAM_n);
   
   p2_intf p2_bus(.clk(C100_n),
		  .addr(p2_cap_addr),
		  .ras_n(P2_RAS_n),
		  .cas_n(P2_CAS_n),
		  .wel_n(P2_WEL_n),
		  .weu_n(P2_WEU_n),
		  .rw_n(P2_RW_n),
		  .go_n(go_n),
		  .wait_n(P2_WAIT_n),
		  .datai(p2_di),
		  .datao(p2_do));
		       
endmodule
