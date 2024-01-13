class router_src_agent extends uvm_agent;

	//Factory Registration
	`uvm_component_utils(router_src_agent)

        //Properties
	router_src_agent_config src_cfg;
	
	router_src_driver drvh;
	router_src_monitor monh;
	router_src_sequencer seqrh;
	
	//------------------------------------------
	// Methods
	//------------------------------------------
	// Standard UVM Methods:
	extern function new(string name= "router_src_agent",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

endclass:router_src_agent

	 //Constructor-new
	function router_src_agent::new(string name= "router_src_agent",uvm_component parent);
		 super.new(name,parent);
	endfunction:new

        //Build phase
	function void router_src_agent::build_phase(uvm_phase phase);
		//super.build_phase(phase);
		
		if(!uvm_config_db #(router_src_agent_config)::get(this,"","router_src_agent_config",src_cfg))
		`uvm_fatal("CONFIG","cannot get() src_cfg from uvm_config_db. Have you set() it?")
	super.build_phase(phase);
		monh=router_src_monitor::type_id::create("monh",this);

		if(src_cfg.is_active==UVM_ACTIVE)
		begin
			drvh=router_src_driver::type_id::create("drvh",this);
			seqrh=router_src_sequencer::type_id::create("seqrh",this);
		end
	endfunction:build_phase

	 function void router_src_agent::connect_phase(uvm_phase phase);
		 if(src_cfg.is_active==UVM_ACTIVE)
                begin
			drvh.seq_item_port.connect(seqrh.seq_item_export);
		end
	endfunction:connect_phase







