module sampled(input clk, input d, output reg q, output reg s);
    always @(posedge clk) begin
        q <= d;
        // s shares resources with assert(q), due to needing to latch q's value
        // early in the clock tick. $past(d) requires two FFs, for the reasons
        // described below. s <= $past(d) does not require a third FF and in
        // fact s is fed by the output of the second FF! See below for
        // rationale.
        s <= $past(d);

        // Sample value of a function is the function evaluated at the sampled
        // value of it's argument. For d, that would be the value of "d" in
        // the Preponed region of the current clock tick (i.e. redundant).
        //
        // $past grabs data from previous $samples in the Preponed region.
        // One FF latching data from d will hold the Preponed region of data
        // through the remaining regions of the time slot, even if d itself
        // changes. I.e. we latched the $sampled value.
        //
        // Conveniently, this means that once the current clock tick becomes
        // the next clock tick, the output of the first FF will match
        // the $sampled value from the previous clock tick- i.e. $past- at
        // least for the Preponed region. If we need the $past value to
        // persist, as would be necessary to implement an assert, we can
        // latch it. Thus $past requires at a minimum two FFs to hold the value
        // for all regions of a clock tick.
        assert($past(d));
        // The expressions in asserts take the value in the Preponed region.
        // Just like with $past, if we want to save the $sampled value at a
        // clock tick, we need to latch it before it's (possibly) overwritten
        // later in the clock tick. q ends up feeding this assert block.
        assert(d);
        // Shares assert block with assert($past(d)); s ends up feeding
        // this assert block for both assert($past(d)) and assert(q).
        // Meaning q represents $past(d) in Preponed region and $sampled(d) in
        // other regions, and that s <= q has the same net effect as
        // s <= $past(d) at clock ticks.
        // TODO: Are s <= q and s <= $past(d) identical at all time steps
        // between clock ticks in simulation?
        assert(q);
        // Analogous to $sampled($past(d))?
        // If $past was to toggle in the current timestep, I _think_
        // $sampled($past(d)) would return the value of $past(d) before
        // the toggle, thus adding a 1 clock tick delay relative to $past(d)
        // alone? I'm not sure.
        assert(s);
    end
endmodule
