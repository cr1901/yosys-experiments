`ifdef TECHMAP
module  \$_DFF_P_ (input D, C, output Q); SATVSMT_FF #(.REGSET("RESET")) _TECHMAP_REPLACE_ (.CLK(C), .LSR(1'b0), .DI(D), .Q(Q)); endmodule
`else
module SATVSMT_FF #(
	parameter REGSET = "SET",
) (
	input CLK, DI, LSR, output reg Q,
);

	wire srval = (REGSET == "SET") ? 1'b1 : 1'b0;

	initial Q = srval;

	always @(posedge CLK)
		if (LSR)
			Q <= srval;
		else
			Q <= DI;
endmodule
`endif
