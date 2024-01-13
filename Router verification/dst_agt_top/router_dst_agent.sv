class router_dst_agent extends uvm_agent;

	//Factory Registration
	`uvm_component_utils(router_dst_agent)

        //Properties
	router_dst_agent_config dst_cfg;
	
	router_dst_monitor monh;
	router_dst_sequencer seqrh;
	router_dst_driver drvh;
		
		//------------------------------------------
		// Methods
		//------------------------------------------
		// Standard UVM Methods:
	extern function new(string name="router_dst_agent",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

endclass:router_dst_agent

		//Constructor-new
	function router_dst_agent::new(string name="router_dst_agent",uvm_component parent);
		 super.new(name,parent);
	endfunction:new

        //Build phase
	 function void router_dst_agent::build_phase(uvm_phase phase);
		super.build_phase(phase);
                // get the config object using uvm_config_db 
	  if(!uvm_config_db #(router_dst_agent_config)::get(this,"","router_dst_agent_config",dst_cfg))
		`uvm_fatal("DST CONFIG","cannot get() dst_cfg from uvm_config_db. Have you set() it?") 
	        monh=router_dst_monitor::type_id::create("monh",this);			
		if(dst_cfg.is_active==UVM_ACTIVE)
		begin
			drvh=router_dst_driver::type_id::create("drvh",this);
			seqrh=router_dst_sequencer::type_id::create("seqrh",this);
		end
	endfunction:build_phase

		//Connect phase
	function void router_dst_agent::connect_phase(uvm_phase phase);
		if(dst_cfg.is_active==UVM_ACTIVE)
			drvh.seq_item_port.connect(seqrh.seq_item_export);
	endfunction:connect_phase










