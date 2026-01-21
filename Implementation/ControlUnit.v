`timescale 1ns / 1ps

module ControlUnit(
    input clk,
    input rst,
    input [15:0] instruction,
    input [3:0] flags, //Z, N, C, V
    
    //ALU done signals
    input alu_done_mul,
    input alu_done_div,
    input alu_done_mod,

    
    //PC control
    output reg pc_inc,
    output reg pc_load,       
    output reg [15:0] jump_addr, 
    output reg jump_en,
    output reg flag_write_en,
    
    //reg control
    output reg [2:0] reg_s_in,  
    output reg [2:0] reg_s_out, 
    output reg reg_write_en,
    output reg reg_out_en,      
    
    //memory control
    output reg mem_read,
    output reg mem_write,
    output reg [1:0] mem_addr_src, //0: PC, 1: IR[9:0] (direct)
    
    //ALU control
    output reg [4:0] alu_op,
    output reg start,          
    output reg alu_src_b_imm,  //0: bus (mem), 1: imm
    output reg alu_out_en,     
    
    //IR Control
    output reg ir_load
);

    //micro PC
    reg [5:0] upc;
    reg [5:0] next_upc;
    
    //opcodes
    localparam OP_LOAD  = 6'b000001; 
    localparam OP_STORE = 6'b000010; 
    localparam OP_ADD   = 6'b000011; 
    localparam OP_SUB   = 6'b000100; 
    localparam OP_MUL   = 6'b000101; 
    localparam OP_DIV   = 6'b000110; 
    localparam OP_MOD   = 6'b000111; 
    localparam OP_MOV   = 6'b010000; 
    localparam OP_CMP   = 6'b010001; 
    
    localparam OP_JMP   = 6'b100000; 
    localparam OP_BRZ   = 6'b100011; 
    
    wire [5:0] ir_opcode = instruction[15:10];
    wire [1:0] ir_reg    = instruction[9:8]; 
    wire [9:0] ir_addr   = instruction[9:0];

    wire [2:0] target_reg = (ir_reg == 0) ? 3'b001 : 3'b010;

    localparam FETCH_1 = 0;
    localparam FETCH_2 = 1;
    localparam DECODE  = 2;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
             upc <= FETCH_1;
             //$display("CU Reset: upc=%d", FETCH_1);
        end else begin
             upc <= next_upc;
             $display("CU Tick: T=%t upc=%d next_upc=%d", $time, upc, next_upc);
        end
    end

    always @(*) begin
        //default signals
        pc_inc = 0; pc_load = 0; jump_addr = 0; jump_en = 0;
        reg_s_in = 0; reg_s_out = 0; reg_write_en = 0; reg_out_en = 0;
        flag_write_en = 0;
        mem_read = 0; mem_write = 0; mem_addr_src = 0;
        alu_op = 0; start = 0; alu_src_b_imm = 0; alu_out_en = 0;
        ir_load = 0;
        next_upc = FETCH_1;

        case (upc)
            FETCH_1: begin
                mem_addr_src = 0; //PC
                mem_read = 1;
                next_upc = FETCH_2;
            end
            
            FETCH_2: begin
                mem_addr_src = 0;
                mem_read = 1; 
                ir_load = 1;  
                pc_inc = 1;
                next_upc = DECODE;
            end
            
            DECODE: begin
                case (ir_opcode)
                    OP_LOAD: next_upc = 10;
                    OP_STORE: next_upc = 20;
                    OP_ADD: next_upc = 30; 
                    OP_SUB: next_upc = 31;
                    OP_MUL: next_upc = 32;
                    OP_DIV: next_upc = 33;
                    OP_MOD: next_upc = 42;
                    OP_MOV: next_upc = 34; 
                    OP_CMP: next_upc = 35;
                    OP_JMP: next_upc = 50;
                    OP_BRZ: next_upc = 51;
                    default: next_upc = FETCH_1; 
                endcase
            end
            
            //EXECUTE
            //LOAD
            10: begin mem_addr_src = 1; mem_read = 1; next_upc = 11; end
            11: begin mem_addr_src = 1; mem_read = 1; reg_s_in = target_reg; reg_write_en = 1; next_upc = FETCH_1; end
            
            //STORE
            20: begin mem_addr_src = 1; reg_s_out = target_reg; reg_out_en = 1; mem_write = 1; next_upc = FETCH_1; end
            
            //ADD
            30: begin mem_addr_src = 1; mem_read = 1; alu_src_b_imm = 0; next_upc = 60; end // Go to Wait
            60: begin mem_addr_src = 1; mem_read = 1; alu_src_b_imm = 0; next_upc = 36; end // Wait State
            36: begin
                 mem_read = 0; //stop driving bus from mem
                 alu_src_b_imm = 0; //use MDR
                 alu_op = 5'd10; 
                 alu_out_en = 1; //ALU drives bus
                 reg_s_in = target_reg; 
                 reg_write_en = 1; 
                 next_upc = FETCH_1; 
            end
            
            //SUB
            31: begin mem_addr_src = 1; mem_read = 1; alu_src_b_imm = 0; next_upc = 61; end // Go to Wait
            61: begin mem_addr_src = 1; mem_read = 1; alu_src_b_imm = 0; next_upc = 37; end // Wait State
            37: begin 
                mem_read = 0; 
                alu_src_b_imm = 0; 
                alu_op = 5'd14; 
                alu_out_en = 1; 
                reg_s_in = target_reg; 
                reg_write_en = 1; 
                next_upc = FETCH_1; 
            end
            
            //MUL
            32: begin
                mem_addr_src = 1;
                mem_read = 1; //load MDR
                alu_src_b_imm = 0;
                next_upc = 62; 
            end
            62: begin
                mem_addr_src = 1;
                mem_read = 1; 
                alu_src_b_imm = 0;
                next_upc = 38; 
            end
            38: begin
                //init MUL
                mem_read = 0; //use MDR
                alu_src_b_imm = 0;
                alu_op = 5'd7; 
                start = 1; 
                next_upc = 40; 
            end
            40: begin
                start = 0; 
                if (alu_done_mul) begin
                    alu_op = 5'd7; 
                    alu_out_en = 1; 
                    reg_s_in = target_reg;
                    reg_write_en = 1;
                    next_upc = FETCH_1;
                end else begin
                    alu_op = 5'd7; 
                    next_upc = 40; 
                end
            end

            //DIV
            33: begin
                mem_addr_src = 1;
                mem_read = 1;
                alu_src_b_imm = 0; 
                next_upc = 63;
            end
            63: begin
                mem_addr_src = 1;
                mem_read = 1;
                alu_src_b_imm = 0; 
                next_upc = 39;
            end
            39: begin
                mem_read = 0; 
                alu_src_b_imm = 0;
                alu_op = 5'd2; 
                start = 1;
                next_upc = 41; 
            end
            41: begin
                start = 0;
                if (alu_done_div) begin
                    alu_op = 5'd2;
                    alu_out_en = 1;
                    reg_s_in = target_reg;
                    reg_write_en = 1;
                    next_upc = FETCH_1;
                end else begin
                    alu_op = 5'd2;
                    next_upc = 41; 
                end
            end

            //MOD
            42: begin
                mem_addr_src = 1;
                mem_read = 1;
                alu_src_b_imm = 0; 
                next_upc = 55;
            end
            55: begin
                mem_addr_src = 1;
                mem_read = 1;
                alu_src_b_imm = 0; 
                next_upc = 43;
            end
            43: begin
                mem_read = 0; 
                alu_src_b_imm = 0;
                alu_op = 5'd5; 
                start = 1;
                next_upc = 44; 
            end
            44: begin
                start = 0; 
                if (alu_done_mod) begin
                    alu_op = 5'd5;
                    alu_out_en = 1;
                    reg_s_in = target_reg;
                    reg_write_en = 1;
                    next_upc = FETCH_1;
                end else begin
                    alu_op = 5'd5;
                    next_upc = 44; 
                end
            end


            
            //MOV
            34: begin alu_src_b_imm = 1; alu_op = 5'd6; alu_out_en = 1; reg_s_in = target_reg; reg_write_en = 1; next_upc = FETCH_1; end
            
            //CMP
            35: begin alu_src_b_imm = 1; alu_op = 5'd17; flag_write_en = 1; next_upc = FETCH_1; end
            
            //JMP
            50: begin jump_addr = {6'b0, ir_addr}; jump_en = 1; next_upc = FETCH_1; end
            
            //BRZ
            51: begin if (flags[3]) begin jump_addr = {6'b0, ir_addr}; jump_en = 1; end next_upc = FETCH_1; end

            default: next_upc = FETCH_1;
        endcase
    end

endmodule
