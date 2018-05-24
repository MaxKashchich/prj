module c5gt_pcie_gen2x4 (

	input	cpu_resetn,

	input CLK_125_P, // for PCIe
//	input clkin_r_p, // for DDR3b  100MHz
   input clkinbot_p,	//for DDR3a  100MHz
	
	output [3:0]	pcie_tx_p,		 	 //1.5-V PCML
	input  [3:0]	pcie_rx_p,		 	 //1.5-V PCML
	input 			pcie_refclk_p,	 	 //HCSL	
	input				pcie_perstn,		 //2.5V

	
   output  [13:0] ddr3a_a,
	output  [2:0] ddr3a_ba,
	output  ddr3a_clk_p,
	output  ddr3a_clk_n,
	output  ddr3a_cke,
	output  ddr3a_csn,
	output  ddr3a_rasn,
	output  ddr3a_casn,
	output  ddr3a_wen,
	output  ddr3a_resetn,
	output  ddr3a_odt,
	output  [4:0] ddr3a_dm,
	inout  [39:0] ddr3a_dq,
	inout  [4:0] ddr3a_dqs_p,
	inout  [4:0] ddr3a_dqs_n,


	
//	output [13 : 0]	ddr3b_a,
//	output [2 : 0]		ddr3b_ba,
//	output ddr3b_casn,
//	output ddr3b_clk_n,
//	output ddr3b_clk_p,
//	output ddr3b_cke,
//	output ddr3b_csn,
//	output [7 : 0]ddr3b_dm,
//	inout [63:0]ddr3b_dq,
//	inout [7 : 0]ddr3b_dqs_n,
//	inout [7 : 0]ddr3b_dqs_p,
//	output ddr3b_odt,
//	output ddr3b_rasn,
//	output ddr3b_resetn,
//	output ddr3b_wen,
	
	
	input rzqin_1_5v,

	
	
//user LED
	output 	[3:0]	user_led			//2.5V
);



wire [31:0]  hip_ctrl_test_in;          //           .test_in
wire         fbout_reconfigclk;
wire [52:0]  tl_cfg_tl_cfg_sts;
wire [31:0] tl_cfg_tl_cfg_ctl;            //            tl_cfg.tl_cfg_ctl
wire [3:0]  tl_cfg_tl_cfg_add;            //                  .tl_cfg_add
wire        status_hip_rx_par_err;        //        status_hip.rx_par_err
wire [3:0]  status_hip_int_status;        //                  .int_status
wire        status_hip_derr_cor_ext_rcv;  //                  .derr_cor_ext_rcv
wire        status_hip_dlup_exit;         //                  .dlup_exit
wire [11:0] status_hip_ko_cpl_spc_data;   //                  .ko_cpl_spc_data
wire        status_hip_l2_exit;           //                  .l2_exit
wire        status_hip_ev1us;             //                  .ev1us
wire        status_hip_derr_rpl;          //                  .derr_rpl
wire [3:0]  status_hip_lane_act;          //                  .lane_act
wire        status_hip_ev128ns;           //                  .ev128ns
wire [1:0]  status_hip_currentspeed;      //                  .currentspeed
wire        status_hip_hotrst_exit;       //                  .hotrst_exit
wire        status_hip_derr_cor_ext_rpl;  //                  .derr_cor_ext_rpl
wire [7:0]  status_hip_ko_cpl_spc_header;//                  .ko_cpl_spc_header
wire        pld_clk_clk;
wire 		reconfig_xcvr_clk;

//assign reconfig_xcvr_clk = clkintop_100_p; // 100MHz clk for reconfig block


assign hip_ctrl_test_in[4:0]  =  5'b01000;
assign hip_ctrl_test_in[31:5] =  27'h5;


  reg     [ 24: 0] alive_cnt;
  wire             any_rstn;
  reg              any_rstn_r /* synthesis ALTERA_ATTRIBUTE = "SUPPRESS_DA_RULE_INTERNAL=R102"  */;
  reg              any_rstn_rr /* synthesis ALTERA_ATTRIBUTE = "SUPPRESS_DA_RULE_INTERNAL=R102"  */;
  wire             gen2_speed;
  wire [5:0]       ltssm;
  wire             cbb_sw;

//assign any_rstn = pcie_perstn & cpu_resetn;
assign any_rstn = pcie_perstn;
//assign hsma_clk_out_p2 = reconfig_xcvr_clk;
assign gen2_speed = tl_cfg_tl_cfg_sts[32:31] == 2'b10;
//assign cbb_sw = req_compliance_pb;

  //reset Synchronizer
  always @(posedge reconfig_xcvr_clk or negedge any_rstn)
    begin
      if (any_rstn == 0)
        begin
          any_rstn_r <= 0;
          any_rstn_rr <= 0;
        end
      else
        begin
          any_rstn_r <= 1;
          any_rstn_rr <= any_rstn_r;
        end
    end



  //LED logic
  reg alive_led;
  reg comp_led;
  reg L0_led;
  reg  gen2_led;
  reg [3:0] lane_active_led;
  
	assign user_led[0] = alive_led;
	assign user_led[1] = comp_led;
	assign user_led[2] = L0_led;
//	assign user_led[3] = gen2_led;
	reg led;
	assign user_led[3] = led;

  always @(posedge pld_clk_clk or negedge any_rstn_rr)
    begin
      if (any_rstn_rr == 0)begin
			led <= 1;
      end else begin
			if(ltssm == 5'b01111)begin
				led <= 0;
			end else begin
				led <= 0;
			end
      end
    end

	 
  always @(posedge pld_clk_clk or negedge any_rstn_rr)
    begin
      if (any_rstn_rr == 0)
        begin
          alive_cnt <= 0;
          alive_led <= 0;
          comp_led <= 0;
          L0_led <= 0;
          gen2_led <= 0;
          lane_active_led[3:0] <= 0;
        end
      else
        begin
          alive_cnt <= alive_cnt +1;
          alive_led <= alive_cnt[24];
          comp_led <= ~(ltssm[4 : 0] == 5'b00011);
          L0_led <= ~(ltssm[4 : 0] == 5'b01111);
          gen2_led <= ~gen2_speed;
          if (tl_cfg_tl_cfg_sts[35])
            lane_active_led <= ~(4'b0001);
          else if (tl_cfg_tl_cfg_sts[36])
            lane_active_led <= ~(4'b0011);
          else if (tl_cfg_tl_cfg_sts[37])
            lane_active_led <= ~(4'b1111);
          else if (tl_cfg_tl_cfg_sts[38])
            lane_active_led <= alive_cnt[24] ? ~(4'b1111) : ~(4'b0111);
        end
    end

	//assign reconfig_xcvr_clk = clkintop_100_p; // 125MHz clk for reconfig block	 
//	pll pll (
//		.refclk(clkintop_100_p),   //  refclk.clk  // input is actually 125MHz
//		.rst(any_rstn_rr),      //   reset.reset
//		.outclk_0(reconfig_xcvr_clk)  // outclk0.clk  100MHz
//	);

	assign reconfig_xcvr_clk = CLK_125_P;
    q_sys u0 (
        .clk_0_clk_reset_reset_n                                (),
        .clk_0_clk_clk                                          (pld_clk_clk),
        .pcie_cv_hip_avmm_0_refclk_clk                          (pcie_refclk_p),
        .pcie_cv_hip_avmm_0_npor_npor                           (any_rstn_rr),
        .pcie_cv_hip_avmm_0_npor_pin_perst                      (pcie_perstn),
        .pcie_cv_hip_avmm_0_hip_ctrl_test_in                    (hip_ctrl_test_in),
        .pcie_cv_hip_avmm_0_hip_ctrl_simu_mode_pipe             (1'b0),
//        .alt_xcvr_reconfig_0_mgmt_clk_clk_clk                   (reconfig_xcvr_clk),
        .alt_xcvr_reconfig_0_mgmt_clk_clk_clk                   (CLK_125_P),
        .alt_xcvr_reconfig_0_mgmt_rst_reset_reset               (!fixedclk_locked),
		  
        .alt_xcvr_reconfig_0_reconfig_mgmt_address              (7'h0),
        .alt_xcvr_reconfig_0_reconfig_mgmt_read                 (1'b0),
        .alt_xcvr_reconfig_0_reconfig_mgmt_readdata             (32'h0),
        .alt_xcvr_reconfig_0_reconfig_mgmt_waitrequest          (1'b0),
        .alt_xcvr_reconfig_0_reconfig_mgmt_write                (1'b0),
        .alt_xcvr_reconfig_0_reconfig_mgmt_writedata            (32'h0),
		  
        .pcie_cv_hip_avmm_0_reconfig_clk_locked_fixedclk_locked (fixedclk_locked),

		  // x1
        .pcie_cv_hip_avmm_0_hip_serial_rx_in0                   (pcie_rx_p[0]),
        .pcie_cv_hip_avmm_0_hip_serial_tx_out0                  (pcie_tx_p[0]),

			// x4
        .pcie_cv_hip_avmm_0_hip_serial_rx_in1                   (pcie_rx_p[1]),
        .pcie_cv_hip_avmm_0_hip_serial_rx_in2                   (pcie_rx_p[2]),
        .pcie_cv_hip_avmm_0_hip_serial_rx_in3                   (pcie_rx_p[3]),
        .pcie_cv_hip_avmm_0_hip_serial_tx_out1                  (pcie_tx_p[1]),
        .pcie_cv_hip_avmm_0_hip_serial_tx_out2                  (pcie_tx_p[2]),
        .pcie_cv_hip_avmm_0_hip_serial_tx_out3                  (pcie_tx_p[3]),
		  
        .pcie_cv_hip_avmm_0_hip_pipe_sim_pipe_pclk_in           (1'b0),
        .pcie_cv_hip_avmm_0_hip_pipe_sim_pipe_rate              (),
        .pcie_cv_hip_avmm_0_hip_pipe_sim_ltssmstate             (ltssm),
		  
        .memory_mem_a                                           (ddr3a_a),
        .memory_mem_ba                                          (ddr3a_ba),
        .memory_mem_ck                                          (ddr3a_clk_p),
        .memory_mem_ck_n                                        (ddr3a_clk_n),
        .memory_mem_cke                                         (ddr3a_cke),
        .memory_mem_cs_n                                        (ddr3a_csn),
        .memory_mem_dm                                          (ddr3a_dm),
        .memory_mem_ras_n                                       (ddr3a_rasn),
        .memory_mem_cas_n                                       (ddr3a_casn),
        .memory_mem_we_n                                        (ddr3a_wen),
        .memory_mem_reset_n                                     (ddr3a_resetn),
        .memory_mem_dq                                          (ddr3a_dq),
        .memory_mem_dqs                                         (ddr3a_dqs_p),
        .memory_mem_dqs_n                                       (ddr3a_dqs_n),
        .memory_mem_odt                                         (ddr3a_odt),
        .oct_rzqin                                              (rzqin_1_5v),
        .clk_100_clk                                            (clkinbot_p),
        .reset_100_reset_n                                      (cpu_resetn)

    );

endmodule