module router_reg(clock,resetn,pkt_valid,data_in,fifo_full,detect_add,
                  ld_state,laf_state,full_state,lfd_state,rst_int_reg,
				  err,parity_done,low_pkt_valid,dout);
				 
  input clock,resetn,pkt_valid,fifo_full,detect_add,ld_state,laf_state,full_state,lfd_state,rst_int_reg;
  input [7:0]data_in;
  output reg err,parity_done,low_pkt_valid;
  output reg [7:0]dout;
  reg [7:0]header_byte,fifo_full_state_byte,int_parity,pkt_parity;//4 internal resgisters
  
  //data out logic
  always@(posedge clock)
   begin
    if(~resetn)
	 dout <= 0;
	else if (lfd_state)
	dout <= header_byte;
	else if(ld_state && ~fifo_full)
	dout <= data_in;
	else if (laf_state)
	dout <= fifo_full_state_byte;
  end
  
  //header_byte and fifo_full_state_byte logic
   always@(posedge clock)
    begin
	 if(~resetn)
	  {header_byte,fifo_full_state_byte} <= 0;
	 else 
	  begin
	   if(pkt_valid && detect_add)
	    header_byte <= data_in;
	   else if(ld_state && fifo_full)
	   fifo_full_state_byte <= data_in;
	  end
	 end 
  
  //low packet valid logic
  always@(posedge clock)
   begin
    if(~resetn)
	 low_pkt_valid <= 0;
	else if(rst_int_reg)
	 low_pkt_valid <= 0;
	else if(~pkt_valid && ld_state)
	 low_pkt_valid <= 1'b1;
   end
   
   //parity done logic
   always@(posedge clock)
    begin
	 if(~resetn)
	  parity_done <= 0;
	 else if(detect_add)
	  parity_done <= 0;
	 else if((ld_state && !pkt_valid && !fifo_full) || (laf_state && !parity_done && low_pkt_valid))
	  parity_done <= 1'b1;		
	end
	
	//internal parity logic or parity calculation logic
	always@(posedge clock)
	 begin 
	  if(~resetn)
	   int_parity <= 8'b0;
	  else if(detect_add)
	  int_parity <= 8'b0;
	  else if(lfd_state)
	   int_parity <= int_parity ^ header_byte;
	  else if(ld_state && pkt_valid && ~full_state)//loding the payloads
	   int_parity <= int_parity ^ data_in;
	  else if(~pkt_valid && rst_int_reg)
	   int_parity <= 0;
	 end
	 
	 //packet parity logic or external parity logic
	 always@(posedge clock)
	  begin
	   if(~resetn)
	    pkt_parity <= 0;
	  else if((ld_state && ~pkt_valid && ~fifo_full) || (laf_state && low_pkt_valid && ~parity_done))
	   pkt_parity <= data_in;
	  else if(~pkt_valid && rst_int_reg)
	   pkt_parity <= 0;
          else if(detect_add)
           pkt_parity <= 0;
          end

   //error logic
   always@(posedge clock)
    begin
     if(~resetn)
      err <= 0;
     else
      begin
        if(parity_done == 1'b1 && (int_parity != pkt_parity))
         err <= 1'b1;
        else
         err <= 0;
      end
    end
	
endmodule	
