class router_src_agent_config extends uvm_object;

	`uvm_object_utils(router_src_agent_config)

	virtual src_if svif;
	
	uvm_active_passive_enum is_active=UVM_ACTIVE ;

	int src_mon_data_count=0;

	int src_drv_data_count=0;

	extern function new(string name="router_src_agent_config");

endclass


function router_src_agent_config::new(string name = "router_src_agent_config");
	super.new(name);
endfunction:new


