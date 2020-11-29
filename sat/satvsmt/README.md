SAT:
```
yosys -p "script synth_satvsmt.ys :sat; script synth_satvsmt.ys sat"
```

SMT:
```
yosys -p "script synth_satvsmt.ys :sat; script synth_satvsmt.ys smt:"
yosys-smtbmc -s z3 --dump-vcd miter_smt_bmc.vcd miter_smt.smt2
yosys-smtbmc -s z3 -i --dump-vcd miter_smt_tmp.vcd miter_smt.smt2
```
