class router_src_driver extends uvm_driver #(write_xtn);
	
	//Factory Registration
	`uvm_component_utils(router_src_driver)

        //Properties
	router_src_agent_config src_cfg;
	
	virtual src_if.SDR_MP svif;
		
		//------------------------------------------
		// Methods
		//------------------------------------------
		// Standard UVM Methods:
	extern function new(string name = "router_src_driver", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
        extern task send_to_dut(write_xtn xtn);
	extern function void report_phase(uvm_phase phase);

endclass:router_src_driver

	//Constructor-new
	function router_src_driver::new(string name = "router_src_driver", uvm_component parent);		
			super.new(name,parent);
	endfunction:new
    	
	    //Build phase	
	function void router_src_driver::build_phase(uvm_phase phase);
		super.build_phase(phase);
	
		if(!uvm_config_db #(router_src_agent_config)::get(this,"","router_src_agent_config",src_cfg))
		`uvm_fatal("CONFIG","cannot get() src_cfg from uvm_config_db. Have you set() it?")
	
	endfunction:build_phase

	//Connect phase
	function void router_src_driver::connect_phase(uvm_phase phase);
		svif=src_cfg.svif;
	endfunction:connect_phase

	task router_src_driver::run_phase(uvm_phase phase);
                //reset logic
                @(svif.sdr_cb);
			svif.sdr_cb.resetn<=0;

		@(svif.sdr_cb);
                        svif.sdr_cb.resetn<=1;

		forever
		begin
			seq_item_port.get_next_item(req);
			send_to_dut(req);
			seq_item_port.item_done();
		end
	endtask:run_phase

	task router_src_driver::send_to_dut(write_xtn xtn);
		
		`uvm_info("ROUTER_SRC_DRIVER",$sformatf("printing from source driver \n %s", xtn.sprint()),UVM_LOW)

		@(svif.sdr_cb);

		while(svif.sdr_cb.busy==1) 
			@(svif.sdr_cb);
//		$display("****111*******");
		svif.sdr_cb.din<=xtn.header;
		svif.sdr_cb.pkt_vld <= 1;

		@(svif.sdr_cb);
//		$display("****121*******");
		foreach(xtn.payload[i])
		begin
			while(svif.sdr_cb.busy==1)
			@(svif.sdr_cb);
	
			svif.sdr_cb.din<=xtn.payload[i];		
			@(svif.sdr_cb);
		
		end
//$display("****131*******");
		while(svif.sdr_cb.busy==1)
			@(svif.sdr_cb);
		
		svif.sdr_cb.din<=xtn.parity;
		svif.sdr_cb.pkt_vld<=0;

		src_cfg.src_drv_data_count++;

		repeat(2)
		@(svif.sdr_cb);

	endtask:send_to_dut

	function void router_src_driver::report_phase(uvm_phase phase);
		`uvm_info(get_type_name(),$sformatf("Report_phase: Router_src_driver sent %0d transactions",src_cfg.src_drv_data_count),UVM_LOW)

	endfunction:report_phase
















