module top(input clk, rst, input di, input hld, output reg q = 0);

reg q1 = 0;

always @(posedge clk) begin
	if (rst) begin
		q <= 0;
    q1 <= 0;
	end else begin
    if (~hld) begin
      q <= q1;
      q1 <= di;
    end
  end
end

endmodule
