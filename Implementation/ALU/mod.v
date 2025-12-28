`timescale 1ns / 1ps
//`include "restoring_div.v"
module mod(
  input clk, rst, start,
  input [15:0] a,
  input [15:0] b,
  output [15:0] result,
  output done_mod,
  output Z,
    output N,
    output C,
    output V
);
  
  restoring_div mod_inst(
    .clk(clk),
    .rst(rst),
    .start(start),
    .inbus1(a),
    .inbus2(b),
    .cat(),
    .rest(result),
    .done(done_mod)
);
  
  reg Z_reg, N_reg;

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        Z_reg <= 0;
        N_reg <= 0;
    end else if (done_mod) begin
        Z_reg <= (result == 16'b0);
        N_reg <= result[15];
    end
end

assign Z = Z_reg;
assign N = N_reg;
assign C = 1'b0;
assign V = 1'b0;

endmodule

  
  