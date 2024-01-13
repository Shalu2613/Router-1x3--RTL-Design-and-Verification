module router_sync(clock,resetn,data_in,detect_add,full_0,full_1,full_2,empty_0,empty_1,empty_2,write_enb_reg,
	           read_enb_0,read_enb_1,read_enb_2,write_enb,fifo_full,vld_out_0,vld_out_1,vld_out_2,
		   soft_reset_0,soft_reset_1,soft_reset_2);

 input clock,resetn,detect_add,full_0,full_1,full_2,empty_0,empty_1,empty_2,write_enb_reg,read_enb_0,read_enb_1,read_enb_2;
 input [1:0]data_in;
 output reg [2:0]write_enb;
 output reg fifo_full,soft_reset_0,soft_reset_1,soft_reset_2;
 output vld_out_0,vld_out_1,vld_out_2;
 
 reg [1:0]int_addr_reg;//internal address register
 reg [4:0]timer_0,timer_1,timer_2;//timer to count 30 clock cycles if fifo read enb is inactive
 
 always@(posedge clock)
  begin
   if(~resetn)
    int_addr_reg <= 0;
  else if(detect_add)
   int_addr_reg <= data_in;
  end

//write_enb logic
always@(*)
 begin
  if(write_enb_reg)
   begin
    case(int_addr_reg)
	 2'b00 : write_enb <= 3'b001;//fifo0 gets enabled
	 2'b01 : write_enb <= 3'b010;//fifo1 gets enabled
	 2'b10 : write_enb <= 3'b100;//fifo2 gets enabled
	 default : write_enb <= 3'b000;
    endcase
   end
   else if(!write_enb_reg)
    begin
     write_enb <= 3'b000;     
    end
 end
 //fifo_full logic
 always@(*)
  begin 
   case(int_addr_reg)
   2'b00 : fifo_full <= full_0;
   2'b01 : fifo_full <= full_1;
   2'b10 : fifo_full <= full_2;   
   default : fifo_full <= 1'b0;
  endcase
 end
 //timer_0 and soft_reset_0 logic
 wire w1 = (timer_0 == 5'd29) ? 1'b1:1'b0;
  always@(posedge clock)
   begin 
    if(~resetn)
	 begin
	  timer_0 <= 0;
	  soft_reset_0 <= 0;
	 end 
    else if(vld_out_0)
	  begin
	   if(!read_enb_0)
	    begin 
		 if(w1)
		  begin
		   soft_reset_0 <= 1'b1;
		   timer_0 <= 0;
		  end
		 else
		  begin
		   soft_reset_0 <= 0;
		   timer_0 <= timer_0 + 1'b1;
		  end
	    end
     end
  end
//timer_1 and soft_reset_1 logic
wire w2 = (timer_1 == 5'd29) ? 1'b1:1'b0;
 always@(posedge clock)
   begin 
    if(~resetn)
	 begin
	  timer_1 <= 0;
	  soft_reset_1 <= 0;
	 end
	else if(vld_out_1)
	  begin
	   if(!read_enb_1)
	    begin 
		 if(w2)
		  begin
		   soft_reset_1 <= 1'b1;
		   timer_1 <= 0;
		  end
		 else
		  begin
		   soft_reset_1 <= 0;
		   timer_1 <= timer_1 + 1'b1;
		  end
	    end
	 end
   end
 //timer_2 and soft_reset_2 logic
 wire w3 = (timer_2 == 5'd29) ? 1'b1:1'b0;
  always@(posedge clock)
   begin 
    if(~resetn)
	 begin
	  timer_2 <= 0;
	  soft_reset_2 <= 0;
	 end
	else if(vld_out_2)
	  begin
	   if(!read_enb_2)
	    begin 
		 if(w3)
		  begin
		   soft_reset_2 <= 1'b1;
		   timer_2 <= 0;
		  end
		 else
		  begin
		   soft_reset_2 <= 0;
		   timer_2 <= timer_2 + 1'b1;
		  end
	    end
	 end
   end
  
  //valid out logic
  assign vld_out_0 = ~empty_0;
  assign vld_out_1 = ~empty_1;
  assign vld_out_2 = ~empty_2;
  
endmodule
