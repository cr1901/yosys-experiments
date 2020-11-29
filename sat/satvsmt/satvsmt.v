module satvsmt(input clk, input d, output reg q);

// SAT vs SMT
// -flatten/-noflatten
// -top/-auto-top
// -proc vs no -proc
// initial q vs no initial

// TODO: Test miter circuit without reset value. SAT and SMT diverge without
// reset value (SAT succeeds, SMT fails). I haven't figured out the correct
// init set of options to make SAT fail.
// "sat -verify -prove-asserts -set-init-def -seq 1 miter" causes assertion
// failure in yosys.

`ifdef INITIAL
initial q = 0;
`endif

always @(posedge clk)
	q <= d;

endmodule
