`timescale 1ns / 1ps
module xor_bit(
  output result,
    input  a,
    input  b
);
  
  assign result = a ^ b;
endmodule

module Xor(
    output [15:0] result,
    input  [15:0] a,
  	input  [15:0] b,
    output Z,
    output N,
    output C,
    output V
);
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin
            xor_bit xob (.result(result[i]), .a(a[i]), .b(b[i]));
        end
    endgenerate
  assign Z = (result == 16'b0);
  assign N = (result[15]);
  assign C = 1'b0;
  assign V = 1'b0;
endmodule
