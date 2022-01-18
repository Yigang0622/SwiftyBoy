from instruction_fetch import *
from typedef import *
from constant import *


def handle_SET_commend(ins: Instruction):
    lines = []
    if ins.operand_2 == '(HL)':
        lines.append('var v = {}'.format(code_template['(HL)']))
        lines.append('v = setBit(n: {}, val: v)'.format(ins.operand_1))
        lines.append('mb.setMem(address: hl, val: v)')
        lines.append('fZ = getZeroFlag(val: v)')
    else:
        lines.append('{} = setBit(n: {}, val: {})'.format(code_template[ins.operand_2],code_template[ins.operand_2], ins.operand_1))
        lines.append('fZ = getZeroFlag(val: {})'.format(code_template[ins.operand_2]))
    lines.append('fN = false')
    lines.append('fH = true')
    return SwiftInstructionFunction(ins, lines)


def handle_SWAP_commend(ins: Instruction):
    lines = []
    if ins.operand_1 == '(HL)':
        lines.append('var v = {}'.format(code_template['(HL)']))
        lines.append('v = swap(val: v)'.format(ins.operand_1))
        lines.append('mb.setMem(address: hl, val: v)')
        lines.append('fZ = getZeroFlag(val: v)')
    else:
        lines.append('{} = swap(val: {})'.format(code_template[ins.operand_1],code_template[ins.operand_1]))
        lines.append('fZ = getZeroFlag(val: {})'.format(code_template[ins.operand_1]))
    lines.append('fN = false')
    lines.append('fH = false')
    lines.append('fC = false')
    return SwiftInstructionFunction(ins, lines)

def handle_RES_commend(ins: Instruction):
    lines = []
    if ins.operand_2 == '(HL)':
        lines.append('var v = {}'.format(code_template['(HL)']))
        lines.append('v = resetBit(n: {}, val: v)'.format(ins.operand_1))
        lines.append('mb.setMem(address: hl, val: v)')
    else:
        lines.append('{} = resetBit(n: {}, val: {})'.format(code_template[ins.operand_2],code_template[ins.operand_2], ins.operand_1))
    return SwiftInstructionFunction(ins, lines)


def handle_BIT_commend(ins: Instruction):
    #
    lines = []
    if ins.operand_2 == '(HL)':
        lines.append('let v = {}'.format(code_template['(HL)']))
        lines.append('let r = v & (1 << {}) == 0x00'.format(ins.operand_1))
    else:
        lines.append('let r = {} & (1 << {}) == 0x00'.format(ins.operand_2.lower(), ins.operand_1))
    lines.append('fZ = r')
    lines.append('fN = false')
    lines.append('fH = true')
    return SwiftInstructionFunction(ins, lines)


def handle_RL_commend(ins: Instruction):
    lines = []

    if ins.operand_1 == '(HL)':
        lines.append('let v = {}'.format(code_template['(HL)']))
        lines.append('let carry = (v & 0x80) >> 7 == 0x01')
        lines.append('let r = (v << 1) | fC.integerValue')
        lines.append('mb.setMem(address: hl, val: r)')
    else:
        op1 = ins.operand_1.lower()
        lines.append('let carry = ({} & 0x80) >> 7 == 0x01'.format(op1))
        lines.append('let r = ({} << 1) | fC.integerValue'.format(op1))
        lines.append('{} = r'.format(op1))
    lines.append('fC = carry')
    lines.append('fN = false')
    lines.append('fH = false')
    lines.append('fZ = getZeroFlag(val: r)')
    return SwiftInstructionFunction(ins, lines)


def handle_RLC_commend(ins: Instruction):
    lines = []
    if ins.operand_1 == '(HL)':
        lines.append('let v = {}'.format(code_template['(HL)']))
        lines.append('let carry = (v & 0x80) >> 7 == 0x01')
        lines.append('let r = (v << 1) + carry.integerValue')
        lines.append('mb.setMem(address: hl, val: r)')
    else:
        op1 = ins.operand_1.lower()
        lines.append('let carry = ({} & 0x80) >> 7 == 0x01'.format(op1))
        lines.append('let r = ({} << 1) + carry.integerValue'.format(op1))
        lines.append('{} = r'.format(op1))
    lines.append('fC = carry')
    lines.append('fN = false')
    lines.append('fH = false')
    lines.append('fZ = getZeroFlag(val: r)')
    return SwiftInstructionFunction(ins, lines)


def handle_RR_commend(ins: Instruction):
    lines = []
    if ins.operand_1 == '(HL)':
        lines.append('let v = {}'.format(code_template['(HL)']))
        lines.append('let carry = v & 0x01 == 0x01')
        lines.append('let r = fC ? (0x80 | (a >> 1)) : (a >> 1)')
        lines.append('mb.setMem(address: hl, val: r)')
    else:
        op1 = ins.operand_1.lower()
        lines.append('let carry = {} & 0x01 == 0x01'.format(op1))
        lines.append('let r = fC ? (0x80 | ({} >> 1)) : ({} >> 1)'.format(op1, op1))
        lines.append('{} = r'.format(op1))
    lines.append('fC = carry')
    lines.append('fN = false')
    lines.append('fH = false')
    lines.append('fZ = getZeroFlag(val: r)')
    return SwiftInstructionFunction(ins, lines)


def handle_RRC_commend(ins: Instruction):
    lines = []
    if ins.operand_1 == '(HL)':
        lines.append('let v = {}'.format(code_template['(HL)']))
        lines.append('let carry = v & 0x01 == 0x01')
        lines.append('let r = carry ? (0x80 | (v >> 1)) : (v >> 1)')
        lines.append('mb.setMem(address: hl, val: r)')
    else:
        op1 = ins.operand_1.lower()
        lines.append('let carry = {} & 0x01 == 0x01'.format(op1))
        lines.append('let r = carry ? (0x80 | ({} >> 1)) : ({} >> 1)'.format(op1, op1))
        lines.append('{} = r'.format(op1))
    lines.append('fC = carry')
    lines.append('fN = false')
    lines.append('fH = false')
    lines.append('fZ = getZeroFlag(val: r)')
    return SwiftInstructionFunction(ins, lines)


def handle_SLA_commend(ins: Instruction):
    lines = []
    if ins.operand_1 == '(HL)':
        lines.append('let v = {}'.format(code_template['(HL)']))
        lines.append('let carry = (v & 0x80) >> 7 == 0x01')
        lines.append('let r = v << 1')
        lines.append('mb.setMem(address: hl, val: r)')
    else:
        op1 = ins.operand_1.lower()
        lines.append('let carry = ({} & 0x80) >> 7 == 0x01'.format(op1))
        lines.append('let r = {} << 1'.format(op1))
        lines.append('{} = r'.format(op1))
    lines.append('fC = carry')
    lines.append('fN = false')
    lines.append('fH = false')
    lines.append('fZ = getZeroFlag(val: r)')
    return SwiftInstructionFunction(ins, lines)


def handle_SRA_commend(ins: Instruction):
    lines = []
    if ins.operand_1 == '(HL)':
        lines.append('let v = {}'.format(code_template['(HL)']))
        lines.append('let carry = (v & 0x01) == 0x01')
        lines.append('let r = (v >> 1) | (v & 0x80)')
        lines.append('mb.setMem(address: hl, val: r)')
    else:
        op1 = ins.operand_1.lower()
        lines.append('let carry = ({} & 0x01) == 0x01'.format(op1))
        lines.append('let r = ({} >> 1) | ({} & 0x80)'.format(op1, op1))
        lines.append('{} = r'.format(op1))
    lines.append('fC = carry')
    lines.append('fN = false')
    lines.append('fH = false')
    lines.append('fZ = getZeroFlag(val: r)')
    return SwiftInstructionFunction(ins, lines)


def handle_SRL_commend(ins: Instruction):
    lines = []
    if ins.operand_1 == '(HL)':
        lines.append('let v = {}'.format(code_template['(HL)']))
        lines.append('let carry = (v & 0x01) == 0x01')
        lines.append('let r = v >> 1')
        lines.append('mb.setMem(address: hl, val: r)')
    else:
        op1 = ins.operand_1.lower()
        lines.append('let carry = ({} & 0x01) == 0x01'.format(op1))
        lines.append('let r = {} >> 1'.format(op1))
        lines.append('{} = r'.format(op1))
    lines.append('fC = carry')
    lines.append('fN = false')
    lines.append('fH = false')
    lines.append('fZ = getZeroFlag(val: r)')
    return SwiftInstructionFunction(ins, lines)


def get_cb_functions():
    ins_list = get_cb_instructions()
    function_list = []
    for each in ins_list:
        if each.command == 'BIT':
            f = handle_BIT_commend(each)
        elif each.command == 'SET':
            f = handle_SET_commend(each)
        elif each.command == 'RES':
            f = handle_RES_commend(each)
        elif each.command == 'SWAP':
            f = handle_SWAP_commend(each)
        elif each.command == 'RL':
            f = handle_RL_commend(each)
        elif each.command == 'RLC':
            f = handle_RLC_commend(each)
        elif each.command == 'RR':
            f = handle_RR_commend(each)
        elif each.command == 'RRC':
            f = handle_RRC_commend(each)
        elif each.command == 'SRA':
            f = handle_SRA_commend(each)
        elif each.command == 'SLA':
            f = handle_SLA_commend(each)
        elif each.command == 'SRL':
            f = handle_SRL_commend(each)
        else:
            raise Exception(each.command + 'not impl')
        function_list.append(f)
    return function_list


ins_list = [x for x in get_cb_instructions()]
for each in ins_list:
    print(SwiftInstructionFunction(each, []))