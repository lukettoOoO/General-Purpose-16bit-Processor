`timescale 1ns / 1ps
`include "restoring_div.v"

module div(
  input clk, rst, start,
  input [15:0] a,
  input [15:0] b,
  output [15:0] result,
  output done_div,
  output Z,
  output N,
  output C,
  output V
);
  
  wire div_by_zero = (b == 16'b0);

  wire [15:0] abs_a = a[15] ? (~a + 1'b1) : a;
  wire [15:0] abs_b = b[15] ? (~b + 1'b1) : b;

  reg sign_quotient;
  always @(posedge clk or negedge rst) begin
      if (!rst) sign_quotient <= 1'b0;
      else if (start) sign_quotient <= a[15] ^ b[15];
  end


  wire [15:0] cat_unsigned;
  
  restoring_div div_inst(
    .clk(clk),
    .rst(rst),
    .start(start),
    .inbus1(abs_a),
    .inbus2(abs_b),
    .cat(cat_unsigned),
    .rest(),
    .done(done_div)
  );
  
  wire [15:0] result_temp = sign_quotient ? (~cat_unsigned + 1'b1) : cat_unsigned;
  
  assign result = div_by_zero ? 16'b0 : result_temp;

  assign Z = (result == 16'b0 && !div_by_zero);
  assign N = (result[15] && !div_by_zero);
  assign V = div_by_zero;
  assign C = 1'b0;

endmodule

