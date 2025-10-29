`timescale 1ns/1ps

module tb_registers;

  reg [2:0] s_in;
  reg [2:0] s_out;
  reg [15:0] d_in;
  reg write_en;
  reg out_en;
  reg clk;
  wire [15:0] d_out;
  wire [15:0] acc_out;
  wire [15:0] x_out;
  wire [15:0] y_out;
  wire [3:0] fr_out;
  wire [15:0] sp_out;
  wire [15:0] pc_out;

  registers uut (
    .s_in(s_in),
    .s_out(s_out),
    .d_in(d_in),
    .write_en(write_en),
    .out_en(out_en),
    .clk(clk),
    .d_out(d_out),
    .acc_out(acc_out),
    .x_out(x_out),
    .y_out(y_out),
    .fr_out(fr_out),
    .sp_out(sp_out),
    .pc_out(pc_out)
  );

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    $display("Time\tOp\ts_in\ts_out\td_in\t\twrite_en\tout_en\t| d_out\t\tacc\t\tx\t\ty\t\tfr\tsp\t\tpc");
    $monitor("%dns\t%s\t%b\t%b\t%h\t%b\t\t%b\t\t| %h\t%h\t%h\t%h\t%h\t%h\t%h",
             $time, "MON", s_in, s_out, d_in, write_en, out_en, 
             d_out, acc_out, x_out, y_out, fr_out, sp_out, pc_out);

    s_in = 3'bxxx;
    s_out = 3'bxxx;
    d_in = 16'hXXXX;
    write_en = 0;
    out_en = 0;
    #10;

    $display("write to ACC");
    s_in = 3'b000;
    d_in = 16'hAAAA;
    write_en = 1;
    @(posedge clk);
    #1;
    write_en = 0;
    #2;
    
    $display("write to X");
    s_in = 3'b001;
    d_in = 16'hBBBB;
    write_en = 1;
    @(posedge clk);
    #1;
    write_en = 0;
    #2;
    
    $display("write to Y");
    s_in = 3'b010;
    d_in = 16'hCCCC;
    write_en = 1;
    @(posedge clk);
    #1;
    write_en = 0;
    #2;

    $display("write to FR");
    s_in = 3'b011;
    d_in = 16'hDDDD;
    write_en = 1;
    @(posedge clk);
    #1;
    write_en = 0;
    #2;

    $display("write to SP");
    s_in = 3'b100;
    d_in = 16'hEEEE;
    write_en = 1;
    @(posedge clk);
    #1;
    write_en = 0;
    #2;

    $display("write to PC");
    s_in = 3'b101;
    d_in = 16'hFFFF;
    write_en = 1;
    @(posedge clk);
    #1;
    write_en = 0;
    #2;

    $display("read verify");
    out_en = 1;

    s_out = 3'b000; #10;
    if (d_out !== 16'hAAAA) $error("read ACC failed! expected 16'hAAAA, got %h", d_out);
    
    s_out = 3'b001; #10;
    if (d_out !== 16'hBBBB) $error("read X failed! expected 16'hBBBB, got %h", d_out);

    s_out = 3'b010; #10;
    if (d_out !== 16'hCCCC) $error("read Y failed! expected 16'hCCCC, got %h", d_out);

    s_out = 3'b011; #10;
    if (d_out !== 16'h000D) $error("read FR failed! expected 16'h000D, got %h", d_out);
    if (fr_out !== 4'hD) $error("FR_out pin failed! expected 4'hD, got %h", fr_out);

    s_out = 3'b100; #10;
    if (d_out !== 16'hEEEE) $error("read SP failed! expected 16'hEEEE, got %h", d_out);

    s_out = 3'b101; #10;
    if (d_out !== 16'hFFFF) $error("read PC failed! expected 16'hFFFF, got %h", d_out);

    $display("high-Z test");
    out_en = 0;
    s_out  = 3'b000;
    #10;
    if (d_out !== 16'bz) $error("high-Z test failed! expected 16'bz, got %h", d_out);

    $display("tests done");
    $finish;
  end

endmodule

