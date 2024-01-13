class router_scoreboard extends uvm_scoreboard;

	//Factory Registration
	`uvm_component_utils(router_scoreboard)

        //Properties
	write_xtn wr_xtn;
	read_xtn rd_xtn;
	write_xtn wr_cov;
	read_xtn rd_cov;

	uvm_tlm_analysis_fifo #(write_xtn) wr_fifoh[];
	uvm_tlm_analysis_fifo #(read_xtn) rd_fifoh[];

	router_env_config env_cfg;

	//covergroups
	covergroup cg_wr_cov;
		option.per_instance=1;

		address: coverpoint wr_cov.header[1:0] {
				bins zero={2'b00};
				bins one={2'b01};
				bins two={2'b10};}

		payload_size: coverpoint wr_cov.header[7:2]{
				bins small_pkt={[1:15]};
				bins medium_pkt={[16:35]};
				bins big_pkt={[36:63]};}
	
		addressxpayload_size: cross address, payload_size;
	endgroup

	covergroup cg_rd_cov;
                option.per_instance=1;

                address: coverpoint rd_cov.header[1:0] {
                                bins zero={2'b00};
                                bins one={2'b01};
                                bins two={2'b10};}

                payload_size: coverpoint rd_cov.header[7:2]{
                                bins small_pkt={[1:15]};
                                bins medium_pkt={[16:35]};
                                bins big_pkt={[36:63]};}

                addressxpayload_size: cross address, payload_size;
        endgroup

		
		//------------------------------------------
		// Methods
		//------------------------------------------
		// Standard UVM Methods:
	extern function new(string name ="router_scoreboard",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task user_compare(write_xtn wr, read_xtn rd);

endclass:router_scoreboard

		//Constructor-new
function router_scoreboard::new(string name ="router_scoreboard",uvm_component parent);
		 super.new(name, parent);
		cg_wr_cov=new();
		cg_rd_cov=new();
endfunction:new

        //Build phase
function void router_scoreboard::build_phase(uvm_phase phase);
		super.build_phase(phase);
	if(! uvm_config_db #(router_env_config)::get(this,"","router_env_config",env_cfg))
		`uvm_fatal("SB:CONFIG","can not get configuration env_cfg from uvm_config_db in router_sb");

	wr_fifoh = new[env_cfg.no_of_src_agts];
	rd_fifoh = new[env_cfg.no_of_dst_agts];

	foreach(wr_fifoh[i])
		wr_fifoh[i] = new($sformatf("wr_fifoh[%0d]",i),this);

	foreach(rd_fifoh[i])
		rd_fifoh[i]=new($sformatf("rd_fifoh[%0d]",i),this);

endfunction:build_phase

		//run phase
task router_scoreboard::run_phase(uvm_phase phase);
	forever
	begin
		fork
		begin
			wr_fifoh[0].get(wr_xtn);
			wr_cov=wr_xtn;
			cg_wr_cov.sample();
			$display("write_coverage = %f",cg_wr_cov.get_coverage());
		end

		begin
		fork 
			rd_fifoh[0].get(rd_xtn);
			rd_fifoh[1].get(rd_xtn);
			rd_fifoh[2].get(rd_xtn);
		join_any
		disable fork;

		rd_cov=rd_xtn;
		cg_rd_cov.sample();
		$display("read_coverage =%f", cg_rd_cov.get_coverage());
		end
		join
		
		user_compare(wr_xtn, rd_xtn);
	end
endtask

//user_compare method
task router_scoreboard::user_compare(write_xtn wr, read_xtn rd);
	if(wr.header == rd.header)
	begin
		`uvm_info("SB Compare", "Header Matched",UVM_LOW)
		foreach(rd.payload[i])
		begin
			if(wr.payload[i]==rd.payload[i])
				`uvm_info("SB Compare", $sformatf("Payload[%0d] Matched",i),UVM_LOW)
			else
				`uvm_error("SB Compare","Payload Not Matched")
	
		end

		if(wr.parity == rd.parity)
			`uvm_info("SB Compare","Parity Matched", UVM_LOW)
		else
			 `uvm_error("SB Compare","Parity Not Matched")

	end
	else
		
                 `uvm_error("SB Compare","Header Not Matched")

endtask





