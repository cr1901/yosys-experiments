# Two Regs

## Invocation
### Run
`yosys -q tworegs.ys`

### Clean
* Unix: `rm -rf *.dot *.png *_*.v`
* Windows `rm -rf *.dot *.png *_*.v`

## Rationale
This simple example initiates two flip-flops in Verilog. One flip-flop uses
`posedge` clocking, the other uses `negedge` clocking. This experiment shows
in both `png` and Verilog (via `write_verilog`) using yosys internal cells the
effect that the `clk2fflogic` pass has on transforming a given design.

## Conclusions
`$ff` is an internal yosys cell which is implicitly clocked by the special,
always-existing `$global_clock` signal. This is particularly useful for SMT
proofs, which by design work with a single clock.

Upon running `clk2fflogic`, all clocked logic for  in the design is transformed
into `$ff` cells and muxes. New values for clocked logic `X` fed by clk `CLK`
are only registered on the outputs when the two conditions are met:

* First the `CLK` feeding `X` must have transitioned appropriately. Either
  `posedge` or `negedge` logic is fine here.
* Upon sensing the appropriate transition of `CLK`, new values on the output of
  `X` will be registered upon the next `posedge` transition of `$global_clock`.

As of this writing (8-15-2019), `$ff` is only documented in the yosys
[source code](https://github.com/YosysHQ/yosys/blob/master/techlibs/common/simlib.v#L1447-L1458)
and not in the [manual](http://www.clifford.at/yosys/files/yosys_manual.pdf)
(page 43 FIXME). I'll probably fix this soon.
