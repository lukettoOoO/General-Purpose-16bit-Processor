`timescale 1ns / 1ps


module tb_ALU;

  reg clk;
  reg rst;
  reg start;
  reg [4:0] op;
  reg [15:0] A;
  reg [15:0] B;

  wire [15:0] result;
  wire [15:0] result_high;
  wire done_div, done_mod, done_mul;
  wire Z, N, C, V;


  ALU dut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .op(op),
    .A(A),
    .B(B),
    .result(result),
    .result_high(result_high),
    .done_div(done_div),
    .done_mod(done_mod),
    .done_mul(done_mul),
    .Z(Z),
    .N(N),
    .C(C),
    .V(V)
  );


  always #5 clk = ~clk;

  initial begin

   
    clk = 0;
    rst = 0;
    start = 0;
    op = 0;
    A = 0;
    B = 0;

    $display("START SIMULARE ALU");
    #10;
    rst = 1;
    #10;

  
    op = 5'd0;
    A  = 16'h00F0;
    B  = 16'h0FF0;
    #10; 
    
    $display("1.OP: AND | A: %b | B: %b | Result: %b | Z:%b N:%b C:%b V:%b", A, B, result, Z, N, C, V);

     #10;
    op = 5'd1;
    A  = 16'd10; 
    #10;
    $display("2.OP: DEC | A: %d | Result: %d | Z:%b N:%b", A, result, Z, N);
    
	#10
    op = 5'd2;
    A  = -16'd20;
    B  = 16'd5;
    start = 1;
    $display("3.OP: DIV STARTED");
    
    #10;
    start = 0;

    wait(done_div == 1);
    #10;

    #10;
    $display("3.OP: DIV DONE | A: %d | B: %d | Result: %d | Z:%d N:%d C:%d V:%d", $signed(A), B, $signed(result), Z, N, C, V);

    
    
    
     #10
    op = 5'd3;
    A = 16'd21;
    #10
    $display("4.OP: INC | A: %d | Result: %d | Z:%b N:%b", A, result, Z, N);
   
     #10;
    op = 5'd4;
    A  = 16'b0000000000000001;
    B  = 16'd2; 
    #10;
    $display("5.OP: LSH | A: %b | Shift: %d | Result: %b", A, B[3:0], result);
    
    #10; 
    
    op = 5'd5;  
    A  = -16'd8;
    B  = 16'd3;
    start = 1;
    $display("6.OP: MOD STARTED");
    
    #10;
    start = 0;

    wait(done_mod == 1);
    #10;
    $display("6.OP: MOD DONE | A: %d | B: %d | Result: %d | Z: %d N: %d V: %d C: %d", $signed(A), B, $signed(result), Z, N, V, C);
    
     #10;
    op = 5'd6; 
    A  = 16'h8001;
    #10;
    $display("7.OP: MOV | A: %d | Result: %d", A, result);
    
    #10;
    op = 5'd7;
    A  = -16'd11;
    B  = 16'd5;
    #5
    start = 1;
    $display("8.OP: MUL STARTED");
    
    #10;
    start = 0; 

    wait(done_mul == 1);
    #10; 
    $display("8.OP: MUL DONE | A: %d | B: %d | ResLow: %d | ResHigh: %d | N: %d Z: %d V: %d C: %d", $signed(A), $signed(B), $signed(result), $signed(result_high), N, Z, V, C);
    
     #10
    op = 5'd8;
    A = 16'd15;
    #10
    $display("9.OP: NOT | A: %b | Result: %b | Z:%b N:%b", A, result, Z, N);
    
    #10
    op = 5'd9;
    A=16'd11;
    B=16'd14;
    #10
    $display("10.OP: OR | A: %b | B: %b | Result: %b | Z:%b N:%b", A, B, result, Z, N);
    

    #10;
    op = 5'd10;
    A  = 16'd10;
    B  = 16'd5;
    #10;
    $display("11.OP: ADD | A: %d | B: %d | Result: %d | Z:%b N:%b C:%b V:%b", A, B, result, Z, N,C, V);
    
     #10;
    op = 5'd11;
    A  = 16'b0000_0000_1111_0000; 
    B  = 16'd4;
    #10;
    $display("12.OP: RSH | A: %b | Shift: %d | Result: %b", A, B[3:0], result);

    #10
    op=5'd12;
    A=16'b0000000011110000;
    B=16'd5;
    #10
    $display("13.OP: ROT_LEFT | A: %b | Rotate: %d | Result: %b", A, B[3:0], result);
    
    #10
    op=5'd13;
    A=16'b0000000011110000;
    B=16'd5;
    #10
    $display("14.OP: ROT_RIGHT | A: %b | Rotate: %d | Result: %b", A, B[3:0], result);

    #10
    op=5'd14;
    A=16'd15;
    B=16'd16;
    #10
    $display("15.OP: SUB | A: %d | B %d | Result: %d | Z:%b N:%b C:%b V:%b", A, B, result, Z, N, C, V);
    
    #10
    op=5'd15;
    A=16'd16;
    B=16'd16;
    #10
    $display("16.OP: TST | A: %d | B: %d | Z:%b N:%b C:%b V:%b", A, B, Z, N, C, V);
    
    #10;
    op = 5'd16; 
    A  = 16'b0101010101010101;
    B  = 16'd123;
    #10;
    $display("17.OP: XOR | A: %b | B: %b | Result: %b", A, B, result);


    #10;
    op = 5'd17; 
    A  = 16'd5;
    B  = 16'd10;
    #10;
    $display("18.OP: CMP | A: %d | B: %d | Z:%b N:%b C:%b V:%b", A, B, Z, N, C, V);

    #50;
    

    $display("FINAL SIMULARE");
    $finish;
  end

endmodule
