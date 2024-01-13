class read_xtn extends uvm_sequence_item;

	//Factory Registration
	`uvm_object_utils(read_xtn)

        //Properties
	bit [7:0]header;
	bit [7:0]payload[];
	bit [7:0]parity;

	//bit vld_out;
	rand bit[4:0]no_of_cycles;		
	
		
	constraint a{no_of_cycles==0;}
		//------------------------------------------
		// Methods
		//------------------------------------------
		// Standard UVM Methods:
	extern function new(string name="read_xtn");
	extern function void do_print(uvm_printer printer);

endclass
		//Constructor-new
	function read_xtn::new(string name="read_xtn");
		super.new(name);
	endfunction:new

//do_print method

function void  read_xtn::do_print (uvm_printer printer);
    super.do_print(printer);


    //                   srting name            bitstream value     size       radix for printing
    printer.print_field( "address",             this.header[1:0],    2,          UVM_DEC                );
    printer.print_field( "Header",              this.header[7:2],           6,          UVM_DEC                );
    foreach(payload[i])
         printer.print_field($sformatf("Payload[%0d]",i),   this.payload[i],    8,      UVM_DEC                );
    printer.print_field( "Parity",           this.parity,      8,          UVM_DEC                );
 printer.print_field( "No_of_cycles",           this.no_of_cycles,    5,          UVM_DEC                );

  endfunction:do_print

