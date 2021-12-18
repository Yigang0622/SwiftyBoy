from instruction_fetch import *
from constant import *
from typedef import *


def handle_LD_command(ins: Instruction):
    lines = []
    if ins.operand_1_is_address():
        if ins.opcode == 0x8:
            lines.append('let nn = get16BitImmediate()')
            lines.append('mb.setMem(address: nn, val: sp & 0xFF)')
            lines.append('mb.setMem(address: nn + 1, val: sp >> 8)')
        elif ins.opcode == 0xea:
            lines.append('let addr = get16BitImmediate()')
            lines.append('mb.setMem(address: addr, val: a)')
        else:
            param_1 = ins.operand_1.replace('(', '').replace(')', '').replace('+', '').replace('-', '').lower()
            if len(param_1) == 1:
                param_1 = '0xFF00 + {}'.format(param_1)
            if ins.operand_2 == 'd8':
                param_2 = 'get8BitImmediate()'
            else:
                param_2 = ins.operand_2.lower()

            lines.append('mb.setMem(address: {}, val: {})'.format(param_1, param_2))
    elif ins.operand_2_is_address():
        param_1 = ins.operand_1.replace('(', '').replace(')', '').replace('+', '').replace('-', '').lower()
        if ins.operand_2 == '(a16)':
            param_2 = 'get16BitImmediate()'
        else:
            param_2 = ins.operand_2.replace('(', '').replace(')', '').replace('+', '').replace('-', '').lower()
            if len(param_2) == 1:
                param_2 = '0xFF00 + {}'.format(param_2)
        lines.append('{} = mb.getMem(address: {})'.format(param_1, param_2))
    else:
        param_1 = ins.operand_1.lower()
        if ins.operand_2 == 'd16':
            param_2 = 'get16BitImmediate()'
        elif ins.operand_2 == 'd8':
            param_2 = 'get8BitImmediate()'
        elif ins.operand_2 == 'SP+r8':
            lines.append('let n = get8BitSignedImmediateValue()')
            param_2 = 'sp + n'
        else:
            param_2 = ins.operand_2.lower()
        lines.append('{} = {}'.format(param_1, param_2))
        if ins.operand_2 == 'SP+r8':
            lines.append('fZ = false')
            lines.append('fN = false')
            lines.append('fC = getFullCarryForAdd(operands: sp, n)')
            lines.append('fH = getHalfCarryForAdd(operands: sp, n)')
    if ins.operand_2 == '(HL+)' or ins.operand_1 == '(HL+)':
        lines.append('hl += 1')
    elif ins.operand_2 == '(HL-)' or ins.operand_1 == '(HL-)':
        lines.append('hl -= 1')

    return SwiftInstructionFunction(ins, lines)


def handle_ADD_commend(ins: Instruction):
    lines = []
    if ins.operand_2 == '(HL)':
        lines.append('let v = mb.getMem(address: hl)')
        lines.append('let r = {} + v'.format(ins.operand_1.lower()))
        operand2 = 'v'
    elif ins.operand_2 == 'd8' or ins.operand_2 == 'r8':
        lines.append('let v = {}'.format(code_template[ins.operand_2]))
        lines.append('let r = {} + v'.format(ins.operand_1.lower()))
        operand2 = 'v'
    else:
        lines.append('let r = {} + {}'.format(ins.operand_1.lower(), ins.operand_2.lower()))
        operand2 = ins.operand_2.lower()

    # ADD HL HL
    if ins.operand_1 == 'HL':
        lines.append('fN = false')
        lines.append('fH = getHalfCarryForAdd16Bit(operands: hl, {})'.format(operand2))
        lines.append('fC = getFullCarryForAdd16Bit(operands: hl, {})'.format(operand2))
    # ADD SP n8
    elif ins.operand_1 == 'SP':
        lines.append('fZ = false')
        lines.append('fN = false')
        lines.append('fH = getHalfCarryForAdd(operands: sp, {})'.format(operand2))
        lines.append('fC = getFullCarryForAdd(operands: sp, {})'.format(operand2))
    else:
        lines.append('fZ = getZeroFlag(val: r)')
        lines.append('fN = false')
        lines.append('fH = getHalfCarryForAdd(operands: a, {})'.format(operand2))
        lines.append('fC = getFullCarryForAdd(operands: a, {})'.format(operand2))
    lines.append('{} = r'.format(ins.operand_1.lower()))
    return SwiftInstructionFunction(ins, lines)


def handle_SUB_commend(ins: Instruction):
    lines = []
    assign = ''
    if ins.operand_1 == '(HL)':
        lines.append('let v = mb.getMem(address: hl)')
        lines.append('let r = a - v')
        assign = 'a = r'
        operand2 = 'v'
    elif ins.operand_1 == 'd8':
        lines.append('let v = {}'.format(code_template[ins.operand_1]))
        lines.append('let r = a - v')
        operand2 = 'v'
    else:
        lines.append('let r = a - {}'.format(ins.operand_1.lower()))
        operand2 = ins.operand_1.lower()

    lines.append('fZ = getZeroFlag(val: r)')
    lines.append('fN = true')
    lines.append('fH = getHalfCarryForSub(operands: a, {})'.format(operand2))
    lines.append('fC = getFullCarryForSub(operands: a, {})'.format(operand2))
    lines.append('a = r')
    return SwiftInstructionFunction(ins, lines)


def handle_PUSH_commend(ins: Instruction):
    lines = []
    sp_low = ins.operand_1[0].lower()
    sp_high = ins.operand_1[1].lower()
    lines.append('mb.setMem(address: sp - 1, val: {})'.format(sp_low))
    lines.append('mb.setMem(address: sp - 2, val: {})'.format(sp_high))
    lines.append('sp -= 2')
    return SwiftInstructionFunction(ins, lines)


def handle_POP_commend(ins: Instruction):
    lines = []
    low = ins.operand_1[0].lower()
    high = ins.operand_1[1].lower()
    lines.append('{} = mb.getMem(address: sp + 1)'.format(low))
    lines.append('{} = mb.getMem(address: sp)'.format(high))
    lines.append('sp += 2')
    return SwiftInstructionFunction(ins, lines)


def handle_INC_commend(ins: Instruction):
    lines = []
    if ins.operand_1 == '(HL)':
        lines.append('let v = mb.getMem(address: hl)')
        lines.append('let r = v + 1')
        lines.append('fZ = getZeroFlag(val: r)')
        lines.append('fN = false')
        lines.append('fH = getHalfCarryForAdd(operands: v, 1)')
        lines.append('mb.setMem(address: hl, val: r)')
    elif len(ins.operand_1) == 2: # BC SP ...
        reg = ins.operand_1.lower()
        lines.append('{} = {} + 1'.format(reg, reg))
    elif len(ins.operand_1) == 1:
        reg = ins.operand_1.lower()
        lines.append('let r = {} + 1'.format(reg))
        lines.append('fZ = getZeroFlag(val: r)')
        lines.append('fN = false')
        lines.append('fH = getHalfCarryForAdd(operands: {}, 1)'.format(reg))
        lines.append('{} = r'.format(reg))
    else:
        raise Exception("not impl inc commend")

    return SwiftInstructionFunction(ins, lines)


def handle_DEC_commend(ins: Instruction):
    lines = []
    if ins.operand_1 == '(HL)':
        lines.append('let v = mb.getMem(address: hl)')
        lines.append('let r = v - 1')
        lines.append('fZ = getZeroFlag(val: r)')
        lines.append('fN = true')
        lines.append('fH = getHalfCarryForSub(operands: v, 1)')
        lines.append('mb.setMem(address: hl, val: r)')
    elif len(ins.operand_1) == 2:
        reg = ins.operand_1.lower()
        lines.append('{} = {} - 1'.format(reg, reg))
    elif len(ins.operand_1) == 1:
        reg = ins.operand_1.lower()
        lines.append('let r = {} - 1'.format(reg))
        lines.append('fZ = getZeroFlag(val: r)')
        lines.append('fN = true')
        lines.append('fH = getHalfCarryForSub(operands: {}, 1)'.format(reg))
        lines.append('{} = r'.format(reg))
    else:
        raise Exception("not impl dec commend")

    return SwiftInstructionFunction(ins, lines)


def handle_ADC_commend(ins: Instruction):
    lines = []
    op1 = ins.operand_1.lower()
    if ins.operand_2 == '(HL)':
        op2 = 'v'
        lines.append('let v = {}'.format(code_template['(HL)']))
    elif ins.operand_2 == 'd8':
        op2 = 'v'
        lines.append('let v = {}'.format(code_template['d8']))
    elif len(ins.operand_2) == 1:
        op2 = ins.operand_2.lower()
    else:
        raise Exception("not impl adc commend")
    lines.append('let r = {} + {} + fC.integerValue'.format(op1, op2))
    lines.append('fZ = getZeroFlag(val: r)')
    lines.append('fN = false')
    lines.append('fH = getHalfCarryForAdd(operands: {}, {}, fC.integerValue)'.format(op1, op2))
    lines.append('fC = getFullCarryForAdd(operands: {}, {}, fC.integerValue)'.format(op1, op2))
    lines.append('{} = r'.format(op1))
    return SwiftInstructionFunction(ins, lines)


def handle_SBC_commend(ins: Instruction):
    lines = []
    op1 = ins.operand_1.lower()
    if ins.operand_2 == '(HL)':
        op2 = 'v'
        lines.append('let v = {}'.format(code_template['(HL)']))
    elif ins.operand_2 == 'd8':
        op2 = 'v'
        lines.append('let v = {}'.format(code_template['d8']))
    elif len(ins.operand_2) == 1:
        op2 = ins.operand_2.lower()
    else:
        raise Exception("not impl sbc commend")
    lines.append('let r = {} - {} - fC.integerValue'.format(op1, op2))
    lines.append('{} = r'.format(op1))
    lines.append('fZ = getZeroFlag(val: r)')
    lines.append('fN = true')
    lines.append('fH = getHalfCarryForSub(operands: {}, {}, fC.integerValue)'.format(op1, op2))
    lines.append('fC = getFullCarryForSub(operands: {}, {}, fC.integerValue)'.format(op1, op2))
    return SwiftInstructionFunction(ins, lines)


def handle_CP_commend(ins: Instruction):
    lines = []
    if ins.operand_1 == '(HL)':
        lines.append('let v = mb.getMem(address: hl)')
        lines.append('let r = a - v')
        operand2 = 'v'
    elif ins.operand_1 == 'd8':
        lines.append('let v = {}'.format(code_template[ins.operand_1]))
        lines.append('let r = a - v')
        operand2 = 'v'
    else:
        lines.append('let r = a - {}'.format(ins.operand_1.lower()))
        operand2 = ins.operand_1.lower()

    lines.append('fZ = getZeroFlag(val: r)')
    lines.append('fN = true')
    lines.append('fH = getHalfCarryForSub(operands: a, {})'.format(operand2))
    lines.append('fC = getFullCarryForSub(operands: a, {})'.format(operand2))
    return SwiftInstructionFunction(ins, lines)


def handle_AND_commend(ins: Instruction):
    lines = ['let r = a & {}'.format(code_template[ins.operand_1]),
             'a = r',
             'fZ = getZeroFlag(val: r)',
             'fN = false',
             'fH = true',
             'fC = false']
    return SwiftInstructionFunction(ins, lines)


def handle_OR_commend(ins: Instruction):
    lines = ['let r = a | {}'.format(code_template[ins.operand_1]),
             'a = r',
             'fZ = getZeroFlag(val: r)',
             'fN = false',
             'fH = false',
             'fC = false']
    return SwiftInstructionFunction(ins, lines)


def handle_XOR_commend(ins: Instruction):
    lines = ['let r = a ^ {}'.format(code_template[ins.operand_1]),
             'a = r',
             'fZ = getZeroFlag(val: r)',
             'fN = false',
             'fH = false',
             'fC = false']
    return SwiftInstructionFunction(ins, lines)


def handle_CPL_commend(ins: Instruction):
    lines = [
        'a = ~a',
        'fN = true',
        'fH = true'
    ]
    return SwiftInstructionFunction(ins, lines)


def handle_CCF_commend(ins: Instruction):
    lines = [
        'fN = false',
        'fH = false',
        'fC = !fC'
    ]
    return SwiftInstructionFunction(ins, lines)


def handle_SCF_commend(ins: Instruction):
    lines = [
        'fN = false',
        'fH = false',
        'fC = true'
    ]
    return SwiftInstructionFunction(ins, lines)


def handle_RST_commend(ins: Instruction):
    lines = [
        'pc += 1',
        'pushPCToStack()',
        'pc = 0x{}'.format(ins.operand_1[:-1])
    ]
    f = SwiftInstructionFunction(ins, lines)
    f.disablePCInc()
    return f


def handle_CALL_commend(ins: Instruction):
    lines = []
    lines.append('let v = get16BitImmediate()')
    lines.append('pc += {}'.format(ins.byte_length))

    cycle_true = ins.cycle.split("/")[0]
    cycle_false = ins.cycle.split("/")[1] if len(ins.cycle.split("/")) == 2 else 0
    hasCondition = ins.operand_2 is not None
    if hasCondition:
        d = {'Z': 'fZ', 'NZ': '!fZ', 'C': 'fC', 'NC': '!fC'}
        lines.append('if ' + d[ins.operand_1] + ' {')
        lines.append('      pushPCToStack()')
        lines.append('      pc = v')
        lines.append('      return {}'.format(cycle_true))
        lines.append('} else {')
        lines.append('      return {}'.format(cycle_false))
        lines.append('}')
    else:
        lines.append('pushPCToStack()')
        lines.append('pc = v')
    f = SwiftInstructionFunction(ins, lines)
    f.disablePCInc()
    return f


def handle_PREFIX_commend(ins: Instruction):
    return SwiftInstructionFunction(ins, [])


def handle_NOP_commend(ins: Instruction):
    return SwiftInstructionFunction(ins, [])


def handle_HALT_commend(ins: Instruction):
    lines = []
    lines.append('halted = true')
    f = SwiftInstructionFunction(ins, lines)
    f.disablePCInc()
    return f


def handle_EI_commend(ins: Instruction):
    lines = ['interruptMasterEnable = true']
    return SwiftInstructionFunction(ins, lines)


def handle_DI_commend(ins: Instruction):
    lines = ['interruptMasterEnable = false']
    return SwiftInstructionFunction(ins, lines)


def handle_RET_commend(ins: Instruction):
    lines = []
    cycle_true = ins.cycle.split("/")[0]
    cycle_false = ins.cycle.split("/")[1] if len(ins.cycle.split("/")) == 2 else 0
    hasCondition = ins.operand_1 is not None
    if hasCondition:
        d = {'Z': 'fZ', 'NZ': '!fZ', 'C': 'fC', 'NC': '!fC'}
        lines.append('if ' + d[ins.operand_1] + ' {')
        lines.append('      popPCFromStack()')
        lines.append('      return {}'.format(cycle_true))
        lines.append('} else {')
        lines.append('      pc += {}'.format(ins.byte_length))
        lines.append('      return {}'.format(cycle_false))
        lines.append('}')
    else:
        lines.append('popPCFromStack()')
    f = SwiftInstructionFunction(ins, lines)
    f.disablePCInc()
    return f


def handle_RETI_commend(ins: Instruction):
    lines = [
        'interruptMasterEnable = true',
        'popPCFromStack()'
    ]
    f = SwiftInstructionFunction(ins, lines)
    f.disablePCInc()
    return f


def handle_STOP_commend(ins: Instruction):
    lines = [
        'halted = true',
        'print("CPU stop")'
    ]
    return SwiftInstructionFunction(ins, lines)


def handle_RRA_commend(ins: Instruction):
    lines = [
        'let c = a & 0x01 == 0x01',
        'let r = (a >> 1) | (fC ? 0x80: 0)',
        'fZ = false',
        'fN = false',
        'fH = false',
        'fC = c',
        'a = r'
    ]
    return SwiftInstructionFunction(ins, lines)


def handle_RRCA_commend(ins: Instruction):
    lines = [
        'let c = a & 0x01 == 0x01',
        'let r = (a >> 1) | (c ? 0x80: 0)',
        'fZ = false',
        'fN = false',
        'fH = false',
        'fC = c',
        'a = r'
    ]
    return SwiftInstructionFunction(ins, lines)


def handle_RLA_commend(ins: Instruction):
    lines = [
        'let c = (a & 0x80) >> 7 == 0x01',
        'let r = (a << 1) | (fC ? 0x1: 0)',
        'fZ = false',
        'fN = false',
        'fH = false',
        'fC = c',
        'a = r'
    ]
    return SwiftInstructionFunction(ins, lines)


def handle_RLCA_commend(ins: Instruction):
    lines = [
        'let c = (a & 0x80) >> 7 == 0x01',
        'let r = (a << 1) | (c ? 0x1: 0)',
        'fZ = false',
        'fN = false',
        'fH = false',
        'fC = c',
        'a = r'
    ]
    return SwiftInstructionFunction(ins, lines)


def handle_JR_commend(ins: Instruction):
    lines = []
    lines.append('let v = {}'.format(code_template['r8']))
    lines.append('pc += {}'.format(ins.byte_length))

    cycle_true = ins.cycle.split("/")[0]
    cycle_false = ins.cycle.split("/")[1] if len(ins.cycle.split("/")) == 2 else 0
    hasCondition = ins.operand_2 is not None
    if hasCondition:
        d = {'Z': 'fZ', 'NZ': '!fZ', 'C': 'fC', 'NC': '!fC'}
        lines.append('if ' + d[ins.operand_1] + ' {')
        lines.append('      pc += v')
        lines.append('      return {}'.format(cycle_true))
        lines.append('} else {')
        lines.append('      return {}'.format(cycle_false))
        lines.append('}')
    else:
        lines.append('pc += v')
    f = SwiftInstructionFunction(ins, lines)
    f.disablePCInc()
    return f


def handle_JP_commend(ins: Instruction):
    lines = []
    if ins.operand_1 == 'a16' or ins.operand_2 == 'a16':
        lines.append('let v = get16BitImmediate()')
    elif ins.operand_1 == '(HL)':
        lines.append('let v = mb.getMem(address: hl)')
    else:
        lines.append('let v = {}'.format(code_template[ins.operand_2]))

    cycle_true = ins.cycle.split("/")[0]
    cycle_false = ins.cycle.split("/")[1] if len(ins.cycle.split("/")) == 2 else 0
    hasCondition = ins.operand_2 is not None
    if hasCondition:
        d = {'Z': 'fZ', 'NZ': '!fZ', 'C': 'fC', 'NC': '!fC'}
        lines.append('if ' + d[ins.operand_1] + ' {')
        lines.append('      pc = v')
        lines.append('      return {}'.format(cycle_true))
        lines.append('} else {')
        lines.append('      pc += {}'.format(ins.byte_length))
        lines.append('      return {}'.format(cycle_false))
        lines.append('}')
    else:
        lines.append('pc = v')
    f = SwiftInstructionFunction(ins, lines)
    f.disablePCInc()
    return f


def handle_LDH_commend(ins: Instruction):
    lines = ['let v = get8BitImmediate()']
    if ins.opcode == 0xe0:
        lines.append('mb.setMem(address: 0xFF00 + v, val: a)')
    elif ins.opcode == 0xf0:
        lines.append('a = mb.getMem(address:  0xFF00 + v)')
    else:
        raise Exception('commend LDH not impl')
    return SwiftInstructionFunction(ins, lines)


def handle_DAA_commend(ins: Instruction):
    code = '''
var result = a
if fN {
    if fH {
        result = (result - 6) & 0xFF
    }
    if fC {
        result = (result - 0x60) & 0xFF
    }
} else {
    if fH || (result & 0xF) > 9 {
        result += 0x06
    }
    if fC || result > 0x9F {
        result += 0x60
    }
}
fH = false
if result > 0xFF {
    fC = true
}
result &= 0xFF
fZ = result == 0
a = result
    '''
    lines = code.split('\n')[1:-1]
    return SwiftInstructionFunction(ins, lines)


def get_base_functions():
    ins_list = get_base_instructions()
    # ins_list = [x for x in ins_list if x.command == 'JP']
    function_list = []

    for each in ins_list:
        if each.command == 'LD':
            f = handle_LD_command(each)
        elif each.command == 'ADD':
            f = handle_ADD_commend(each)
        elif each.command == 'PUSH':
            f = handle_PUSH_commend(each)
        elif each.command == 'POP':
            f = handle_POP_commend(each)
        elif each.command == 'INC':
            f = handle_INC_commend(each)
        elif each.command == 'DEC':
            f = handle_DEC_commend(each)
        elif each.command == 'ADC':
            f = handle_ADC_commend(each)
        elif each.command == 'SBC':
            f = handle_SBC_commend(each)
        elif each.command == 'CP':
            f = handle_CP_commend(each)
        elif each.command == 'OR':
            f = handle_OR_commend(each)
        elif each.command == 'AND':
            f = handle_AND_commend(each)
        elif each.command == 'XOR':
            f = handle_XOR_commend(each)
        elif each.command == 'CCF':
            f = handle_CCF_commend(each)
        elif each.command == 'SCF':
            f = handle_SCF_commend(each)
        elif each.command == 'RST':
            f = handle_RST_commend(each)
        elif each.command == 'CALL':
            f = handle_CALL_commend(each)
        elif each.command == 'PREFIX':
            f = handle_PREFIX_commend(each)
        elif each.command == 'NOP':
            f = handle_NOP_commend(each)
        elif each.command == 'DI':
            f = handle_DI_commend(each)
        elif each.command == 'EI':
            f = handle_EI_commend(each)
        elif each.command == 'RET':
            f = handle_RET_commend(each)
        elif each.command == 'RETI':
            f = handle_RETI_commend(each)
        elif each.command == 'STOP':
            f = handle_STOP_commend(each)
        elif each.command == 'RRA':
            f = handle_RRA_commend(each)
        elif each.command == 'RRCA':
            f = handle_RRCA_commend(each)
        elif each.command == 'RLA':
            f = handle_RLA_commend(each)
        elif each.command == 'RLCA':
            f = handle_RLCA_commend(each)
        elif each.command == 'JR':
            f = handle_JR_commend(each)
        elif each.command == 'JP':
            f = handle_JP_commend(each)
        elif each.command == 'LDH':
            f = handle_LDH_commend(each)
        elif each.command == 'DAA':
            f = handle_DAA_commend(each)
        elif each.command == 'CPL':
            f = handle_CPL_commend(each)
        elif each.command == 'HALT':
            f = handle_HALT_commend(each)
        elif each.command == 'SUB':
            f = handle_SUB_commend(each)
        else:
            raise Exception(each.command + 'not impl')
        function_list.append(f)
    return function_list

#
# ins_list = [x for x in get_base_instructions() if x.command == 'LD']
# for each in ins_list:
#     # print(each)
#     f = handle_LD_command(each)
#     print(f)
#     print()