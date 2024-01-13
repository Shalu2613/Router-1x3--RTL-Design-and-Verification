class router_vbase_seq extends uvm_sequence #(uvm_sequence_item);
	
	//Factory Registration
	`uvm_object_utils(router_vbase_seq)

        //Properties
	router_src_sequencer src_seqrh[];
	router_dst_sequencer dst_seqrh[];

	router_virtual_sequencer v_sequencer;
	
	router_rand_src_xtns rand_xtns;
	router_rand_dst_xtns rand_xtns;
	
	router_env_config env_cfg;

		//------------------------------------------
		// Methods
		//------------------------------------------
		// Standard UVM Methods:
		extern function new(string name="router_vbase_seq");
		extern task body();

endclass:router_vbase_seq
	
	//Constructor-new
	function router_vbase_seq::new(string name="router_vbase_seq");					 
		super.new(name);
	endfunction:new

        //task body
task router_vbase_seq::body();
	if(!uvm_config_db#(router_env_config)::get(null,get_full_name,"router_env_config",env_cfg))
		`uvm_fatal("CONFIG","cannot get() env_cfg from uvm_config_db. Have you set() it?")

 	src_seqrh=new[env_cfg.no_of_src_agts];
  	dst_seqrh=new[env_cfg.no_of_dst_agts];

  assert($cast(v_sequencer,m_sequencer)) else begin
    `uvm_error("BODY", "Error in $cast of virtual sequencer")
  end

 	foreach(src_seqrh[i])
                src_seqrh[i] = v_sequencer.src_seqrh[i];
        foreach(dst_seqrh[i])
                dst_seqrh[i] = v_sequencer.rd_seqrh[i];
		
endtask: body





