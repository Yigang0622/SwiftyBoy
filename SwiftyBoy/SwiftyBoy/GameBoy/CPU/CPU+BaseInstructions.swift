import Foundation

extension CPU {
    
    // 0x00 NOP
    func NOP_00() -> Int {
        pc += 1
        return 4
    }
    // 0x01 LD BC,d16
    func LD_01() -> Int {
        let v = get16BitImmediate()
        _ld(to: .bc, val: v)
        pc += 3
        return 12
    }
    // 0x02 LD (BC),A
    func LD_02() -> Int {
        _ld(toAddress: bc, fromReg: .a)
        pc += 1
        return 8
    }
    // 0x03 INC BC
    func INC_03() -> Int {
        _inc(reg: .bc)
        pc += 1
        return 8
    }
    // 0x04 INC B
    func INC_04() -> Int {
        _inc(reg: .b)
        pc += 1
        return 4
    }
    // 0x05 DEC B
    func DEC_05() -> Int {
        _dec(reg: .b)
        pc += 1
        return 4
    }
    // 0x06 LD B,d8
    func LD_06() -> Int {
        let v = get8BitImmediate()
        _ld(to: .b, val: v)
        pc += 2
        return 8
    }
    // 0x07 RLCA
    func RLCA_07() -> Int {
        _rlca()
        pc += 1
        return 4
    }
    // 0x08 LD (a16),SP
    func LD_08() -> Int {
        let addr = get16BitImmediate()
        mb.setMem(address: addr, val: sp & 0xFF)
        mb.setMem(address: addr + 1, val: sp >> 8)    
        pc += 3
        return 20
    }
    // 0x09 ADD HL,BC
    func ADD_09() -> Int {
        _add(reg: .hl, val: bc)
        pc += 1
        return 8
    }
    // 0x0a LD A,(BC)
    func LD_0A() -> Int {
        _ld(to: .a, address: bc)
        pc += 1
        return 8
    }
    // 0x0b DEC BC
    func DEC_0B() -> Int {
        _dec(reg: .bc)
        pc += 1
        return 8
    }
    // 0x0c INC C
    func INC_0C() -> Int {
        _inc(reg: .c)
        pc += 1
        return 4
    }
    // 0x0d DEC C
    func DEC_0D() -> Int {
        _dec(reg: .c)
        pc += 1
        return 4
    }
    // 0x0e LD C,d8
    func LD_0E() -> Int {
        let v = get8BitImmediate()
        _ld(to: .c, val: v)
        pc += 2
        return 8
    }
    // 0x0f RRCA
    func RRCA_0F() -> Int {
        _rrca()
        pc += 1
        return 4
    }
    // 0x10 STOP 0
    func STOP_10() -> Int {
        halted = true
        print("cpu stopped")
        pc += 2
        return 4
    }
    // 0x11 LD DE,d16
    func LD_11() -> Int {
        let v = get16BitImmediate()
        _ld(to: .de, val: v)
        pc += 3
        return 12
    }
    // 0x12 LD (DE),A
    func LD_12() -> Int {
        _ld(toAddress: de, fromReg: .a)
        pc += 1
        return 8
    }
    // 0x13 INC DE
    func INC_13() -> Int {
        _inc(reg: .de)
        pc += 1
        return 8
    }
    // 0x14 INC D
    func INC_14() -> Int {
        _inc(reg: .d)
        pc += 1
        return 4
    }
    // 0x15 DEC D
    func DEC_15() -> Int {
        _dec(reg: .d)
        pc += 1
        return 4
    }
    // 0x16 LD D,d8
    func LD_16() -> Int {
        let v = get8BitImmediate()
        _ld(to: .d, val: v)
        pc += 2
        return 8
    }
    // 0x17 RLA
    func RLA_17() -> Int {
        _rla()
        pc += 1
        return 4
    }
    // 0x18 JR r8
    func JR_18() -> Int {
        let v = get8BitImmediate()
        pc += 2
        _jr(val: v)        
        return 12
    }
    // 0x19 ADD HL,DE
    func ADD_19() -> Int {
        _add(reg: .hl, val: de)
        pc += 1
        return 8
    }
    // 0x1a LD A,(DE)
    func LD_1A() -> Int {
        _ld(to: .a, address: de)
        pc += 1
        return 8
    }
    // 0x1b DEC DE
    func DEC_1B() -> Int {
        _dec(reg: .de)
        pc += 1
        return 8
    }
    // 0x1c INC E
    func INC_1C() -> Int {
        _inc(reg: .e)
        pc += 1
        return 4
    }
    // 0x1d DEC E
    func DEC_1D() -> Int {
        _dec(reg: .e)
        pc += 1
        return 4
    }
    // 0x1e LD E,d8
    func LD_1E() -> Int {
        let v = get8BitImmediate()
        _ld(to: .e, val: v)
        pc += 2
        return 8
    }
    // 0x1f RRA
    func RRA_1F() -> Int {
        _rra()
        pc += 1
        return 4
    }
    // 0x20 JR NZ,r8
    func JR_20() -> Int {
        let v = get8BitImmediate()
        pc += 2
        if !fZ {
            _jr(val: v)
            return 12
        } else {
            return 8
        }
        //12/8
    }
    // 0x21 LD HL,d16
    func LD_21() -> Int {
        let v = get16BitImmediate()
        _ld(to: .hl, val: v)
        pc += 3
        return 12
    }
    // 0x22 LD (HL+),A
    func LD_22() -> Int {
        _ld(toAddress: hl, fromReg: .a)
        hl += 1
        pc += 1
        return 8
    }
    // 0x23 INC HL
    func INC_23() -> Int {
        _inc(reg: .hl)
        pc += 1
        return 8
    }
    // 0x24 INC H
    func INC_24() -> Int {
        _inc(reg: .h)
        pc += 1
        return 4
    }
    // 0x25 DEC H
    func DEC_25() -> Int {
        _dec(reg: .h)
        pc += 1
        return 4
    }
    // 0x26 LD H,d8
    func LD_26() -> Int {
        let v = get8BitImmediate()
        _ld(to: .h, val: v)
        pc += 2
        return 8
    }
    // 0x27 DAA
    func DAA_27() -> Int {
        _daa()
        pc += 1
        return 4
    }
    // 0x28 JR Z,r8
    func JR_28() -> Int {
        let v = get8BitImmediate()
        pc += 2
        if fZ {
            _jr(val: v)
            return 12
        } else {
            return 8
        }
        //12/8
    }
    // 0x29 ADD HL,HL
    func ADD_29() -> Int {
        _add(reg: .hl, val: hl)
        pc += 1
        return 8
    }
    // 0x2a LD A,(HL+)
    func LD_2A() -> Int {
        _ld(to: .a, address: hl)
        hl += 1
        pc += 1
        return 8
    }
    // 0x2b DEC HL
    func DEC_2B() -> Int {
        _dec(reg: .hl)
        pc += 1
        return 8
    }
    // 0x2c INC L
    func INC_2C() -> Int {
        _inc(reg: .l)
        pc += 1
        return 4
    }
    // 0x2d DEC L
    func DEC_2D() -> Int {
        _dec(reg: .l)
        pc += 1
        return 4
    }
    // 0x2e LD L,d8
    func LD_2E() -> Int {
        let v = get8BitImmediate()
        _ld(to: .l, val: v)
        pc += 2
        return 8
    }
    // 0x2f CPL
    func CPL_2F() -> Int {
        _cpl()
        pc += 1
        return 4
    }
    // 0x30 JR NC,r8
    func JR_30() -> Int {
        let v = get8BitImmediate()
        pc += 2
        if !fC {
            _jr(val: v)
            return 12
        } else {
            return 8
        }
        //12/8
    }
    // 0x31 LD SP,d16
    func LD_31() -> Int {
        let v = get16BitImmediate()
        _ld(to: .sp, val: v)
        pc += 3
        return 12
    }
    // 0x32 LD (HL-),A
    func LD_32() -> Int {
        _ld(toAddress: hl, fromReg: .a)
        hl -= 1
        pc += 1
        return 8
    }
    // 0x33 INC SP
    func INC_33() -> Int {
        _inc(reg: .sp)
        pc += 1
        return 8
    }
    // 0x34 INC (HL)
    func INC_34() -> Int {
        _inc(address: hl)
        pc += 1
        return 12
    }
    // 0x35 DEC (HL)
    func DEC_35() -> Int {
        _dec(address: hl)
        pc += 1
        return 12
    }
    // 0x36 LD (HL),d8
    func LD_36() -> Int {
        let v = get8BitImmediate()
        mb.setMem(address: hl, val: v)
        pc += 2
        return 12
    }
    // 0x37 SCF
    func SCF_37() -> Int {
        _scf()
        pc += 1
        return 4
    }
    // 0x38 JR C,r8
    func JR_38() -> Int {
        let v = get8BitImmediate()
        pc += 2
        if fC {
            _jr(val: v)
            return 12
        } else {
            return 8
        }
        //12/8
    }
    // 0x39 ADD HL,SP
    func ADD_39() -> Int {
        _add(reg: .hl, val: sp)
        pc += 1
        return 8
    }
    // 0x3a LD A,(HL-)
    func LD_3A() -> Int {
        _ld(to: .a, address: hl)
        hl -= 1
        pc += 1
        return 8
    }
    // 0x3b DEC SP
    func DEC_3B() -> Int {
        _dec(reg: .sp)
        pc += 1
        return 8
    }
    // 0x3c INC A
    func INC_3C() -> Int {
        _inc(reg: .a)
        pc += 1
        return 4
    }
    // 0x3d DEC A
    func DEC_3D() -> Int {
        _dec(reg: .a)
        pc += 1
        return 4
    }
    // 0x3e LD A,d8
    func LD_3E() -> Int {
        let v = get8BitImmediate()
        _ld(to: .a, val: v)
        pc += 2
        return 8
    }
    // 0x3f CCF
    func CCF_3F() -> Int {
        _ccf()
        pc += 1
        return 4
    }
    // 0x40 LD B,B
    func LD_40() -> Int {
        _ld(to: .b, from: .b)
        pc += 1
        return 4
    }
    // 0x41 LD B,C
    func LD_41() -> Int {
        _ld(to: .b, from: .c)
        pc += 1
        return 4
    }
    // 0x42 LD B,D
    func LD_42() -> Int {
        _ld(to: .b, from: .d)
        pc += 1
        return 4
    }
    // 0x43 LD B,E
    func LD_43() -> Int {
        _ld(to: .b, from: .e)
        pc += 1
        return 4
    }
    // 0x44 LD B,H
    func LD_44() -> Int {
        _ld(to: .b, from: .h)
        pc += 1
        return 4
    }
    // 0x45 LD B,L
    func LD_45() -> Int {
        _ld(to: .b, from: .l)
        pc += 1
        return 4
    }
    // 0x46 LD B,(HL)
    func LD_46() -> Int {
        _ld(to: .b, address: hl)
        pc += 1
        return 8
    }
    // 0x47 LD B,A
    func LD_47() -> Int {
        _ld(to: .b, from: .a)
        pc += 1
        return 4
    }
    // 0x48 LD C,B
    func LD_48() -> Int {
        _ld(to: .c, from: .b)
        pc += 1
        return 4
    }
    // 0x49 LD C,C
    func LD_49() -> Int {
        _ld(to: .c, from: .c)
        pc += 1
        return 4
    }
    // 0x4a LD C,D
    func LD_4A() -> Int {
        _ld(to: .c, from: .d)
        pc += 1
        return 4
    }
    // 0x4b LD C,E
    func LD_4B() -> Int {
        _ld(to: .c, from: .e)
        pc += 1
        return 4
    }
    // 0x4c LD C,H
    func LD_4C() -> Int {
        _ld(to: .c, from: .h)
        pc += 1
        return 4
    }
    // 0x4d LD C,L
    func LD_4D() -> Int {
        _ld(to: .c, from: .l)
        pc += 1
        return 4
    }
    // 0x4e LD C,(HL)
    func LD_4E() -> Int {
        _ld(to: .c, address: hl)
        pc += 1
        return 8
    }
    // 0x4f LD C,A
    func LD_4F() -> Int {
        _ld(to: .c, from: .a)
        pc += 1
        return 4
    }
    // 0x50 LD D,B
    func LD_50() -> Int {
        _ld(to: .d, from: .b)
        pc += 1
        return 4
    }
    // 0x51 LD D,C
    func LD_51() -> Int {
        _ld(to: .d, from: .c)
        pc += 1
        return 4
    }
    // 0x52 LD D,D
    func LD_52() -> Int {
        _ld(to: .d, from: .d)
        pc += 1
        return 4
    }
    // 0x53 LD D,E
    func LD_53() -> Int {
        _ld(to: .d, from: .e)
        pc += 1
        return 4
    }
    // 0x54 LD D,H
    func LD_54() -> Int {
        _ld(to: .d, from: .h)
        pc += 1
        return 4
    }
    // 0x55 LD D,L
    func LD_55() -> Int {
        _ld(to: .d, from: .l)
        pc += 1
        return 4
    }
    // 0x56 LD D,(HL)
    func LD_56() -> Int {
        _ld(to: .d, address: hl)
        pc += 1
        return 8
    }
    // 0x57 LD D,A
    func LD_57() -> Int {
        _ld(to: .d, from: .a)
        pc += 1
        return 4
    }
    // 0x58 LD E,B
    func LD_58() -> Int {
        _ld(to: .e, from: .b)
        pc += 1
        return 4
    }
    // 0x59 LD E,C
    func LD_59() -> Int {
        _ld(to: .e, from: .c)
        pc += 1
        return 4
    }
    // 0x5a LD E,D
    func LD_5A() -> Int {
        _ld(to: .e, from: .d)
        pc += 1
        return 4
    }
    // 0x5b LD E,E
    func LD_5B() -> Int {
        _ld(to: .e, from: .e)
        pc += 1
        return 4
    }
    // 0x5c LD E,H
    func LD_5C() -> Int {
        _ld(to: .e, from: .h)
        pc += 1
        return 4
    }
    // 0x5d LD E,L
    func LD_5D() -> Int {
        _ld(to: .e, from: .l)
        pc += 1
        return 4
    }
    // 0x5e LD E,(HL)
    func LD_5E() -> Int {
        _ld(to: .e, address: hl)
        pc += 1
        return 8
    }
    // 0x5f LD E,A
    func LD_5F() -> Int {
        _ld(to: .e, from: .a)
        pc += 1
        return 4
    }
    // 0x60 LD H,B
    func LD_60() -> Int {
        _ld(to: .h, from: .b)
        pc += 1
        return 4
    }
    // 0x61 LD H,C
    func LD_61() -> Int {
        _ld(to: .h, from: .c)
        pc += 1
        return 4
    }
    // 0x62 LD H,D
    func LD_62() -> Int {
        _ld(to: .h, from: .d)
        pc += 1
        return 4
    }
    // 0x63 LD H,E
    func LD_63() -> Int {
        _ld(to: .h, from: .e)
        pc += 1
        return 4
    }
    // 0x64 LD H,H
    func LD_64() -> Int {
        _ld(to: .h, from: .h)
        pc += 1
        return 4
    }
    // 0x65 LD H,L
    func LD_65() -> Int {
        _ld(to: .h, from: .l)
        pc += 1
        return 4
    }
    // 0x66 LD H,(HL)
    func LD_66() -> Int {
        _ld(to: .h, address: hl)
        pc += 1
        return 8
    }
    // 0x67 LD H,A
    func LD_67() -> Int {
        _ld(to: .h, from: .a)
        pc += 1
        return 4
    }
    // 0x68 LD L,B
    func LD_68() -> Int {
        _ld(to: .l, from: .b)
        pc += 1
        return 4
    }
    // 0x69 LD L,C
    func LD_69() -> Int {
        _ld(to: .l, from: .c)
        pc += 1
        return 4
    }
    // 0x6a LD L,D
    func LD_6A() -> Int {
        _ld(to: .l, from: .d)
        pc += 1
        return 4
    }
    // 0x6b LD L,E
    func LD_6B() -> Int {
        _ld(to: .l, from: .e)
        pc += 1
        return 4
    }
    // 0x6c LD L,H
    func LD_6C() -> Int {
        _ld(to: .l, from: .h)
        pc += 1
        return 4
    }
    // 0x6d LD L,L
    func LD_6D() -> Int {
        _ld(to: .l, from: .l)
        pc += 1
        return 4
    }
    // 0x6e LD L,(HL)
    func LD_6E() -> Int {
        _ld(to: .l, address: hl)
        pc += 1
        return 8
    }
    // 0x6f LD L,A
    func LD_6F() -> Int {
        _ld(to: .l, from: .a)
        pc += 1
        return 4
    }
    // 0x70 LD (HL),B
    func LD_70() -> Int {
        _ld(toAddress: hl, fromReg: .b)
        pc += 1
        return 8
    }
    // 0x71 LD (HL),C
    func LD_71() -> Int {
        _ld(toAddress: hl, fromReg: .c)
        pc += 1
        return 8
    }
    // 0x72 LD (HL),D
    func LD_72() -> Int {
        _ld(toAddress: hl, fromReg: .d)
        pc += 1
        return 8
    }
    // 0x73 LD (HL),E
    func LD_73() -> Int {
        _ld(toAddress: hl, fromReg: .e)
        pc += 1
        return 8
    }
    // 0x74 LD (HL),H
    func LD_74() -> Int {
        _ld(toAddress: hl, fromReg: .h)
        pc += 1
        return 8
    }
    // 0x75 LD (HL),L
    func LD_75() -> Int {
        _ld(toAddress: hl, fromReg: .l)
        pc += 1
        return 8
    }
    // 0x76 HALT
    func HALT_76() -> Int {
        self.halted = true
        print("CPU halt")
        pc += 1
        return 4
    }
    // 0x77 LD (HL),A
    func LD_77() -> Int {
        _ld(toAddress: hl, fromReg: .a)
        pc += 1
        return 8
    }
    // 0x78 LD A,B
    func LD_78() -> Int {
        _ld(to: .a, from: .b)
        pc += 1
        return 4
    }
    // 0x79 LD A,C
    func LD_79() -> Int {
        _ld(to: .a, from: .c)
        pc += 1
        return 4
    }
    // 0x7a LD A,D
    func LD_7A() -> Int {
        _ld(to: .a, from: .d)
        pc += 1
        return 4
    }
    // 0x7b LD A,E
    func LD_7B() -> Int {
        _ld(to: .a, from: .e)
        pc += 1
        return 4
    }
    // 0x7c LD A,H
    func LD_7C() -> Int {
        _ld(to: .a, from: .h)
        pc += 1
        return 4
    }
    // 0x7d LD A,L
    func LD_7D() -> Int {
        _ld(to: .a, from: .l)
        pc += 1
        return 4
    }
    // 0x7e LD A,(HL)
    func LD_7E() -> Int {
        _ld(to: .a, address: hl)
        pc += 1
        return 8
    }
    // 0x7f LD A,A
    func LD_7F() -> Int {
        _ld(to: .a, from: .a)
        pc += 1
        return 4
    }
    // 0x80 ADD A,B
    func ADD_80() -> Int {
        _add(reg: .a, val: b)
        pc += 1
        return 4
    }
    // 0x81 ADD A,C
    func ADD_81() -> Int {
        _add(reg: .a, val: c)
        pc += 1
        return 4
    }
    // 0x82 ADD A,D
    func ADD_82() -> Int {
        _add(reg: .a, val: d)
        pc += 1
        return 4
    }
    // 0x83 ADD A,E
    func ADD_83() -> Int {
        _add(reg: .a, val: e)
        pc += 1
        return 4
    }
    // 0x84 ADD A,H
    func ADD_84() -> Int {
        _add(reg: .a, val: h)
        pc += 1
        return 4
    }
    // 0x85 ADD A,L
    func ADD_85() -> Int {
        _add(reg: .a, val: l)
        pc += 1
        return 4
    }
    // 0x86 ADD A,(HL)
    func ADD_86() -> Int {
        let v = mb.getMem(address: hl)
        _add(reg: .a, val: v)
        pc += 1
        return 8
    }
    // 0x87 ADD A,A
    func ADD_87() -> Int {
        _add(reg: .a, val: a)
        pc += 1
        return 4
    }
    // 0x88 ADC A,B
    func ADC_88() -> Int {
        _adc(val: b)
        pc += 1
        return 4
    }
    // 0x89 ADC A,C
    func ADC_89() -> Int {
        _adc(val: c)
        pc += 1
        return 4
    }
    // 0x8a ADC A,D
    func ADC_8A() -> Int {
        _adc(val: d)
        pc += 1
        return 4
    }
    // 0x8b ADC A,E
    func ADC_8B() -> Int {
        _adc(val: e)
        pc += 1
        return 4
    }
    // 0x8c ADC A,H
    func ADC_8C() -> Int {
        _adc(val: h)
        pc += 1
        return 4
    }
    // 0x8d ADC A,L
    func ADC_8D() -> Int {
        _adc(val: l)
        pc += 1
        return 4
    }
    // 0x8e ADC A,(HL)
    func ADC_8E() -> Int {
        let v = mb.getMem(address: hl)
        _adc(val: v)
        pc += 1
        return 8
    }
    // 0x8f ADC A,A
    func ADC_8F() -> Int {
        _adc(val: a)
        pc += 1
        return 4
    }
    // 0x90 SUB B
    func SUB_90() -> Int {
        _sub(val: b)
        pc += 1
        return 4
    }
    // 0x91 SUB C
    func SUB_91() -> Int {
        _sub(val: c)
        pc += 1
        return 4
    }
    // 0x92 SUB D
    func SUB_92() -> Int {
        _sub(val: d)
        pc += 1
        return 4
    }
    // 0x93 SUB E
    func SUB_93() -> Int {
        _sub(val: e)
        pc += 1
        return 4
    }
    // 0x94 SUB H
    func SUB_94() -> Int {
        _sub(val: h)
        pc += 1
        return 4
    }
    // 0x95 SUB L
    func SUB_95() -> Int {
        _sub(val: l)
        pc += 1
        return 4
    }
    // 0x96 SUB (HL)
    func SUB_96() -> Int {
        let v = mb.getMem(address: hl)
        _sub(val: v)
        pc += 1
        return 8
    }
    // 0x97 SUB A
    func SUB_97() -> Int {
        _sub(val: a)
        pc += 1
        return 4
    }
    // 0x98 SBC A,B
    func SBC_98() -> Int {
        _sbc(val: b)
        pc += 1
        return 4
    }
    // 0x99 SBC A,C
    func SBC_99() -> Int {
        _sbc(val: c)
        pc += 1
        return 4
    }
    // 0x9a SBC A,D
    func SBC_9A() -> Int {
        _sbc(val: d)
        pc += 1
        return 4
    }
    // 0x9b SBC A,E
    func SBC_9B() -> Int {
        _sbc(val: e)
        pc += 1
        return 4
    }
    // 0x9c SBC A,H
    func SBC_9C() -> Int {
        _sbc(val: h)
        pc += 1
        return 4
    }
    // 0x9d SBC A,L
    func SBC_9D() -> Int {
        _sbc(val: l)
        pc += 1
        return 4
    }
    // 0x9e SBC A,(HL)
    func SBC_9E() -> Int {
        let v = mb.getMem(address: hl)
        _sbc(val: v)
        pc += 1
        return 8
    }
    // 0x9f SBC A,A
    func SBC_9F() -> Int {
        _sbc(val: a)
        pc += 1
        return 4
    }
    // 0xa0 AND B
    func AND_A0() -> Int {
        _and(val: b)
        pc += 1
        return 4
    }
    // 0xa1 AND C
    func AND_A1() -> Int {
        _and(val: c)
        pc += 1
        return 4
    }
    // 0xa2 AND D
    func AND_A2() -> Int {
        _and(val: d)
        pc += 1
        return 4
    }
    // 0xa3 AND E
    func AND_A3() -> Int {
        _and(val: e)
        pc += 1
        return 4
    }
    // 0xa4 AND H
    func AND_A4() -> Int {
        _and(val: h)
        pc += 1
        return 4
    }
    // 0xa5 AND L
    func AND_A5() -> Int {
        _and(val: l)
        pc += 1
        return 4
    }
    // 0xa6 AND (HL)
    func AND_A6() -> Int {
        let v = mb.getMem(address: hl)
        _and(val: v)
        pc += 1
        return 8
    }
    // 0xa7 AND A
    func AND_A7() -> Int {        
        _and(val: a)
        pc += 1
        return 4
    }
    // 0xa8 XOR B
    func XOR_A8() -> Int {
        _xor(val: b)
        pc += 1
        return 4
    }
    // 0xa9 XOR C
    func XOR_A9() -> Int {
        _xor(val: c)
        pc += 1
        return 4
    }
    // 0xaa XOR D
    func XOR_AA() -> Int {
        _xor(val: d)
        pc += 1
        return 4
    }
    // 0xab XOR E
    func XOR_AB() -> Int {
        _xor(val: e)
        pc += 1
        return 4
    }
    // 0xac XOR H
    func XOR_AC() -> Int {
        _xor(val: h)
        pc += 1
        return 4
    }
    // 0xad XOR L
    func XOR_AD() -> Int {
        _xor(val: l)
        pc += 1
        return 4
    }
    // 0xae XOR (HL)
    func XOR_AE() -> Int {
        let v = mb.getMem(address: hl)
        _xor(val: v)
        pc += 1
        return 8
    }
    // 0xaf XOR A
    func XOR_AF() -> Int {
        _xor(val: a)
        pc += 1
        return 4
    }
    // 0xb0 OR B
    func OR_B0() -> Int {
        _or(val: b)
        pc += 1
        return 4
    }
    // 0xb1 OR C
    func OR_B1() -> Int {
        _or(val: c)
        pc += 1
        return 4
    }
    // 0xb2 OR D
    func OR_B2() -> Int {
        _or(val: d)
        pc += 1
        return 4
    }
    // 0xb3 OR E
    func OR_B3() -> Int {
        _or(val: e)
        pc += 1
        return 4
    }
    // 0xb4 OR H
    func OR_B4() -> Int {
        _or(val: h)
        pc += 1
        return 4
    }
    // 0xb5 OR L
    func OR_B5() -> Int {
        _or(val: l)
        pc += 1
        return 4
    }
    // 0xb6 OR (HL)
    func OR_B6() -> Int {
        let v = mb.getMem(address: hl)
        _or(val: v)
        pc += 1
        return 8
    }
    // 0xb7 OR A
    func OR_B7() -> Int {
        _or(val: a)
        pc += 1
        return 4
    }
    // 0xb8 CP B
    func CP_B8() -> Int {
        _cp(val: b)
        pc += 1
        return 4
    }
    // 0xb9 CP C
    func CP_B9() -> Int {
        _cp(val: c)
        pc += 1
        return 4
    }
    // 0xba CP D
    func CP_BA() -> Int {
        _cp(val: d)
        pc += 1
        return 4
    }
    // 0xbb CP E
    func CP_BB() -> Int {
        _cp(val: e)
        pc += 1
        return 4
    }
    // 0xbc CP H
    func CP_BC() -> Int {
        _cp(val: h)
        pc += 1
        return 4
    }
    // 0xbd CP L
    func CP_BD() -> Int {
        _cp(val: l)
        pc += 1
        return 4
    }
    // 0xbe CP (HL)
    func CP_BE() -> Int {
        let v = mb.getMem(address: hl)
        _cp(val: v)
        pc += 1
        return 8
    }
    // 0xbf CP A
    func CP_BF() -> Int {
        _cp(val: a)
        pc += 1
        return 4
    }
    // 0xc0 RET NZ
    func RET_C0() -> Int {
        if !fZ {
            _ret()
            return 20
        } else {
            pc += 1
            return 8
        }
        //20/8
    }
    // 0xc1 POP BC
    func POP_C1() -> Int {
        _pop(reg: .bc)
        pc += 1
        return 12
    }
    // 0xc2 JP NZ,a16
    func JP_C2() -> Int {
        let v = get16BitImmediate()
        if !fZ {
            _jp(val: v)
            return 16
        } else {
            pc += 3
            return 12
        }
        //16/12
    }
    // 0xc3 JP a16
    func JP_C3() -> Int {
        let v = get16BitImmediate()
        pc += 3
        _jp(val: v)
        return 16
    }
    // 0xc4 CALL NZ,a16
    func CALL_C4() -> Int {
        let v = get16BitImmediate()
        pc += 3
        if !fZ {
            _call(address: v)
            return 24
        } else {
            return 12
        }
    }
    // 0xc5 PUSH BC
    func PUSH_C5() -> Int {
        _push(reg: .bc)
        pc += 1
        return 16
    }
    // 0xc6 ADD A,d8
    func ADD_C6() -> Int {
        let v = get8BitImmediate()
        _add(reg: .a, val: v)
        pc += 2
        return 8
    }
    // 0xc7 RST 00H
    func RST_C7() -> Int {
        pc += 1
        _rst(val: 0x00)
        return 16
    }
    // 0xc8 RET Z
    func RET_C8() -> Int {
        if fZ {
            _ret()
            return 20
        } else {
            pc += 1
            return 8
        }
        //20/8
    }
    // 0xc9 RET
    func RET_C9() -> Int {
        _ret()
        return 16
    }
    // 0xca JP Z,a16
    func JP_CA() -> Int {
        let v = get16BitImmediate()
        if fZ {
            _jp(val: v)
            return 16
        } else {
            pc += 3
            return 12
        }
        //16/12
    }
    // 0xcb PREFIX CB
    func PREFIX_CB() -> Int {
        pc += 1
        fatalError("PREFIX_CB error")
    }
    // 0xcc CALL Z,a16
    func CALL_CC() -> Int {
        let v = get16BitImmediate()
        pc += 3
        if fZ {
            _call(address: v)
            return 24
        } else {
            return 12
        }
        //24/12
    }
    // 0xcd CALL a16
    func CALL_CD() -> Int {
        let v = get16BitImmediate()
        pc += 3
        _call(address: v)
        return 24
    }
    // 0xce ADC A,d8
    func ADC_CE() -> Int {
        let v = get8BitImmediate()
        _adc(val: v)
        pc += 2
        return 8
    }
    // 0xcf RST 08H
    func RST_CF() -> Int {
        pc += 1
        _rst(val: 0x08)
        return 16
    }
    // 0xd0 RET NC
    func RET_D0() -> Int {
        if !fC {
            _ret()
            return 20
        } else {
            pc += 1
            return 8
        }
        //20/8
    }
    // 0xd1 POP DE
    func POP_D1() -> Int {
        _pop(reg: .de)
        pc += 1
        return 12
    }
    // 0xd2 JP NC,a16
    func JP_D2() -> Int {
        let v = get16BitImmediate()
        if !fC {
            _jp(val: v)
            return 16
        } else {
            pc += 3
            return 12
        }
        //16/12
    }
    // 0xd4 CALL NC,a16
    func CALL_D4() -> Int {
        let v = get16BitImmediate()
        pc += 3
        if !fC {
            _call(address: v)
            return 24
        } else {
            return 12
        }
        //24/12
    }
    // 0xd5 PUSH DE
    func PUSH_D5() -> Int {
        _push(reg: .de)
        pc += 1
        return 16
    }
    // 0xd6 SUB d8
    func SUB_D6() -> Int {
        let v = get8BitImmediate()
        _sub(val: v)
        pc += 2
        return 8
    }
    // 0xd7 RST 10H
    func RST_D7() -> Int {
        pc += 1
        _rst(val: 0x10)
        return 16
    }
    // 0xd8 RET C
    func RET_D8() -> Int {
        if fC {
            _ret()
            return 20
        } else {
            pc += 1
            return 8
        }
        //20/8
    }
    // 0xd9 RETI
    func RETI_D9() -> Int {
        _reti()
        return 16
    }
    // 0xda JP C,a16
    func JP_DA() -> Int {
        let v = get16BitImmediate()
        if fC {
            _jp(val: v)
            return 16
        } else {
            pc += 3
            return 12
        }
        //16/12
    }
    // 0xdc CALL C,a16
    func CALL_DC() -> Int {
        let v = get16BitImmediate()
        pc += 3
        if fC {
            _call(address: v)
            return 24
        } else {
            return 12
        }
        //24/12
    }
    // 0xde SBC A,d8
    func SBC_DE() -> Int {
        let v = get8BitImmediate()
        _sbc(val: v)
        pc += 2
        return 8
    }
    // 0xdf RST 18H
    func RST_DF() -> Int {
        pc += 1
        _rst(val: 0x18)
        return 16
    }
    // 0xe0 LDH (a8),A
    func LDH_E0() -> Int {
        let v = get8BitImmediate()
        _ld(toAddress: 0xFF00 + v, fromReg: .a)
        pc += 2
        return 12
    }
    // 0xe1 POP HL
    func POP_E1() -> Int {
        _pop(reg: .hl)
        pc += 1
        return 12
    }
    // 0xe2 LD (C),A
    func LD_E2() -> Int {
        _ld(toAddress: 0xFF00 + c, fromReg: .a)
        pc += 1
        return 8
    }
    // 0xe5 PUSH HL
    func PUSH_E5() -> Int {
        _push(reg: .hl)
        pc += 1
        return 16
    }
    // 0xe6 AND d8
    func AND_E6() -> Int {
        let v = get8BitImmediate()
        _and(val: v)
        pc += 2
        return 8
    }
    // 0xe7 RST 20H
    func RST_E7() -> Int {
        pc += 1
        _rst(val: 0x20)
        return 16
    }
    // 0xe8 ADD SP,r8
    func ADD_E8() -> Int {
        let v = get8BitImmediate()
        _add(reg: .sp, val: v)
        pc += 2
        return 16
    }
    // 0xe9 JP (HL)
    func JP_E9() -> Int {
        _jp(val: hl)
        return 4
    }
    // 0xea LD (a16),A
    func LD_EA() -> Int {
        let v = get16BitImmediate()
        _ld(toAddress: v, fromReg: .a)
        pc += 3
        return 16
    }
    // 0xee XOR d8
    func XOR_EE() -> Int {
        let v = get8BitImmediate()
        _xor(val: v)
        pc += 2
        return 8
    }
    // 0xef RST 28H
    func RST_EF() -> Int {
        pc += 1
        _rst(val: 0x28)
        return 16
    }
    // 0xf0 LDH A,(a8)
    func LDH_F0() -> Int {
        let v = get8BitImmediate()
        _ld(to: .a, address: 0xFF00 + v)
        pc += 2
        return 12
    }
    // 0xf1 POP AF
    func POP_F1() -> Int {
        _pop(reg: .af)
        pc += 1
        return 12
    }
    // 0xf2 LD A,(C)
    func LD_F2() -> Int {
        _ld(to: .a, address: 0xFF00 + c)
        pc += 1
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
        _push(reg: .af)
        pc += 1
        return 16
    }
    // 0xf6 OR d8
    func OR_F6() -> Int {
        let v = get8BitImmediate()
        _or(val: v)
        pc += 2
        return 8
    }
    // 0xf7 RST 30H
    func RST_F7() -> Int {
        pc += 1
        _rst(val: 0x30)
        return 16
    }
    // 0xf8 LD HL,SP+r8
    func LD_F8() -> Int {
        let v = get8BitImmediate()
        let signedV = converToSignedValue(val: v)
        hl = sp + signedV
        fZ = false
        fN = false
        fH = getHalfCarryForAdd(operands: sp, v)
        fC = getFullCarryForAdd(operands: sp, v)
        pc += 2
        return 12
    }
    // 0xf9 LD SP,HL
    func LD_F9() -> Int {
        _ld(to: .sp, from: .hl)
        pc += 1
        return 8
    }
    // 0xfa LD A,(a16)
    func LD_FA() -> Int {
        let v = get16BitImmediate()
        _ld(to: .a, address: v)
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
        _cp(val: v)
        pc += 2
        return 8
    }
    // 0xff RST 38H
    func RST_FF() -> Int {
        pc += 1
        _rst(val: 0x38)
        return 16
    }
    
}
