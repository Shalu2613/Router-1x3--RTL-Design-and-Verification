class write_xtn extends uvm_sequence_item;

	//Factory Registration
	`uvm_object_utils(write_xtn)

        //Properties
	rand bit[7:0]header;
	rand bit[7:0]payload[];
	bit [7:0]parity;

	//constraints
	constraint header1{header[1:0] != 2'b11;
			   header[7:2] inside {[1:63]};
		           payload.size==header[7:2];}

		
	//------------------------------------------
	// Methods
	//------------------------------------------
	// Standard UVM Methods:
	extern function new(string name = "write_xtn");
	extern function void do_print(uvm_printer printer);
	extern function void post_randomize();
	
endclass:write_xtn

	 //Constructor-new
	function write_xtn::new(string name="write_xtn");
		super.new(name);
	endfunction:new

//do_print
function void  write_xtn::do_print (uvm_printer printer);
    super.do_print(printer);


    //                   srting name            bitstream value     size       radix for printing
    printer.print_field( "address",             this.header[1:0],    2,          UVM_DEC                );
    printer.print_field( "Header",              this.header[7:2],           6,          UVM_DEC                );
    foreach(payload[i])
  	 printer.print_field($sformatf("Payload[%0d]",i),   this.payload[i],    8,      UVM_DEC                );
    printer.print_field( "Parity",           this.parity,      8,          UVM_DEC                );

  endfunction:do_print

//post_randomize
function void write_xtn::post_randomize();
	parity=header^8'b0;
	foreach(payload[i])
		parity=parity^payload[i];
endfunction:post_randomize

