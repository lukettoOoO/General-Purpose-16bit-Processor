`timescale 1ns / 1ps
`include "fac.v"
module parallel_adder(
  input [15:0] A,
  input [15:0] B,
    input cin,
  	output [15:0] Sum,
    output Z,
    output N,
    output C,
    output V
);
  
  
  wire [16:0] carry; 

    assign carry[0] = cin; 
    
    fac fac_0 (.x(A[0]), .y(B[0]), .ci(carry[0]), .z(Sum[0]), .co(carry[1]));
    fac fac_1 (.x(A[1]), .y(B[1]), .ci(carry[1]), .z(Sum[1]), .co(carry[2]));
    fac fac_2 (.x(A[2]), .y(B[2]), .ci(carry[2]), .z(Sum[2]), .co(carry[3]));
    fac fac_3 (.x(A[3]), .y(B[3]), .ci(carry[3]), .z(Sum[3]), .co(carry[4]));
    fac fac_4 (.x(A[4]), .y(B[4]), .ci(carry[4]), .z(Sum[4]), .co(carry[5]));
    fac fac_5 (.x(A[5]), .y(B[5]), .ci(carry[5]), .z(Sum[5]), .co(carry[6]));
    fac fac_6 (.x(A[6]), .y(B[6]), .ci(carry[6]), .z(Sum[6]), .co(carry[7]));
    fac fac_7 (.x(A[7]), .y(B[7]), .ci(carry[7]), .z(Sum[7]), .co(carry[8]));
  	fac fac_8 (.x(A[8]), .y(B[8]), .ci(carry[8]), .z(Sum[8]), .co(carry[9]));
  
    fac fac_9 (.x(A[9]), .y(B[9]), .ci(carry[9]), .z(Sum[9]), .co(carry[10]));
    fac fac_10 (.x(A[10]), .y(B[10]), .ci(carry[10]), .z(Sum[10]), .co(carry[11]));
    fac fac_11 (.x(A[11]), .y(B[11]), .ci(carry[11]), .z(Sum[11]), .co(carry[12]));
    fac fac_12 (.x(A[12]), .y(B[12]), .ci(carry[12]), .z(Sum[12]), .co(carry[13]));
    fac fac_13 (.x(A[13]), .y(B[13]), .ci(carry[13]), .z(Sum[13]), .co(carry[14]));
    fac fac_14 (.x(A[14]), .y(B[14]), .ci(carry[14]), .z(Sum[14]), .co(carry[15]));
    fac fac_15 (.x(A[15]), .y(B[15]), .ci(carry[15]), .z(Sum[15]), .co(carry[16]));
  
  assign Z = (Sum==16'b0);
  assign N = (Sum[15]);
  assign C = carry[16];
  assign V = (~(A[15] ^ B[15])) & (A[15] ^ Sum[15]);

endmodule
