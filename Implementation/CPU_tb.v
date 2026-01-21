`timescale 1ns / 1ps

`include "CPU.v"

module CPU_tb;

    reg clk;
    reg rst;
    
    CPU uut (
        .clk(clk), 
        .rst(rst)
    );
    
    always #5 clk = ~clk;
    
    //states
    always @(uut.cu.upc) begin
        $display("T=%t State=%d PC=%h IR=%h Bus=%h", $time, uut.cu.upc, uut.PC, uut.IR, uut.system_bus);
    end
    
    integer f_input, f_output;
    integer op_read;
    integer a_val, b_val, cmd_val;
    
    initial begin
        clk = 0;
        rst = 1;

        //load program logic (from assembler)
        $display("loading Program from calculator_prog.txt...");
        $readmemb("calculator_prog.txt", uut.main_mem.mem);
        
        $display("Mem[0] after load: %h", uut.main_mem.mem[0]);
        if (uut.main_mem.mem[0] === 16'bx) begin
            $display("Mem[0] is X, forcing test program.");
            //force LOAD X, 102 (CMD) -> 0466
            //000001 00 01100110
            uut.main_mem.mem[0] = 16'h0466;
        end
        
        //inject Input Data
        //reads input.txt: A, B, CMD
        f_input = $fopen("input.txt", "r");
        if (f_input) begin
            op_read = $fscanf(f_input, "%x\n%x\n%x\n", a_val, b_val, cmd_val);
            $display("injecting Input: A=%d, B=%d, Cmd=%d (to Addr 100,101,102)", a_val, b_val, cmd_val);
            uut.main_mem.mem[100] = a_val;
            uut.main_mem.mem[101] = b_val;
            uut.main_mem.mem[102] = cmd_val;
            $fclose(f_input);
        end else begin
             $display("input.txt not found, using defaults");
             uut.main_mem.mem[100] = 5;
             uut.main_mem.mem[101] = 3;
             uut.main_mem.mem[102] = 0; // ADD
        end

        //start simulation
        #100;
        rst = 0;
        
        //run
        #10000;
        
        //output result
        $display("simulation finished");
        $display("result at 103: %d", uut.main_mem.mem[103]);
        
        //write output for interface
        f_output = $fopen("result.txt", "w");
        $fwrite(f_output, "%d", $signed(uut.main_mem.mem[103]));
        $fclose(f_output);
        $display("Result written to result.txt");
        
        $finish;
    end
      
endmodule
