class router_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);

	//Factory Registration
	`uvm_component_utils(router_virtual_sequencer)

        //Properties
	router_src_sequencer src_seqrh[];
	router_dst_sequencer dst_seqrh[];
	
	router_env_config env_cfg;

		//------------------------------------------
		// Methods
		//------------------------------------------
		// Standard UVM Methods:
	extern function new(string name="router_virtual_sequencer",uvm_component parent);
	extern function void build_phase(uvm_phase phase);

endclass:router_virtual_sequencer
	
		//Constructor-new
	function router_virtual_sequencer::new(string name="router_virtual_sequencer",uvm_component parent);
		super.new(name,parent);
	endfunction:new

	function void router_virtual_sequencer::build_phase(uvm_phase phase);
		
		if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",env_cfg))
		`uvm_fatal("CONFIG","cannot get() env_cfg from uvm_config_db. Have you set() it?")

		super.build_phase(phase);
		
		src_seqrh=new[env_cfg.no_of_src_agts];
		dst_seqrh=new[env_cfg.no_of_dst_agts];
	
	endfunction:build_phase


