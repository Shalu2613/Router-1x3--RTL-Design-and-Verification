class router_dst_sequencer extends uvm_sequencer #(read_xtn);

	//Factory Registration
	`uvm_component_utils(router_dst_sequencer)

        //Properties
		
		//------------------------------------------
		// Methods
		//------------------------------------------
		// Standard UVM Methods:
	extern function new(string name ="router_dst_sequencer",uvm_component parent);

endclass:router_dst_sequencer

		//Constructor-new
function router_dst_sequencer::new(string name ="router_dst_sequencer",uvm_component parent);
	super.new(name,parent);
endfunction:new










