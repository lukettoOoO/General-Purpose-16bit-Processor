`timescale 1ns / 1ps
//`include "parallel_adder.v"
module restoring_div(
  input clk, rst, start,
  input  [15:0] inbus1, inbus2,
  output [15:0] cat, rest,
  output done
);

  
  reg busy, busy_d;
  reg [4:0] count; 
  reg [15:0] inbus1_reg, inbus2_reg;

  reg [15:0] a;
  reg [15:0] q;
  reg [15:0] shift_a;
  reg [15:0] shift_q;

  wire [15:0] sum;
  wire restore_a;
  wire finish;
  wire q_lsb;

  assign restore_a = sum[15]; 
  assign q_lsb = !restore_a;
  assign finish = (count == 5'd15);

  assign cat  = q;
  assign rest = a;
  assign done = (!busy) && (busy_d);

  reg [15:0] complement_reg;
  always @(posedge clk or negedge rst) begin
    if (!rst)
      complement_reg <= 16'h0;
    else if (start)
      complement_reg <= ~inbus2 + 16'b1;
  end

  parallel_adder u_parallel_adder(
    .A(shift_a),
    .B(complement_reg),
    .cin(1'b0),
    .Sum(sum),
    .Z(), .N(), .C(), .V()
  );

  always @(posedge clk or negedge rst) begin
    if (!rst)
      busy <= 1'b0;
    else if (start)
      busy <= 1'b1;
    else if (finish)
      busy <= 1'b0;
  end

  always @(posedge clk or negedge rst) begin
    if (!rst)
      busy_d <= 1'b0;
    else
      busy_d <= busy;
  end

  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      inbus1_reg <= 16'h0;
      inbus2_reg <= 16'h0;
    end else if (start) begin
      inbus1_reg <= inbus1;
      inbus2_reg <= inbus2;
    end
  end

  always @(posedge clk or negedge rst) begin
    if (!rst)
      count <= 5'd0;
    else if (start)
      count <= 5'd0;
    else if (busy)
      count <= count + 5'd1;
  end

  always @(*) begin
    if (busy)
      {shift_a, shift_q} = {a, q} << 1;
    else
      {shift_a, shift_q} = {32'h0};
  end

  always @(posedge clk or negedge rst) begin
    if (!rst)
      {a, q} <= {32'h0};
    else if (start)
      {a, q} <= {16'h0, inbus1};
    else if (busy) begin
      if (restore_a)
        {a, q} <= {shift_a, q[14:0], q_lsb}; 
      else
        {a, q} <= {sum, q[14:0], q_lsb};
    end
  end

endmodule
