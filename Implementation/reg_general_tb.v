`timescale 1ns/1ps

module tb_reg_general;

  reg [15:0] d_in;
  reg clk;
  reg rst;
  reg load;
  wire [15:0] d_out;

  reg_general uut (
    .d_in(d_in),
    .clk(clk),
    .rst(rst),
    .load(load),
    .d_out(d_out)
  );

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    $display("Time\tclk\trst\tload\td_in\t\t| d_out");
    $monitor("%dns\t%b\t%b\t%b\t%h\t| %h",
             $time, clk, rst, load, d_in, d_out);
    
    rst = 1;
    load = 0;
    d_in = 16'hXXXX;
    @(posedge clk);
    
    #1
    rst = 0;
    @(posedge clk);
    
    #1
    load = 1;
    d_in = 16'hAAAA;
    @(posedge clk);
    
    #1
    load = 0;
    d_in = 16'hBBBB;
    @(posedge clk);
    
    #1
    load = 1;
    d_in = 16'hBBBB;
    @(posedge clk);
	
    #1
    rst = 1;
    load = 1;
    d_in = 16'hFFFF;
    @(posedge clk);
    
    #1
    rst = 0;
    @(posedge clk);
    
    $finish;
  end

endmodule
