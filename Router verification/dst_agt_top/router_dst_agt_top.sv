class router_dst_agt_top extends uvm_env;

	//Factory Registration
	`uvm_component_utils(router_dst_agt_top)

        //Properties
	router_dst_agent agnth[];

	router_env_config env_cfg;
		
	
		//------------------------------------------
		// Methods
		//------------------------------------------
		// Standard UVM Methods:
	extern function new(string name="router_dst_agt_top",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void start_of_simulation_phase(uvm_phase phase);

endclass:router_dst_agt_top

		//Constructor-new
	function router_dst_agt_top::new(string name="router_dst_agt_top",uvm_component parent);
		super.new(name, parent);
	endfunction:new

	//build phase	
	function  void router_dst_agt_top::build_phase(uvm_phase phase);
	
		if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",env_cfg))
			`uvm_fatal("ENV CONFIG","cannot get()interface env_cfg from uvm_config_db. Have you set() it?")		

		super.build_phase(phase);

		agnth=new[env_cfg.no_of_dst_agts];

		foreach(agnth[i])
		begin
			agnth[i]=router_dst_agent::type_id::create($sformatf("agnth[%0d]",i),this);
		
			uvm_config_db #(router_dst_agent_config)::set(this,$sformatf("agnth[%0d]*",i),"router_dst_agent_config", env_cfg.dst_cfg[i]);
		end

	endfunction:build_phase

	//run phase
	function void router_dst_agt_top::start_of_simulation_phase(uvm_phase phase);
		uvm_top.print_topology();
	endfunction:start_of_simulation_phase
	









