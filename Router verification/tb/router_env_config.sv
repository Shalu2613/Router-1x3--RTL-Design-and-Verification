class router_env_config extends uvm_object;
	//Factory Registration
	`uvm_object_utils(router_env_config)

	//Properties
	bit has_functional_coverage = 0;
	bit has_src_agent_functional_coverage = 0;

	bit has_src_agent=1;
	bit has_dst_agent=1;
	bit has_scoreboard=1;
	bit has_virtual_sequencer=1;

	int no_of_src_agts=1;
	int no_of_dst_agts=3;

	router_dst_agent_config dst_cfg[];
	router_src_agent_config src_cfg[];
	//router_dst_agent_config dst_cfg[];
	
	//------------------------------------------
	// Methods
	//------------------------------------------
	// Standard UVM Methods:
	extern function  new(string name="router_env_config");

endclass:router_env_config

	//Constructor-new
	function  router_env_config::new(string name="router_env_config");
		super.new(name);
	endfunction

