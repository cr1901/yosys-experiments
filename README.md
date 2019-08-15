# Yosys Experiments

## Introduction
Yosys is a (Hardware Description Language) HDL compiler that can target multiple
families of FPGAs and ASIC cell libraries. As part of its duties before output
emission, yosys will convert the input high level description of a digital
circuit (such as in Verilog) into its own internal Intermediate Representation
called RTLIL. This conversion is done using one of a number of `passes`, like
`read_verilog` and `read_ilang`.

The RTLIL is further transformed and optimized via a large series of other
`passes`, such as `memory_dff`, and `opt`, to name two. Optimization `passes`
are often not called directly, but rather called automatically through high
level `passes` optimized for a specific output target (`synth`, `synth_ice40`).

This repository is a collection of test cases I use to figure out how yosys
`passes` works as a supplement to reading the source. Using [Kitten Book](https://twitter.com/thepracticaldev/status/720257210161311744?lang=en)
principles, I find that staring at yosys output via the `show` command or
reading the output files<sup>1</sup> to be very effective in gaining insight
into how `yosys` and the companion `yosys-smtbmc`<sup>2</sup> internally work.

## Prerequisites
1. [`yosys`](https://github.com/YosysHQ/yosys) from git master branch.
2. [`symbiyosys`](https://github.com/YosysHQ/SymbiYosys) from git master branch.
3. [yices2](https://github.com/SRI-CSL/yices2). If running on Windows, ask me
   for help with getting a yices2 binary if needed.
   * Previous knowledge of the [SMTv2 format](http://smtlib.cs.uiowa.edu) and
     experience using an SMT solver is also helpful.
4. [graphviz](https://www.graphviz.org). Required for yosys' `show` command.

## Invocation
Each subdirectory containing a README.md contains invocation instructions in
addition to useful information regarding the test case.

## Footnotes
1. Particularly in the case of the `smt2` backend.
2. `yosys-smtbmc` is invoked via the `symbiyosys` frontend in this repository.
