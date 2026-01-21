`timescale 1ns / 1ps

`include "ALU.v"
`include "registers.v"
`include "memory.v"
`include "ControlUnit.v"
`include "SignExtend.v"

module CPU(
    input clk,
    input rst
);

    //bus
    wire [15:0] system_bus;
    
    //instruction Register
    reg [15:0] IR;
    
    //control unit signals
    wire pc_inc, pc_load, jump_en;
    wire [15:0] jump_addr;
    wire [2:0] reg_s_in, reg_s_out;
    wire reg_write_en, reg_out_en;
    wire mem_read, mem_write;
    wire [1:0] mem_addr_src;
    wire [4:0] alu_op;
    wire alu_start, alu_src_b_imm, alu_out_en;
    wire ir_load;

    //data path signals
    wire [15:0] reg_d_out;
    wire [15:0] acc_out, x_out, y_out, sp_out, pc_out;
    wire [3:0] fr_out;
    
    wire [15:0] mem_data_bus; //connection to inout memory
    wire [9:0] mem_addr;
    
    wire [15:0] alu_result;
    wire alu_done_div, alu_done_mod, alu_done_mul;
    wire Z, N, C, V;
    
    wire [15:0] sign_ext_out;
    
    reg [3:0] stored_flags;
    wire cu_flag_write_en;
    
    always @(posedge clk or posedge rst) begin
        if (rst) stored_flags <= 4'b0000;
        else if (cu_flag_write_en) stored_flags <= {Z, N, C, V};
    end

    ControlUnit cu (
        .clk(clk),
        .rst(rst),
        .instruction(IR),
        .flags(stored_flags), 
        .alu_done_mul(alu_done_mul),
        .alu_done_div(alu_done_div),
        .alu_done_mod(alu_done_mod),
        .pc_inc(pc_inc),
        .pc_load(pc_load),
        .jump_addr(jump_addr),
        .jump_en(jump_en),
        .flag_write_en(cu_flag_write_en),
        .reg_s_in(reg_s_in),
        .reg_s_out(reg_s_out),
        .reg_write_en(reg_write_en),
        .reg_out_en(reg_out_en),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_addr_src(mem_addr_src),
        .alu_op(alu_op),
        .start(alu_start),
        .alu_src_b_imm(alu_src_b_imm),
        .alu_out_en(alu_out_en),
        .ir_load(ir_load)
    );

    reg [15:0] PC;
    
    always @(posedge clk or posedge rst) begin
        if (rst) PC <= 0;
        else if (jump_en) PC <= jump_addr;
        else if (pc_inc) PC <= PC + 1;
    end
    
    registers reg_file (
        .clk(clk),
        .s_in(reg_s_in),
        .s_out(reg_s_out),
        .d_in(system_bus),
        .write_en(reg_write_en),
        .out_en(reg_out_en),
        .d_out(reg_d_out),
        .acc_out(acc_out),
        .x_out(x_out),
        .y_out(y_out),
        .fr_out(fr_out),
        .sp_out(sp_out),
        .pc_out(pc_out)
    );
    
    //address Mux
    assign mem_addr = (mem_addr_src == 1) ? IR[9:0] : PC[9:0];
    
    //memory
    memory main_mem (
        .clk(clk),
        .addr(mem_addr),
        .write_en(mem_write),
        .read_en(mem_read),
        .data(system_bus)
    );

    //IR logic
    always @(posedge clk) begin
        if (ir_load) IR <= system_bus;
    end

    SignExtend sext (
        .in(IR[8:0]), 
        .out(sign_ext_out)
    );
    
    //memory data register
    reg [15:0] MDR;
    always @(posedge clk) begin
        if (mem_read) MDR <= system_bus;
    end

    wire [15:0] alu_a = (IR[8] == 0) ? x_out : y_out;
    wire [15:0] alu_b = (alu_src_b_imm) ? sign_ext_out : MDR; 

    ALU main_alu (
        .clk(clk),
        .rst(rst),
        .start(alu_start),
        .op(alu_op),
        .A(alu_a),
        .B(alu_b),
        .result(alu_result),
        .result_high(),
        .done_div(alu_done_div),
        .done_mod(alu_done_mod),
        .done_mul(alu_done_mul),
        .Z(Z), .N(N), .C(C), .V(V)
    );

    assign system_bus = (alu_out_en) ? alu_result : 16'bz;

    assign system_bus = reg_d_out; 

endmodule