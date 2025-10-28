`timescale 1ns/1ps

module registers_tb;

  reg [2:0] s_in;
  reg [2:0] s_out;
  reg [7:0] d_in;
  reg write_en;
  reg out_en;
  reg clk;
  wire [7:0] d_out;
  wire [7:0] r0, r1, r2, r3, r4, r5, r6, r7;

  registers uut (
    .s_in(s_in),
    .s_out(s_out),
    .d_in(d_in),
    .write_en(write_en),
    .out_en(out_en),
    .clk(clk),
    .d_out(d_out),
    .r0(r0),
    .r1(r1),
    .r2(r2),
    .r3(r3),
    .r4(r4),
    .r5(r5),
    .r6(r6),
    .r7(r7)
  );

  always #5 clk = ~clk;

  initial begin
    clk = 0;
    write_en = 0;
    out_en = 0;
    s_in = 3'b000;
    s_out = 3'b000;
    d_in = 8'h00;

    $monitor("T=%0t | write_en=%b out_en=%b | s_in=%0d s_out=%0d | d_in=%h | d_out=%h | r0=%h r1=%h r2=%h r3=%h r4=%h r5=%h r6=%h r7=%h",
              $time, write_en, out_en, s_in, s_out, d_in, d_out,
              r0, r1, r2, r3, r4, r5, r6, r7);

	//write into registers
    #10;
    write_en = 1;
    d_in = 8'hAA; s_in = 3'd0; #10;
    d_in = 8'hBB; s_in = 3'd1; #10;
    d_in = 8'hCC; s_in = 3'd2; #10;
    d_in = 8'hDD; s_in = 3'd3; #10;
    write_en = 0;

	//read from registers
    #10;
    out_en = 1;
    s_out = 3'd0; #10;
    s_out = 3'd1; #10;
    s_out = 3'd2; #10;
    s_out = 3'd3; #10;

	//output disabled test
    #10;
    out_en = 0;
    #10;

    $stop;
  end
  
endmodule
