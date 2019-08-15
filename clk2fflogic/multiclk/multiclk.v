module multiclk(input clk, output [3:0] counter_a, counter_b);
	reg [3:0] counter_a = 0;
	reg [3:0] counter_b = 0;

	always @(posedge clk)
		counter_a <= counter_a + 1;
	
	always @(posedge clk)
		counter_b[0] <= !counter_b[0];

	always @(negedge counter_b[0])
		counter_b[1] <= !counter_b[1];

	always @(negedge counter_b[1])
		counter_b[2] <= !counter_b[2];

	always @(negedge counter_b[2])
		counter_b[3] <= !counter_b[3];

	assert property (counter_a == counter_b);
endmodule
