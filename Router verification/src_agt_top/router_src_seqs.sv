class router_sbase_seqs extends uvm_sequence #(write_xtn);
	
	//Factory Registration
	`uvm_object_utils(router_sbase_seqs)

        //Properties
	bit [1:0] addr;

		//------------------------------------------
		// Methods
		//------------------------------------------
		// Standard UVM Methods:
	extern function new(string name = "router_sbase_seqs");
	extern task body();

endclass:router_sbase_seqs

		//Constructor-new
	function router_sbase_seqs::new(string name = "router_sbase_seqs");
		super.new(name);
	endfunction:new


	//task body
	task router_sbase_seqs::body();
		
		 if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit",addr))
                        `uvm_fatal("SRC_SEQUENCE","addr is not get")
	endtask:body

//----------------------------router_src_rand_seqs-----------------------------------//
		
class router_src_rand_seqs extends router_sbase_seqs;
	
        //Factory Registration
        `uvm_object_utils(router_src_rand_seqs)

                //------------------------------------------
                // Methods
                //------------------------------------------
                // Standard UVM Methods:
        extern function new(string name = "router_src_rand_seqs");
	extern task body();

endclass:router_src_rand_seqs

                //Constructor-new
        function router_src_rand_seqs::new(string name = "router_src_rand_seqs");
                super.new(name);
        endfunction:new

	//task body
	 task router_src_rand_seqs::body();
		super.body();
//		repeat(2) begin                
		req = write_xtn::type_id::create("req");
   
                start_item(req);
   
		assert(req.randomize()with {header[1:0]==addr;
						header[7:2]==5;});  

       	         finish_item(req);

		//`uvm_info("ROUTER_SRC_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
//		end
        endtask:body

	
//----------------------------router_src_medium_seqs-----------------------------------//

class router_src_medium_seqs extends router_sbase_seqs;

        //Factory Registration
        `uvm_object_utils(router_src_medium_seqs)

                //------------------------------------------
                // Methods
                //------------------------------------------
                // Standard UVM Methods:
        extern function new(string name = "router_src_medium_seqs");
        extern task body();

endclass:router_src_medium_seqs

                //Constructor-new
        function router_src_medium_seqs::new(string name = "router_src_medium_seqs");
                super.new(name);
        endfunction:new

        //task body
         task router_src_medium_seqs::body();
                super.body();
//              repeat(2) begin
                req = write_xtn::type_id::create("req");

                start_item(req);

                assert(req.randomize()with {header[1:0]==addr;
                                                header[7:2]==16;});

                 finish_item(req);

                //`uvm_info("ROUTER_SRC_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
//              end
        endtask:body

//----------------------------router_src_big_seqs-----------------------------------//

class router_src_big_seqs extends router_sbase_seqs;

        //Factory Registration
        `uvm_object_utils(router_src_big_seqs)

                //------------------------------------------
                // Methods
                //------------------------------------------
                // Standard UVM Methods:
        extern function new(string name = "router_src_big_seqs");
        extern task body();

endclass:router_src_big_seqs

                //Constructor-new
        function router_src_big_seqs::new(string name = "router_src_big_seqs");
                super.new(name);
        endfunction:new

        //task body
         task router_src_big_seqs::body();
                super.body();
//              repeat(2) begin
                req = write_xtn::type_id::create("req");

                start_item(req);

                assert(req.randomize()with {header[1:0]==addr;
                                                header[7:2]==36;});

                 finish_item(req);

                //`uvm_info("ROUTER_SRC_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
  //            end
        endtask:body





