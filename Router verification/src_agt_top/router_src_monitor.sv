class router_src_monitor extends uvm_monitor;
	
	//Factory Registration
	`uvm_component_utils(router_src_monitor)

        //Properties
	router_src_agent_config src_cfg;

	virtual src_if.SMON_MP svif;

	write_xtn xtn;

	uvm_analysis_port #(write_xtn)monitor_port;	
		
		//------------------------------------------
		// Methods
		//------------------------------------------
		// Standard UVM Methods:
	extern function new (string name ="router_src_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
	extern function void report_phase(uvm_phase phase);

endclass:router_src_monitor

	//Constructor-new
	function router_src_monitor::new(string name ="router_src_monitor", uvm_component parent);
		 super.new(name,parent);
		monitor_port=new("monitor_port",this);
	endfunction:new

        //Build phase
	function void router_src_monitor::build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		if(!uvm_config_db #(router_src_agent_config)::get(this,"","router_src_agent_config",src_cfg))
		`uvm_fatal("CONFIG","cannot get() src_cfg from uvm_config_db. Have you set() it?")
		
	endfunction:build_phase

	//Connect phase
	function void router_src_monitor::connect_phase(uvm_phase phase);
		svif=src_cfg.svif;
	endfunction:connect_phase


	//run_phase
	task router_src_monitor::run_phase(uvm_phase phase);
	forever
	begin
			collect_data();
	end
	endtask:run_phase

	//collect data
	task router_src_monitor::collect_data();
			
		xtn=write_xtn::type_id::create("xtn");
		repeat(4)
		@(svif.smon_cb);

		$display("pkt valid =%0d , busy=%0d ", svif.smon_cb.pkt_vld, svif.smon_cb.busy);
	
		while(!svif.smon_cb.pkt_vld)
			@(svif.smon_cb);

		while(svif.smon_cb.busy)
			@(svif.smon_cb);

		xtn.header = svif.smon_cb.din;
//.		@(svif.smon_cb);
		$display($time, "SRC Monitor: Header Received =%0d",xtn.header);

		xtn.payload=new[xtn.header[7:2]];
	  	@(svif.smon_cb);

		foreach(xtn.payload[i])
		begin
			while(svif.smon_cb.busy)
			@(svif.smon_cb);
	
			xtn.payload[i] = svif.smon_cb.din;
			 $display($time,"SRC Monitor- payload recieved: %0d",xtn.payload[i]);
			@(svif.smon_cb);

		end

		while(svif.smon_cb.pkt_vld)
                        @(svif.smon_cb);

                while(svif.smon_cb.busy)
                        @(svif.smon_cb);

		xtn.parity=svif.smon_cb.din;
		$display($time, "SRC Monitor: Parity Received =%0d",xtn.parity);

		src_cfg.src_mon_data_count++;
	
		@(svif.smon_cb);

		`uvm_info("ROUTER_SRC_MONITOR",$sformatf("printing from Monitor \n %s", xtn.sprint()),UVM_LOW)

		monitor_port.write(xtn);

	endtask:collect_data

	function void router_src_monitor::report_phase(uvm_phase phase);
		`uvm_info(get_type_name(), $sformatf("Report phase: Router Source Monitor received %0d transactions",src_cfg.src_mon_data_count),UVM_LOW);
	
	endfunction:report_phase


