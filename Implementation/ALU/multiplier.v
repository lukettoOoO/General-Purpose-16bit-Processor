//`include "parallel_adder.v"
`timescale 1ns / 1ps
module multiplier(
    input clk,
    input rst,

    input start,
  input [15:0] A,
  input [15:0] B,
  output [15:0] product_high,
  output [15:0] product_low,
    output done
);
    reg busy;
    reg busy_d;
  reg [4:0] count;

  reg [15:0] A_reg;
  reg [15:0] B_reg;

  reg [15:0] a;
  reg [15:0] q;

  wire [15:0] renew;
    wire acc_load;
    wire carry;

    assign acc_load = (q[0]);
  wire finish;
  assign finish = (count == 5'd15);
    

  assign product_high = {a};
  assign product_low = {q};
    assign done = (!busy) && (busy_d);


  
  parallel_adder u_parallel_adder(
    .A(a), .B(A_reg), .cin(1'b0), .Sum(renew), .Z(), .N(), .C(carry), .V()
  );

    always @(posedge clk or posedge rst)begin
        if(rst)
            busy <= 1'b0;
        else if(start)
            busy <= 1'b1;
        else if(finish)
            busy <= 1'b0;
    end

    always @(posedge clk or posedge rst)begin
        if(rst)
            busy_d <= 1'b0;
        else
            busy_d <= busy;
    end

    always @(posedge clk or posedge rst)begin
        if(rst) begin
            A_reg <= 16'h0;
            B_reg <= 16'h0;
        end

        else if(start) begin
            A_reg <= A;
            B_reg <= B;
        end

    end

  always @(posedge clk or posedge rst)begin
        if(rst)
        {a, q} <= {32'h0};

        else if(start)
        {a, q} <= {16'h0, B};

        else if(busy) begin
         if (acc_load)
            {a, q} <= {carry, renew, q[15:1]};
        else
            {a, q} <= {1'b0, a, q[15:1]};
        end

        else
        {a, q} <= {a, q};
    end

    always @(posedge clk or posedge rst)begin
        if(rst)
            count <= 5'd0;
        else if(busy)
            count <= count + 5'd1;
        else
            count <= 5'd0;
    end
    




endmodule