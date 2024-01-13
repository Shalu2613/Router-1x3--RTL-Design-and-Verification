module router_fsm(clock,resetn,pkt_valid,data_in,fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,soft_reset_0,
                  soft_reset_1,soft_reset_2,parity_done,low_pkt_valid,write_enb_reg,detect_add,ld_state,
		  laf_state,lfd_state,full_state,rst_int_reg,busy);
				  
 
 input clock,resetn,pkt_valid,fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2;
 input soft_reset_0,soft_reset_1,soft_reset_2,parity_done,low_pkt_valid;
 input [1:0]data_in;
 
 output write_enb_reg,detect_add,ld_state,laf_state,lfd_state,full_state,rst_int_reg,busy;

 parameter DECODE_ADDRESS = 3'b000,
           LOAD_FIRST_DATA = 3'b001,
           LOAD_DATA       = 3'b010,
 		   FIFO_FULL_STATE = 3'b011,
		   LOAD_AFTER_FULL = 3'b100,
		   LOAD_PARITY     = 3'b101,
		   CHECK_PARITY_ERROR = 3'b110,
		   WAIT_TILL_EMPTY = 3'b111;

 reg [2:0]PRESENT_STATE,NEXT_STATE;
 reg [1:0]addr;
 
 //present state logic
 always@(posedge clock)
  begin
   if(!resetn)
    PRESENT_STATE <= DECODE_ADDRESS;
   else if((soft_reset_0 && data_in == 2'b00) || (soft_reset_1 && data_in == 2'b01) || (soft_reset_2 && data_in == 2'b10))
   PRESENT_STATE <= DECODE_ADDRESS;
   else
   PRESENT_STATE <= NEXT_STATE;
  end
  
  //internal variable address logic(only useful when present state is WAIT_TILL_EMPTY state)
  always@(posedge clock)
   begin
    if(!resetn)
	 addr <= 0;
    else if((soft_reset_0 && data_in == 2'b00) || (soft_reset_1 && data_in == 2'b01) || (soft_reset_2 && data_in == 2'b10))
     addr <= 0;
    else if (DECODE_ADDRESS)
     addr <= data_in;
   end	
 
 //next_state logic (purely combinational)
 always@(*)
    begin
	 NEXT_STATE = DECODE_ADDRESS;
	 case(PRESENT_STATE)
	  DECODE_ADDRESS : begin
	  
	                   if((pkt_valid && (data_in == 0) && fifo_empty_0) || 
			      (pkt_valid && (data_in == 1) && fifo_empty_1) || 
			      (pkt_valid && (data_in == 2) && fifo_empty_2))
						  
			      NEXT_STATE = LOAD_FIRST_DATA;
					
		       else if((pkt_valid && (data_in == 0) && ~fifo_empty_0) ||
                               (pkt_valid && (data_in == 1) && ~fifo_empty_1) ||
                               (pkt_valid && (data_in == 2) && ~fifo_empty_2))
                            
                              NEXT_STATE = WAIT_TILL_EMPTY;
                        
			else						  
                        	
                            NEXT_STATE = DECODE_ADDRESS;
						
                        end
						
    LOAD_FIRST_DATA : NEXT_STATE = LOAD_DATA;

    LOAD_DATA : begin
                 if(fifo_full)
                   NEXT_STATE = FIFO_FULL_STATE;
	    else if(!fifo_full && !pkt_valid)
                   NEXT_STATE = LOAD_PARITY;
	       else
		   NEXT_STATE = LOAD_DATA;
		end
    
	FIFO_FULL_STATE : begin
	                   if(!fifo_full)
			      NEXT_STATE = LOAD_AFTER_FULL;
		      else if(fifo_full)
			     NEXT_STATE = FIFO_FULL_STATE;
			  end
                		
    LOAD_AFTER_FULL : begin
                       if((!parity_done) && (!low_pkt_valid))
                        NEXT_STATE = LOAD_DATA;
                     else if((!parity_done) && (low_pkt_valid))//parity not done but all payload are sent
                       NEXT_STATE = LOAD_PARITY;
                     else if(parity_done)
                       NEXT_STATE = DECODE_ADDRESS;
                     end
    
    LOAD_PARITY : NEXT_STATE = CHECK_PARITY_ERROR;

    CHECK_PARITY_ERROR : begin
                          if(fifo_full)
                           NEXT_STATE = FIFO_FULL_STATE;
                         else if(!fifo_full)
                           NEXT_STATE = DECODE_ADDRESS;
						 end
    
    WAIT_TILL_EMPTY : begin
	                   if ((!fifo_empty_0 && (addr == 0)) ||
                               (!fifo_empty_1 && (addr == 1)) ||
                               (!fifo_empty_2 && (addr == 2)))
                         NEXT_STATE = WAIT_TILL_EMPTY;
                     else if((fifo_empty_0 &&(addr == 0)) ||
                             (fifo_empty_1 &&(addr == 1)) ||
                             (fifo_empty_2 &&(addr == 2)))
                         NEXT_STATE = LOAD_FIRST_DATA; 
		     else
			 NEXT_STATE = WAIT_TILL_EMPTY;
                     end
     endcase
   end

//output logic
assign detect_add =(PRESENT_STATE == DECODE_ADDRESS) ? 1'b1:1'b0;
assign lfd_state = (PRESENT_STATE == LOAD_FIRST_DATA) ? 1'b1:1'b0;
assign ld_state = (PRESENT_STATE == LOAD_DATA) ? 1'b1:1'b0;
assign full_state = (PRESENT_STATE == FIFO_FULL_STATE) ? 1'b1:1'b0;
assign laf_state = (PRESENT_STATE == LOAD_AFTER_FULL) ? 1'b1:1'b0;
assign rst_int_reg = (PRESENT_STATE == CHECK_PARITY_ERROR) ? 1'b1:1'b0;
assign write_enb_reg = ((PRESENT_STATE == LOAD_DATA || PRESENT_STATE == LOAD_AFTER_FULL || PRESENT_STATE == LOAD_PARITY)) ? 1'b1:1'b0;
assign busy = ((PRESENT_STATE == LOAD_FIRST_DATA || PRESENT_STATE == FIFO_FULL_STATE || PRESENT_STATE == LOAD_AFTER_FULL || 
	        PRESENT_STATE == LOAD_PARITY||PRESENT_STATE == CHECK_PARITY_ERROR || PRESENT_STATE == WAIT_TILL_EMPTY)) ? 1'b1:1'b0;
				
endmodule
				
 
