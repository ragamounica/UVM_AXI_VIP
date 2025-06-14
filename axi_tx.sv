class axi_tx;//same tx can write also read also
	rand bit [31:0] addr;
	rand bit [31:0] dataQ[$];
	rand bit [3:0] len;
	rand bit wr_rd;//Based on this, below fields will be understood as either write related fields and read related fields
	rand burst_size_t burst_size;//no. of bytes per beat
	rand bit [3:0] id;//awid, wid, bid, id, - No need to declare all id's
	rand burst_type_t burst_type;
	rand lock_t lock;
	rand bit [2:0] prot;//All 3 bits have different meanings, no need to do enum
	rand bit [3:0] cache;//All 3 bits have different meanings, no need to do enum
	rand resp_t resp;
	//wstrb is not required, it will be taken care of bfm

	constraint dataQ_c {
		dataQ.size() == len+1;
	}

		constraint rsvd_c {
		burst_type != RSVD_BURSTT;
		lock != RSVD_LOCKT;
		resp == OKAY;
	}

	constraint soft_c {
		soft resp == OKAY;
		soft burst_size == 2;
		soft burst_type == INCR;
		soft prot == 3'b0;
		soft cache == 4'b0;
		soft lock == NORMAL;
	}

	function void print();
		$display("#########################");
		$display("### axi_tx::print ###");
		$display("#########################");
		$display("id=%h", id);
		$display("addr=%h", addr);
		$display("dataQ=%p", dataQ);
		$display("len=%h", len);
		$display("wr_rd=%s", wr_rd ? "WRITE" : "READ");
		$display("size=%s", 
			burst_size == 3'b000 ? "BURST_SIZE_1_BYTE" : 
			burst_size == 3'b001 ? "BURST_SIZE_2_BYTE" : 
			burst_size == 3'b010 ? "BURST_SIZE_4_BYTE" : 
			burst_size == 3'b011 ? "BURST_SIZE_8_BYTE" :
			burst_size == 3'b100 ? "BURST_SIZE_16_BYTE" : 
			burst_size == 3'b101 ? "BURST_SIZE_32_BYTE" : 
			burst_size == 3'b110 ? "BURST_SIZE_64_BYTE" : "BURST_SIZE_128_BYTE");
		
		$display("burst=%s", burst_type);
		$display("lock=%s", lock);
		$display("prot=%h", prot);
		$display("cache=%h", cache);
		$display("resp=%s", resp);
	endfunction

endclass
