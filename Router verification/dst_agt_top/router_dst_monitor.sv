class router_dst_monitor extends uvm_monitor;

	           
		//Factory Registration
	`uvm_component_utils(router_dst_monitor)

        //Properties
	virtual dst_if.DMON_MP dvif;
	
	router_dst_agent_config dst_cfg;
	read_xtn xtn;
		
	uvm_analysis_port #(read_xtn)dst_monitor_port;

		//------------------------------------------
		// Methods
		//------------------------------------------
		// Standard UVM Methods:
	extern function new(string name="router_dst_monitor",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task dst_collect_data();;
	extern function void report_phase(uvm_phase phase);

endclass:router_dst_monitor

		//Constructor-new
function router_dst_monitor::new(string name="router_dst_monitor",uvm_component parent);
	super.new(name,parent);
	dst_monitor_port=new("dst_monitor_port",this);
endfunction:new

        //Build phase
function void router_dst_monitor::build_phase(uvm_phase phase);
	if(!uvm_config_db #(router_dst_agent_config)::get(this,"","router_dst_agent_config",dst_cfg))
		`uvm_fatal("DST CONFIG","cannot get()interface dst_cfg from uvm_config_db. Have you set() it?")
	
	super.build_phase(phase);

endfunction:build_phase

	//Connect phase
function void router_dst_monitor::connect_phase(uvm_phase phase);
	dvif=dst_cfg.dvif;
endfunction:connect_phase

//run_phase
task router_dst_monitor::run_phase(uvm_phase phase);
	repeat(2)
		@(dvif.dmon_cb);
	
	forever
	begin
		dst_collect_data();
		dst_monitor_port.write(xtn);
	end
endtask:run_phase

//dst_collect_data
task router_dst_monitor::dst_collect_data();
	
	xtn=read_xtn::type_id::create("xtn");

	while(!dvif.dmon_cb.rd_enb)
		@(dvif.dmon_cb);
	@(dvif.dmon_cb);

	xtn.header = dvif.dmon_cb.dout;
		$display($time, "DST Monitor: Header Received =%0d",xtn.header);

	xtn.payload = new[xtn.header[7:2]];
	@(dvif.dmon_cb);
	
	foreach(xtn.payload[i])
	begin
 
		xtn.payload[i] = dvif.dmon_cb.dout;
		$display($time," DST Monitor-payload recieved: %0d",xtn.payload[i]);
		@(dvif.dmon_cb);
	end

	xtn.parity = dvif.dmon_cb.dout;
	$display($time, "DST Monitor: Parity Received=%0d",xtn.parity);
@(dvif.dmon_cb);
	dst_cfg.dst_mon_data_count++;
		
	`uvm_info("ROUTER_DST_MONITOR",$sformatf("printing from monitor \n %s", xtn.sprint()),UVM_LOW)
	
endtask:dst_collect_data

//report phase
function void router_dst_monitor::report_phase(uvm_phase phase);
 `uvm_info(get_type_name(),$sformatf("Report_phase: Router_dst_monitor Received %0d transactions",dst_cfg.dst_mon_data_count),UVM_LOW)
endfunction:report_phase





