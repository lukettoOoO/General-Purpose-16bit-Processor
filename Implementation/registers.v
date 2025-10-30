`timescale 1ns/1ps

//register file
module registers(
  input wire [2:0] s_in,     //selection bits
  input wire [2:0] s_out,
  input wire [15:0] d_in,
  input wire write_en,
  input wire out_en,
  input wire clk,
  output wire [15:0] d_out,
  output wire [15:0] acc_out, 
  output wire [15:0] x_out,
  output wire [15:0] y_out,
  output wire [3:0] fr_out,
  output wire [15:0] sp_out,
  output wire [15:0] pc_out
);

  reg [15:0] acc_reg;
  reg [15:0] x_reg;
  reg [15:0] y_reg;
  reg [3:0] fr_reg;
  reg [15:0] sp_reg;
  reg [15:0] pc_reg;

  //mapping: 0=ACC, 1=X, 2=Y, 3=FR, 4=SP, 5=PC
  always @(posedge clk) begin
    if (write_en) begin
      case (s_in)
        3'b000: acc_reg <= d_in;
        3'b001: x_reg <= d_in;
        3'b010: y_reg <= d_in;
        3'b011: fr_reg <= d_in[3:0];
        3'b100: sp_reg <= d_in;
        3'b101: pc_reg <= d_in;
        default: ;
      endcase
    end
  end

  reg [15:0] d_out_reg;  
  assign d_out = d_out_reg;

  always @(*) begin
    if (out_en) begin
      case (s_out)
        3'b000: d_out_reg = acc_reg;
        3'b001: d_out_reg = x_reg;
        3'b010: d_out_reg = y_reg;
        3'b011: d_out_reg = {12'b0, fr_reg};
        3'b100: d_out_reg = sp_reg;
        3'b101: d_out_reg = pc_reg;
        default: d_out_reg = 16'hXXXX;
      endcase
    end
    else begin
      d_out_reg = 16'bz;
    end
  end
  
  assign acc_out = acc_reg;
  assign x_out = x_reg;
  assign y_out = y_reg;
  assign fr_out = fr_reg;
  assign sp_out = sp_reg;
  assign pc_out = pc_reg;

endmodule

