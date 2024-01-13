class router_dst_agent_config extends uvm_object;

        `uvm_object_utils(router_dst_agent_config)

        virtual dst_if dvif;

        uvm_active_passive_enum is_active = UVM_ACTIVE;

	 int dst_mon_data_count=0;
	 int dst_drv_data_count=0;

        extern function new(string name="router_dst_agent_config");

endclass


function router_dst_agent_config::new(string name = "router_dst_agent_config");
        super.new(name);
endfunction:new

