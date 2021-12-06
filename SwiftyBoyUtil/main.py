from typedef import *
from cb_instructions import get_cb_functions
from base_instructions import get_base_functions
from file_util import write_swift_cpu_file
from instruction_fetch import *

file = CPUExtensionSwiftFile('CPU+CBInstructions')
file.function_list = get_cb_functions()
write_swift_cpu_file(file)
file = CPUExtensionSwiftFile('CPU+BaseInstructions')
file.function_list = get_base_functions()
write_swift_cpu_file(file)

for each in get_base_instructions():
    i = each.opcode
    desc = each.desc
    opcode = each.opcode
    s = 'baseInstructions[{}] = CPUInstruction(name: "{}", opcode: {}, instruction: {}, byteLength: {})'.format(each.opcode_hex, desc, each.opcode_hex, each.method_name, each.byte_length)
    print(s)


for each in get_cb_instructions():
    i = each.opcode
    desc = each.desc
    opcode = each.opcode
    s = 'cbInstructions[{}] = CPUInstruction(name: "{}", opcode: {}, instruction: {}, byteLength: {})'.format(each.opcode_hex, desc, each.opcode_hex, each.method_name, each.byte_length)
    print(s)



