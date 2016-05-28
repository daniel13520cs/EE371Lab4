
module Serial2Parallel(serin, clk, parin, reset, charReceive, en);
input serin;
input reset;
input clk;
input en;
output reg[7:0] parin;
input charReceive;
reg[7:0] bufferreg;

always@(posedge clk)
begin

if(reset == 1) begin
   bufferreg = 8'bx;
   parin = 8'bx;
end else if(en) begin
   bufferreg <= (bufferreg<<1);
   bufferreg[0] <= serin;
end else if(charReceive)begin
   parin <= bufferreg;
   bufferreg <= 8'bx;
end

end
endmodule



module Serial2Parallel_tb();
reg serin;
reg reset;
reg clk;
reg charReceive;
reg en;
wire[7:0] parin;
wire[7:0] bufferreg;

always #5 clk = ~clk;

Serial2Parallel s2p0(serin, clk, parin, reset, charReceive, en);

initial begin
$dumpfile("Serial2Parallel.vcd");
$dumpvars(0, Serial2Parallel_tb);
clk = 1; reset = 1;
#5;
reset = 0;
#5;#5;
serin = 0; charReceive = 0; //start bit
#5;#5;
serin = 1; en = 1;
#5;#5;
serin = 1;
#5;#5;
serin = 0;
#5;#5;
serin = 0;
#5;#5;
serin = 1;
#5;#5;
serin = 1;
#5;#5;
serin = 0;
#5;#5;
serin = 0;
#5;#5;
serin = 1; charReceive = 1; en = 0;
#5;#5;
serin = 0; charReceive = 0;
#5;#5; en = 1;
end

endmodule