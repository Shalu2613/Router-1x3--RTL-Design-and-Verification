module top;

	import uvm_pkg::*;	
	
	import router_test_pkg::*;

	bit clock;

	always
		#10 clock=!clock;
	
	src_if in0(clock);
	dst_if in1(clock);
	dst_if in2(clock);
	dst_if in3(clock);

	//instantiate design
/*
	router1x3_topblock  DUV(.clk(clock), .rstn(in0.resetn), .pkt_valid(in0.pkt_vld), .data_in(in0.din),
				.rd_en_0(in1.rd_enb), .rd_en_1(in2.rd_enb), .rd_en_2(in3.rd_enb),
				.vld_out_0(in1.vld_out), .vld_out_1(in2.vld_out), .vld_out_2(in3.vld_out),
				.error(in0.error), .busy(in0.busy), .data_out_0(in1.dout), 
				.data_out_1(in2.dout), .data_out_2(in3.dout));	
*/

	router_top DUV(.clock(clock), .resetn(in0.resetn), .read_enb_0(in1.rd_enb),
		.read_enb_1(in2.rd_enb), .read_enb_2(in3.rd_enb), .data_in(in0.din),
		 .pkt_valid(in0.pkt_vld), .data_out_0(in1.dout), .data_out_1(in2.dout), 
		.data_out_2(in3.dout), .vld_out_0(in1.vld_out), .vld_out_1(in2.vld_out),
		 .vld_out_2(in3.vld_out), .err(in0.error), .busy(in0.busy));

	//initial block	
	initial 
	begin
		uvm_config_db#(virtual src_if)::set(null,"*","svif_0",in0);
		uvm_config_db#(virtual dst_if)::set(null,"*","dvif_0",in1);
		uvm_config_db#(virtual dst_if)::set(null,"*","dvif_1",in2);
		uvm_config_db#(virtual dst_if)::set(null,"*","dvif_2",in3);


		run_test();
	end
endmodule
