module router_fifo(clock,resetn,write_enb,soft_reset,read_enb,data_in,lfd_state,full,empty,data_out);

 input clock,resetn,soft_reset,read_enb,write_enb,lfd_state;
 input [7:0]data_in;
 output full,empty;
 output reg [7:0]data_out;
 
 reg [4:0]rd_ptr,wr_ptr;//5 bit for read,write pointer to distinguish full state and empty state
 reg [5:0]count;//fifo counter
 reg [8:0]fifo_mem[15:0];//16*9 fifo size>>>> 9 bits width for lfd_state[msb]+data_in>>>if lfd = 1 data is header else data contains payloads 
 
 integer i;
 reg lfd_state_t;
 
 always@(posedge clock)
   begin
    if(~resetn)
	 lfd_state_t <= 0;
	else
	 lfd_state_t <= lfd_state;
   end
   
 //read operation logic
  always@(posedge clock)
   begin
    if(!resetn)
	 data_out <= 8'b0;
    else if(soft_reset)
	 data_out <= 8'bz;
	else if(read_enb && ~empty)
	   data_out <= fifo_mem[rd_ptr[3:0]];
	else if(count == 0)//read has not been enabled
	   data_out <= 8'bz;
    end
 //write operation logic
 always@(posedge clock)
  begin
   if(!resetn || soft_reset)
    begin
	 for(i=0;i<16;i=i+1)
	  begin
	   fifo_mem[i] <= 0;
	  end
	end
  else 
   begin 
    if(write_enb && ~full)
	 {fifo_mem[wr_ptr[3:0]][8],fifo_mem[wr_ptr[3:0]][7:0]} <= {lfd_state_t,data_in};
   end
  end
 //logic for implementing pointer
 always@(posedge clock)
  begin
   if(!resetn || soft_reset)
    begin
	 rd_ptr <= 5'b00000;
	 wr_ptr <= 5'b00000;
	end
   else 
    begin
	 if(write_enb && !full)
	  wr_ptr <= wr_ptr + 1'b1;
	 if(read_enb && !empty)
	  rd_ptr <= rd_ptr + 1'b1;
	end
 end
 //FIFO_down counter logic while reading
 always@(posedge clock)
  begin
   if(!resetn)
   begin
    count <= 0;
   end 
  else if(soft_reset)
   begin
    count <= 0;
   end
  else if(read_enb & !empty)
   begin
    if((fifo_mem[rd_ptr[3:0]][8]) == 1'b1)
     count <= fifo_mem[rd_ptr[3:0]][7:2] + 1'b1;//latching of payload length
    else if(count != 0)
     count <= count - 1'b1;
   end
 end
//full and empty conditions
assign full = (wr_ptr == {~rd_ptr[4],rd_ptr[3:0]})?1'b1:1'b0;
assign empty = (wr_ptr == rd_ptr)?1'b1:1'b0;

endmodule 
