SAT:
```
yosys -s synth_satvsmt.ys
yosys -s smt.ys
```


SMT:
```
yosys -s synth_satvsmt.ys
yosys -s smt.ys
yosys-smtbmc -s z3 --dump-vcd miter_smt_bmc.vcd miter_smt.smt2
yosys-smtbmc -s z3 -i --dump-vcd miter_smt_bmc.vcd miter_smt.smt2
```
