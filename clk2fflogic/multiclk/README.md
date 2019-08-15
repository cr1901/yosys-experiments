# Multiclk

## Invocation
`sby -f multiclk.sby` in the same directory as this file.

## Rationale
`multiclk.v` is copied verbatim from the supplementary examples zip file of one
of Clifford's [presentations](http://www.clifford.at/papers/2016/yosys-smtbmc/).

`multiclk.v` is one of the simplest examples showing that a BMC proof can
succeed or fail depending on whether the `multiclk` option was given to
`symbiyosys`. Someone who knows Verilog will likely see by visual inspection
that the proof should indeed succeed (the two implementations of the counter are
equivalent; one uses `posedge` synchronous logic, the other uses `negedge`
synchronous logic also).

I created this example to analyze the differences between the BMC proofs
generated to be fed into an SMT solver, and ultimately figure out which of
these differences causes the proof to fail (when it should succeed!) when
`multiclk` isn't specified.

## Output Files
* `multiclk_clk2ff/engine_0/trace.smt2`- BMC proof fed into an SMT solver with
  `multiclk` enabled.
* `multiclk_clk2ff/engine_0/trace.smt2`- BMC proof fed into an SMT solver with
  `multiclk` _disabled_.

## Conclusions
