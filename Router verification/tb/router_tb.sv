class router_tb extends uvm_env;

	//Factory Registration
	`uvm_component_utils(router_tb)

        //Properties
	router_src_agt_top sagt_top;
	router_dst_agt_top dagt_top;
	
	//router_virtual_sequencer v_sequencer;

	router_env_config env_cfg;

	//router_scoreboard sb;
	router_scoreboard sb;
		
	//------------------------------------------
	// Methods
	//------------------------------------------
	// Standard UVM Methods:
	extern function new(string name = "router_tb", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

endclass:router_tb

	 //Constructor-new
		function router_tb::new(string name = "router_tb", uvm_component parent);
			super.new(name,parent);
		endfunction:new

        //Build phase
	function void router_tb::build_phase(uvm_phase phase);
		if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",env_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
	
		if(env_cfg.has_src_agent)
		begin
			sagt_top= router_src_agt_top::type_id::create("sagt_top",this);
		    
		end

		if(env_cfg.has_dst_agent)
                begin
                        dagt_top= router_dst_agt_top::type_id::create("dagt_top",this);
                   
                end

		super.build_phase(phase);

		if(env_cfg.has_scoreboard)
			sb=router_scoreboard::type_id::create("sb",this);
	
	endfunction:build_phase

	function void router_tb::connect_phase(uvm_phase phase);
		if(env_cfg.has_scoreboard)
		begin
			foreach(sagt_top.agnth[i])
				sagt_top.agnth[i].monh.monitor_port.connect(sb.wr_fifoh[i].analysis_export);
      			foreach(dagt_top.agnth[i])
		                  dagt_top.agnth[i].monh.dst_monitor_port.connect(sb.rd_fifoh[i].analysis_export);
                end
        endfunction:connect_phase


