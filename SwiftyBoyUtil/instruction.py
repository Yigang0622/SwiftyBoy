def parseInstruction(opcode, arr):
    line_1 = arr[0]  # DEC B
    line_2 = arr[1]  # 1 4
    line_3 = arr[2]  # Z 1 H -
    ins = Instruction()
    ins.opcode = opcode
    line_1_arr = line_1.split(' ')
    ins.desc = line_1
    ins.command = line_1_arr[0]
    if len(line_1_arr) == 2:
        operand_arr = line_1_arr[1].split(',')
        ins.operand_1 = operand_arr[0]
        if len(operand_arr) == 2:
            ins.operand_2 = operand_arr[1]
    ins.flag_config = line_3
    line_2_arr = line_2.split(' ')
    ins.byte_length = line_2_arr[0]
    ins.cycle = line_2_arr[1]
    ins.opcode_hex = "0x{:02x}".format(ins.opcode)
    ins.method_name = '{}_{}'.format(ins.command, ins.opcode_hex.upper()[2:])
    return ins


class Instruction:

    def __init__(self):
        self.opcode = 0
        self.desc = ''
        self.command = ''
        self.operand_1 = None
        self.operand_2 = None
        self.flag_config = '- - - -'
        self.byte_length = 0
        self.cycle = 0

    def __str__(self):
        return "{} {}".format(hex(self.opcode), self.desc)

    def operand_1_is_address(self):
        if not self.operand_1:
            return False
        return ('(' in self.operand_1) and (')' in self.operand_1)

    def operand_2_is_address(self):
        if not self.operand_2:
            return False
        return ('(' in self.operand_2) and (')' in self.operand_2)
