from bs4 import BeautifulSoup
from instruction import *

file = open("gameboy_opcodes.html")
soup = BeautifulSoup(file, features="html.parser")
tables = soup.find_all("table")


def _parse_instruction_set_from_html_table(table):
    tr_list = table.find_all('tr')[1:]
    instruction_set = []
    opcode = 0
    for each_tr in tr_list:
        td_list = each_tr.find_all('td')[1:]
        for each_td in td_list:
            arr = [x.replace('\xa0\xa0', ' ') for x in each_td.stripped_strings]
            if len(arr) == 3:
                ins = parseInstruction(opcode, arr)
                instruction_set.append(ins)
            else:
                pass
                # print("{} Empty".format(hex(opcode)))
            opcode += 1
    return instruction_set


def get_base_instructions() -> [Instruction]:
    table_base_instructions = tables[0]
    return _parse_instruction_set_from_html_table(table_base_instructions)


def get_cb_instructions() -> [Instruction]:
    table_base_instructions = tables[1]
    return _parse_instruction_set_from_html_table(table_base_instructions)
