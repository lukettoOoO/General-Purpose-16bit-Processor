//`include "subtracter.v"
`timescale 1ns / 1ps
 module dec(
  output [15:0] result,
   input [15:0] a,
   output Z,
    output N,
    output C,
    output V
);
  

subtracter dec_sub (
    .A(a),    
    .B(16'b0000000000000001),
    .dif(result),
    .Z(Z),
    .N(N),
    .C(C),
    .V(V)
);
  
endmodule