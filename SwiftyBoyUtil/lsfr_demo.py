
bit_len = 15
state = 0
for i in range(bit_len):
    state += 1 << i

print(bin(state), state)

for i in range(2560):
    print(state & 1, end='')
    new_bit = (state ^ (state >> 1)) & 1
    state = (state >> 1) | (new_bit << (bit_len - 1))