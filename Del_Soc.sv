module Del_Soc(CLOCK_50, SW, LEDR, KEY);
	input CLOCK_50;
	input[9:0] SW;
	output[9:0] LEDR;
	input[3:0] KEY;

	wire charSent, charReceive;
	wire receiveSignal, sentSignal;
	wire receiveEnable;
	wire bitSampleIn, bitSampleOut;
	wire[7:0] parin, parout;
	wire serin, serout;
	wire trans, LOAD;
	//wire clock_9600, clock_9600x16;
	
	
	userInput sent(.clk(clk[11]), .reset(~KEY[0]), .In(sentSignal), .lightOn(charSent));
	userInput receive(.clk(clk[11]), .reset(~KEY[0]), .In(receiveSignal), .lightOn(charReceive));
		
	//Clock divider
	wire [31:0] clk;
	clock_divider clkdiv(.clock(CLOCK_50), .divided_clocks(clk));
	//freq_divider_9600 fd0(.clk(CLOCK_50), .clk_div(clock_9600));
	//freq_divider_9600x16 fd1(.clk(CLOCK_50), .clk_div(clock_9600x16));
	
	//Transmit
	BSC out1(.clk(clk[7]), .rst(~KEY[0]), .en(trans), .bitSample(bitSampleOut), .charPass(sentSignal));
   Parallel2Serial p0(.parout(parout), .serout(serout), .clk(bitSampleOut), .reset(~KEY[0]), .load(LOAD), .charSent(charSent)); //clock is clock_9600
	
	//Receive
	BSC in1(.clk(clk[7]), .rst(~KEY[0]), .en(receiveEnable), .bitSample(bitSampleIn), .charPass(receiveSignal));
	Serial2Parallel s2p0(.serin((serout | ~trans)), .parin(parin), .clk(bitSampleIn), .reset(~KEY[0]), .charReceive(charReceive));
	
	startBit_det st0(.serin((serout | ~trans)), .Enable(receiveEnable), .endBit(charReceive), .rst(~KEY[0]));
	
	Lab4 u0 (
		.char_r_export(charReceive),   //   char_r.export
		.char_s_export(charSent),   //   char_s.export
		.clk_clk(CLOCK_50),         //      clk.clk
		.data_in_export(parin),  //  data_in.export
		.data_out_export(parout), // data_out.export
		.led_out_export(LEDR[7:0]),  //  led_out.export
		.load_export(LOAD),     //     load.export
		.reset_reset_n(KEY[3]),   //    reset.reset_n
		.trans_export(trans)     //    trans.export
	);

endmodule 

module clock_divider (clock, divided_clocks);
 input clock;
 output [31:0] divided_clocks;
 reg [31:0] divided_clocks;

 initial
 divided_clocks = 0;

 always @(posedge clock)
 divided_clocks = divided_clocks + 1;
endmodule
