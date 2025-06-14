`include "axi_assertion.sv"
`include "axi_slave.sv"
`include "axi_memory.sv"
`include "axi_common.sv"
`include "axi_intf.sv"
`include "axi_tx.sv"
`include "axi_bfm.sv"
`include "axi_cov.sv"
//typedef class axi_gen;
//typedef class axi_mon;
`include "axi_gen.sv"
`include "axi_mon.sv"
`include "axi_env.sv"

module top;
reg clk, rst;

axi_intf pif(clk, rst);//Interface Instantiation
axi_env env;//AS we are skiping the program block, we instantiate env in top module

initial begin
	clk = 0;
	forever #5 clk = ~clk;
end

initial begin
	if (!$value$plusargs("testname=%s", axi_common::testname)) begin
		axi_common::testname = "test_5_wr_5_rd"; // Default if not passed from command line
	end	
	axi_common::vif = pif; //Assigning physical interface handle to virtual interface
	rst = 1;
	reset_design_inputs();
	@(posedge clk);
	rst = 0;
	env = new();
	env.run();
end

axi_assertion axi_assertion_i();//Assertion module instantiation

//pif signals should be connected to axi_slaves ports
//format required: .awid(pif.awid), all lines should be like this
//So, here there is a pattern in coding, then we can make GVIM function
axi_slave dut(
	.aclk(pif.aclk),
	.arst(pif.arst),
	.awid(pif.awid),
	.awaddr(pif.awaddr),
	.awlen(pif.awlen),
	.awsize(pif.awsize),
	.awburst(pif.awburst),
	.awlock(pif.awlock),
	.awcache(pif.awcache),
	.awprot(pif.awprot),
	.awqos(pif.awqos),
	.awregion(pif.awregion),
	.awvalid(pif.awvalid),
	.awready(pif.awready),
	.wid(pif.wid),
	.wdata(pif.wdata),
	.wstrb(pif.wstrb),
	.wlast(pif.wlast),
	.wvalid(pif.wvalid),
	.wready(pif.wready),
	.bid(pif.bid),
	.bresp(pif.bresp),
	.bvalid(pif.bvalid),
	.bready(pif.bready),
	.arid(pif.arid),
	.araddr(pif.araddr),
	.arlen(pif.arlen),
	.arsize(pif.arsize),
	.arburst(pif.arburst),
	.arlock(pif.arlock),
	.arcache(pif.arcache),
	.arprot(pif.arprot),
	.arqos(pif.arqos),
	.arregion(pif.arregion),
	.arvalid(pif.arvalid),
	.arready(pif.arready),
	.rid(pif.rid),
	.rdata(pif.rdata),
	.rlast(pif.rlast),
	.rvalid(pif.rvalid),
	.rready(pif.rready),
	.rresp(pif.rresp)
	);

initial begin
	#500;
	$finish;
end

task reset_design_inputs();
	pif.awid = 0;
	pif.awaddr = 0; 
	pif.awlen = 0;
	pif.awsize = 0;
	pif.awburst = 0;
	pif.awlock = 0;
	pif.awcache = 0;
	pif.awprot = 0;
	pif.awqos = 0;
	pif.awregion = 0;
	pif.awvalid = 0;
	pif.wid = 0;
	pif.wdata =  0;
	pif.wstrb = 0;
	pif.wlast = 0;
	pif.wvalid = 0;
	pif.bready = 0;
	pif.arid = 0;
	pif.araddr = 0;
	pif.arlen = 0;
	pif.arsize = 0;
	pif.arburst = 0;
	pif.arlock = 0;
	pif.arcache = 0;
	pif.arprot = 0;
	pif.arqos = 0;
	pif.arregion = 0;
	pif.arvalid = 0;
	pif.rready =0;
endtask

endmodule
