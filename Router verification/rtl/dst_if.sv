interface dst_if(input bit clock);
	logic [7:0]dout;
	logic vld_out;
	logic rd_enb;

	//assign clk=clock;

	clocking ddrv_cb@ (posedge clock);
	    default input #1 output #1;
		input vld_out;
		output rd_enb;
	endclocking:ddrv_cb

	clocking dmon_cb@ (posedge clock);
            default input #1 output #1;
                input dout;
                input rd_enb;
        endclocking:dmon_cb

	modport DDR_MP(clocking ddrv_cb);
	
	modport DMON_MP(clocking dmon_cb);
endinterface

