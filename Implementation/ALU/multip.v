`timescale 1ns / 1ps
`include "multiplier.v"

module multip(
    input clk,
    input rst,
    input start,
  input [15:0] a,
  input [15:0] b,
    output [15:0] product_low,
    output [15:0] product_high,
    output done,
    output Z, 
    output N, 
    output C, 
    output V
);

 
  wire [15:0] abs_A = a[15] ? (~a + 1'b1) : a;
  wire [15:0] abs_B = b[15] ? (~b + 1'b1) : b;

    reg sign_final;
    always @(posedge clk or posedge rst) begin
        if (rst) 
            sign_final <= 1'b0;
        else if (start) 
          sign_final <= a[15] ^ b[15]; 
    end

    wire [15:0] p_high_uns;
    wire [15:0] p_low_uns;

    multiplier multipl_uut(
        .clk(clk),
        .rst(rst),
        .start(start),
      	.A(abs_A), 
      	.B(abs_B), 
        .product_high(p_high_uns),
        .product_low(p_low_uns),
        .done(done)
    );
  
 
    wire [31:0] full_uns = {p_high_uns, p_low_uns};

    wire [31:0] full_signed = sign_final ? (~full_uns + 1'b1) : full_uns;

    assign product_high = full_signed[31:16];
  assign product_low  = full_signed[15:0];

    assign Z = (full_signed == 32'b0);
    assign N = full_signed[31]; 
    assign V = 1'b0;
    assign C = 1'b0;

endmodule