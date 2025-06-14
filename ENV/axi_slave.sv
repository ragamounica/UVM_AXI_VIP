//Memory with AXI Interface
module axi_slave(
	input logic aclk, arst,
	input logic [3:0] awid,
	input logic [31:0] awaddr,
	input logic [3:0] awlen,
	input logic [2:0] awsize,
	input logic [1:0] awburst,
	input logic [1:0] awlock,
	input logic [3:0] awcache,
	input logic [2:0] awprot,
	input logic awqos,
	input logic awregion,
	input logic awvalid,
	output reg awready,
	input logic [3:0] wid,
	input logic [64-1:0] wdata,
	input logic [3:0] wstrb,
	input logic wlast,
	input logic wvalid,
	output reg wready,
	output reg [3:0] bid,
	output reg [1:0] bresp,
	output reg bvalid,
	input logic bready,
	input logic [3:0] arid,
	input logic [31:0] araddr,
	input logic [3:0] arlen,
	input logic [2:0] arsize,
	input logic [1:0] arburst,
	input logic [1:0] arlock,
	input logic [3:0] arcache,
	input logic [2:0] arprot,
	input logic arqos,
	input logic arregion,
	input logic arvalid,
	output reg arready,
	output reg [3:0] rid,
	output reg [64-1:0] rdata,
	output reg rlast,
	output reg rvalid,
	input logic rready,
	output reg [1:0] rresp
	);
parameter WIDTH=64;

//reg[WIDTH-1:0] mem[DEPTH-1:0];
reg[WIDTH-1:0] mem[int];

reg[3:0] awid_t;
reg[31:0] awaddr_t;
reg[3:0] awlen_t;
reg[2:0] awsize_t;
reg[1:0] awburst_t;
reg[1:0] awlock_t;
reg[3:0] awcache_t;
reg[2:0] awprot_t;
reg[3:0] arid_t;
reg[31:0] araddr_t;
reg[3:0] arlen_t;
reg[2:0] arsize_t;
reg[1:0] arburst_t;
reg[1:0] arlock_t;
reg[3:0] arcache_t;
reg[2:0] arprot_t;
integer write_count;

//slave needs to complete handshaking
//All the outputs should be made 0
always @(posedge aclk) begin
if (arst == 1) begin
	arready = 0;
	wready = 0;
	awready = 0;
	rid = 0;
	rdata = 0;
	rlast = 0;
	rvalid = 0;
	bid = 0;
	bvalid = 0;
	write_count = 0;

end
else begin
	//Write address channel handshake
	if (awvalid == 1) begin
		awready = 1;
		//Slave is collecting the write address information in to the
		//temporary variables 
		awaddr_t = awaddr;
		awlen_t = awlen;
		awsize_t = awsize;
		awburst_t = awburst;
		awid_t = awid;
		awlock_t = awlock;
		awprot_t = awprot;
		awcache_t = awcache;
		write_count = 0;
	end
	else begin
		awready = 0;
	end

	//Write data channel handshake
	if (wvalid == 1) begin
		wready = 1;
		store_write_data();
		write_count++;//check if write_count == awlen_t + 1	
		if(wlast == 1) begin
			if(write_count != awlen_t + 1) begin
				$error("Write bursts are not matching awlen+1");
			end
			write_resp_phase(wid);
		end
	end
	else begin
		wready = 0;
	end

	//Read address channel handshake
	if (arvalid == 1) begin
		arready = 1;
		araddr_t = araddr;
		arlen_t = arlen;
		arsize_t = arsize;
		arburst_t = arburst;
		arid_t = arid;
		arlock_t = arlock;
		arprot_t = arprot;
		arcache_t = arcache;
		drive_read_data();//master has given me read request, I need to provide read data
	end
	else begin
		arready = 0;
	end
end	
end	

//This task represents one beat of AXI tx
task store_write_data();
	if(awsize_t == 0) begin
		mem[awaddr_t] = wdata[7:0];
	end

	if(awsize_t == 1) begin
		mem[awaddr_t] = wdata[7:0];
		mem[awaddr_t+1] = wdata[15:8];
	end

	if(awsize_t == 2) begin
		mem[awaddr_t] = wdata[7:0];
		mem[awaddr_t+1] = wdata[15:8];
		mem[awaddr_t+2] = wdata[23:16];
		mem[awaddr_t+3] = wdata[31:24];
	end

	if(awsize_t == 3) begin
		mem[awaddr_t] = wdata[7:0];
		mem[awaddr_t+1] = wdata[15:8];
		mem[awaddr_t+2] = wdata[23:16];
		mem[awaddr_t+3] = wdata[31:24];
		mem[awaddr_t+4] = wdata[39:32];
		mem[awaddr_t+5] = wdata[47:40];
		mem[awaddr_t+6] = wdata[55:48];
		mem[awaddr_t+7] = wdata[63:56];
	end
	
	//Slave should internally update it's address, because whatever next
	//data comes, it should store to different address as per burst type
	awaddr_t += 2**awsize_t;
	//we need to do wrap upper boundary check, if it crosses, then do wrap
	//to lower update

endtask

task drive_read_data();
for(int i=0; i<arlen_t+1; i++)begin
	@(posedge aclk);
	if(arsize_t == 0) begin
		rdata[7:0] = mem[araddr_t];
	end

	if(arsize_t == 1) begin
		rdata[7:0] = mem[araddr_t];
		rdata[15:8] = mem[araddr_t+1];
	end

	if(arsize_t == 2) begin
		rdata[7:0] = mem[araddr_t];
		rdata[15:8] = mem[araddr_t+1];
		rdata[23:16] = mem[araddr_t+2];
		rdata[31:24] = mem[araddr_t+3];
	end
	if(arsize_t == 3) begin
		rdata[7:0] =   mem[araddr_t]  ;
		rdata[15:8] =  mem[araddr_t+1];
		rdata[23:16] = mem[araddr_t+2];
		rdata[31:24] = mem[araddr_t+3];
		rdata[39:32] = mem[araddr_t+4];
		rdata[47:40] = mem[araddr_t+5];
		rdata[55:48] = mem[araddr_t+6];
		rdata[63:56] = mem[araddr_t+7];
	end

	rvalid = 1;
	rid = arid_t;
	rresp = 2'b00;//OKAY Response
	if(i == arlen_t) rlast = 1;//The last beat of read data phase
	wait(rready == 1);
	//Slave should internally update it's address, because whatever next
	//data comes, it should store to different address as per burst type
	araddr_t += 2**arsize_t;
	//we need to do wrap upper boundary check, if it crosses, then do wrap
	//to lower update
end
	@(posedge aclk);
	rvalid = 0;
	rid = 0;
	rdata = 0;
	rlast = 0;
endtask

task write_resp_phase(input [3:0] id);
	begin
		@(posedge aclk);
		bvalid = 1;
		bid = id;
		bresp = 2'b00;
		wait (bready == 1);
		@(posedge aclk);
		bvalid = 0;
	end
endtask

endmodule
