//`include "fac.v"
`timescale 1ns / 1ps
module subtracter(
	input [15:0] A,
  	input [15:0] B,
    output [15:0] dif,
    output Z,
    output N,
    output C,
    output V
);
  
  wire [16:0] carry;
  wire [16:0] temp_res;
  
  assign temp_res = A + ~B + 1'b1;
  assign dif = temp_res[15:0];
  assign carry[16] = temp_res[16];
  
  assign Z = (dif==16'b0);
  assign N = (dif[15]);
  assign C = carry[16];
  assign V = (A[15] != B[15]) && (dif[15] != A[15]);
endmodule
