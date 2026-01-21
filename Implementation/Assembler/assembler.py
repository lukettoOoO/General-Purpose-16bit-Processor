#!/usr/bin/env python3

import sys
import argparse
import os

FORMAT1_OPCODES = {
    "LOAD":  "000001",
    "STORE": "000010",
    "ADD":   "000011",
    "SUB":   "000100",
    "MUL":   "000101",
    "DIV":   "000110",
    "MOD":   "000111",
    "LSR":   "001000",
    "LSL":   "001001",
    "RSR":   "001010",
    "RSL":   "001011",
    "AND":   "001100",
    "OR":    "001101",
    "XOR":   "001110",
    "NOT":   "001111",
    "MOV":   "010000",
    "CMP":   "010001",
    "TST":   "010010",
    "INC":   "010011",
    "DEC":   "010100",
}

FORMAT2_OPCODES = {
    "JMP": "100000",
    "RET": "100001",
    "BRA": "100010",
    "BRZ": "100011",
    "BRN": "100100",
    "BRC": "100101",
    "BRO": "100110",
}

REGISTER_MAP = {
    "X": "0",
    "Y": "1",
}

def to_binary(n, bits):
    """Convert an int n to a binary string of size bits"""
    if isinstance(n, str):
        n = int(n)
        
    if n < 0:
        #c2
        n = (1 << bits) + n
    
    bin_str = format(n, f'0{bits}b')
    
    if len(bin_str) > bits:
        raise ValueError(f"Number {n} requires more than {bits} bits!")
        
    return bin_str


def clean_line(line):
    """Clear whitespace and comments from line"""
    if ';' in line:
        line = line[:line.find(';')]
    return line.strip().upper()

#besides cleaning whitespace and comments, this pass counts the lines
#and stores at which address each label is located
def pass_one(source_lines):
    """Build symbol table"""
    symbol_table = {}
    instruction_lines = []
    current_address = 0
    
    for line_number, line in enumerate(source_lines):
        line = clean_line(line)
        
        if not line:
            continue  
            
        if line.endswith(':'):
            label = line[:-1]
            if label in symbol_table:
                raise ValueError(f"Label '{label}' is redefined at line {line_number + 1}!")
            #found label, save the address
            symbol_table[label] = current_address
        else:
            #found instruction, save it and move on
            current_address += 1
            instruction_lines.append((line, line_number + 1))
            
    return symbol_table, instruction_lines

#generates the binary code for each instruction
#and substitutes labels with their addresses
def pass_two(instruction_lines, symbol_table):
    """Generate the 16-bit binary code"""
    machine_code = []
    
    for line, line_number in instruction_lines:
        try:
            parts = line.replace(',', ' ').split()
            if not parts:
                continue
                
            mnemonic = parts[0]
            operands = parts[1:]
            
            binary_instruction = ""
            
            if mnemonic in FORMAT1_OPCODES:
                opcode_bin = FORMAT1_OPCODES[mnemonic]
                
                if len(operands) != 2:
                    raise ValueError(f"Instruction '{mnemonic}' requires 2 operands, got {len(operands)}!")
                
                if operands[0] not in REGISTER_MAP:
                    raise ValueError(f"Unknown register '{operands[0]}'! Expected X or Y!")
                reg_bin = REGISTER_MAP[operands[0]]
                
                imm_str = operands[1]
                if imm_str in symbol_table:
                    imm_val = symbol_table[imm_str]
                else:
                    imm_val = int(imm_str)
                
                imm_bin = to_binary(imm_val, 9)
                
                binary_instruction = opcode_bin + reg_bin + imm_bin
                
            elif mnemonic in FORMAT2_OPCODES:
                opcode_bin = FORMAT2_OPCODES[mnemonic]
                
                if mnemonic == "RET":
                    if len(operands) != 0:
                        raise ValueError("'RET' instruction doesn't require operands!")
                    addr_bin = to_binary(0, 10)
                else:  #JMP, BRA, BRZ, etc.
                    if len(operands) != 1:
                        raise ValueError(f"Instruction '{mnemonic}' requires 1 operand (label/address)!")
                    
                    target = operands[0]
                    if target in symbol_table:
                        addr_val = symbol_table[target]
                    else:
                        try:
                            addr_val = int(target)
                        except ValueError:
                            raise ValueError(f"Unknown label or invalid address '{target}'!")
                    
                    addr_bin = to_binary(addr_val, 10)
                
                binary_instruction = opcode_bin + addr_bin
                
            else:
                raise ValueError(f"Unknown instruction (mnemonic): '{mnemonic}'!")

            if len(binary_instruction) != 16:
                raise ValueError(f"Generated instruction has {len(binary_instruction)} bits instead of 16!")

            machine_code.append(binary_instruction)
            
        except Exception as e:
            raise ValueError(f"Error at line {line_number}: {e}!")
            
    return machine_code


def write_output_files(output_base_name, binary_strings):
    """Write .txt and .bin output files"""
    #.txt file - text binary representation (for debugging purposes)
    txt_filename = output_base_name + ".txt"
    with open(txt_filename, 'w') as f:
        for bin_str in binary_strings:
            f.write(f"{bin_str}\n")
    print(f".txt file generated successfully: {txt_filename}")

    #.bin file - binary file to be loaded into memory
    bin_filename = output_base_name + ".bin"
    try:
        with open(bin_filename, 'wb') as f:
            for bin_str in binary_strings:
                value = int(bin_str, 2)
                f.write(value.to_bytes(2, byteorder='big'))
        print(f".bin file generated successfully: {bin_filename}")
    except IOError as e:
        raise IOError(f"Error writing to file '{bin_filename}': {e}!")

def main():    
    parser = argparse.ArgumentParser(
        description="*** 16-bit GPP Assembler",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="Usage: python assembler.py -i file.asm -o file"
    )
    parser.add_argument(
        '-i', '--input', 
        type=str, 
        required=True, 
        help="Input .asm file"
    )
    parser.add_argument(
        '-o', '--output', 
        type=str, 
        required=True, 
        help="Output file base name (.bin and .txt)"
    )
    args = parser.parse_args()

    try:
        with open(args.input, 'r') as f:
            source_lines = f.readlines()
    except FileNotFoundError:
        print(f"ERROR: Input file '{args.input}' not found!", file=sys.stderr)
        sys.exit(1)
    except IOError as e:
        print(f"ERROR: Reading file '{args.input}': {e}!", file=sys.stderr)
        sys.exit(1)

    print(f"Assembly start: {args.input}")

    try:
        symbol_table, instruction_lines = pass_one(source_lines)
        print(f"First pass done. Symbol table: {symbol_table}")
        
        binary_output = pass_two(instruction_lines, symbol_table)
        print("Second pass done.")
        
        write_output_files(args.output, binary_output)
        
        print(f"\nAssembly done. Generated {len(binary_output)} instructions.")
        
    except Exception as e:
        print(f"\nASSEMBLY FAILED: {e}!", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()