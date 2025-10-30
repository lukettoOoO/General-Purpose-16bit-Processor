`timescale 1ns/1ps

module counter(
  input wire clk,
  input wire rst,
  input wire sel_in,
  input wire count_up,
  input wire count_down,
  input wire [15:0] d_in,
  output reg [15:0] out
);

  initial begin
    out = 0;
  end

  always @(posedge clk) begin
    if (rst) begin
      out <= 0;
    end
    else if (sel_in) begin
      out <= d_in;
    end
    else if (count_up) begin
      out <= out + 1;
    end
    else if (count_down) begin
      out <= out - 1;
    end
  end

endmodule

