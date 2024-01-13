class router_dbase_seqs extends uvm_sequence #(read_xtn);

        //Factory Registration
        `uvm_object_utils(router_dbase_seqs)

        //Properties

                //------------------------------------------
                // Methods
                //------------------------------------------
                // Standard UVM Methods:
        extern function new(string name = "router_dbase_seqs");


endclass:router_dbase_seqs

                //Constructor-new
        function router_dbase_seqs::new(string name = "router_dbase_seqs");
                super.new(name);
        endfunction:new

/*-----------------------------------router_dst_medium_seqs--------------------------------------*/

class router_dst_rand_seqs extends router_dbase_seqs;

        //Factory Registration
        `uvm_object_utils(router_dst_rand_seqs)

        //Properties

                //------------------------------------------
                // Methods
                //------------------------------------------
                // Standard UVM Methods:
        extern function new(string name = "router_dst_rand_seqs");
        extern task body();

endclass:router_dst_rand_seqs

                //Constructor-new
        function router_dst_rand_seqs::new(string name = "router_dst_rand_seqs");
                super.new(name);
        endfunction:new


	//task body
         task router_dst_rand_seqs::body();
//		repeat(2) begin
                req = read_xtn::type_id::create("req");

                start_item(req);

//                assert(req.randomize()with {no_of_cycles==0;});
		 assert(req.randomize());
                 finish_item(req);

                //`uvm_info("ROUTER_SRC_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
//		end
        endtask:body

/*-----------------------------------router_dst_medium_seqs--------------------------------------*/

class router_dst_medium_seqs extends router_dbase_seqs;

        //Factory Registration
        `uvm_object_utils(router_dst_medium_seqs)

        //Properties

                //------------------------------------------
                // Methods
                //------------------------------------------
                // Standard UVM Methods:
        extern function new(string name = "router_dst_medium_seqs");
        extern task body();

endclass:router_dst_medium_seqs

                //Constructor-new
        function router_dst_medium_seqs::new(string name = "router_dst_medium_seqs");
                super.new(name);
        endfunction:new


        //task body
         task router_dst_medium_seqs::body();

                req = read_xtn::type_id::create("req");

                start_item(req);

//                assert(req.randomize()with {no_of_cycles==0;});
                 assert(req.randomize());
                 finish_item(req);

                //`uvm_info("ROUTER_SRC_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)

        endtask:body


/*-----------------------------------router_dst_big_seqs--------------------------------------*/

class router_dst_big_seqs extends router_dbase_seqs;

        //Factory Registration
        `uvm_object_utils(router_dst_big_seqs)

        //Properties

                //------------------------------------------
                // Methods
                //------------------------------------------
                // Standard UVM Methods:
        extern function new(string name = "router_dst_big_seqs");
        extern task body();

endclass:router_dst_big_seqs

                //Constructor-new
        function router_dst_big_seqs::new(string name = "router_dst_big_seqs");
                super.new(name);
        endfunction:new


        //task body
         task router_dst_big_seqs::body();

                req = read_xtn::type_id::create("req");

                start_item(req);

//                assert(req.randomize()with {no_of_cycles==0;});
                 assert(req.randomize());
                 finish_item(req);

                //`uvm_info("ROUTER_SRC_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)

        endtask:body

