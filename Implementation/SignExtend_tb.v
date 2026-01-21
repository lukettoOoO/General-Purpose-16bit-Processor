`timescale 1ns / 1ps

module SignExtend_tb;

    reg [8:0] in;
    wire [15:0] out;

    SignExtend uut (
        .in(in), 
        .out(out)
    );

    initial begin

        in = 0;

        #100;
        
        in = 9'b000000101;
        #10;
        if (out === 16'h0005) $display("Test Case 1 Passed: +5 -> %h", out);
        else $display("Test Case 1 Failed: +5 -> %h", out);

        in = 9'b111111011;
        #10;
        if (out === 16'hFFFB) $display("Test Case 2 Passed: -5 -> %h", out);
        else $display("Test Case 2 Failed: -5 -> %h", out);

        in = 9'b000000000;
        #10;
        if (out === 16'h0000) $display("Test Case 3 Passed: 0 -> %h", out);
        else $display("Test Case 3 Failed: 0 -> %h", out);
        
        in = 9'b011111111;
        #10;
        if (out === 16'h00FF) $display("Test Case 4 Passed: +255 -> %h", out);
        else $display("Test Case 4 Failed: +255 -> %h", out);

        in = 9'b100000000;
        #10;
        if (out === 16'hFF00) $display("Test Case 5 Passed: -256 -> %h", out);
        else $display("Test Case 5 Failed: -256 -> %h", out);

        $finish;
    end
      
endmodule
