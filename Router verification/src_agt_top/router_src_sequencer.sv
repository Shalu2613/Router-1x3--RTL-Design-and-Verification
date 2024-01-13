class router_src_sequencer extends uvm_sequencer #(write_xtn);

	`uvm_component_utils(router_src_sequencer)

//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
	extern function new(string name = "router_src_sequencer",uvm_component parent);

endclass
//-----------------  constructor new method  -------------------//

	function router_src_sequencer::new(string name="router_src_sequencer",uvm_component parent);
		super.new(name,parent);
	endfunction









