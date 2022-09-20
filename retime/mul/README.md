# Multiplier Retiming

## Invocation
### Run
```
yosys -ql mul.log mul.ys
nextpnr-ecp5 -ql comb_mul_pnr.log --out-of-context --25k --json comb_mul.json --write comb_mul_pnr.json
nextpnr-ecp5 -ql pipe_mul_pnr.log --out-of-context --25k --json pipe_mul.json --write pipe_mul_pnr.json
```

### Clean
* Unix: `rm -rf *.log *.json *.dot *.png`
* Windows `rm -rf *.log *.json *.dot *.png abc.history`

## TODO
Create a `yosys` `select` query for "select all wires and FFs from `q`'s input
cone that don't immediately connect to other FFs. (i.e. figure out how many
pipeline regs actually have comb logic between)".

Bonus: `select` query for "find all paths to `q` from `a` and `b` who have at
least "N" stages of FFs that don't immediately connect to other FFs." Is this
possible?
