module my_reg(input clka, input clkb, input a_d, b_d, output reg a_q, b_q);

    initial a_q = 0;
    always @ (posedge clka)
        a_q <= a_d;

    //cover property ((a_q == 1) && (a_d == 0));

    always @ (negedge clkb)
        b_q <= b_d;
endmodule
