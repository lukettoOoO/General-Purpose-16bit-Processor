`timescale 1ns / 1ps
`include "multiplier.v"
module multip(
    input clk,
    input rst,
    input start,
    input [15:0] A,
    input [15:0] B,
  output [15:0] product_low,
  output [15:0] product_high,
    output done,
    output Z,
    output N,
    output C,
    output V
);

    multiplier multipl_uut(
        .clk(clk),
        .rst(rst),
        .start(start),
        .A(A),
        .B(B),
      .product_high(product_high),
      .product_low(product_low),
        .done(done)
    );

    reg Z_reg, N_reg;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            Z_reg <= 0;
            N_reg <= 0;
        end 
        else if (done) begin
          Z_reg <= (product_high == 16'b0) && (product_low == 16'b0);
            N_reg <= product_high[15];
        end
    end

    assign Z = Z_reg;
    assign N = N_reg;

    assign C = 1'b0;
    assign V = 1'b0;

endmodule
