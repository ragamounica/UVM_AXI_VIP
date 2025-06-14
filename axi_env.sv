//`ifndef AXI_ENV//2nd time we compile this file, this macro is already defined, hence `ifdef will be false
//`define AXI_ENV
class axi_env;
	axi_bfm bfm;
	axi_gen gen;
	axi_mon mon;
	axi_cov cov;

	function new();
		bfm = new();
		gen = new();
		mon = new();
		cov = new();
	endfunction

	task run();
	fork
		bfm.run();
		gen.run();
		mon.run();
		cov.run();
	join
	endtask
endclass
