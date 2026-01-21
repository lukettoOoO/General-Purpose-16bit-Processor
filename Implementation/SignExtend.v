`timescale 1ns / 1ps

module SignExtend(
    input [8:0] in,
    output [15:0] out
);

    assign out = {{7{in[8]}}, in};

endmodule
