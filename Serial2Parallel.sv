module Serial2Parallel(serin, clk, parin, reset, charReceive);
 input serin;
 input reset;
 input clk;
 output reg[7:0] parin;
 input charReceive;
 reg[7:0] bufferreg;
 
always@(posedge clk)
 begin
      //assign bufferreg =Parin;
      if(reset == 1) begin
			bufferreg = 0;
         parin = 'bz;
      end else if(~charReceive) begin
         bufferreg <= (bufferreg<<1);
		   bufferreg[0] <= serin;
      end else
         parin <= bufferreg;
      end
endmodule
