`timescale 1ns / 1ps
module Cmp(
  input [15:0] A,
  input [15:0] B,
  output Z,
    output N,
    output C,
    output V

);
  
  wire [15:0] diff;

subtracter sub (
    .A(A),
    .B(B),
  .dif(diff),
  .Z(Z),
  .N(N),
  .C(C),
  .V(V)
);

endmodule