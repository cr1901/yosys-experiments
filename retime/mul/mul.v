module top(input clk, input [3:0] a, input [3:0] b, output reg [7:0] q);
    reg [3:0] a_reg;
    reg [3:0] b_reg;
    wire [7:0] q_out;

    // Use a dummy set of registers to delineate the bounds of the comb
    // network you want to retime for doing a latency/fmax evaluation.
    // nextpnr's --out-of-context mode will ignore giving timing for:
    // * Any comb logic seen by the output cone of top-level inputs up to the
    //   first FFs.
    // * Any comb logic from seen by the input cone of top-level outputs from
    //   last FFs.
    // Putting all the comb logic plus pipelining FFs in between two sets of
    // additional FFs ideally makes sure that --out-of-context gives timing
    // for the entire comb network you want to optimize.

    // In practice, this doesn't actually work well; even with (* keep = 1 *)
    // (omitted here) abc will happily retime these bounds registers, putting
    // comb logic before (usually) a/b_reg and after (rarely) q_out.
    always @(posedge clk) begin
        a_reg <= a;
        b_reg <= b;
        q <= q_out;
    end

    mcve mcve(clk, a_reg, b_reg, q_out);
endmodule

// Test both an input pipeline and output pipeline (even if Intel
// Hyperpipeling only adds pipelines to the output:
// https://www.intel.com/content/www/us/en/docs/programmable/683353/21-3/appendix-a-parameterizable-pipeline-modules.html)
// just to see how ABC reacts.
module mcve #(
    parameter INPUT_PIPELINE_DEPTH = 0,
    parameter OUTPUT_PIPELINE_DEPTH = 0,
)
(input clk, input [3:0] a, input [3:0] b, output [7:0] q);
    wire [7:0] mul_results;
    genvar i;

    generate
        if (INPUT_PIPELINE_DEPTH > 0) begin
            reg [3:0] a_reg[INPUT_PIPELINE_DEPTH-1:0];
            reg [3:0] b_reg[INPUT_PIPELINE_DEPTH-1:0];

            always @(posedge clk) begin
                a_reg[0] <= a;
                b_reg[0] <= b;
            end

            for(i = 1; i < INPUT_PIPELINE_DEPTH; i = i + 1) begin
                always @(posedge clk) begin
                    a_reg[i] <= a_reg[i - 1];
                    b_reg[i] <= b_reg[i - 1];
                end
            end

            assign mul_results = a_reg[INPUT_PIPELINE_DEPTH-1] * b_reg[INPUT_PIPELINE_DEPTH-1];
        end else begin
            assign mul_results = a * b;
        end
    endgenerate

    generate
        if (OUTPUT_PIPELINE_DEPTH > 0) begin
            reg [7:0] pipeline[OUTPUT_PIPELINE_DEPTH-1:0] ;

            always @(posedge clk) begin
                pipeline[0] <= mul_results;
            end

            for(i = 1; i < OUTPUT_PIPELINE_DEPTH; i = i + 1) begin
                always @(posedge clk) begin
                    pipeline[i] <= pipeline[i - 1];
                end
            end

            assign q = pipeline[OUTPUT_PIPELINE_DEPTH-1];
        end else begin
            assign q = mul_results;
        end
    endgenerate
endmodule
