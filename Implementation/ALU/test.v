//`include "And.v"
`timescale 1ns / 1ps
module test(
    input [15:0] a,
    input [15:0] b,
    output Z,
    output N,
    output C,
    output V
);

    wire [15:0] and_result;

    And and_inst(
        .a(a),
        .b(b),
        .result(and_result),
        .Z(Z),
        .N(N),
        .C(C),
        .V(V)
    );


endmodule
