`timescale 1ns/1ps

module memory_tb;

  reg clk;
  reg [9:0] addr;
  reg write_en;
  reg read_en;
  reg [15:0] data_in_reg;
  wire [15:0] data_out_wire;

  wire [15:0] data;

  memory uut (
    .clk(clk),
    .addr(addr),
    .write_en(write_en),
    .read_en(read_en),
    .data(data)
  );
  
  assign data = (write_en) ? data_in_reg : 16'bz;
  assign data_out_wire = data;

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    $display("Time\tclk\taddr\twr\trd\tdata_in\t\t| data_out");
    $monitor("%dns\t%b\t%h\t%b\t%b\t%h\t| %h",
             $time, clk, addr, write_en, read_en, data_in_reg, data_out_wire);

    addr = 10'hXXX;
    write_en = 0;
    read_en = 0;
    data_in_reg = 16'hXXXX;
    #10;
    
    write_en = 1;
    addr = 10'h100;
    data_in_reg = 16'hAAAA;
    @(posedge clk);
    #1;
    
    addr = 10'h101;
    data_in_reg = 16'hBBBB;
    @(posedge clk);
    #1;

    write_en = 0;
    read_en = 1;
    addr = 10'h100;
    @(posedge clk);
    @(posedge clk);
    
    #1;
    addr = 10'h101;
    @(posedge clk);
    @(posedge clk);
    
    read_en = 0;
    @(posedge clk);

    write_en = 1;
    read_en = 1;
    addr = 10'h102;
    data_in_reg = 16'hCCCC;
    @(posedge clk);
    #1;
    
    write_en = 0;
    read_en = 0;
    @(posedge clk);

    $finish;
  end

endmodule

