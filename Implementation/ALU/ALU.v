`timescale 1ns / 1ps
`include "And.v"
`include "dec.v"
`include "div.v"
`include "inc.v"
`include "left_shift.v"
`include "mod.v"
`include "Mov.v"
`include "multip.v"
`include "Not.v"
`include "Or.v"
`include "parallel_adder.v"
`include "right_shift.v"
`include "Mux.v"
`include "rotate_left.v"
`include "rotate_right.v"
`include "subtracter.v"
`include "test.v"
`include "Xor.v"
`include "Cmp.v"

module ALU(
	input clk, rst, start,
  input [4:0] op,
  input [15:0] A,
  input [15:0] B,
  output reg [15:0] result,
  output reg [15:0] result_high,
    output done_div, done_mod, done_mul,

    output reg Z,
    output reg N,
    output reg C,
    output reg V
);
  
  wire [15:0] and_res, dec_res, div_res, inc_res, lsh_res, mod_res, mov_res, mul_high_res, mul_low_res, not_res, or_res, add_res, rsh_res, rotl_res, rotr_res, sub_res, xor_res;
  wire [17:0] N_op, Z_op, C_op, V_op;
  
  And And_unit(
    .result(and_res),
    .a(A),
    .b(B),
    .Z(Z_op[0]),
    .N(N_op[0]),
    .C(C_op[0]),
    .V(V_op[0])
  );
  
  dec dec_unit(
    .result(dec_res),
    .a(A),
    .Z(Z_op[1]),
    .N(N_op[1]),
    .C(C_op[1]),
    .V(V_op[1])
  );
  
  div div_unit(
    .clk(clk),
    .rst(rst),
    .start(start),
    .a(A),
    .b(B),
    .result(div_res),
    .done_div(done_div),
    .Z(Z_op[2]),
    .N(N_op[2]),
    .C(C_op[2]),
    .V(V_op[2])
  );
  
  
  inc inc_unit(
    .result(inc_res),
    .a(A),
    .Z(Z_op[3]),
    .N(N_op[3]),
    .C(C_op[3]),
    .V(V_op[3])
  );
  
  left_shift left_sh_unit(
    .j(A),
    .k(B[3:0]),
    .lshift(lsh_res),
    .C(C_op[4]),
    .Z(Z_op[4]),
    .N(N_op[4]),
    .V(V_op[4])
  );
  
  mod mod_unit(
    .clk(clk),
    .rst(rst),
    .start(start),
    .a(A),
    .b(B),
    .result(mod_res),
    .done_mod(done_mod),
    .Z(Z_op[5]),
    .N(N_op[5]),
    .C(C_op[5]),
    .V(V_op[5])
  );
  
  Mov mov_unit(
    .result(mov_res),
    .a(A),
    .Z(Z_op[6]),
    .N(N_op[6]),
    .C(C_op[6]),
    .V(V_op[6])
  );
  
  multip multip_unit(
    .clk(clk),
    .rst(rst),
    .start(start),
    .A(A),
    .B(B),
    .product_high(mul_high_res),
    .product_low(mul_low_res),
    .done(done_mul),
    .Z(Z_op[7]),
    .N(N_op[7]),
    .C(C_op[7]),
    .V(V_op[7])
  );
  
  Not Not_unit(
    .result(not_res),
    .a(A),
    .Z(Z_op[8]),
    .N(N_op[8]),
    .C(C_op[8]),
    .V(V_op[8])
  );
  
  Or Or_unit(
    .result(or_res),
    .a(A),
    .b(B),
    .Z(Z_op[9]),
    .N(N_op[9]),
    .C(C_op[9]),
    .V(V_op[9])
  );
  
  parallel_adder adder_unit(
    .A(A),
    .B(B),
    .cin(1'b0),
    .Sum(add_res),
    .Z(Z_op[10]),
    .N(N_op[10]),
    .C(C_op[10]),
    .V(V_op[10])
  );
  
  right_shift right_sh_unit(
    .j(A),
    .k(B[3:0]),
    .rshift(rsh_res),
    .Z(Z_op[11]),
    .N(N_op[11]),
    .C(C_op[11]),
    .V(V_op[11])
  );
  
  rotate_left rotate_left_unit(
    .result(rotl_res),
    .j(A),
    .k(B[3:0]),
    .Z(Z_op[12]),
    .N(N_op[12]),
    .C(C_op[12]),
    .V(V_op[12])
  );
  
  rotate_right rotate_right_unit(
    .result(rotr_res),
    .j(A),
    .k(B[3:0]),
    .Z(Z_op[13]),
    .N(N_op[13]),
    .C(C_op[13]),
    .V(V_op[13])
  );
  
  subtracter subtracter_unit(
    .A(A),
    .B(B),
    .dif(sub_res),
    .Z(Z_op[14]),
    .N(N_op[14]),
    .C(C_op[14]),
    .V(V_op[14])
  );
  
  test test_unit(
    .a(A),
    .b(B),
    .Z(Z_op[15]),
    .N(N_op[15]),
    .C(C_op[15]),
    .V(V_op[15])
  );
  
  Xor Xor_unit(
    .result(xor_res),
    .a(A),
    .b(B),
    .Z(Z_op[16]),
    .N(N_op[16]),
    .C(C_op[16]),
    .V(V_op[16])
  );
  Cmp Cmp_unit(
    .A(A),
    .B(B),
    .Z(Z_op[17]),
    .N(N_op[17]),
    .C(C_op[17]),
    .V(V_op[17])
  );
  
  always @(*) begin
    result = 16'b0;
  	result_high = 16'b0;
  	Z = 1'b0;
  	N = 1'b0;
  	C = 1'b0;
  	V = 1'b0;

    case(op)
      5'd0: begin result = and_res; N = N_op[0]; Z = Z_op[0]; C = C_op[0]; V = V_op[0]; end
      5'd1: begin result = dec_res; N = N_op[1]; Z = Z_op[1]; C = C_op[1]; V = V_op[1]; end
      5'd2: begin result = div_res; N = N_op[2]; Z = Z_op[2]; C = C_op[2]; V = V_op[2]; end
      5'd3: begin result = inc_res; N = N_op[3]; Z = Z_op[3]; C = C_op[3]; V = V_op[3]; end
      5'd4: begin result = lsh_res; N = N_op[4]; Z = Z_op[4]; C = C_op[4]; V = V_op[4]; end
      5'd5: begin result = mod_res; N = N_op[5]; Z = Z_op[5]; C = C_op[5]; V = V_op[5]; end
      5'd6: begin result = mov_res; N = N_op[6]; Z = Z_op[6]; C = C_op[6]; V = V_op[6]; end
      5'd7: begin result = mul_low_res; result_high = mul_high_res; N = N_op[7]; Z = Z_op[7]; C = C_op[7]; V = V_op[7]; end
      5'd8: begin result = not_res; N = N_op[8]; Z = Z_op[8]; C = C_op[8]; V = V_op[8]; end
      5'd9: begin result = or_res; N = N_op[9]; Z = Z_op[9]; C = C_op[9]; V = V_op[9]; end
      5'd10: begin result = add_res; N = N_op[10]; Z = Z_op[10]; C = C_op[10]; V = V_op[10]; end
      5'd11: begin result = rsh_res; N = N_op[11]; Z = Z_op[11]; C = C_op[11]; V = V_op[11]; end
      5'd12: begin result = rotl_res; N = N_op[12]; Z = Z_op[12]; C = C_op[12]; V = V_op[12]; end
      5'd13: begin result = rotr_res; N = N_op[13]; Z = Z_op[13]; C = C_op[13]; V = V_op[13]; end
      5'd14: begin result = sub_res; N = N_op[14]; Z = Z_op[14]; C = C_op[14]; V = V_op[14]; end
      5'd15: begin N = N_op[15]; Z = Z_op[15]; C = C_op[15]; V = V_op[15]; end
      5'd16: begin result = xor_res; N = N_op[16]; Z = Z_op[16]; C = C_op[16]; V = V_op[16]; end
      5'd17: begin N = N_op[17]; Z = Z_op[17]; C = C_op[17]; V = V_op[17]; end
    endcase
end

  
endmodule