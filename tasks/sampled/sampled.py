from nmigen import *
from nmigen.asserts import Assert, Past
from nmigen.cli import main


class Sampled(Elaboratable):
    def __init__(self):
        self.d = Signal()
        self.q   = Signal()
        self.s   = Signal()

    def elaborate(self, platform):
        m = Module()
        m.d.sync += [
            self.q.eq(self.d),
            self.s.eq(Past(self.d)),
            Assert(Past(self.d)),
            Assert(self.d),
            Assert(self.q),
            Assert(self.s)
        ]

        return m


if __name__ == "__main__":
    m = Module()
    m.submodules.sampled = sampled = Sampled()
    m.domains.sync = sync = ClockDomain("sync", reset_less=True)
    main(m, ports=[sync.clk, sampled.d, sampled.q, sampled.s])
