`timescale 1ns/1ps

module reg_general(
  input wire [15:0] d_in,
  input wire clk,
  input wire rst,
  input wire load,
  output reg [15:0] d_out
);

  initial begin
    d_out = 0;
  end

  always @(posedge clk) begin
    if (rst) begin
      d_out <= 0;
    end
    else if (load) begin
      d_out <= d_in;
    end
  end

endmodule

