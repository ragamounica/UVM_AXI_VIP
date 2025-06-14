class axi_gen;
	axi_tx tx;
	axi_tx txQ[$];
	task run();
	$display("axi_gen::run");
	$display("Selected testname: %s", axi_common::testname);	
	case(axi_common::testname)
		"test_5_wr" : begin
			repeat(5) begin
				tx = new();
				tx.randomize() with {wr_rd == WRITE;};
				axi_common::gen2bfm.put(tx);
			end
		end

		"test_5_wr_5_rd" : begin
			for(int i=0; i<5; i++) begin
				tx = new();
				tx.randomize() with {wr_rd == WRITE;};//Writes will happen to random locations
				axi_common::gen2bfm.put(tx);
				txQ[i] = new tx;//doing shallow copy when tx=new is done again, it shouldn't impact queue tx's in the queue 
			end
			for(int i=0; i<5; i++) begin
				tx = new();
				//tx.randomize() with {wr_rd == READ;};//Reads will happen to random locations
				tx.randomize() with {wr_rd == READ; addr == txQ[i].addr; len == txQ[i].len; burst_size == txQ[i].burst_size;};//making sure that, read also happens same as write
				axi_common::gen2bfm.put(tx);
			end
		end
	endcase
	endtask
endclass
