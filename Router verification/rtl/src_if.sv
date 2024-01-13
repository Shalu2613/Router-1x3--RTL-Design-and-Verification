interface src_if(input bit clock);
	logic pkt_vld;
	logic [7:0]din;
	logic resetn;
	logic error,busy;

//	assign clk=clock;

	clocking sdr_cb @ (posedge clock);
	    default input #1 output #1;
	    output din;
	    output resetn;
	    output pkt_vld;
	    input error;
	    input busy;
	  endclocking:sdr_cb
	
	clocking smon_cb @ (posedge clock);
		 default input #1 output #1;
		input din;
		input resetn;
		input pkt_vld;
		input error;
		input busy;
	endclocking:smon_cb

	modport SDR_MP (clocking sdr_cb);
	
	modport SMON_MP (clocking smon_cb);
endinterface
