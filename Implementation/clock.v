module clock(
  input wire en,
  output reg clk = 0,
  output wire clk_inv
);

  always begin
    #5 clk = ~clk & en;
  end

  assign clk_inv = ~clk;

endmodule
