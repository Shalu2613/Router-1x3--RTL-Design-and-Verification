class router_dst_driver extends uvm_driver #(read_xtn);

	//Factory Registration
	`uvm_component_utils(router_dst_driver)

        //Properties
	virtual dst_if.DDR_MP dvif;
	
	router_dst_agent_config dst_cfg;
		
		//------------------------------------------
		// Methods
		//------------------------------------------
		// Standard UVM Methods:
	extern function new(string name ="router_dst_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task drive_data(read_xtn xtn);
	extern function void report_phase(uvm_phase phase);

endclass:router_dst_driver

		//Constructor-new
function router_dst_driver::new(string name ="router_dst_driver",uvm_component parent);
		 super.new(name,parent);
endfunction:new

        //Build phase
function void router_dst_driver::build_phase(uvm_phase phase);
	if(!uvm_config_db #(router_dst_agent_config) ::get(this,"","router_dst_agent_config",dst_cfg))
		`uvm_fatal("DST CONFIG","cannot get()interface dst_cfg from uvm_config_db. Have you set() it?")		
	
	super.build_phase(phase);
endfunction:build_phase
	
	//Connect phase
function void router_dst_driver::connect_phase(uvm_phase phase);
	dvif=dst_cfg.dvif;
endfunction:connect_phase

//run_phase
task router_dst_driver::run_phase(uvm_phase phase);
		
	 @(dvif.ddrv_cb);
	dvif.ddrv_cb.rd_enb<=0;

	forever
	begin
		seq_item_port.get_next_item(req);
		drive_data(req);
		seq_item_port.item_done();
	end
endtask:run_phase

//drive data
task router_dst_driver::drive_data(read_xtn xtn);
	
	`uvm_info("ROUTER_DST_DRIVER",$sformatf("printing from driver \n %s", xtn.sprint()),UVM_LOW)
	@(dvif.ddrv_cb);

	while(!dvif.ddrv_cb.vld_out)
		@(dvif.ddrv_cb);

	repeat(xtn.no_of_cycles)
		@(dvif.ddrv_cb);

		dvif.ddrv_cb.rd_enb <= 1;

	while(dvif.ddrv_cb.vld_out)
		@(dvif.ddrv_cb);

	dvif.ddrv_cb.rd_enb<=0;

//	repeat(2//
		@(dvif.ddrv_cb);	
	dst_cfg.dst_drv_data_count++;

endtask:drive_data

//report phase
function void router_dst_driver::report_phase(uvm_phase phase);
 `uvm_info(get_type_name(),$sformatf("Report_phase: Router_dst_driver sent %0d transactions",dst_cfg.dst_drv_data_count),UVM_LOW)	
endfunction:report_phase

