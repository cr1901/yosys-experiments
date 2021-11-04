# DFF Hold

## Invocation
### Run
`sby -f dffhold.sby`

## Rationale
`dffhold.v` is an example of a simple circuit which fails k-induction at any
length without constraining assumptions. The `top` module of `dffhold.v`
creates a chain of _two_ DFFs whose states can be held in place by a `hld`
input signal, regardless of the input `di`. The two DFF states can be reset
using a `rst` signal as well, though I'm not sure its required for this demo.

The `dffhold.sby` script creates two copies of the `top` module of `dffhold`,
and then creates a miter circuit `dffhold_miter` to compare their outputs
when given identical input. A miter circuit compares two subcircuits `gate`
and `gold` with identical input and output ports by:

1. Connecting like input ports together so they are fed with the same input.
2. Exclusive-ORs like outputs.
3. Reduce-ORs the Exclusive-OR stage.

The result of the miter is "if these two circuit's output ever differ given
the same input, the output of the miter is `1`, else the output of the miter
is `0` (or vice-versa)". It is a form of equivalence checking. `yosys` provides
a `miter` pass to create miter circuits, along with an `assert` output for
testing that two subcircuits are identical.

When comparing two exact copies of the same circuit with a miter, the miter
should always show that the two circuits are the same; given identical inputs,
copies of the same circuit should have the same output!

And indeed, a bounded model check of `dffhold.v` shows they're identical.
However, temporal induction will fail, no matter how long of an induction
length you try.

## Conclusions
Examples of failing traces show `q1` in `gate` and `gold` taking opposite
values before `hld` is deasserted, and `q` is loaded with opposite values from
`q1`. That state is impossible to reach from `top`'s initial state;
remember that `gate` and `gold` are copies of `top`, and `q1` and `q` are
initialized to `0`. The same circuit fed the same inputs should have the same
state.

Unfortunately, temporal induction does not care about the initial state
of a circuit. This includes whether the state is _even reachable_ from the
circuits' initial state. As far as the SMT solver is concerned, impossible to
reach states must be checked in order to prove a property holds "for all time"
using temporal induction.

Increasing the induction length is a good way to flush out counterexamples from
temporal induction. The problem here is that the state of `gate` and `gold` can
be arbitrarily frozen for arbitarily long thanks to the `hld` input. So an SMT
solver can- _and will_- find a counterexample in a `k`-step temporal induction
by:

1. Find a state where the value of `q1` differs in `gate` and `gold`, but `q0`
   of `gate` and `gold` are the same value.
2. Choose to keep `hld` asserted for `k - 2` time steps.
3. At `k - 1`, release `hld`.
4. At `k`, `q` in `gate` and `gold` will be loaded with `q1`, and the output
   `q` will diverge. The miter will trigger an assertion failure.

The `miter` pass has a `-flatten` option. If `-flatten` is added, `yosys` will
_correctly_ optimize the `miter` circuit down to a single copy of the `top`
module of `dffhold.v`, and temporal induction will pass. This only works for
two exact copies of the same circuit, however (and in practice, you're using
a miter to test optimizations or transformations).

## Open Question
I'm not sure of a good way to prevent temporal induction from failing other
than "add an assumption that `hld` will not be held indefinitely". This is a
reasonable assumption, but begs the question: "What is a reasonable number of
cycles in practice to keep the metaphorical `hld` signal in the same state in a
real application"?
