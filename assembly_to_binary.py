#!/usr/bin/env python3
"""
RISC-32 Assembler to COE File Converter
Converts assembly code to 32-bit machine code in COE format (radix 16)
"""

import re
import sys

# Instruction definitions based on ISA
R_TYPE_INSTRUCTIONS = {
    'ADD': ('000000', '00001'),
    'SUB': ('000000', '00010'),
    'AND': ('000000', '00011'),
    'OR': ('000000', '00100'),
    'XOR': ('000000', '00101'),
    'NOR': ('000000', '00110'),
    'SL': ('000000', '00111'),
    'SRL': ('000000', '01000'),
    'SRA': ('000000', '01001'),
    'SLT': ('000000', '01010'),
    'SGT': ('000000', '01011'),
    'NOT': ('000000', '01100'),
    'INC': ('000000', '01101'),
    'DEC': ('000000', '01110'),
    'HAM': ('000000', '01111'),
    'MOVE': ('010100', '10000'),
    'CMOV': ('010101', '10001'),
}

I_TYPE_INSTRUCTIONS = {
    'ADDI': '000001',
    'SUBI': '000010',
    'ANDI': '000011',
    'ORI': '000100',
    'XORI': '000101',
    'NORI': '000110',
    'SLI': '000111',
    'SRLI': '001000',
    'SRAI': '001001',
    'SLTI': '001010',
    'SGTI': '001011',
    'NOTI': '001100',
    'INCI': '001101',
    'DECI': '001110',
    'HAMI': '001111',
    'LUI': '010000',
    'LD': '010001',
    'ST': '010010',
    'BMI': '100001',
    'BPL': '100010',
    'BZ': '100011',
}

J_TYPE_INSTRUCTIONS = {
    'BR': '100000',
}

PROGRAM_CONTROL = {
    'HALT': '100100',
    'NOP': '100101',
    'CALL': '100110',
}


def parse_register(reg_str):
    """Parse register string and return 5-bit binary representation"""
    reg_str = reg_str.strip().upper()
    
    # Handle different register formats
    if reg_str == '$R0' or reg_str == 'R0' or reg_str == '$0':
        return '00000'
    elif reg_str == '$RET' or reg_str == 'RET':
        return '10000'
    elif reg_str.startswith('$R'):
        reg_num = int(reg_str[2:])
    elif reg_str.startswith('R'):
        reg_num = int(reg_str[1:])
    elif reg_str.startswith('$'):
        reg_num = int(reg_str[1:])
    else:
        reg_num = int(reg_str)
    
    if reg_num < 0 or reg_num > 15:
        raise ValueError(f"Invalid register number: {reg_num}")
    
    return format(reg_num, '05b')


def parse_immediate(imm_str, bits=16):
    """Parse immediate value and return binary representation in two's complement"""
    imm_str = imm_str.strip()
    
    # Remove # prefix if present
    if imm_str.startswith('#'):
        imm_str = imm_str[1:]
    
    # Handle hexadecimal
    if imm_str.startswith('0x') or imm_str.startswith('0X'):
        value = int(imm_str, 16)
    # Handle binary
    elif imm_str.startswith('0b') or imm_str.startswith('0B'):
        value = int(imm_str, 2)
    # Handle decimal (including negative)
    else:
        value = int(imm_str)
    
    # Handle negative numbers using two's complement
    if value < 0:
        # Check if negative value is in valid range
        min_value = -(1 << (bits - 1))
        if value < min_value:
            raise ValueError(f"Immediate value {value} out of range for {bits}-bit two's complement (min: {min_value})")
        # Convert to two's complement: for negative n, result is 2^bits + n
        value = (1 << bits) + value
    else:
        # Check if positive value is in valid range
        max_value = (1 << (bits - 1)) - 1
        if value > max_value:
            raise ValueError(f"Immediate value {value} out of range for {bits}-bit two's complement (max: {max_value})")
    
    return format(value, f'0{bits}b')


def assemble_r_type(instruction, parts):
    """Assemble R-type instruction"""
    opcode, funct = R_TYPE_INSTRUCTIONS[instruction]
    
    if instruction in ['NOT', 'INC', 'DEC', 'HAM']:
        # Format: INST rd, rt
        if len(parts) != 2:
            raise ValueError(f"{instruction} requires 2 operands")
        rd = parse_register(parts[0])
        rt = parse_register(parts[1])
        rs = '00000'  # Don't care
    elif instruction == 'MOVE':
        # Format: MOVE rd, rs
        if len(parts) != 2:
            raise ValueError(f"{instruction} requires 2 operands")
        rd = parse_register(parts[0])
        rs = parse_register(parts[1])
        rt = '00000'  # Don't care
    else:
        # Format: INST rd, rs, rt
        if len(parts) != 3:
            raise ValueError(f"{instruction} requires 3 operands")
        rd = parse_register(parts[0])
        rs = parse_register(parts[1])
        rt = parse_register(parts[2])
    
    dont_care = '000000'
    machine_code = opcode + rs + rt + rd + dont_care + funct
    return machine_code


def assemble_i_type(instruction, parts):
    """Assemble I-type instruction"""
    opcode = I_TYPE_INSTRUCTIONS[instruction]
    
    if instruction in ['LD', 'ST']:
        # Format: LD/ST rt, #imm(rs) or LD/ST rt, imm(rs)
        if len(parts) != 2:
            raise ValueError(f"{instruction} requires 2 operands")
        rt = parse_register(parts[0])
        
        # Parse #imm(rs) or imm(rs) format
        match = re.match(r'#?(-?\d+)\s*\(\s*([^)]+)\s*\)', parts[1])
        if not match:
            raise ValueError(f"Invalid format for {instruction}: expected #imm(rs) or imm(rs)")
        imm = parse_immediate(match.group(1), 16)
        rs = parse_register(match.group(2))
        
    elif instruction in ['BMI', 'BPL', 'BZ']:
        # Format: BRANCH rs, #imm or BRANCH rs, imm
        if len(parts) != 2:
            raise ValueError(f"{instruction} requires 2 operands")
        rs = parse_register(parts[0])
        rt = '00000'
        imm = parse_immediate(parts[1], 16)
        
    elif instruction in ['NOTI', 'INCI', 'DECI', 'HAMI', 'LUI']:
        # Format: INST rt, #imm or INST rt, imm
        if len(parts) != 2:
            raise ValueError(f"{instruction} requires 2 operands")
        rt = parse_register(parts[0])
        rs = '00000'
        imm = parse_immediate(parts[1], 16)
    else:
        # Format: INST rt, rs, #imm or INST rt, rs, imm
        if len(parts) != 3:
            raise ValueError(f"{instruction} requires 3 operands")
        rt = parse_register(parts[0])
        rs = parse_register(parts[1])
        imm = parse_immediate(parts[2], 16)
    
    machine_code = opcode + rs + rt + imm
    return machine_code


def assemble_j_type(instruction, parts):
    """Assemble J-type instruction"""
    opcode = J_TYPE_INSTRUCTIONS[instruction]
    
    if len(parts) != 1:
        raise ValueError(f"{instruction} requires 1 operand")
    
    imm = parse_immediate(parts[0], 26)
    machine_code = opcode + imm
    return machine_code


def assemble_program_control(instruction):
    """Assemble program control instruction"""
    opcode = PROGRAM_CONTROL[instruction]
    dont_care = '0' * 26
    machine_code = opcode + dont_care
    return machine_code


def preprocess_line(line):
    """Preprocess line to handle missing commas and clean up"""
    # Remove comments
    line = re.sub(r'[;#].*$', '', line)
    line = line.strip()
    
    if not line:
        return None
    
    # Fix missing comma before # (e.g., "SLI R7, R7 #1" -> "SLI R7, R7, #1")
    # This pattern looks for: register followed by space and # without comma
    line = re.sub(r'(R\d+)\s+(#)', r'\1, \2', line)
    
    return line


def assemble_line(line):
    """Assemble a single line of assembly code"""
    line = preprocess_line(line)
    
    # Skip empty lines
    if not line:
        return None
    
    # Split instruction and operands more carefully
    # First, split by whitespace to get instruction
    tokens = line.split(None, 1)
    if not tokens:
        return None
    
    instruction = tokens[0].upper()
    
    # Parse operands by splitting on commas
    if len(tokens) > 1:
        operands_str = tokens[1]
        # Split by comma and clean up each operand
        operands = [op.strip() for op in operands_str.split(',') if op.strip()]
    else:
        operands = []
    
    # Assemble based on instruction type
    if instruction in R_TYPE_INSTRUCTIONS:
        return assemble_r_type(instruction, operands)
    elif instruction in I_TYPE_INSTRUCTIONS:
        return assemble_i_type(instruction, operands)
    elif instruction in J_TYPE_INSTRUCTIONS:
        return assemble_j_type(instruction, operands)
    elif instruction in PROGRAM_CONTROL:
        return assemble_program_control(instruction)
    else:
        raise ValueError(f"Unknown instruction: {instruction}")


def binary_to_hex(binary_str):
    """Convert 32-bit binary string to 8-digit hexadecimal"""
    return format(int(binary_str, 2), '08X')


def assemble_to_coe(assembly_code, output_file=None):
    """Convert assembly code to COE file format"""
    lines = assembly_code.strip().split('\n')
    machine_codes = []
    
    for line_num, line in enumerate(lines, 1):
        try:
            machine_code = assemble_line(line)
            if machine_code:
                machine_codes.append(machine_code)
        except Exception as e:
            print(f"Error on line {line_num}: {line}")
            print(f"  {str(e)}")
            sys.exit(1)
    
    # Generate COE file content
    coe_content = "memory_initialization_radix=16;\n"
    coe_content += "memory_initialization_vector=\n"
    
    hex_codes = [binary_to_hex(code) for code in machine_codes]
    coe_content += ',\n'.join(hex_codes)
    coe_content += ";"
    
    if output_file:
        with open(output_file, 'w') as f:
            f.write(coe_content)
        print(f"Successfully assembled {len(machine_codes)} instructions to {output_file}")
    
    return coe_content


# Example usage
if __name__ == "__main__":
    # Example assembly code from user
    example_assembly = """
LD R10, #0(R0)
ADDI R11, R0, #1
BZ R10, #31
MOVE R1, R10
MOVE R2, R11
ADDI R3, R0, #32
MOVE R7, R2
ANDI R7, R7, #1
SLI R7, R7 #1
OR R7, R7, R6
BZ R7, #10
SUBI R7, R7, #1
BZ R7, #5
SUBI R7, R7, #1
BZ R7, #5
SUBI R7, R7, #1
BZ R7, #4
ADD R4, R4, R1
BR #2
SUB R4, R4, R1
MOVE R7, R4
ANDI R7, R7, #1
SLI R7, R7, #31
MOVE R6, R2
ANDI R6, R6, #1
SRLI R2, R2, #1
OR R2, R2, R7
SRAI R4, R4, #1
SUBI R3, R3, #1
BPL R3, #-23
MOVE R11, R2
SUBI R10, R10, #1
BR #-30
HALT
    """
    
    if len(sys.argv) > 1:
        # Read from input file
        input_file = sys.argv[1]
        output_file = sys.argv[2] if len(sys.argv) > 2 else "output.coe"
        
        with open(input_file, 'r') as f:
            assembly_code = f.read()
        
        assemble_to_coe(assembly_code, output_file)
    else:
        # Use example
        print("Assembling example code...")
        print(assemble_to_coe(example_assembly))
        print("\nUsage: python assembler.py <input.asm> [output.coe]")
