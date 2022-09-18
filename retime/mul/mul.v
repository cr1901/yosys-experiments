module top(input clk, input [3:0] a, input [3:0] b, output reg [7:0] q);
    reg [3:0] a_reg;
    reg [3:0] b_reg;
    wire [7:0] q_out;

    // Required for --out-of-context mode; async information is lost.
    always @(posedge clk) begin
        a_reg <= a;
        b_reg <= b;
        q <= q_out;
    end

    mcve mcve(clk, a_reg, b_reg, q_out);
endmodule

module mcve #(
    parameter PIPELINE_DEPTH = 3,
)
(input clk, input [3:0] a, input [3:0] b, output [7:0] q);
    wire [7:0] mul_results;
    assign mul_results = a * b;

    genvar i;
    generate
        if (PIPELINE_DEPTH > 0) begin
            reg [7:0] pipeline[PIPELINE_DEPTH-1:0] ;

            always @(posedge clk) begin
                pipeline[0] <= mul_results;
            end

            for(i = 1; i < PIPELINE_DEPTH; i = i + 1) begin
                always @(posedge clk) begin
                    pipeline[i] <= pipeline[i - 1];
                end
            end

            assign q = pipeline[PIPELINE_DEPTH-1];
        end else begin
            assign q = mul_results;
        end
    endgenerate
endmodule
