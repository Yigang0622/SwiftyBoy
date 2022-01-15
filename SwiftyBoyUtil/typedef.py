class CPUExtensionSwiftFile:

    def __init__(self, name):
        self.name = '{}.swift'.format(name)
        self.function_list: [SwiftInstructionFunction] = []

    def __str__(self):
        lines = ['import Foundation',
                 '',
                 'extension CPU {',
                 '']

        for each in self.function_list:
            function_lines = ['     {}'.format(x) for x in str(each).split('\n')]
            lines.extend(function_lines)
            lines.append('')

        lines.append('}')
        return '\n'.join(lines)


class SwiftInstructionFunction:

    def __init__(self, ins, lines):
        self.ins = ins
        self.lines = lines
        self.pcInc = True
        self.returnEnable = '/' not in ins.cycle

    def __str__(self):
        opcode_hex = "0x{:02x}".format(self.ins.opcode)
        lines = ['// {} {}'.format(opcode_hex, self.ins.desc)]
        method_name = '{}_{}'.format(self.ins.command, opcode_hex.upper()[2:])
        lines.append('func ' + method_name + '() -> Int {')
        for each in self.lines:
            lines.append('      {}'.format(each))
        if self.pcInc:
            lines.append("      pc += {}".format(self.ins.byte_length))
        if self.returnEnable:
            lines.append('      return {}'.format(self.ins.cycle))
        else:
            lines.append('      //{}'.format(self.ins.cycle))
        lines.append('}')
        return '\n'.join(lines)

    def disablePCInc(self):
        self.pcInc = False

    def disableReturn(self):
        self.returnEnable = False
