`timescale 1ns/1ps

module memory(
  input wire clk,
  input wire [9:0] addr,
  input wire write_en,
  input wire read_en,
  inout wire [15:0] data
);

  reg [15:0] mem [0:1023];
  reg [15:0] read_data;
  reg [15:0] data_out;

  // initialization
  integer i;
  initial begin
    for (i = 0; i < 1024; i = i + 1) begin
      mem[i] = 16'h0000;
    end
    read_data = 16'h0000;
    data_out = 16'hzzzz;
  end

  always @(posedge clk) begin
    if (write_en) begin
      mem[addr] <= data;
    end
    else begin
      read_data <= mem[addr];
    end
  end

  always @(*) begin
    if (read_en & ~write_en)
      data_out = read_data;
    else
      data_out = 16'hzzzz;
  end

  assign data = data_out;

endmodule