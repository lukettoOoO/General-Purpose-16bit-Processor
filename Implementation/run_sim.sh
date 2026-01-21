iverilog -I ALU -o cpu_sim CPU_tb.v
vvp cpu_sim > output.log
