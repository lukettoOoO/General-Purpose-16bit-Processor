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
  assign carry[0] = 1;
    
  genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : fac_loop
            fac fa (
                .x(A[i]),
                .y(~B[i]),
                .ci(carry[i]),
                .z(dif[i]),
                .co(carry[i+1])
            );
        end
    endgenerate
  assign Z = (dif==16'b0);
  assign N = (dif[15]);
  assign C = carry[16];
  assign V = (A[15] != B[15]) && (dif[15] != A[15]);
endmodule
