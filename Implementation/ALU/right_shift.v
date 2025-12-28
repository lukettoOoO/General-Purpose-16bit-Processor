`timescale 1ns / 1ps
module right_shift(
    input [15:0] j,
    input [3:0] k,
    output reg [15:0] rshift,
    output reg C,
    output Z,
    output N,
    output V
);

  always @(*) begin
    rshift = j >> k;

    if (k == 0)
        C = 1'b0;
    else
        C = j[k-1];
  end

  assign Z = (rshift == 0);
  assign N = rshift[15];
  
  assign V = 1'b0;

endmodule
