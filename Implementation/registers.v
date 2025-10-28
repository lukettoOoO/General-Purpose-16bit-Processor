`timescale 1ns/1ps

module registers(
  input  wire [2:0] s_in, //selection bits
  input  wire [2:0] s_out,
  input  wire [7:0] d_in,
  input  wire write_en,
  input  wire out_en,
  input  wire clk,
  output wire [7:0] d_out,
  output wire [7:0] r0,
  output wire [7:0] r1,
  output wire [7:0] r2,
  output wire [7:0] r3,
  output wire [7:0] r4,
  output wire [7:0] r5,
  output wire [7:0] r6,
  output wire [7:0] r7
);

  reg [7:0] r [7:0];

  always @(posedge clk) begin
    if (write_en)
      r[s_in] <= d_in;
  end

  reg [7:0] d_out_reg;  
  assign d_out = d_out_reg;

  always @(*) begin
    if (out_en)
      d_out_reg = r[s_out];
    else
      d_out_reg = 8'bz;
  end
  
  assign {r7, r6, r5, r4, r3, r2, r1, r0} = {r[7], r[6], r[5], r[4], r[3], r[2], r[1], r[0]};

endmodule
