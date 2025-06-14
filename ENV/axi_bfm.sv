class axi_bfm;
	axi_tx tx;
	virtual axi_intf vif;//virtual interface
	task run();
		$display("axi_bfm::run");
		vif = axi_common::vif;
		forever begin
			axi_common::gen2bfm.get(tx);
			tx.print();
			drive_tx(tx);
		end
	endtask

	//Drive this transaction to the interface
	task drive_tx(axi_tx tx);
		case(tx.wr_rd)
			WRITE : begin
				write_addr_phase(tx);
				write_data_phase(tx);
				write_resp_phase(tx);
			end

			READ : begin
				read_addr_phase(tx);
				read_data_phase(tx);
			end
		endcase
	endtask
	
	//To implement these tasks, open write timing diagram
	task write_addr_phase(axi_tx tx);
		$display("Write_addr_phase");
		@(posedge vif.aclk);
		vif.awid = tx.id;
		vif.awaddr = tx.addr;
		vif.awlen = tx.len;
		vif.awsize = tx.burst_size;
		vif.awburst = tx.burst_type;
		vif.awlock = tx.lock;
		vif.awcache = tx.cache;
		vif.awprot = tx.prot;
		vif.awqos = 1'b0;
		vif.awregion = 1'b0;
		vif.awvalid = 1;
		wait(vif.awready == 1); //Waiting for handshaking completion
		@(posedge vif.aclk);
		vif.awvalid = 0;
		vif.awid = 0;
		vif.awaddr = 0;
		vif.awlen = 0;
		vif.awsize = 0;
		vif.awburst = 0;
		vif.awlock = 0;
		vif.awcache = 0;
		vif.awprot = 0;

	endtask

	task write_data_phase(axi_tx tx);
	$display("Write _data_phase");
	for (int i=0; i<=tx.len; i++) begin
		@(posedge vif.aclk);
		vif.wdata = tx.dataQ.pop_front();
		vif.wid = tx.id;
		vif.wstrb = 4'hF;//A:; byte transfer
		vif.wlast = (i == tx.len) ? 1 : 0;
		vif.wvalid = 1;
		wait(vif.wready == 1);//waiting for handshake completion	
	end
		@(posedge vif.aclk);
		vif.wdata = 0;
		vif.wid = 0;
		vif.wstrb = 0;
		vif.wlast = 0;
		vif.wvalid = 0;
	endtask

	task write_resp_phase(axi_tx tx);
		$display("Write _resp_phase");
		@(posedge vif.aclk);
		while (vif.bvalid == 0) begin
			@(posedge vif.aclk);
		end
		vif.bready = 1;
		@(posedge vif.aclk);
		vif.bready = 0;
	endtask

	task read_addr_phase(axi_tx tx);
		$display("read _addr_phase");
		@(posedge vif.aclk);
		vif.arid = tx.id;
		vif.araddr = tx.addr;
		vif.arlen = tx.len;
		vif.arsize = tx.burst_size;
		vif.arburst = tx.burst_type;
		vif.arlock = tx.lock;
		vif.arcache = tx.cache;
		vif.arprot = tx.prot;
		vif.arqos = 1'b0;
		vif.arregion = 1'b0;
		vif.arvalid = 1;
		wait(vif.arready == 1); //Waiting for handshaking completion
		@(posedge vif.aclk);
		vif.arvalid = 0;
		vif.arid = 0;
		vif.araddr = 0;
		vif.arlen = 0;
		vif.arsize = 0;
		vif.arburst = 0;
		vif.arlock = 0;
		vif.arcache = 0;
	endtask

	task read_data_phase(axi_tx tx);
		tx.dataQ.delete();//since I'm getting data from slave, I'm emptying dataQ to hold the read data coming from slave
		$display("read _data_phase");
		for (int i=0; i<=tx.len; i++) begin
			@(posedge vif.aclk);
		while (vif.rvalid == 0) begin
			vif.rready = 1;
			@(posedge vif.aclk);
		end//when rvalid=1, while loop exits, I get indication that master is giving me valid read data
		tx.dataQ.push_back(vif.rdata);//Pushing read data into the dataQ
		//To complete handshaking, axi_bfm make rready=1
		@(posedge vif.aclk);//wait for one dge of clock
		vif.rready = 0;
		end
		//By the time loop completes, dataQ has all read data
	endtask
endclass
