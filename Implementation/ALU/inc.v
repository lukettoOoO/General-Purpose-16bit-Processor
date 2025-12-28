//`include "parallel_adder.v"
`timescale 1ns / 1ps
module inc(
  output [15:0] result,
  input [15:0] a,
  output Z,
    output N,
    output C,
    output V
);
  

parallel_adder inc_adder (
  	.A(a),    
    .B(16'b0000000000000001),
    .cin(1'b0),
    .Sum(result),
    .Z(Z),
    .N(N),
    .C(C),
    .V(V)
);
  
endmodule