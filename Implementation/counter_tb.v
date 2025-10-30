`timescale 1ns/1ps

module tb_counter;

  reg clk;
  reg rst;
  reg sel_in;
  reg count_up;
  reg count_down;
  reg [15:0] d_in;
  wire [15:0] out;

  counter uut (
    .clk(clk),
    .rst(rst),
    .sel_in(sel_in),
    .count_up(count_up),
    .count_down(count_down),
    .d_in(d_in),
    .out(out)
  );

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    $display("Time\tclk\trst\tsel_in\tup\tdown\td_in\t\t| out");
    $monitor("%dns\t%b\t%b\t%b\t\t%b\t%b\t\t%h\t| %h",
             $time, clk, rst, sel_in, count_up, count_down, d_in, out);

    rst = 1;
    sel_in = 0;
    count_up = 0;
    count_down = 0;
    d_in = 16'hXXXX;
    @(posedge clk);
    
    rst = 0;
    @(posedge clk);
    
    count_up = 1;
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    count_up = 0;
    
    count_down = 1;
    @(posedge clk);
    @(posedge clk);
    count_down = 0;
    @(posedge clk);
    
    sel_in = 1;
    d_in = 16'hAAAA;
    @(posedge clk);
    
    d_in = 16'hBBBB;
    count_up = 1;
    @(posedge clk);
    
    sel_in = 0;
    count_up = 0;
    @(posedge clk);
    
    rst = 1;
    sel_in = 1;
    count_up = 1;
    d_in = 16'hFFFF;
    @(posedge clk);
    
    rst = 0;
    @(posedge clk);
    
    $finish;
  end

endmodule
