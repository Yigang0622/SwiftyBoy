REG_8_BIT = {'A', 'B', 'C', 'D', 'E', 'H', 'L'}
REG_16_BIT = {'AF', 'BC', 'DE', 'HL', 'SP'}
IMMEDIATE = {'d8', 'd16', 'r8'}
ADDRESS_IMMEDIATE = {'a8', 'a16'}
ADDRESS_VALUE = {'(HL)', '(HL+)', '(HL-)', '(DE)', '(BC)', '(C)'}
ADDRESS_VALUE_IMMEDIATE = {'(a8)', '(a16)'}

code_template = {
    'A': 'a',
    'B': 'b',
    'C': 'c',
    'D': 'd',
    'E': 'e',
    'H': 'h',
    'L': 'l',
    'BC': 'bc',
    'DE': 'de',
    'HL': 'hl',
    'SP': 'sp',
    'd8': 'get8BitImmediate()',
    'd16': 'get16BitImmediate()',
    'r8': 'get8BitSignedImmediateValue()',
    'a8': 'mb.getMem(address: 0xFF00 + get8BitImmediate())',
    'a16': 'mb.getMem(address: get16BitImmediate())',
    '(HL)': 'mb.getMem(address: hl)'
}