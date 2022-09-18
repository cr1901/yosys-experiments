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
