`timescale 1ns / 1ps
module mov_bit(
  output result,
    input  a
);
  
  assign result = a;
endmodule

module Mov(
    output [15:0] result,
  input  [15:0] a,
    output Z,
    output N,
    output C,
    output V
);
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin
            mov_bit mob (.result(result[i]), .a(a[i]));
        end
    endgenerate
  assign Z = (result == 16'b0);
  assign N = (result[15]);
  assign C = 1'b0;
  assign V = 1'b0;
endmodule
