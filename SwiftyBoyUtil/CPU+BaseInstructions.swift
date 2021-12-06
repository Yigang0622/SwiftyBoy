import Foundation

extension CPU {

     // 0x00 NOP
     func NOP_00() -> Int {
           pc += 1
           return 4
     }

     // 0x01 LD BC,d16
     func LD_01() -> Int {
           bc = get16BitImmediate()
           pc += 3
           return 12
     }

     // 0x02 LD (BC),A
     func LD_02() -> Int {
           mb.setMem(address: bc, val: a)
           pc += 1
           return 8
     }

     // 0x03 INC BC
     func INC_03() -> Int {
           bc = bc + 1
           pc += 1
           return 8
     }

     // 0x04 INC B
     func INC_04() -> Int {
           let r = b + 1
           b = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = getHalfCarryForAdd(operands: b, 1)
           pc += 1
           return 4
     }

     // 0x05 DEC B
     func DEC_05() -> Int {
           let r = b - 1
           b = r
           fZ = getZeroFlag(val: r)
           fN = true
           fH = getHalfCarryForSub(operands: b, 1)
           pc += 1
           return 4
     }

     // 0x06 LD B,d8
     func LD_06() -> Int {
           b = get8BitImmediate()
           pc += 2
           return 8
     }

     // 0x07 RLCA
     func RLCA_07() -> Int {
           let c = (a & 0x80) >> 7 == 0x01
           let r = (a << 1) | (c ? 0x1: 0)
           fZ = getZeroFlag(val: r)
           fN = false
           fH = false
           fC = c
           a = r
           pc += 1
           return 4
     }

     // 0x08 LD (a16),SP
     func LD_08() -> Int {
           let nn = get16BitImmediate()
           mb.setMem(address: nn, val: sp & 0xFF)
           mb.setMem(address: nn + 1, val: sp >> 8)
           pc += 3
           return 20
     }

     // 0x09 ADD HL,BC
     func ADD_09() -> Int {
           let r = hl + bc
           hl = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = getHalfCarryForAdd(operands: a, bc)
           fC = getFullCarryForAdd(operands: a, bc)
           pc += 1
           return 8
     }

     // 0x0a LD A,(BC)
     func LD_0A() -> Int {
           a = mb.getMem(address: bc)
           pc += 1
           return 8
     }

     // 0x0b DEC BC
     func DEC_0B() -> Int {
           bc = bc - 1
           pc += 1
           return 8
     }

     // 0x0c INC C
     func INC_0C() -> Int {
           let r = c + 1
           c = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = getHalfCarryForAdd(operands: c, 1)
           pc += 1
           return 4
     }

     // 0x0d DEC C
     func DEC_0D() -> Int {
           let r = c - 1
           c = r
           fZ = getZeroFlag(val: r)
           fN = true
           fH = getHalfCarryForSub(operands: c, 1)
           pc += 1
           return 4
     }

     // 0x0e LD C,d8
     func LD_0E() -> Int {
           c = get8BitImmediate()
           pc += 2
           return 8
     }

     // 0x0f RRCA
     func RRCA_0F() -> Int {
           let c = a & 0x01 == 0x01
           let r = (a >> 1) | (c ? 0x80: 0)
           fZ = getZeroFlag(val: r)
           fN = false
           fH = false
           fC = c
           a = r
           pc += 1
           return 4
     }

     // 0x10 STOP 0
     func STOP_10() -> Int {
           halted = true
           print("CPU stop")
           pc += 2
           return 4
     }

     // 0x11 LD DE,d16
     func LD_11() -> Int {
           de = get16BitImmediate()
           pc += 3
           return 12
     }

     // 0x12 LD (DE),A
     func LD_12() -> Int {
           mb.setMem(address: de, val: a)
           pc += 1
           return 8
     }

     // 0x13 INC DE
     func INC_13() -> Int {
           de = de + 1
           pc += 1
           return 8
     }

     // 0x14 INC D
     func INC_14() -> Int {
           let r = d + 1
           d = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = getHalfCarryForAdd(operands: d, 1)
           pc += 1
           return 4
     }

     // 0x15 DEC D
     func DEC_15() -> Int {
           let r = d - 1
           d = r
           fZ = getZeroFlag(val: r)
           fN = true
           fH = getHalfCarryForSub(operands: d, 1)
           pc += 1
           return 4
     }

     // 0x16 LD D,d8
     func LD_16() -> Int {
           d = get8BitImmediate()
           pc += 2
           return 8
     }

     // 0x17 RLA
     func RLA_17() -> Int {
           let c = (a & 0x80) >> 7 == 0x01
           let r = (a << 1) | (fC ? 0x1: 0)
           fZ = getZeroFlag(val: r)
           fN = false
           fH = false
           fC = c
           a = r
           pc += 1
           return 4
     }

     // 0x18 JR r8
     func JR_18() -> Int {
           let v = get8BitSignedImmediateValue()
           pc += 2
           pc += v
           return 12
     }

     // 0x19 ADD HL,DE
     func ADD_19() -> Int {
           let r = hl + de
           hl = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = getHalfCarryForAdd(operands: a, de)
           fC = getFullCarryForAdd(operands: a, de)
           pc += 1
           return 8
     }

     // 0x1a LD A,(DE)
     func LD_1A() -> Int {
           a = mb.getMem(address: de)
           pc += 1
           return 8
     }

     // 0x1b DEC DE
     func DEC_1B() -> Int {
           de = de - 1
           pc += 1
           return 8
     }

     // 0x1c INC E
     func INC_1C() -> Int {
           let r = e + 1
           e = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = getHalfCarryForAdd(operands: e, 1)
           pc += 1
           return 4
     }

     // 0x1d DEC E
     func DEC_1D() -> Int {
           let r = e - 1
           e = r
           fZ = getZeroFlag(val: r)
           fN = true
           fH = getHalfCarryForSub(operands: e, 1)
           pc += 1
           return 4
     }

     // 0x1e LD E,d8
     func LD_1E() -> Int {
           e = get8BitImmediate()
           pc += 2
           return 8
     }

     // 0x1f RRA
     func RRA_1F() -> Int {
           let c = a & 0x01 == 0x01
           let r = (a >> 1) | (fC ? 0x80: 0)
           fZ = getZeroFlag(val: r)
           fN = false
           fH = false
           fC = c
           a = r
           pc += 1
           return 4
     }

     // 0x20 JR NZ,r8
     func JR_20() -> Int {
           let v = get8BitSignedImmediateValue()
           pc += 2
           if !fZ {
                 pc += v
                 return 12
           } else {
                 return 8
           }
     }

     // 0x21 LD HL,d16
     func LD_21() -> Int {
           hl = get16BitImmediate()
           pc += 3
           return 12
     }

     // 0x22 LD (HL+),A
     func LD_22() -> Int {
           mb.setMem(address: hl, val: a)
           hl += 1
           pc += 1
           return 8
     }

     // 0x23 INC HL
     func INC_23() -> Int {
           hl = hl + 1
           pc += 1
           return 8
     }

     // 0x24 INC H
     func INC_24() -> Int {
           let r = h + 1
           h = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = getHalfCarryForAdd(operands: h, 1)
           pc += 1
           return 4
     }

     // 0x25 DEC H
     func DEC_25() -> Int {
           let r = h - 1
           h = r
           fZ = getZeroFlag(val: r)
           fN = true
           fH = getHalfCarryForSub(operands: h, 1)
           pc += 1
           return 4
     }

     // 0x26 LD H,d8
     func LD_26() -> Int {
           h = get8BitImmediate()
           pc += 2
           return 8
     }

     // 0x27 DAA
     func DAA_27() -> Int {
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
           pc += 1
           return 4
     }

     // 0x28 JR Z,r8
     func JR_28() -> Int {
           let v = get8BitSignedImmediateValue()
           pc += 2
           if fZ {
                 pc += v
                 return 12
           } else {
                 return 8
           }
     }

     // 0x29 ADD HL,HL
     func ADD_29() -> Int {
           let r = hl + hl
           hl = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = getHalfCarryForAdd(operands: a, hl)
           fC = getFullCarryForAdd(operands: a, hl)
           pc += 1
           return 8
     }

     // 0x2a LD A,(HL+)
     func LD_2A() -> Int {
           a = mb.getMem(address: hl)
           hl += 1
           pc += 1
           return 8
     }

     // 0x2b DEC HL
     func DEC_2B() -> Int {
           hl = hl - 1
           pc += 1
           return 8
     }

     // 0x2c INC L
     func INC_2C() -> Int {
           let r = l + 1
           l = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = getHalfCarryForAdd(operands: l, 1)
           pc += 1
           return 4
     }

     // 0x2d DEC L
     func DEC_2D() -> Int {
           let r = l - 1
           l = r
           fZ = getZeroFlag(val: r)
           fN = true
           fH = getHalfCarryForSub(operands: l, 1)
           pc += 1
           return 4
     }

     // 0x2e LD L,d8
     func LD_2E() -> Int {
           l = get8BitImmediate()
           pc += 2
           return 8
     }

     // 0x2f CPL
     func CPL_2F() -> Int {
           a = ~a
           fN = true
           fH = true
           pc += 1
           return 4
     }

     // 0x30 JR NC,r8
     func JR_30() -> Int {
           let v = get8BitSignedImmediateValue()
           pc += 2
           if !fC {
                 pc += v
                 return 12
           } else {
                 return 8
           }
     }

     // 0x31 LD SP,d16
     func LD_31() -> Int {
           sp = get16BitImmediate()
           pc += 3
           return 12
     }

     // 0x32 LD (HL-),A
     func LD_32() -> Int {
           mb.setMem(address: hl, val: a)
           hl -= 1
           pc += 1
           return 8
     }

     // 0x33 INC SP
     func INC_33() -> Int {
           sp = sp + 1
           pc += 1
           return 8
     }

     // 0x34 INC (HL)
     func INC_34() -> Int {
           let v = mb.getMem(address: hl)
           let r = v + 1
           mb.setMem(address: hl, val: r)
           fZ = getZeroFlag(val: r)
           fN = false
           fH = getHalfCarryForAdd(operands: v, 1)
           pc += 1
           return 12
     }

     // 0x35 DEC (HL)
     func DEC_35() -> Int {
           let v = mb.getMem(address: hl)
           let r = v - 1
           mb.setMem(address: hl, val: r)
           fZ = getZeroFlag(val: r)
           fN = true
           fH = getHalfCarryForSub(operands: v, 1)
           pc += 1
           return 12
     }

     // 0x36 LD (HL),d8
     func LD_36() -> Int {
           mb.setMem(address: hl, val: get8BitImmediate())
           pc += 2
           return 12
     }

     // 0x37 SCF
     func SCF_37() -> Int {
           fN = false
           fH = false
           fC = true
           pc += 1
           return 4
     }

     // 0x38 JR C,r8
     func JR_38() -> Int {
           let v = get8BitSignedImmediateValue()
           pc += 2
           if fC {
                 pc += v
                 return 12
           } else {
                 return 8
           }
     }

     // 0x39 ADD HL,SP
     func ADD_39() -> Int {
           let r = hl + sp
           hl = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = getHalfCarryForAdd(operands: a, sp)
           fC = getFullCarryForAdd(operands: a, sp)
           pc += 1
           return 8
     }

     // 0x3a LD A,(HL-)
     func LD_3A() -> Int {
           a = mb.getMem(address: hl)
           hl -= 1
           pc += 1
           return 8
     }

     // 0x3b DEC SP
     func DEC_3B() -> Int {
           sp = sp - 1
           pc += 1
           return 8
     }

     // 0x3c INC A
     func INC_3C() -> Int {
           let r = a + 1
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = getHalfCarryForAdd(operands: a, 1)
           pc += 1
           return 4
     }

     // 0x3d DEC A
     func DEC_3D() -> Int {
           let r = a - 1
           a = r
           fZ = getZeroFlag(val: r)
           fN = true
           fH = getHalfCarryForSub(operands: a, 1)
           pc += 1
           return 4
     }

     // 0x3e LD A,d8
     func LD_3E() -> Int {
           a = get8BitImmediate()
           pc += 2
           return 8
     }

     // 0x3f CCF
     func CCF_3F() -> Int {
           fN = false
           fH = false
           fC = !fC
           pc += 1
           return 4
     }

     // 0x40 LD B,B
     func LD_40() -> Int {
           b = b
           pc += 1
           return 4
     }

     // 0x41 LD B,C
     func LD_41() -> Int {
           b = c
           pc += 1
           return 4
     }

     // 0x42 LD B,D
     func LD_42() -> Int {
           b = d
           pc += 1
           return 4
     }

     // 0x43 LD B,E
     func LD_43() -> Int {
           b = e
           pc += 1
           return 4
     }

     // 0x44 LD B,H
     func LD_44() -> Int {
           b = h
           pc += 1
           return 4
     }

     // 0x45 LD B,L
     func LD_45() -> Int {
           b = l
           pc += 1
           return 4
     }

     // 0x46 LD B,(HL)
     func LD_46() -> Int {
           b = mb.getMem(address: hl)
           pc += 1
           return 8
     }

     // 0x47 LD B,A
     func LD_47() -> Int {
           b = a
           pc += 1
           return 4
     }

     // 0x48 LD C,B
     func LD_48() -> Int {
           c = b
           pc += 1
           return 4
     }

     // 0x49 LD C,C
     func LD_49() -> Int {
           c = c
           pc += 1
           return 4
     }

     // 0x4a LD C,D
     func LD_4A() -> Int {
           c = d
           pc += 1
           return 4
     }

     // 0x4b LD C,E
     func LD_4B() -> Int {
           c = e
           pc += 1
           return 4
     }

     // 0x4c LD C,H
     func LD_4C() -> Int {
           c = h
           pc += 1
           return 4
     }

     // 0x4d LD C,L
     func LD_4D() -> Int {
           c = l
           pc += 1
           return 4
     }

     // 0x4e LD C,(HL)
     func LD_4E() -> Int {
           c = mb.getMem(address: hl)
           pc += 1
           return 8
     }

     // 0x4f LD C,A
     func LD_4F() -> Int {
           c = a
           pc += 1
           return 4
     }

     // 0x50 LD D,B
     func LD_50() -> Int {
           d = b
           pc += 1
           return 4
     }

     // 0x51 LD D,C
     func LD_51() -> Int {
           d = c
           pc += 1
           return 4
     }

     // 0x52 LD D,D
     func LD_52() -> Int {
           d = d
           pc += 1
           return 4
     }

     // 0x53 LD D,E
     func LD_53() -> Int {
           d = e
           pc += 1
           return 4
     }

     // 0x54 LD D,H
     func LD_54() -> Int {
           d = h
           pc += 1
           return 4
     }

     // 0x55 LD D,L
     func LD_55() -> Int {
           d = l
           pc += 1
           return 4
     }

     // 0x56 LD D,(HL)
     func LD_56() -> Int {
           d = mb.getMem(address: hl)
           pc += 1
           return 8
     }

     // 0x57 LD D,A
     func LD_57() -> Int {
           d = a
           pc += 1
           return 4
     }

     // 0x58 LD E,B
     func LD_58() -> Int {
           e = b
           pc += 1
           return 4
     }

     // 0x59 LD E,C
     func LD_59() -> Int {
           e = c
           pc += 1
           return 4
     }

     // 0x5a LD E,D
     func LD_5A() -> Int {
           e = d
           pc += 1
           return 4
     }

     // 0x5b LD E,E
     func LD_5B() -> Int {
           e = e
           pc += 1
           return 4
     }

     // 0x5c LD E,H
     func LD_5C() -> Int {
           e = h
           pc += 1
           return 4
     }

     // 0x5d LD E,L
     func LD_5D() -> Int {
           e = l
           pc += 1
           return 4
     }

     // 0x5e LD E,(HL)
     func LD_5E() -> Int {
           e = mb.getMem(address: hl)
           pc += 1
           return 8
     }

     // 0x5f LD E,A
     func LD_5F() -> Int {
           e = a
           pc += 1
           return 4
     }

     // 0x60 LD H,B
     func LD_60() -> Int {
           h = b
           pc += 1
           return 4
     }

     // 0x61 LD H,C
     func LD_61() -> Int {
           h = c
           pc += 1
           return 4
     }

     // 0x62 LD H,D
     func LD_62() -> Int {
           h = d
           pc += 1
           return 4
     }

     // 0x63 LD H,E
     func LD_63() -> Int {
           h = e
           pc += 1
           return 4
     }

     // 0x64 LD H,H
     func LD_64() -> Int {
           h = h
           pc += 1
           return 4
     }

     // 0x65 LD H,L
     func LD_65() -> Int {
           h = l
           pc += 1
           return 4
     }

     // 0x66 LD H,(HL)
     func LD_66() -> Int {
           h = mb.getMem(address: hl)
           pc += 1
           return 8
     }

     // 0x67 LD H,A
     func LD_67() -> Int {
           h = a
           pc += 1
           return 4
     }

     // 0x68 LD L,B
     func LD_68() -> Int {
           l = b
           pc += 1
           return 4
     }

     // 0x69 LD L,C
     func LD_69() -> Int {
           l = c
           pc += 1
           return 4
     }

     // 0x6a LD L,D
     func LD_6A() -> Int {
           l = d
           pc += 1
           return 4
     }

     // 0x6b LD L,E
     func LD_6B() -> Int {
           l = e
           pc += 1
           return 4
     }

     // 0x6c LD L,H
     func LD_6C() -> Int {
           l = h
           pc += 1
           return 4
     }

     // 0x6d LD L,L
     func LD_6D() -> Int {
           l = l
           pc += 1
           return 4
     }

     // 0x6e LD L,(HL)
     func LD_6E() -> Int {
           l = mb.getMem(address: hl)
           pc += 1
           return 8
     }

     // 0x6f LD L,A
     func LD_6F() -> Int {
           l = a
           pc += 1
           return 4
     }

     // 0x70 LD (HL),B
     func LD_70() -> Int {
           mb.setMem(address: hl, val: b)
           pc += 1
           return 8
     }

     // 0x71 LD (HL),C
     func LD_71() -> Int {
           mb.setMem(address: hl, val: c)
           pc += 1
           return 8
     }

     // 0x72 LD (HL),D
     func LD_72() -> Int {
           mb.setMem(address: hl, val: d)
           pc += 1
           return 8
     }

     // 0x73 LD (HL),E
     func LD_73() -> Int {
           mb.setMem(address: hl, val: e)
           pc += 1
           return 8
     }

     // 0x74 LD (HL),H
     func LD_74() -> Int {
           mb.setMem(address: hl, val: h)
           pc += 1
           return 8
     }

     // 0x75 LD (HL),L
     func LD_75() -> Int {
           mb.setMem(address: hl, val: l)
           pc += 1
           return 8
     }

     // 0x76 HALT
     func HALT_76() -> Int {
           halted = true
           return 4
     }

     // 0x77 LD (HL),A
     func LD_77() -> Int {
           mb.setMem(address: hl, val: a)
           pc += 1
           return 8
     }

     // 0x78 LD A,B
     func LD_78() -> Int {
           a = b
           pc += 1
           return 4
     }

     // 0x79 LD A,C
     func LD_79() -> Int {
           a = c
           pc += 1
           return 4
     }

     // 0x7a LD A,D
     func LD_7A() -> Int {
           a = d
           pc += 1
           return 4
     }

     // 0x7b LD A,E
     func LD_7B() -> Int {
           a = e
           pc += 1
           return 4
     }

     // 0x7c LD A,H
     func LD_7C() -> Int {
           a = h
           pc += 1
           return 4
     }

     // 0x7d LD A,L
     func LD_7D() -> Int {
           a = l
           pc += 1
           return 4
     }

     // 0x7e LD A,(HL)
     func LD_7E() -> Int {
           a = mb.getMem(address: hl)
           pc += 1
           return 8
     }

     // 0x7f LD A,A
     func LD_7F() -> Int {
           a = a
           pc += 1
           return 4
     }

     // 0x80 ADD A,B
     func ADD_80() -> Int {
           let r = a + b
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = getHalfCarryForAdd(operands: a, b)
           fC = getFullCarryForAdd(operands: a, b)
           pc += 1
           return 4
     }

     // 0x81 ADD A,C
     func ADD_81() -> Int {
           let r = a + c
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = getHalfCarryForAdd(operands: a, c)
           fC = getFullCarryForAdd(operands: a, c)
           pc += 1
           return 4
     }

     // 0x82 ADD A,D
     func ADD_82() -> Int {
           let r = a + d
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = getHalfCarryForAdd(operands: a, d)
           fC = getFullCarryForAdd(operands: a, d)
           pc += 1
           return 4
     }

     // 0x83 ADD A,E
     func ADD_83() -> Int {
           let r = a + e
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = getHalfCarryForAdd(operands: a, e)
           fC = getFullCarryForAdd(operands: a, e)
           pc += 1
           return 4
     }

     // 0x84 ADD A,H
     func ADD_84() -> Int {
           let r = a + h
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = getHalfCarryForAdd(operands: a, h)
           fC = getFullCarryForAdd(operands: a, h)
           pc += 1
           return 4
     }

     // 0x85 ADD A,L
     func ADD_85() -> Int {
           let r = a + l
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = getHalfCarryForAdd(operands: a, l)
           fC = getFullCarryForAdd(operands: a, l)
           pc += 1
           return 4
     }

     // 0x86 ADD A,(HL)
     func ADD_86() -> Int {
           let v = mb.getMem(address: hl)
           let r = a + v
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = getHalfCarryForAdd(operands: a, v)
           fC = getFullCarryForAdd(operands: a, v)
           pc += 1
           return 8
     }

     // 0x87 ADD A,A
     func ADD_87() -> Int {
           let r = a + a
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = getHalfCarryForAdd(operands: a, a)
           fC = getFullCarryForAdd(operands: a, a)
           pc += 1
           return 4
     }

     // 0x88 ADC A,B
     func ADC_88() -> Int {
           let r = a + b + fC.integerValue
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = getHalfCarryForAdd(operands: a, b, fC.integerValue)
           fC = getFullCarryForAdd(operands: a, b, fC.integerValue)
           pc += 1
           return 4
     }

     // 0x89 ADC A,C
     func ADC_89() -> Int {
           let r = a + c + fC.integerValue
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = getHalfCarryForAdd(operands: a, c, fC.integerValue)
           fC = getFullCarryForAdd(operands: a, c, fC.integerValue)
           pc += 1
           return 4
     }

     // 0x8a ADC A,D
     func ADC_8A() -> Int {
           let r = a + d + fC.integerValue
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = getHalfCarryForAdd(operands: a, d, fC.integerValue)
           fC = getFullCarryForAdd(operands: a, d, fC.integerValue)
           pc += 1
           return 4
     }

     // 0x8b ADC A,E
     func ADC_8B() -> Int {
           let r = a + e + fC.integerValue
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = getHalfCarryForAdd(operands: a, e, fC.integerValue)
           fC = getFullCarryForAdd(operands: a, e, fC.integerValue)
           pc += 1
           return 4
     }

     // 0x8c ADC A,H
     func ADC_8C() -> Int {
           let r = a + h + fC.integerValue
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = getHalfCarryForAdd(operands: a, h, fC.integerValue)
           fC = getFullCarryForAdd(operands: a, h, fC.integerValue)
           pc += 1
           return 4
     }

     // 0x8d ADC A,L
     func ADC_8D() -> Int {
           let r = a + l + fC.integerValue
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = getHalfCarryForAdd(operands: a, l, fC.integerValue)
           fC = getFullCarryForAdd(operands: a, l, fC.integerValue)
           pc += 1
           return 4
     }

     // 0x8e ADC A,(HL)
     func ADC_8E() -> Int {
           let v = mb.getMem(address: hl)
           let r = a + v + fC.integerValue
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = getHalfCarryForAdd(operands: a, v, fC.integerValue)
           fC = getFullCarryForAdd(operands: a, v, fC.integerValue)
           pc += 1
           return 8
     }

     // 0x8f ADC A,A
     func ADC_8F() -> Int {
           let r = a + a + fC.integerValue
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = getHalfCarryForAdd(operands: a, a, fC.integerValue)
           fC = getFullCarryForAdd(operands: a, a, fC.integerValue)
           pc += 1
           return 4
     }

     // 0x90 SUB B
     func SUB_90() -> Int {
           a = a - b
           fZ = getZeroFlag(val: a)
           fN = true
           fH = getHalfCarryForSub(operands: a, b)
           fC = getFullCarryForSub(operands: a, b)
           pc += 1
           return 4
     }

     // 0x91 SUB C
     func SUB_91() -> Int {
           a = a - c
           fZ = getZeroFlag(val: a)
           fN = true
           fH = getHalfCarryForSub(operands: a, c)
           fC = getFullCarryForSub(operands: a, c)
           pc += 1
           return 4
     }

     // 0x92 SUB D
     func SUB_92() -> Int {
           a = a - d
           fZ = getZeroFlag(val: a)
           fN = true
           fH = getHalfCarryForSub(operands: a, d)
           fC = getFullCarryForSub(operands: a, d)
           pc += 1
           return 4
     }

     // 0x93 SUB E
     func SUB_93() -> Int {
           a = a - e
           fZ = getZeroFlag(val: a)
           fN = true
           fH = getHalfCarryForSub(operands: a, e)
           fC = getFullCarryForSub(operands: a, e)
           pc += 1
           return 4
     }

     // 0x94 SUB H
     func SUB_94() -> Int {
           a = a - h
           fZ = getZeroFlag(val: a)
           fN = true
           fH = getHalfCarryForSub(operands: a, h)
           fC = getFullCarryForSub(operands: a, h)
           pc += 1
           return 4
     }

     // 0x95 SUB L
     func SUB_95() -> Int {
           a = a - l
           fZ = getZeroFlag(val: a)
           fN = true
           fH = getHalfCarryForSub(operands: a, l)
           fC = getFullCarryForSub(operands: a, l)
           pc += 1
           return 4
     }

     // 0x96 SUB (HL)
     func SUB_96() -> Int {
           let v = mb.getMem(address: hl)
           a = a - v
           fZ = getZeroFlag(val: a)
           fN = true
           fH = getHalfCarryForSub(operands: a, v)
           fC = getFullCarryForSub(operands: a, v)
           pc += 1
           return 8
     }

     // 0x97 SUB A
     func SUB_97() -> Int {
           a = a - a
           fZ = getZeroFlag(val: a)
           fN = true
           fH = getHalfCarryForSub(operands: a, a)
           fC = getFullCarryForSub(operands: a, a)
           pc += 1
           return 4
     }

     // 0x98 SBC A,B
     func SBC_98() -> Int {
           let r = a - b - fC.integerValue
           a = r
           fZ = getZeroFlag(val: r)
           fN = true
           fH = getHalfCarryForSub(operands: a, b, fC.integerValue)
           fC = getFullCarryForSub(operands: a, b, fC.integerValue)
           pc += 1
           return 4
     }

     // 0x99 SBC A,C
     func SBC_99() -> Int {
           let r = a - c - fC.integerValue
           a = r
           fZ = getZeroFlag(val: r)
           fN = true
           fH = getHalfCarryForSub(operands: a, c, fC.integerValue)
           fC = getFullCarryForSub(operands: a, c, fC.integerValue)
           pc += 1
           return 4
     }

     // 0x9a SBC A,D
     func SBC_9A() -> Int {
           let r = a - d - fC.integerValue
           a = r
           fZ = getZeroFlag(val: r)
           fN = true
           fH = getHalfCarryForSub(operands: a, d, fC.integerValue)
           fC = getFullCarryForSub(operands: a, d, fC.integerValue)
           pc += 1
           return 4
     }

     // 0x9b SBC A,E
     func SBC_9B() -> Int {
           let r = a - e - fC.integerValue
           a = r
           fZ = getZeroFlag(val: r)
           fN = true
           fH = getHalfCarryForSub(operands: a, e, fC.integerValue)
           fC = getFullCarryForSub(operands: a, e, fC.integerValue)
           pc += 1
           return 4
     }

     // 0x9c SBC A,H
     func SBC_9C() -> Int {
           let r = a - h - fC.integerValue
           a = r
           fZ = getZeroFlag(val: r)
           fN = true
           fH = getHalfCarryForSub(operands: a, h, fC.integerValue)
           fC = getFullCarryForSub(operands: a, h, fC.integerValue)
           pc += 1
           return 4
     }

     // 0x9d SBC A,L
     func SBC_9D() -> Int {
           let r = a - l - fC.integerValue
           a = r
           fZ = getZeroFlag(val: r)
           fN = true
           fH = getHalfCarryForSub(operands: a, l, fC.integerValue)
           fC = getFullCarryForSub(operands: a, l, fC.integerValue)
           pc += 1
           return 4
     }

     // 0x9e SBC A,(HL)
     func SBC_9E() -> Int {
           let v = mb.getMem(address: hl)
           let r = a - v - fC.integerValue
           a = r
           fZ = getZeroFlag(val: r)
           fN = true
           fH = getHalfCarryForSub(operands: a, v, fC.integerValue)
           fC = getFullCarryForSub(operands: a, v, fC.integerValue)
           pc += 1
           return 8
     }

     // 0x9f SBC A,A
     func SBC_9F() -> Int {
           let r = a - a - fC.integerValue
           a = r
           fZ = getZeroFlag(val: r)
           fN = true
           fH = getHalfCarryForSub(operands: a, a, fC.integerValue)
           fC = getFullCarryForSub(operands: a, a, fC.integerValue)
           pc += 1
           return 4
     }

     // 0xa0 AND B
     func AND_A0() -> Int {
           let r = a & b
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = true
           fC = false
           pc += 1
           return 4
     }

     // 0xa1 AND C
     func AND_A1() -> Int {
           let r = a & c
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = true
           fC = false
           pc += 1
           return 4
     }

     // 0xa2 AND D
     func AND_A2() -> Int {
           let r = a & d
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = true
           fC = false
           pc += 1
           return 4
     }

     // 0xa3 AND E
     func AND_A3() -> Int {
           let r = a & e
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = true
           fC = false
           pc += 1
           return 4
     }

     // 0xa4 AND H
     func AND_A4() -> Int {
           let r = a & h
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = true
           fC = false
           pc += 1
           return 4
     }

     // 0xa5 AND L
     func AND_A5() -> Int {
           let r = a & l
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = true
           fC = false
           pc += 1
           return 4
     }

     // 0xa6 AND (HL)
     func AND_A6() -> Int {
           let r = a & mb.getMem(address: hl)
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = true
           fC = false
           pc += 1
           return 8
     }

     // 0xa7 AND A
     func AND_A7() -> Int {
           let r = a & a
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = true
           fC = false
           pc += 1
           return 4
     }

     // 0xa8 XOR B
     func XOR_A8() -> Int {
           let r = a ^ b
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = false
           fC = false
           pc += 1
           return 4
     }

     // 0xa9 XOR C
     func XOR_A9() -> Int {
           let r = a ^ c
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = false
           fC = false
           pc += 1
           return 4
     }

     // 0xaa XOR D
     func XOR_AA() -> Int {
           let r = a ^ d
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = false
           fC = false
           pc += 1
           return 4
     }

     // 0xab XOR E
     func XOR_AB() -> Int {
           let r = a ^ e
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = false
           fC = false
           pc += 1
           return 4
     }

     // 0xac XOR H
     func XOR_AC() -> Int {
           let r = a ^ h
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = false
           fC = false
           pc += 1
           return 4
     }

     // 0xad XOR L
     func XOR_AD() -> Int {
           let r = a ^ l
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = false
           fC = false
           pc += 1
           return 4
     }

     // 0xae XOR (HL)
     func XOR_AE() -> Int {
           let r = a ^ mb.getMem(address: hl)
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = false
           fC = false
           pc += 1
           return 8
     }

     // 0xaf XOR A
     func XOR_AF() -> Int {
           let r = a ^ a
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = false
           fC = false
           pc += 1
           return 4
     }

     // 0xb0 OR B
     func OR_B0() -> Int {
           let r = a | b
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = false
           fC = false
           pc += 1
           return 4
     }

     // 0xb1 OR C
     func OR_B1() -> Int {
           let r = a | c
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = false
           fC = false
           pc += 1
           return 4
     }

     // 0xb2 OR D
     func OR_B2() -> Int {
           let r = a | d
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = false
           fC = false
           pc += 1
           return 4
     }

     // 0xb3 OR E
     func OR_B3() -> Int {
           let r = a | e
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = false
           fC = false
           pc += 1
           return 4
     }

     // 0xb4 OR H
     func OR_B4() -> Int {
           let r = a | h
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = false
           fC = false
           pc += 1
           return 4
     }

     // 0xb5 OR L
     func OR_B5() -> Int {
           let r = a | l
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = false
           fC = false
           pc += 1
           return 4
     }

     // 0xb6 OR (HL)
     func OR_B6() -> Int {
           let r = a | mb.getMem(address: hl)
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = false
           fC = false
           pc += 1
           return 8
     }

     // 0xb7 OR A
     func OR_B7() -> Int {
           let r = a | a
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = false
           fC = false
           pc += 1
           return 4
     }

     // 0xb8 CP B
     func CP_B8() -> Int {
           let r = a - b
           fZ = getZeroFlag(val: r)
           fN = true
           fH = getHalfCarryForSub(operands: a, b)
           fC = getFullCarryForSub(operands: a, b)
           pc += 1
           return 4
     }

     // 0xb9 CP C
     func CP_B9() -> Int {
           let r = a - c
           fZ = getZeroFlag(val: r)
           fN = true
           fH = getHalfCarryForSub(operands: a, c)
           fC = getFullCarryForSub(operands: a, c)
           pc += 1
           return 4
     }

     // 0xba CP D
     func CP_BA() -> Int {
           let r = a - d
           fZ = getZeroFlag(val: r)
           fN = true
           fH = getHalfCarryForSub(operands: a, d)
           fC = getFullCarryForSub(operands: a, d)
           pc += 1
           return 4
     }

     // 0xbb CP E
     func CP_BB() -> Int {
           let r = a - e
           fZ = getZeroFlag(val: r)
           fN = true
           fH = getHalfCarryForSub(operands: a, e)
           fC = getFullCarryForSub(operands: a, e)
           pc += 1
           return 4
     }

     // 0xbc CP H
     func CP_BC() -> Int {
           let r = a - h
           fZ = getZeroFlag(val: r)
           fN = true
           fH = getHalfCarryForSub(operands: a, h)
           fC = getFullCarryForSub(operands: a, h)
           pc += 1
           return 4
     }

     // 0xbd CP L
     func CP_BD() -> Int {
           let r = a - l
           fZ = getZeroFlag(val: r)
           fN = true
           fH = getHalfCarryForSub(operands: a, l)
           fC = getFullCarryForSub(operands: a, l)
           pc += 1
           return 4
     }

     // 0xbe CP (HL)
     func CP_BE() -> Int {
           let v = mb.getMem(address: hl)
           let r = a - v
           fZ = getZeroFlag(val: r)
           fN = true
           fH = getHalfCarryForSub(operands: a, v)
           fC = getFullCarryForSub(operands: a, v)
           pc += 1
           return 8
     }

     // 0xbf CP A
     func CP_BF() -> Int {
           let r = a - a
           fZ = getZeroFlag(val: r)
           fN = true
           fH = getHalfCarryForSub(operands: a, a)
           fC = getFullCarryForSub(operands: a, a)
           pc += 1
           return 4
     }

     // 0xc0 RET NZ
     func RET_C0() -> Int {
           if !fZ {
                 popPCFromStack()
                 return 20
           } else {
                 return 8
           }
     }

     // 0xc1 POP BC
     func POP_C1() -> Int {
           b = mb.getMem(address: sp + 1)
           c = mb.getMem(address: sp)
           sp += 2
           pc += 1
           return 12
     }

     // 0xc2 JP NZ,a16
     func JP_C2() -> Int {
           let v = mb.getMem(address: get16BitImmediate())
           if !fZ {
                 pc = v
                 return 16
           } else {
                 pc += 3
                 return 12
           }
     }

     // 0xc3 JP a16
     func JP_C3() -> Int {
           let v = mb.getMem(address: get16BitImmediate())
           pc = v
           return 16
     }

     // 0xc4 CALL NZ,a16
     func CALL_C4() -> Int {
           let v = get16BitImmediate()
           pc += 3
           if !fZ {
                 pushPCToStack()
                 pc = v
                 return 24
           } else {
                 return 12
           }
     }

     // 0xc5 PUSH BC
     func PUSH_C5() -> Int {
           mb.setMem(address: sp - 1, val: b)
           mb.setMem(address: sp - 2, val: c)
           sp -= 2
           pc += 1
           return 16
     }

     // 0xc6 ADD A,d8
     func ADD_C6() -> Int {
           let v = get8BitImmediate()
           let r = a + v
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = getHalfCarryForAdd(operands: a, v)
           fC = getFullCarryForAdd(operands: a, v)
           pc += 2
           return 8
     }

     // 0xc7 RST 00H
     func RST_C7() -> Int {
           pc += 1
           pushPCToStack()
           pc = 0x00
           return 16
     }

     // 0xc8 RET Z
     func RET_C8() -> Int {
           if fZ {
                 popPCFromStack()
                 return 20
           } else {
                 return 8
           }
     }

     // 0xc9 RET
     func RET_C9() -> Int {
           popPCFromStack()
           return 16
     }

     // 0xca JP Z,a16
     func JP_CA() -> Int {
           let v = mb.getMem(address: get16BitImmediate())
           if fZ {
                 pc = v
                 return 16
           } else {
                 pc += 3
                 return 12
           }
     }

     // 0xcb PREFIX CB
     func PREFIX_CB() -> Int {
           pc += 1
           return 4
     }

     // 0xcc CALL Z,a16
     func CALL_CC() -> Int {
           let v = get16BitImmediate()
           pc += 3
           if fZ {
                 pushPCToStack()
                 pc = v
                 return 24
           } else {
                 return 12
           }
     }

     // 0xcd CALL a16
     func CALL_CD() -> Int {
           let v = get16BitImmediate()
           pc += 3
           pushPCToStack()
           pc = v
           return 24
     }

     // 0xce ADC A,d8
     func ADC_CE() -> Int {
           let v = get8BitImmediate()
           let r = a + v + fC.integerValue
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = getHalfCarryForAdd(operands: a, v, fC.integerValue)
           fC = getFullCarryForAdd(operands: a, v, fC.integerValue)
           pc += 2
           return 8
     }

     // 0xcf RST 08H
     func RST_CF() -> Int {
           pc += 1
           pushPCToStack()
           pc = 0x08
           return 16
     }

     // 0xd0 RET NC
     func RET_D0() -> Int {
           if !fC {
                 popPCFromStack()
                 return 20
           } else {
                 return 8
           }
     }

     // 0xd1 POP DE
     func POP_D1() -> Int {
           d = mb.getMem(address: sp + 1)
           e = mb.getMem(address: sp)
           sp += 2
           pc += 1
           return 12
     }

     // 0xd2 JP NC,a16
     func JP_D2() -> Int {
           let v = mb.getMem(address: get16BitImmediate())
           if !fC {
                 pc = v
                 return 16
           } else {
                 pc += 3
                 return 12
           }
     }

     // 0xd4 CALL NC,a16
     func CALL_D4() -> Int {
           let v = get16BitImmediate()
           pc += 3
           if !fC {
                 pushPCToStack()
                 pc = v
                 return 24
           } else {
                 return 12
           }
     }

     // 0xd5 PUSH DE
     func PUSH_D5() -> Int {
           mb.setMem(address: sp - 1, val: d)
           mb.setMem(address: sp - 2, val: e)
           sp -= 2
           pc += 1
           return 16
     }

     // 0xd6 SUB d8
     func SUB_D6() -> Int {
           let v = get8BitImmediate()
           a = a - v
           fZ = getZeroFlag(val: a)
           fN = true
           fH = getHalfCarryForSub(operands: a, v)
           fC = getFullCarryForSub(operands: a, v)
           pc += 2
           return 8
     }

     // 0xd7 RST 10H
     func RST_D7() -> Int {
           pc += 1
           pushPCToStack()
           pc = 0x10
           return 16
     }

     // 0xd8 RET C
     func RET_D8() -> Int {
           if fC {
                 popPCFromStack()
                 return 20
           } else {
                 return 8
           }
     }

     // 0xd9 RETI
     func RETI_D9() -> Int {
           interruptMasterEnable = true
           pc = popFromStack(numOfByte: 2)
           return 16
     }

     // 0xda JP C,a16
     func JP_DA() -> Int {
           let v = mb.getMem(address: get16BitImmediate())
           if fC {
                 pc = v
                 return 16
           } else {
                 pc += 3
                 return 12
           }
     }

     // 0xdc CALL C,a16
     func CALL_DC() -> Int {
           let v = get16BitImmediate()
           pc += 3
           if fC {
                 pushPCToStack()
                 pc = v
                 return 24
           } else {
                 return 12
           }
     }

     // 0xde SBC A,d8
     func SBC_DE() -> Int {
           let v = get8BitImmediate()
           let r = a - v - fC.integerValue
           a = r
           fZ = getZeroFlag(val: r)
           fN = true
           fH = getHalfCarryForSub(operands: a, v, fC.integerValue)
           fC = getFullCarryForSub(operands: a, v, fC.integerValue)
           pc += 2
           return 8
     }

     // 0xdf RST 18H
     func RST_DF() -> Int {
           pc += 1
           pushPCToStack()
           pc = 0x18
           return 16
     }

     // 0xe0 LDH (a8),A
     func LDH_E0() -> Int {
           let v = get8BitImmediate()
           mb.setMem(address: 0xFF00 + v, val: a)
           pc += 2
           return 12
     }

     // 0xe1 POP HL
     func POP_E1() -> Int {
           h = mb.getMem(address: sp + 1)
           l = mb.getMem(address: sp)
           sp += 2
           pc += 1
           return 12
     }

     // 0xe2 LD (C),A
     func LD_E2() -> Int {
           mb.setMem(address: 0xFF00 + c, val: a)
           pc += 2
           return 8
     }

     // 0xe5 PUSH HL
     func PUSH_E5() -> Int {
           mb.setMem(address: sp - 1, val: h)
           mb.setMem(address: sp - 2, val: l)
           sp -= 2
           pc += 1
           return 16
     }

     // 0xe6 AND d8
     func AND_E6() -> Int {
           let r = a & get8BitImmediate()
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = true
           fC = false
           pc += 2
           return 8
     }

     // 0xe7 RST 20H
     func RST_E7() -> Int {
           pc += 1
           pushPCToStack()
           pc = 0x20
           return 16
     }

     // 0xe8 ADD SP,r8
     func ADD_E8() -> Int {
           let v = get8BitSignedImmediateValue()
           let r = sp + v
           sp = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = getHalfCarryForAdd(operands: a, v)
           fC = getFullCarryForAdd(operands: a, v)
           pc += 2
           return 16
     }

     // 0xe9 JP (HL)
     func JP_E9() -> Int {
           let v = mb.getMem(address: hl)
           pc = v
           return 4
     }

     // 0xea LD (a16),A
     func LD_EA() -> Int {
           let addr = get16BitImmediate()
           mb.setMem(address: addr, val: a)
           pc += 3
           return 16
     }

     // 0xee XOR d8
     func XOR_EE() -> Int {
           let r = a ^ get8BitImmediate()
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = false
           fC = false
           pc += 2
           return 8
     }

     // 0xef RST 28H
     func RST_EF() -> Int {
           pc += 1
           pushPCToStack()
           pc = 0x28
           return 16
     }

     // 0xf0 LDH A,(a8)
     func LDH_F0() -> Int {
           let v = get8BitImmediate()
           a = mb.getMem(address:  0xFF00 + v)
           pc += 2
           return 12
     }

     // 0xf1 POP AF
     func POP_F1() -> Int {
           a = mb.getMem(address: sp + 1)
           f = mb.getMem(address: sp)
           sp += 2
           pc += 1
           return 12
     }

     // 0xf2 LD A,(C)
     func LD_F2() -> Int {
           a = mb.getMem(address: 0xFF00 + c)
           pc += 2
           return 8
     }

     // 0xf3 DI
     func DI_F3() -> Int {
           interruptMasterEnable = false
           pc += 1
           return 4
     }

     // 0xf5 PUSH AF
     func PUSH_F5() -> Int {
           mb.setMem(address: sp - 1, val: a)
           mb.setMem(address: sp - 2, val: f)
           sp -= 2
           pc += 1
           return 16
     }

     // 0xf6 OR d8
     func OR_F6() -> Int {
           let r = a | get8BitImmediate()
           a = r
           fZ = getZeroFlag(val: r)
           fN = false
           fH = false
           fC = false
           pc += 2
           return 8
     }

     // 0xf7 RST 30H
     func RST_F7() -> Int {
           pc += 1
           pushPCToStack()
           pc = 0x30
           return 16
     }

     // 0xf8 LD HL,SP+r8
     func LD_F8() -> Int {
           let n = get8BitSignedImmediateValue()
           hl = sp + n
           fZ = false
           fN = false
           fC = getFullCarryForAdd(operands: sp, n)
           fH = getHalfCarryForAdd(operands: sp, n)
           pc += 2
           return 12
     }

     // 0xf9 LD SP,HL
     func LD_F9() -> Int {
           sp = hl
           pc += 1
           return 8
     }

     // 0xfa LD A,(a16)
     func LD_FA() -> Int {
           a = mb.getMem(address: get16BitImmediate())
           pc += 3
           return 16
     }

     // 0xfb EI
     func EI_FB() -> Int {
           interruptMasterEnable = true
           pc += 1
           return 4
     }

     // 0xfe CP d8
     func CP_FE() -> Int {
           let v = get8BitImmediate()
           let r = a - v
           fZ = getZeroFlag(val: r)
           fN = true
           fH = getHalfCarryForSub(operands: a, v)
           fC = getFullCarryForSub(operands: a, v)
           pc += 2
           return 8
     }

     // 0xff RST 38H
     func RST_FF() -> Int {
           pc += 1
           pushPCToStack()
           pc = 0x38
           return 16
     }

}