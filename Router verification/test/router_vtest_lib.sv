
class router_base_test extends uvm_test;

	//Factory Registration
	`uvm_component_utils(router_base_test)

	//Properties
	router_env_config env_cfg;
	
	router_src_agent_config src_cfg[];
	router_dst_agent_config dst_cfg[];

	router_tb env_h;

	bit has_src_agent=1;
        bit has_dst_agent=1;

        int no_of_src_agts=1;
        int no_of_dst_agts=3;	
	
	uvm_active_passive_enum is_active;

	bit [1:0]addr;
	
	//------------------------------------------
	// Methods
	//------------------------------------------
	// Standard UVM Methods:
	extern function new(string name="router_base_test",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void config_router();
endclass:router_base_test

	function router_base_test::new(string name="router_base_test",uvm_component parent);
		super.new(name,parent);
	endfunction:new

	//Build phase
	function void router_base_test::build_phase(uvm_phase phase);
		super.build_phase(phase);

		addr=$urandom_range(0,2);
	        uvm_config_db #(bit[1:0])::set(this,"*","bit",addr);

		env_cfg=router_env_config::type_id::create("env_cfg");
	
		if(has_src_agent)
		begin
			src_cfg=new[no_of_src_agts];
		        
		     foreach(src_cfg[i])
			src_cfg[i]=router_src_agent_config::type_id::create($sformatf("src_cfg[%0d]",i));
		end

		if(has_dst_agent)
               begin
                        dst_cfg=new[no_of_dst_agts];

                     foreach(dst_cfg[i])
                        dst_cfg[i]=router_dst_agent_config::type_id::create($sformatf("dst_cfg[%0d]",i));
                end

		config_router();
		
		env_h=router_tb::type_id::create("env_h",this);
	endfunction:build_phase

	//User defined task
	function void  router_base_test::config_router();
		if(has_src_agent)
		begin
			
			env_cfg.src_cfg=new[no_of_src_agts];

			for(int i=0;i<no_of_src_agts;i++)
			begin
				is_active=UVM_ACTIVE;
				
				if(!uvm_config_db #(virtual src_if)::get(this,"","svif_0",src_cfg[i].svif))
                `uvm_fatal("VIF CONFIG","cannot get()interface vif from uvm_config_db. Have you set() it?")
		
				env_cfg.src_cfg[i]=src_cfg[i];
			end
		end

		if(has_dst_agent)
                begin
        		env_cfg.dst_cfg=new[no_of_dst_agts];   
	             for(int i=0;i<no_of_dst_agts;i++)
                        begin
		
                                is_active=UVM_ACTIVE;

                                if(!uvm_config_db #(virtual dst_if)::get(this,"", $sformatf("dvif_%0d",i),dst_cfg[i].dvif))
                `uvm_fatal("VIF CONFIG","cannot get()interface vif from uvm_config_db. Have you set() it?")

                                env_cfg.dst_cfg[i]=dst_cfg[i];
                        end
                end

		env_cfg.no_of_src_agts=no_of_src_agts;
		env_cfg.no_of_dst_agts=no_of_dst_agts;

		env_cfg.has_src_agent=has_src_agent;
		env_cfg.has_dst_agent=has_dst_agent;

		uvm_config_db#(router_env_config)::set(this,"*","router_env_config",env_cfg);
	endfunction:config_router

class router_rand_test extends router_base_test;
	
	//Factory Registration
	`uvm_component_utils(router_rand_test)

        //Properties
	router_src_rand_seqs srand_seqh;
	router_dst_rand_seqs drand_seqh;

//	 bit [1:0]addr;
			
		//------------------------------------------
		// Methods
		//------------------------------------------
		// Standard UVM Methods:
	extern function new(string name = "router_rand_test", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);

endclass:router_rand_test

		//Constructor-new
function router_rand_test::new(string name = "router_rand_test", uvm_component parent);
	super.new(name,parent);
endfunction:new

//build phase
function void router_rand_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
//	addr=$urandom_range(0,2);
//	uvm_config_db #(bit[1:0])::set(this,"*","bit",addr);

endfunction:build_phase

//run phase
task router_rand_test::run_phase(uvm_phase phase);

	phase.raise_objection(this);
	srand_seqh=router_src_rand_seqs::type_id::create("srand_seqh");
	drand_seqh=router_dst_rand_seqs::type_id::create("drand_seqh");

	fork
	begin
		srand_seqh.start(env_h.sagt_top.agnth[0].seqrh);
		#100;
	end
	begin
		if(addr==0)
		 begin
			#260;
			drand_seqh.start(env_h.dagt_top.agnth[0].seqrh);
			#100;
		end
	
		if(addr==1)
		 begin
			#260;
			drand_seqh.start(env_h.dagt_top.agnth[1].seqrh);	
			#100;
		end

		if(addr==2)
		 begin
			#260;
			drand_seqh.start(env_h.dagt_top.agnth[2].seqrh);
			#100;
		end
	end
	join
	#100;
	phase.drop_objection(this);

endtask:run_phase

//--------------------------------------router_medium_test-----------------------------------------------//

class router_medium_test extends router_base_test;

        //Factory Registration
        `uvm_component_utils(router_medium_test)

        //Properties
        router_src_medium_seqs smedium_seqh;
        router_dst_medium_seqs dmedium_seqh;

                //------------------------------------------
                // Methods
                //------------------------------------------
                // Standard UVM Methods:
        extern function new(string name = "router_medium_test", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);

endclass:router_medium_test

                //Constructor-new
function router_medium_test::new(string name = "router_medium_test", uvm_component parent);
        super.new(name,parent);
endfunction:new

//build phase
function void router_medium_test::build_phase(uvm_phase phase);
        super.build_phase(phase);
endfunction:build_phase

//run phase
task router_medium_test::run_phase(uvm_phase phase);

        phase.raise_objection(this);
        smedium_seqh=router_src_medium_seqs::type_id::create("smedium_seqh");
        dmedium_seqh=router_dst_medium_seqs::type_id::create("dmedium_seqh");

        fork
        begin
                smedium_seqh.start(env_h.sagt_top.agnth[0].seqrh);
                #100;
        end
        begin
                if(addr==0)
                 begin
                        #260;
                        dmedium_seqh.start(env_h.dagt_top.agnth[0].seqrh);
                        #100;
                end
		
		if(addr==1)
                 begin
                        #260;
                        dmedium_seqh.start(env_h.dagt_top.agnth[1].seqrh);
                        #100;
                end

                if(addr==2)
                 begin
                        #260;
                        dmedium_seqh.start(env_h.dagt_top.agnth[2].seqrh);
                        #100;
                end
        end
        join
        #100;
        phase.drop_objection(this);

endtask:run_phase


//--------------------------------------router_big_test-----------------------------------------------//

class router_big_test extends router_base_test;

        //Factory Registration
        `uvm_component_utils(router_big_test)

        //Properties
        router_src_big_seqs sbig_seqh;
        router_dst_big_seqs dbig_seqh;

                //------------------------------------------
                // Methods
                //------------------------------------------
                // Standard UVM Methods:
        extern function new(string name = "router_big_test", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);

endclass:router_big_test

                //Constructor-new
function router_big_test::new(string name = "router_big_test", uvm_component parent);
        super.new(name,parent);
endfunction:new

//build phase
function void router_big_test::build_phase(uvm_phase phase);
        super.build_phase(phase);
endfunction:build_phase

//run phase
task router_big_test::run_phase(uvm_phase phase);

        phase.raise_objection(this);
        sbig_seqh=router_src_big_seqs::type_id::create("sbig_seqh");
        dbig_seqh=router_dst_big_seqs::type_id::create("dbig_seqh");

        fork
        begin
                sbig_seqh.start(env_h.sagt_top.agnth[0].seqrh);
                #100;
        end
        begin
                if(addr==0)
                 begin
                        #260;
                        dbig_seqh.start(env_h.dagt_top.agnth[0].seqrh);
                        #100;
                end

                if(addr==1)
                 begin
                        #260;
                        dbig_seqh.start(env_h.dagt_top.agnth[1].seqrh);
                        #100;
                end

                if(addr==2)
                 begin
                        #260;
                        dbig_seqh.start(env_h.dagt_top.agnth[2].seqrh);
                        #100;
                end
        end
        join
        #100;
        phase.drop_objection(this);

endtask:run_phase

