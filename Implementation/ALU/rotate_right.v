//`include "Mux.v" 
`timescale 1ns / 1ps
module rotate_right(
    output [15:0] result,
    input  [15:0] j,
  input  [3:0]  k,
  output Z,
    output N,
    output C,
    output V
);

    genvar i;

    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_rotate
          wire [3:0] s;
         
            assign s = (i + k) & 4'hF; 

            mux16to1 m (
                .out(result[i]),
                .in(j),
              .s(s)
            );
        end
    endgenerate
	assign Z = (result == 16'b0);
  assign N = (result[15]);
  assign C = 1'b0;
  assign V = 1'b0;
endmodule
